// GB power bracelet

//const int SPRITE_FIREBALL = 17; //fuck you Dimentio
//const int SPRITE_BOMB = 7;

// global constants

const int CF_PICK = 103; // SCRIPT1, bracelet

const int SCRIPT_POWERBRACELET = 73; // set this to the ffc script slot assigned to PowerBracelet script when compiling

const int LTM_CATCHING = 157; // LTM for Link catching a block with the Power Bracelet
const int LTM_PULLING = 158; // LTM for Link pulling a block with the Power Bracelet
const int LTM_HOLDING = 156; // LTM for Link holding a block with the Power Bracelet

const int BLOCK_VH=4; //thrown block/bush horizontal initial velocity
const int BLOCK_VV=1; //thrown block/bush vertical initial velocity
const int BLOCK_DMG=8; //damage dealt to enemies by thrown block/bush
const int LW_BLOCK = 31; //id of a lweapon to be used as thrown block
const float BLOCK_FALL = 0.5; //gravity acceleration for block in sideview screens
const int PB_PULL_TIME=15; // num of frames to wait for pickup with PB
const int PB_UNDERCOMBO=-1; // combo to set after picking up a block; set a negative value to have a shift of the original combo

const int SFX_PICKUP_BLOCK = 93; // sfx played when link picks up the block
const int SFX_THROW_BLOCK = 94; // sfx played when the block is thrown
const int SFX_CRASH_BLOCK = 81; // sfx of a block crashing

const int SFX_STATUE_BOUNCE = 65; // sfx of a statue bouncing
//const int INV_COMBO_ID = 1; // id af an invisible combo
const int INV_TILE_ID = 65456; // id af an invisible tile
const int CRASH_SPR = 9; // sprite for a block crashing at ground
const int BUSH_SPR = 9; // sprite for a bush crashing at ground
const int LAYER_OVER = 3; // an overhead layer

//const int NPC_ITEMSET = 311; // id of a dummy enemy with type different from "none"

// ------------------------------------------

// global variables

const int THROW_DISABLED = 0;
const int HOLDING_BLOCK = 1;
const int HOLDING_BUSH = 2;
const int LINK_CATCHING = 3;

int powerBracelet[8];

// bool throw_disabled
// int holding_block
// bool holding_Bush
// int link_catching


// ------------------------------------------

// Example of Global Scripts (comment this out if using other global scripts in the quest)


global script Slot_3{
void run(){
Link->Item[LTM_CATCHING] = false;
Link->Item[LTM_HOLDING] = false;
Link->Item[LTM_PULLING] = false;
powerBracelet[HOLDING_BLOCK] = 0;
powerBracelet[HOLDING_BUSH] = 0;
powerBracelet[LINK_CATCHING] = 0;
}
}

// ------------------------------------------

// global function to add to the global script
void PowerBracelet(){
if(Link->Item[LTM_HOLDING]){
if(CountFFCsRunning(SCRIPT_POWERBRACELET)==0 && powerBracelet[HOLDING_BLOCK]>0){
powerBracelet[HOLDING_BLOCK] = 0;
Link->Item[LTM_HOLDING] = false;
Link->Item[LTM_CATCHING] = false;
Link->Item[LTM_PULLING] = false;
}
}
}

// ------------------------------------------

// Item script
item script PowerBracelet{
	void run(){
		// if(powerBracelet[HOLDING_BLOCK]==0 && holding_item==0 && holding_bomb==0){}
		if(powerBracelet[HOLDING_BLOCK]==0 && holding_bomb==0){ // use this line if not using GB_Shop and GB_Bombs
			if(!powerBracelet[LINK_CATCHING] && isSolid(TouchedX(),TouchedY())){
				powerBracelet[LINK_CATCHING]=1;
				int args[] = {0,0,0,0,0,0,0,0};
				int id = RunFFCScript(SCRIPT_POWERBRACELET, args);
			}	
		}
	}
}

void DoPowerBracelet()
{
	if (Link->PressEx2 && (Link->Action == LA_NONE || Link->Action == LA_WALKING))
	{
		if(powerBracelet[HOLDING_BLOCK]==0 && holding_bomb==0)
		{ // use this line if not using GB_Shop and GB_Bombs
			if(!powerBracelet[LINK_CATCHING] && (isSolid(TouchedX(),TouchedY()) || PowerBracelet_GrabbingElephantStatue() ) )
			{
				powerBracelet[LINK_CATCHING]=1;
				int args[] = {0,0,0,0,0,0,0,0};
				int id = RunFFCScript(SCRIPT_POWERBRACELET, args);
			}	
		}
	}
}

// ------------------------------------------

// FFC script (automatically called by the item script - you don't have to place any ffc on the screen for this)
ffc script UsePowerBracelet{
	void run(int input){
		// initialization
		this->Data = INV_COMBO_ID;
		this->X = -16;
		this->Y = -16;
		int counter = 0;

		ffc statue;
		while(Link->InputA || Link->InputB || Link->InputEx2){
			// set link catching the wall / block / bush
			if(!Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = true;

			// store the FFC number of the statue Link is grabbing
			int grabbingStatue = PowerBracelet_GrabbingElephantStatue();
			
			// to fix a bug...
			if(!isSolid(TouchedX(),TouchedY()) && grabbingStatue == 0) break;

			// if pressing opposite direction, set link pulling
			if(OppositeDir()){
				if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
				if(!Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = true;
				counter ++;
			}
			else{
				if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
				counter = 0;
			}

			// if pulling a block or bush for 15 frames or more, pick it up
			if(counter>PB_PULL_TIME){
				int loc=TouchedComboLoc();
				
				bool canLift = true; //Assume Link can lift the thing
				if(grabbingStatue>0){ //Grabbing a statue overrides everything else
					if(!Link->Item[56])
						canLift = false;
					statue = Screen->LoadFFC(grabbingStatue);
					if(statue->InitD[0]==1) //Can't lift a statue that's already lifted
						canLift = false;
					LinkMovement_Push2NoEdge(statue->InitD[1], statue->InitD[2]);
					
				}
				else{
					if(!ComboFI(loc, CF_PICK)) //If no flag, he can't
						canLift = false;
					if(Screen->ComboT[loc] == CT_WATER) //If it's water, he can't
						canLift = false;
					if(Screen->ComboT[loc]==CT_PUSHHEAVY || Screen->ComboT[loc]==CT_PUSHHEAVYWAIT){ //If it's a heavy push, check for the item
						if(!Link->Item[19])
							canLift = false;
					}
				}
				if(canLift){
					powerBracelet[LINK_CATCHING] = 0;
					int combo = Screen->ComboD[loc];
					if (combo == 64 || combo == 118) combo = 10269;
					int cset = Screen->ComboC[loc];
					if(grabbingStatue>0){
						powerBracelet[HOLDING_BUSH] = 0;
						statue = Screen->LoadFFC(grabbingStatue); //Warning: Pointless ahead. Message, and then...Message? Try jumping.
						combo = statue->Data;
						cset = statue->CSet;
						statue->InitD[0] = 1; //Tell the statue to disappear
					}
					else{
						if(isBush(Screen->ComboT[loc])) powerBracelet[HOLDING_BUSH] = 1;
						else powerBracelet[HOLDING_BUSH] = 0;
						if(PB_UNDERCOMBO<0) 
						{
							Screen->ComboD[loc] += (-PB_UNDERCOMBO);
							if (Screen->ComboI[loc] == 102) Screen->ComboD[loc] += 3;
						}
						else Screen->ComboD[loc] = PB_UNDERCOMBO;
						ItemSetAt(IS_DEFAULT,loc);
					}
					Game->PlaySound(SFX_PICKUP_BLOCK);
					powerBracelet[THROW_DISABLED] = 1;
					
					if(grabbingStatue>0){
						// mid-air statue
						for(int i=0;i<16;i++){
							int blockX = (Link->X+statue->X)/2;
							int blockY = Link->Y-23;
							if(i!=0) //Disable draw for the first frame since the statue needs a frame to disappear
								Screen->DrawCombo(LAYER_OVER, blockX, blockY, combo, 1, 2, cset, -1, -1, 0, 0, 0, -1, 0, true, 128 );
							WaitNoAction();
						}
					}
					else{
						// mid-air block
						for(int i=0;i<16;i++){
							int blockX = (Link->X+ComboX(loc))/2;
							int blockY = Link->Y-7;
							Screen->FastCombo(LAYER_OVER, blockX, blockY, combo, cset, 128 );
							WaitNoAction();
						}
					}

					// set link holding
					powerBracelet[HOLDING_BLOCK] = 1;
					if(!Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = true;
					if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
					if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
					while(powerBracelet[THROW_DISABLED] || (!Link->InputA && !Link->InputB && !Link->InputEx2)){
						if(!Link->InputA && !Link->InputB && !Link->InputEx2) powerBracelet[THROW_DISABLED] = 0;
						if(grabbingStatue>0)
							Screen->DrawCombo(LAYER_OVER, Link->X, Link->Y - 28, combo, 1, 2, cset, -1, -1, 0, 0, 0, -1, 0, true, 128 );
						else
							Screen->FastCombo(LAYER_OVER, Link->X, Link->Y - 12, combo, cset, 128 );
						if(Link->Invisible || (Link->Action != LA_NONE && Link->Action != LA_WALKING)) break; // break if falling in pit or water!
						Waitframe();
					}
					if(Link->Invisible || (Link->Action != LA_NONE && Link->Action != LA_WALKING)){
						if(grabbingStatue==0)
							break; // break if falling in pit or water!
					}
					Link->PressA = false; Link->InputA = false;
					Link->PressB = false; Link->InputB = false;
					counter = 0;
					powerBracelet[HOLDING_BLOCK] = 0;
					if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
					if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
					if(Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = false;

					if(grabbingStatue>0){ //If Link is holding a statue, the throwing code is different
						int statueX = Link->X;
						int statueY = Link->Y;
						int statueZ = 12;
						int step = 3;
						int dir = Link->Dir;
						int jump = 1;
						int bounces = 2;
						lweapon hitbox;
						if(!Link->PressEx2){ //if Ex2 isn't pressed, drop the statue in front of Link
							statueX = Link->X+InFrontX(Link->Dir, 0);
							statueY = Link->Y+InFrontY(Link->Dir, 0);
							step = 0;
							jump = 0;
						}
						while(statueZ>0||bounces>0){
							//Handle the forward movement of the statue
							if(step>0){
								for(int i=0; i<step; i++){
									//If the statue can't move, reverse its direction
									if(!LinkMovement_CanWalk(statueX, statueY, dir, 1, true, true)){
										step--;
										dir = OppositeDir(dir);
									}
									if(dir==DIR_UP)
										statueY--;
									else if(dir==DIR_DOWN)
										statueY++;
									else if(dir==DIR_LEFT)
										statueX--;
									else if(dir==DIR_RIGHT)
										statueX++;
								}
							}
							jump -= GRAVITY;
							statueZ = Max(0, statueZ+jump);
							//Handle the hitbox and solidity when it's below a certain height
							if(statueZ<8){
								SolidObjects_Add(statueX, statueY, 16, 16);
								if(hitbox->isValid()){
									hitbox->X = statueX;
									hitbox->Y = statueY;
								}
								else{
									hitbox = CreateLWeaponAt(LW_SCRIPT1, statueX, statueY);
									hitbox->HitXOffset = -4;
									hitbox->HitYOffset = -4;
									hitbox->HitWidth = 24;
									hitbox->HitHeight = 24;
									hitbox->Damage = BLOCK_DMG;
									hitbox->DrawYOffset = -1000;
									hitbox->Dir = -1;
								}
							}
							else{
								if(hitbox->isValid())
									hitbox->DeadState = 0;
							}
							//When it hits the ground, count down the bounces
							if(statueZ==0){
								if(bounces==2)
									jump = 0.8;
								else if(bounces==1)
									jump = 0.6;
								bounces--;
								Game->PlaySound(SFX_STATUE_BOUNCE);
							}
							Screen->DrawCombo(LAYER_OVER, statueX, statueY - statueZ - 16, combo, 1, 2, cset, -1, -1, 0, 0, 0, -1, 0, true, 128 );
							Waitframe();
						}
						if(hitbox->isValid())
							hitbox->DeadState = 0;
						//Move the FFC to where the statue landed
						if(!isOutOfScreen(statueX, statueY,16,16)){
							statue->X = statueX;
							statue->Y = statueY - 16;
							statue->InitD[0] = 0;
							statue->Data = combo;
						}
					}
					else{
						// throw block
						lweapon w = CreateLWeaponAt(LW_SCRIPT1,Link->X,Link->Y);
						w->Damage = BLOCK_DMG;
						w->OriginalTile = INV_TILE_ID;
						w->NumFrames = 1;
						w->Dir = Link->Dir;
						w->Step = Floor(BLOCK_VH*100);
						w->DrawYOffset = -12;
						w->HitXOffset = -4;
						w->HitYOffset = -4;
						w->HitWidth = 16 + 8;
						w->HitHeight = 16 + 8;
						w->HitZHeight = 16 + 8;
						Game->PlaySound(SFX_THROW_BLOCK);
						while(w->DrawYOffset<0 && !isSolid(w->X+8,w->Y+ 8) && !isOutOfScreen(w->X,w->Y,16,16)){
							if(counter<4) Link->Action = LA_ATTACKING;
							w->DrawYOffset += Floor(counter*GRAVITY) - BLOCK_VV;
							Screen->FastCombo(LAYER_OVER, w->X, w->Y + w->DrawYOffset, combo, cset, 128 );
							Waitframe();
							counter ++;
						}
						if(powerBracelet[HOLDING_BUSH]) Game->PlaySound(SFX_GRASSCUT);
						else Game->PlaySound(SFX_CRASH_BLOCK);
						if(w->isValid()){
							w->DeadState = WDS_DEAD;
							if(powerBracelet[HOLDING_BUSH]) CreateGraphicAt(BUSH_SPR,w->X,w->Y + w->DrawYOffset);
							else CreateGraphicAt(CRASH_SPR,w->X,w->Y + w->DrawYOffset);
						}
					}
					break;
				}
			}
			NoMoveAction();
			Waitframe();
		}
		powerBracelet[LINK_CATCHING] = 0;
		powerBracelet[HOLDING_BLOCK] = 0;
		counter = 0;
		if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
		if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
		if(Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = false;
		this->Data = 0;
		Quit();
	}
}

int PowerBracelet_GrabbingElephantStatue(){
	int str[] = "ElephantStatue";
	int ffcs = Game->GetFFCScript(str);
	int x; int y;
	if(Link->Dir==DIR_UP){
		x = Link->X+8;
		y = Link->Y-1;
	}
	else if(Link->Dir==DIR_DOWN){
		x = Link->X+8;
		y = Link->Y+16;
	}
	else if(Link->Dir==DIR_LEFT){
		x = Link->X-1;
		y = Link->Y+12;
	}
	else if(Link->Dir==DIR_RIGHT){
		x = Link->X+16;
		y = Link->Y+12;
	}
	for(int i=1; i<=32; i++){
		ffc f = Screen->LoadFFC(i);
		if(f->Script==ffcs){
			if(x>=f->X&&x<=f->X+15&&y>=f->Y+16&&y<=f->Y+31&&f->InitD[0]==0)
				return i;
		}
	}
	return 0;
}

// ------------------------------------------

// utility functions
bool isBush(int ct){
if(ct==CT_BUSH) return true;
if(ct==CT_BUSHC) return true;
if(ct==CT_BUSHNEXT) return true;
if(ct==CT_BUSHNEXTC) return true;
if(ct==CT_FLOWERS) return true;
if(ct==CT_FLOWERSC) return true;
return false;
}

// ------------------------------------------





// function to test if (x,y) is out of the screen
bool isOutOfScreen(int x, int y, int dx, int dy){
if((x+dx) > 16*16) return true;
else if(x < 0) return true;
else if((y+dy) > 16*11) return true;
else if(y < 0) return true;
else return false;
}



// inhibit all the movement actions
void NoMoveAction(){
Link->InputUp = false;
Link->InputDown = false;
Link->InputLeft = false;
Link->InputRight = false;
}

// this utility routine by Saffith checks for walkability of combos
bool isSolid(int x, int y){
if(x<0 || x>255 || y<0 || y>175) return false;
int mask=1111b;
if(x%16< 8) mask&=0011b;
else mask&=1100b;
if(y%16< 8) mask&=0101b;
else mask&=1010b;
return (!(Screen->ComboS[ComboAt(x, y)]&mask)==0);
}

// gives true if Link pushes the opposite direction of his facing direction
bool OppositeDir(){
if(Link->InputDown && Link->Dir==DIR_UP) return true;
if(Link->InputUp && Link->Dir==DIR_DOWN) return true;
if(Link->InputRight && Link->Dir==DIR_LEFT) return true;
if(Link->InputLeft && Link->Dir==DIR_RIGHT) return true;
else return false;
}

// ------------------------------------------

ffc script ElephantStatue{
	void run(int lifted){
		int cmb = this->Data;
		int push[2];
		int lastDir[8];
		while(true){
			//While D[0] is 0, the FFC is visible, the top half is drawn on layer 4, and it has solidity
			if(this->InitD[0]==0){
				this->Data = cmb;
				Screen->FastCombo(4, this->X, this->Y, this->Data, this->CSet, 128);
				SolidObjects_Add(this->X, this->Y+16, 16, 16);
			}
			else{ //Otherwise it becomes invisible
				this->Data = FFCS_INVISIBLE_COMBO;
			}
			ElephantStatue_ConveyorMovement(this, push, lastDir);
			Waitframe();
		}
	}
	void SomariaOnConveyor(ffc this, bool dir){
		for(int x=0; x<2; x++){
			for(int y=0; y<2; y++){
				int ct = Screen->ComboT[ComboAt(this->X+15*x, this->Y+15*y)];
				if(ct==CT_CVUP)
					dir[DIR_UP] = true;
				else if(ct==CT_CVDOWN)
					dir[DIR_DOWN] = true;
				else if(ct==CT_CVLEFT)
					dir[DIR_LEFT] = true;
				else if(ct==CT_CVRIGHT)
					dir[DIR_RIGHT] = true;
			}
		}
	}
	void ElephantStatue_ConveyorMovement(ffc f, int push, int lastDir){
		bool dir[4];
		for(int x=0; x<2; x++){
			for(int y=0; y<2; y++){
				int ct = Screen->ComboT[ComboAt(f->X+15*x, f->Y+16+15*y)];
				if(ct==CT_CVUP)
					dir[DIR_UP] = true;
				else if(ct==CT_CVDOWN)
					dir[DIR_DOWN] = true;
				else if(ct==CT_CVLEFT)
					dir[DIR_LEFT] = true;
				else if(ct==CT_CVRIGHT)
					dir[DIR_RIGHT] = true;
			}
		}
		
		f->InitD[1] = 0;
		f->InitD[2] = 0;
		if(dir[DIR_UP]){
			f->InitD[2] -= 0.6;
			push[1] -= 0.6;
		
		}
		if(dir[DIR_DOWN]){
			f->InitD[2] += 0.6;
			push[1] += 0.6;
		}
		if(dir[DIR_LEFT]){
			f->InitD[1] -= 0.6;
			push[0] -= 0.6;
		}
		if(dir[DIR_RIGHT]){
			f->InitD[1] += 0.6;
			push[0] += 0.6;
		}
		
		int sizeX = Abs(push[0]);
		int sizeY = Abs(push[1]);
		if(sizeY>=1){
			for(int i=0; i<sizeY; i++){
				if(push[1]<0){
					if(LinkMovement_CanWalk(f->X, f->Y+16, DIR_UP, 1, true, true))
						f->Y--;
					push[1]++;
				}
				else if(push[1]>0){
					if(LinkMovement_CanWalk(f->X, f->Y+16, DIR_DOWN, 1, true, true))
						f->Y++;
					push[1]--;
				}
			}
		}
		if(sizeX>=1){
			for(int i=0; i<sizeX; i++){
				if(push[0]<0){
					if(LinkMovement_CanWalk(f->X, f->Y+16, DIR_LEFT, 1, true, true))
						f->X--;
					push[0]++;
				}
				else if(push[0]>0){
					if(LinkMovement_CanWalk(f->X, f->Y+16, DIR_RIGHT, 1, true, true))
						f->X++;
					push[0]--;
				}
			}
		}
	}
}