////////////////////////////////////////////////////////////////
//// screen-change.zh
 
// Last noticed DMap.
int LastDMap = -1;
// Last noticed DScreen.
int LastDScreen = -1;
// If the screen has changed.
bool ScreenChanged = false;
// If the dmap has changed.
bool DMapChanged = false;
 
void ScreenChange_Update() {
  int dMap = Game->GetCurDMap();
  int dScreen = Game->GetCurDMapScreen();
  DMapChanged = dMap != LastDMap;
  ScreenChanged = DMapChanged || dScreen != LastDScreen;
  LastDMap = dMap;
  LastDScreen = dScreen;}
 
////////////////////////////////////////////////////////////////
//// link-speed.zh
 
// Link's locaton last frame.
int LS_OldX = 0;
int LS_OldY = 0;
 
// Link's Partial movement
int LS_PartialX = 0;
int LS_PartialY = 0;
 
// Link's speed multiplier.
int LS_Speed = 1.0;
 
void LS_Update() {
  if (ScreenChanged) {
    LS_PartialX = 0;
    LS_PartialY = 0;
    LS_OldX = Link->X;
    LS_OldY = Link->Y;}

  if (Link->Action == LA_RAFTING ||
      Link->Action == LA_SWIMMING) {
    LS_OldX = Link->X;
    LS_OldY = Link->Y;
    return;}

  int dx = Link->X - LS_OldX;
  int dy = Link->Y - LS_OldY;
 
  // Slow Link Down.
  if (LS_Speed < 1) {
    int max = 1.5 * LS_Speed;
    if (Abs(dx) > max) {
      if (dx > 0 && Link->InputRight) {dx = max;}
      else if (Link->InputLeft) {dx = -max;}}
    if (Abs(dy) > max) {
      if (dy > 0 && Link->InputDown) {dy = max;}
      else if (Link->InputUp) {dy = -max;}}
 
    Link->X = LS_OldX + (dx >> 0);
    LS_PartialX += dx - (dx >> 0);
    Link->Y = LS_OldY + (dy >> 0);
    LS_PartialY += dy - (dy >> 0);}
 
  // Speed Link Up.
  else if (LS_Speed > 1) {
    if (dy < 0 && Link->InputUp) {
      LS_PartialY -= 1.5 * LS_Speed + dy;}
    if (dy > 0 && Link->InputDown) {
      LS_PartialY += 1.5 * LS_Speed - dy;}
    if (dx < 0 && Link->InputLeft) {
      LS_PartialX -= 1.5 * LS_Speed + dx;}
    if (dx > 0 && Link->InputRight) {
      LS_PartialX += 1.5 * LS_Speed - dx;}}
 
  // Apply partial movement.
  while (LS_PartialY < -0.5 && CanWalk(Link->Y, Link->Y, DIR_UP, 1, false)) {
    Link->Y--;
    LS_PartialY += 1;}
  while (LS_PartialY > 0.5 && CanWalk(Link->Y, Link->Y, DIR_DOWN, 1, false)) {
    Link->Y++;
    LS_PartialY -= 1;}
  while (LS_PartialX < -0.5 && CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)) {
    Link->X--;
    LS_PartialX += 1;}
  while (LS_PartialX > 0.5 && CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)) {
    Link->X++;
    LS_PartialX -= 1;}
 
  // Get rid of excess partial movement.
  if (LS_PartialY < -0.5) {LS_PartialY = -0.5;}
  if (LS_PartialY > 0.5) {LS_PartialY = 0.5;}
  if (LS_PartialX < -0.5) {LS_PartialX = -0.5;}
  if (LS_PartialX > 0.5) {LS_PartialX = 0.5;}
 
  // Save new position.
  LS_OldX = Link->X;
  LS_OldY = Link->Y;}
 
