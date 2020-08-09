// ID's of barrier-related combos
// Barriers in raised state
const int BARRIER_A_RAISED           = 2996;
const int BARRIER_B_RAISED           = 2997;

// Barriers in lowered state
const int BARRIER_A_LOWERED          = 2998;
const int BARRIER_B_LOWERED          = 2999;

// Barriers animating to raised state
const int BARRIER_A_ANIMRAISE        = 3000;
const int BARRIER_B_ANIMRAISE        = 3001;

// Barriers animating to lowered state
const int BARRIER_A_ANIMLOWER        = 3002;
const int BARRIER_B_ANIMLOWER        = 3003;

// Raised barriers that Link can walk on
const int BARRIER_A_WALKABLE         = 3004;
const int BARRIER_B_WALKABLE         = 3005;

// Barrier switches
const int BARRIER_A_SWITCH           = 3006;
const int BARRIER_B_SWITCH           = 3007;

const int BARRIER_SWITCH_DUMMY = 258; // ID of a switch hit detection dummy enemy
const int BARRIER_SWITCH_DUMMY_HP = 32767;

// Global array to store the state of barriers per dmap
// If you have more than 16 dmaps you can change the capacity in the []'s
// You may change the states in other scripts, but the changes will not be visible
// until there is a new screen, so set them before Barriers_NewScreen() is called.
bool barriers[256]; // false = blue barriers raised, true = red barriers raised


global script slot2 {
 void run() {
  // Initialize variables used to listen on screen changes
  int curscreen = -1;

  while (true) {
   // Keep track of screen changes
   // Run a Barrier script on every screen change
   if (Game->GetCurScreen() != curscreen) {
    curscreen = Game->GetCurScreen();
    Barriers_NewScreen();}

   Waitframe();}}}


// Function that makes preparations for barriers on each screen and starts an FFC script
void Barriers_NewScreen() {

 // Search for a barrier-related combo
 for (int i = 0; i <= 175; i++) {
  int cd = Screen->ComboD[i];
  if (cd == BARRIER_A_RAISED || cd == BARRIER_A_LOWERED || cd == BARRIER_A_SWITCH ||
      cd == BARRIER_B_RAISED || cd == BARRIER_B_LOWERED || cd == BARRIER_B_SWITCH) {
   // A barrier-related combo was found

   // Make initial changes to combos
   if (barriers[Game->GetCurLevel()]) {
    for (int j = i; j <= 175; j++) {
     int cd = Screen->ComboD[j];
     if (cd == BARRIER_A_RAISED) Screen->ComboD[j] = BARRIER_A_LOWERED;
     else if (cd == BARRIER_B_LOWERED) Screen->ComboD[j] = BARRIER_B_RAISED;
     else if (cd == BARRIER_A_SWITCH) Screen->ComboD[j] = BARRIER_B_SWITCH;}}
   else {
    for (int j = i; j <= 175; j++) {
     int cd = Screen->ComboD[j];
     if (cd == BARRIER_B_RAISED) Screen->ComboD[j] = BARRIER_B_LOWERED;
     else if (cd == BARRIER_A_LOWERED) Screen->ComboD[j] = BARRIER_A_RAISED;
     else if (cd == BARRIER_B_SWITCH) Screen->ComboD[j] = BARRIER_A_SWITCH;}}
   
   // So run FFCscript to control barriers
   int args[] = {0,0,0,0,0,0,0,0};
   RunFFCScript(SCRIPT_BARRIERS, args);
   break;}
}}

// This lets you toggle barriers on any dmap
bool ToggleBarriers(int dmap) {
 if (dmap == Game->GetCurLevel()) ToggleBarriers();
 else barriers[dmap] = !barriers[dmap];
 return barriers[dmap];}

// This toggles barriers on the current dmap
bool ToggleBarriers() {

 int curdmap = Game->GetCurLevel();
 if (!barriers[curdmap]) {
  barriers[curdmap] = true;
  for (int i = 0; i <= 175; i++) {
   int cd = Screen->ComboD[i];
   if (cd == BARRIER_A_RAISED || cd == BARRIER_A_WALKABLE || cd == BARRIER_A_ANIMRAISE) {
    Screen->ComboD[i] = BARRIER_A_ANIMLOWER;}
   else if (cd == BARRIER_B_LOWERED || cd == BARRIER_B_ANIMLOWER) {
    Screen->ComboD[i] = BARRIER_B_ANIMRAISE;}
   else if (cd == BARRIER_A_SWITCH) {Screen->ComboD[i] = BARRIER_B_SWITCH;}}}
 else {
  barriers[curdmap] = false;
  for (int i = 0; i <= 175; i++) {
   int cd = Screen->ComboD[i];
   if (cd == BARRIER_B_RAISED || cd == BARRIER_B_WALKABLE || cd == BARRIER_B_ANIMRAISE) {
    Screen->ComboD[i] = BARRIER_B_ANIMLOWER;}
   else if (cd == BARRIER_A_LOWERED || cd == BARRIER_A_ANIMLOWER) {
    Screen->ComboD[i] = BARRIER_A_ANIMRAISE;}
   else if (cd == BARRIER_B_SWITCH) {Screen->ComboD[i] = BARRIER_A_SWITCH;}}}

 return barriers[curdmap];
}

// This script controls barriers on the screen
// The FFC is automatically created by Barriers_NewScreen()
ffc script Barriers {
 void run() {

  // Initialize storage for bswitch hit dummies
  int bswitch_count;
  npc bswitch[8];

  for (int i = 0; i <= 175; i++) {
   if (Screen->ComboD[i] == BARRIER_A_SWITCH || Screen->ComboD[i] == BARRIER_B_SWITCH) {
    npc bs = CreateNPCAt(BARRIER_SWITCH_DUMMY, ComboX(i), ComboY(i));
    bs->HitWidth = 8; // Smaller hit box to avoid annoying collisions with Link
    bs->HitHeight = 8;
    bs->HP = BARRIER_SWITCH_DUMMY_HP;
    bswitch[bswitch_count++] = bs;}}

  // Change raised barriers to walkable ones if Link enters screen on a raised barrier
  int lcombo = LinkOnComboD();
  bool onbarrier = (lcombo == BARRIER_A_RAISED || lcombo == BARRIER_B_RAISED);
  if (onbarrier) for (int i = 0; i < 176; i++) {
   if (Screen->ComboD[i] == BARRIER_A_RAISED) {Screen->ComboD[i] = BARRIER_A_WALKABLE;}
   else if (Screen->ComboD[i] == BARRIER_B_RAISED) {Screen->ComboD[i] = BARRIER_B_WALKABLE;}}


  while (true) {

   // Detect hits on bswitches, and change combos accordingly
   for (int j = 0; j < bswitch_count; j++) {
    if (bswitch[j]->HP < BARRIER_SWITCH_DUMMY_HP) {
     bswitch[j]->HP = BARRIER_SWITCH_DUMMY_HP;
     ToggleBarriers();
     break;}} //break so that only one bswitch hit may register per frame


   // Make barriers walkable if Link is on raised barriers, or unwalkable if not
   lcombo = LinkOnComboD();
   if (!onbarrier && (lcombo == BARRIER_A_RAISED || lcombo == BARRIER_B_RAISED)) {
    onbarrier = true;
    for (int i = 0; i <= 175; i++) {
     if (Screen->ComboD[i] == BARRIER_A_RAISED) {Screen->ComboD[i] = BARRIER_A_WALKABLE;}
     else if (Screen->ComboD[i] == BARRIER_B_RAISED) {Screen->ComboD[i] = BARRIER_B_WALKABLE;}}}
   else if (onbarrier && !(lcombo == BARRIER_A_WALKABLE || lcombo == BARRIER_B_WALKABLE)) {
    onbarrier = false;
    for (int i = 0; i <= 175; i++) {
     if (Screen->ComboD[i] == BARRIER_A_WALKABLE) {Screen->ComboD[i] = BARRIER_A_RAISED;}
     else if (Screen->ComboD[i] == BARRIER_B_WALKABLE) {Screen->ComboD[i] = BARRIER_B_RAISED;}}}

   Waitframe();}
}}



// A utility function that returns the ID of the combo that Link appears to stand on
int LinkOnComboD() {
 return Screen->ComboD[ComboAt(Link->X+8, Link->Y+13)];
}