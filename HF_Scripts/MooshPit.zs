int MooshPit[16];
const int MP_LASTX = 0;
const int MP_LASTY = 1;
const int MP_LASTDMAP = 2;
const int MP_LASTSCREEN = 3;
const int MP_ENTRYX = 4;
const int MP_ENTRYY = 5;
const int MP_ENTRYDMAP = 6;
const int MP_ENTRYSCREEN = 7;
const int MP_FALLX = 8;
const int MP_FALLY = 9;
const int MP_FALLTIMER = 10;
const int MP_FALLSTATE = 11;
const int MP_DAMAGETYPE = 12;
const int MP_SLIDETIMER = 13;
const int MP_SWAMPTIMER = 14;

const int BIG_LINK = 0;   //Set this constant to 1 if using the Large Link Hit Box feature.

float PitsLava[7]; //Array for Holelava.

const int WPS_LINK_FALL          = 92;  //The weapon sprite to display when Link falls into a pit. "Sprite 88 by default"
const int WPS_LINK_LAVA          = 93;  //The weapon sprite to display when Link drowns in lava. "Sprite 89 by default"
const int SFX_LINK_FALL          = 73;  //The sound to play when Link falls into a pit. "SFX_FALL by default"
const int SFX_LINK_LAVA          = 55;  //The sound to play when Link drowns in Lava. "SFX_SPLASH by default.
const int CMB_AUTOWARP            = 3128; //The first of your four transparent autowarp combos.
const int HL_FALLING               = 0;

const int CT_HOLELAVA = 128; //Combo type for pits (No Ground Enemies by default)
const int CF_LAVA = 101; //Combo flag marking pits as lava (Script 1 by default)
const int CF_SWAMP = 97; //Combo flag marking pits as swamp (Script 2 by default)

const int SPR_FALLHOLE = 92; //Sprite for Link falling in a hole
const int SPR_FALLLAVA = 93; //Sprite for Link falling in lava

const int SFX_FALLHOLE = 73; //Sound for falling in a hole
const int SFX_FALLLAVA = 13; //Sound for falling in lava

const int DAMAGE_FALLHOLE = 8; //How much damage pits deal (1/2 heart default)
const int DAMAGE_FALLLAVA = 16; //How much damage lava deals (1 heart default)

const int FFC_MOOSHPIT_AUTOWARPA = 32; //FFC that turns into an auto side warp combo when you fall in a pit
const int CMB_MOOSHPIT_AUTOWARPA = 19; //Combo number of an invisible Auto Side Warp A combo
const int SF_MISC_MOOSHPITWARP = 4; //Number of the screen flag under the Misc. section that makes pits warp (Script 1 by default)
								    //All pit warps use Side Warp A
									
const int MOOSHPIT_MIN_FALL_TIME = 60; //Minimum time for the pit's fall animation, to prevent repeated falling in pits
const int MOOSHPIT_EXTRA_FALL_TIME = 0; //Extra frames at the end of the falling animation before Link respawns
								
//Width and height of Link's hitbox for colliding with pits
const int MOOSHPIT_LINKHITBOXWIDTH = 16;
const int MOOSHPIT_LINKHITBOXHEIGHT = 16;

const int MOOSHPIT_SLIDE_LINKHITBOXWIDTH = 4;
const int MOOSHPIT_SLIDE_LINKHITBOXHEIGHT = 4;

//Width and height of Link's hitbox for colliding with pits/lava in sideview
const int MOOSHPIT_SIDEVIEW_LINKHITBOXWIDTH = 10;
const int MOOSHPIT_SIDEVIEW_LINKHITBOXHEIGHT = 10;

const int MOOSHPIT_NO_GRID_SNAP = 0; //Set to 1 to prevent Link's falling sprite from snapping to the combo grid.

const int MOOSHPIT_ENABLE_SLIDEYPITS = 1; //Set to 1 if Link should slide into pits he's partially on
const int MOOSHPIT_SLIDEYPIT_FREQ = 3; //Link will be pushed into slideypits every 1/n frames
const int MOOSHPIT_SLIDEYPIT_MAXTIME = 20; //Link will be pushed into slideypits more intensely after n frames
const int MOOSHPIT_SLIDEYPIT_ACCELFREQ = 8; //How often Link accelerates when falling in the pit
						
const int MOOSHPIT_NO_MOVE_WHILE_FALLING = 1; //Set to 1 if you don't want Link able to move while falling

int MooshPit_OnPit(int LinkX, int LinkY, bool countFFCs){
	if(Link->Action==LA_FROZEN||Link->Action==LA_RAFTING||Link->Action==LA_INWIND)
		return -1;
	
	if(countFFCs){
		if(MooshPit_OnFFC(LinkX, LinkY))
			return -1;
	}
	
	bool sideview;
	if(Screen->Flags[SF_ROOMTYPE]&100b)
		sideview = true;
	//wew lad
	int width = MOOSHPIT_LINKHITBOXWIDTH;
	int height = MOOSHPIT_LINKHITBOXHEIGHT;
	
	int total;
	int solidTotal;
	
	for(int x=0; x<=1; x++){
		for(int y=0; y<=1; y++){
			int X; int Y;
			if(sideview){ //Hitbox functions differently in sideview
				width = MOOSHPIT_SIDEVIEW_LINKHITBOXWIDTH;
				height = MOOSHPIT_SIDEVIEW_LINKHITBOXHEIGHT;
				X = Floor(LinkX+7-width/2+(width-1)*x)+1;
				Y = Floor(LinkY+7-height/2+(height-1)*y)+1;
			}
			else{
				X = Floor(LinkX+7-width/2+(width-1)*x)+1;
				Y = Floor(LinkY+7-height/2+(height-1)*y)+1;
			}
			
			//If one corner of Link's hitbox is on a pit, flag that corner as covered
			if(Screen->ComboT[ComboAt(X, Y)]==CT_HOLELAVA){
				total |= 1<<(1+(x+y*2));
			}
			//If Link is on a solid combo, count that corner as a pit
			if(Screen->isSolid(X, Y)){
				solidTotal |= 1<<(x+y*2);
			}
		}
	}
	if(total>0) //Assuming Link is on at least one actual pit, add up the solid and nonsolid pits
		return (total>>1)|(solidTotal<<4);
	return -1;
}

int MooshPit_OnSlideyPit(int LinkX, int LinkY, bool countFFCs){
	if(Link->Action==LA_FROZEN||Link->Action==LA_RAFTING||Link->Action==LA_INWIND)
		return -1;
	
	if(countFFCs){
		if(MooshPit_OnFFC(LinkX, LinkY))
			return -1;
	}
	
	bool sideview;
	if(Screen->Flags[SF_ROOMTYPE]&100b)
		sideview = true;
	//wew lad
	int width = MOOSHPIT_SLIDE_LINKHITBOXWIDTH;
	int height = MOOSHPIT_SLIDE_LINKHITBOXHEIGHT;
	
	int total;
	int solidTotal;
	
	for(int x=0; x<=1; x++){
		for(int y=0; y<=1; y++){
			int X; int Y;
			if(sideview){ //Hitbox functions differently in sideview
				width = MOOSHPIT_SIDEVIEW_LINKHITBOXWIDTH;
				height = MOOSHPIT_SIDEVIEW_LINKHITBOXHEIGHT;
				X = Floor(LinkX+7-width/2+(width-1)*x)+1;
				Y = Floor(LinkY+7-height/2+(height-1)*y)+1;
			}
			else{
				X = Floor(LinkX+7-width/2+(width-1)*x)+1;
				Y = Floor(LinkY+11-height/2+(height-1)*y)+1;
			}
			
			//If one corner of Link's hitbox is on a pit, flag that corner as covered
			if(Screen->ComboT[ComboAt(X, Y)]==CT_HOLELAVA){
				total |= 1<<(1+(x+y*2));
			}
			//If Link is on a solid combo, count that corner as a pit
			if(Screen->isSolid(X, Y)){
				solidTotal |= 1<<(x+y*2);
			}
		}
	}
	if(total>0) //Assuming Link is on at least one actual pit, add up the solid and nonsolid pits
		return (total>>1)|(solidTotal<<4);
	return -1;
}

bool MooshPit_OnFFC(int LinkX, int LinkY){
	for(int i=1; i<=32; i++){ //Cycle through every FFC
		ffc f = Screen->LoadFFC(i);
		//Check if the FFC is solid
		if(f->Data>0&&!f->Flags[FFCF_CHANGER]&&!f->Flags[FFCF_ETHEREAL]){
			//Check if Link collides with the FFC
			if(RectCollision(LinkX+4, LinkY+9, LinkX+11, LinkY+14, f->X, f->Y, f->X+f->EffectWidth-1, f->Y+f->EffectHeight-1)){
				return true;
			}
		}
	}
	//If Link doesn't collide with any FFC, return false
	return false;
}

void MooshPit_Init(){
	MooshPit[MP_LASTX] = Link->X;
	MooshPit[MP_LASTY] = Link->Y;
	MooshPit[MP_LASTDMAP] = Game->GetCurDMap();
	MooshPit[MP_LASTSCREEN] = Game->GetCurDMapScreen();
	MooshPit[MP_ENTRYX] = Link->X;
	MooshPit[MP_ENTRYY] = Link->Y;
	MooshPit[MP_ENTRYDMAP] = Game->GetCurDMap();
	MooshPit[MP_ENTRYSCREEN] = Game->GetCurDMapScreen();
	MooshPit[MP_FALLSTATE] = 0;
	MooshPit[MP_FALLTIMER] = 0;
	Link->CollDetection = true;
	Link->Invisible = false;
}

void MooshPit_Update(){
	int i;
	bool isWarp;
	if(Screen->Flags[SF_MISC]&(1<<SF_MISC_MOOSHPITWARP))
		isWarp = true;
	
	bool sideview;
	if(Screen->Flags[SF_ROOMTYPE]&100b)
		sideview = true;
	
	if(Link->Action!=LA_SCROLLING){
		//Update the entry point whenever the screen changes
		if(MooshPit[MP_ENTRYDMAP]!=Game->GetCurDMap()||MooshPit[MP_ENTRYSCREEN]!=Game->GetCurDMapScreen()){
			MooshPit[MP_ENTRYX] = Link->X;
			MooshPit[MP_ENTRYY] = Link->Y;
			MooshPit[MP_ENTRYDMAP] = Game->GetCurDMap();
			MooshPit[MP_ENTRYSCREEN] = Game->GetCurDMapScreen();
		}
		
		if(MooshPit[MP_FALLSTATE]==0){ //Not falling in pit
			int onPit = MooshPit_OnPit(Link->X, Link->Y, true);
			//Check if slidey pits are enabled and it's not sideview
			if(MOOSHPIT_ENABLE_SLIDEYPITS&&!IsSideview()){
				int onSPit = MooshPit_OnSlideyPit(Link->X, Link->Y, true);
				if(Link->Z<=0&&onSPit>-1&&!ComboFI(ComboAt(Link->X + 8, Link->Y + 8), CF_SWAMP)){ //If Link is partially on a pit
					int slideVx; int slideVy;
					int reps = 1;
					//Check if it's a frame Link should be moved
					if(MooshPit[MP_SLIDETIMER]%MOOSHPIT_SLIDEYPIT_FREQ==0||MooshPit[MP_SLIDETIMER]>=MOOSHPIT_SLIDEYPIT_MAXTIME){
						if((onPit&0111b)==0111b){ //Going up-left
							slideVx = -1;
							slideVy = -1;
						}
						else if((onPit&1011b)==1011b){ //Going up-right
							slideVx = 1;
							slideVy = -1;
						}
						else if((onPit&1101b)==1101b){ //Going down-left
							slideVx = -1;
							slideVy = 1;
						}
						else if((onPit&1110b)==1110b){ //Going down-right
							slideVx = 1;
							slideVy = 1;
						}
						else if((onPit&0011b)==0011b){ //Going up
							slideVy = -1;
						}
						else if((onPit&1100b)==1100b){ //Going down
							slideVy = 1;
						}
						else if((onPit&0101b)==0101b){ //Going left
							slideVx = -1;
						}
						else if((onPit&1010b)==1010b){ //Going right
							slideVx = 1;
						}
						else if((onPit&0001b)==0001b){ //Going up-left
							slideVx = -1;
							slideVy = -1;
						}
						else if((onPit&0010b)==0010b){ //Going up-right
							slideVx = 1;
							slideVy = -1;
						}
						else if((onPit&0100b)==0100b){ //Going down-left
							slideVx = -1;
							slideVy = 1;
						}
						else if((onPit&1000b)==1000b){ //Going down-right
							slideVx = 1;
							slideVy = 1;
						}
						
						//DEBUG DRAWS
						//VX
						// Screen->DrawInteger(6, 0, 0, FONT_Z1, 0x01, 0x0F, -1, -1, slideVx, 0, 128);
						//VY
						// Screen->DrawInteger(6, 0, 8, FONT_Z1, 0x01, 0x0F, -1, -1, slideVy, 0, 128);
						//ONPIT BITS
						// Screen->DrawInteger(6, 0, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&1000b)>>3, 0, 128);
						// Screen->DrawInteger(6, 8, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&0100b)>>2, 0, 128);
						// Screen->DrawInteger(6, 16, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&0010b)>>1, 0, 128);
						// Screen->DrawInteger(6, 24, 16, FONT_Z1, 0x01, 0x0F, -1, -1, (onPit&0001b), 0, 128);
						
						//If Link is over the max slide time, increase the speed every 4 frames
						if(MooshPit[MP_SLIDETIMER]>=MOOSHPIT_SLIDEYPIT_MAXTIME)
							reps += Floor((MooshPit[MP_SLIDETIMER]-MOOSHPIT_SLIDEYPIT_MAXTIME)/MOOSHPIT_SLIDEYPIT_ACCELFREQ);
					}
					
					for(i=0; i<reps; i++){
						if(slideVx<0&&CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)){
							Link->X--;
						}
						else if(slideVx>0&&CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)){
							Link->X++;
						}
						if(slideVy<0&&CanWalk(Link->X, Link->Y, DIR_UP, 1, false)){
							Link->Y--;
						}
						else if(slideVy>0&&CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)){
							Link->Y++;
						}
					}
					MooshPit[MP_SLIDETIMER]++;
				}
				else{
					MooshPit[MP_SLIDETIMER] = 0;
				}
			}
			if(onPit>-1){
				//Combine solid combo bits with pit bits
				onPit |= (onPit>>4);
				//Remove non pit bits
				onPit &= 1111b;
			}
			if(Link->Z<=0&&onPit==15){ //If Link steps on a pit
				int underLink;
				if(!sideview){
					underLink = ComboAt(Link->X+8, Link->Y+12);
					if(Screen->ComboT[underLink]!=CT_HOLELAVA){
						for(i=0; i<4; i++){
							underLink = ComboAt(Link->X+15*(i%2), Link->Y+8+7*Floor(i/2));
							if(Screen->ComboT[underLink]==CT_HOLELAVA)
								break;
						}
					}
				}
				else{
					underLink = ComboAt(Link->X+8, Link->Y+8);
					if(Screen->ComboT[underLink]!=CT_HOLELAVA){
						for(i=0; i<4; i++){
							underLink = ComboAt(Link->X+15*(i%2), Link->Y+15*Floor(i/2));
							if(Screen->ComboT[underLink]==CT_HOLELAVA)
								break;
						}
					}
				}
			
				lweapon fall;
				
				//Check if the combo is lava
				if(ComboFI(underLink, CF_LAVA)){
					//Play sound and display animation
					Game->PlaySound(SFX_FALLLAVA);
					fall = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
					if(!MOOSHPIT_NO_GRID_SNAP){
						fall->X = ComboX(underLink);
						fall->Y = ComboY(underLink);
					}
					fall->UseSprite(SPR_FALLLAVA);
					fall->CollDetection = false;
					fall->DeadState = fall->ASpeed*fall->NumFrames;
				
					//Mark as lava damage
					MooshPit[MP_DAMAGETYPE] = 1;
				}
				else if(ComboFI(underLink, CF_SWAMP)){
					//Play sound and display animation
					if (DashCounter <= 10)
					{
						MooshPit[MP_SWAMPTIMER]++;
						LinkMovement_AddLinkSpeedBoost(Max(MooshPit[MP_SWAMPTIMER] * -0.08, -1.5));
					}
					else
					{
						LinkMovement_AddLinkSpeedBoost(-1);
					}
					if (MooshPit[MP_SWAMPTIMER] > 45)
					{
						Game->PlaySound(55);
						fall = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
						fall->UseSprite(SPR_FALLLAVA);
						fall->CollDetection = false;
						fall->DeadState = fall->ASpeed*fall->NumFrames;
					
						//Mark as lava damage
						MooshPit[MP_DAMAGETYPE] = 0;
					}
				}
				//Otherwise it's a pit
				else{
					//Play sound and display animation
					Game->PlaySound(SFX_FALLHOLE);
					fall = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
					if(!MOOSHPIT_NO_GRID_SNAP){
						fall->X = ComboX(underLink);
						fall->Y = ComboY(underLink);
						if(isWarp){
							Link->X = ComboX(underLink);
							Link->Y = ComboY(underLink);
						}
					}
					fall->UseSprite(SPR_FALLHOLE);
					fall->CollDetection = false;
					fall->DeadState = fall->ASpeed*fall->NumFrames;
				
					//Mark as hole damage
					MooshPit[MP_DAMAGETYPE] = 0;
				}
				
				if(!ComboFI(underLink, CF_SWAMP) || MooshPit[MP_SWAMPTIMER] > 45)
				{
					MooshPit[MP_FALLX] = Link->X;
					MooshPit[MP_FALLY] = Link->Y;
					
					//Cooldown should last as long as the fall animation
					MooshPit[MP_FALLSTATE] = 1;
					MooshPit[MP_FALLTIMER] = Max(MOOSHPIT_MIN_FALL_TIME, fall->DeadState+MOOSHPIT_EXTRA_FALL_TIME);
					
					//Render Link invisible and intangible
					Vanish();
					Link->CollDetection = false;
					
					NoAction();
				}
			}
			else if(MooshPit_OnPit(Link->X, Link->Y, false)==-1&&Link->Action!=LA_FROZEN){ //All other times, while Link is on solid ground, record Link's last position
				if(sideview){
					//Link has no Z value in sideview, so we check if he's on a platform instead
					if(OnSidePlatform(Link->X, Link->Y)){
						MooshPit[MP_LASTDMAP] = Game->GetCurDMap();
						MooshPit[MP_LASTSCREEN] = Game->GetCurDMapScreen();
						MooshPit[MP_LASTX] = Link->X;
						MooshPit[MP_LASTY] = Link->Y;
					}
				}
				else{
					if(Link->Z<=0){
						MooshPit[MP_LASTDMAP] = Game->GetCurDMap();
						MooshPit[MP_LASTSCREEN] = Game->GetCurDMapScreen();
						MooshPit[MP_LASTX] = Link->X;
						MooshPit[MP_LASTY] = Link->Y;
					}
				}
				MooshPit[MP_SWAMPTIMER] = 0;
			}
		}
		else if(MooshPit[MP_FALLSTATE]==1){ //Falling animation
			if(MooshPit[MP_FALLTIMER]>0)
				MooshPit[MP_FALLTIMER]--;
		
			Link->Jump = 0;
			Link->Z = 0;
			
			//Keep Link invisible just in case
			Vanish();
			Link->CollDetection = false;
			NoAction();
			if(MooshPit[MP_FALLTIMER]==0){
				MooshPit[MP_SLIDETIMER] = 0;
				if(!isWarp||MooshPit[MP_DAMAGETYPE]==1){ //If the pit isn't a warp, deal damage and move Link back to the return point
					//If the entry would dump Link back in the pit, dump him out at the failsafe position
					if(MooshPit_OnPit(MooshPit[MP_ENTRYX], MooshPit[MP_ENTRYY], false)==15){
						Link->X = MooshPit[MP_LASTX];
						Link->Y = MooshPit[MP_LASTY];
						//If the failsafe position was on a different screen, warp there
						if(Game->GetCurDMap()!=MooshPit[MP_LASTDMAP]||Game->GetCurDMapScreen()!=MooshPit[MP_LASTSCREEN]){
							Link->PitWarp(MooshPit[MP_LASTDMAP], MooshPit[MP_LASTSCREEN]);
						}
				
						Link->Invisible = false;
						Link->CollDetection = true;
					}
					else{
						//Move Link to the start and make him visible
						Link->X = MooshPit[MP_ENTRYX];
						Link->Y = MooshPit[MP_ENTRYY];
						
						Link->Invisible = false;
						Link->CollDetection = true;
					}
					
					//Subtract HP based on damage type
					if(MooshPit[MP_DAMAGETYPE]==1)
						Link->HP -= DAMAGE_FALLLAVA;
					else
						Link->HP -= DAMAGE_FALLHOLE;
					//Play hurt sound and animation
					Link->Action = LA_GOTHURTLAND;
					Link->HitDir = -1;
					Game->PlaySound(SFX_OUCH);
					
					MooshPit[MP_FALLSTATE] = 0;
				}
				else{
					MooshPit[MP_FALLSTATE] = 2;
					MooshPit[MP_FALLTIMER] = 1;
					ffc warp = Screen->LoadFFC(FFC_MOOSHPIT_AUTOWARPA);
					warp->Data = CMB_MOOSHPIT_AUTOWARPA;
					warp->Flags[FFCF_CARRYOVER] = false;
				}
			}
		}
		else if(MooshPit[MP_FALLSTATE]==2){ //Just warped
			if(sideview){
				Link->X = MooshPit[MP_FALLX];
				Link->Y = 0;
			}
			else{
				Link->X = MooshPit[MP_FALLX];
				Link->Y = MooshPit[MP_FALLY];
				Link->Z = 176;
			}
			Link->Invisible = false;
			Link->CollDetection = true;
			
			if(MOOSHPIT_NO_MOVE_WHILE_FALLING){
				MooshPit[MP_FALLSTATE] = 3;
				NoAction();
			}
			else
				MooshPit[MP_FALLSTATE] = 0;
			MooshPit[MP_FALLTIMER] = 0;
		}
		else if(MooshPit[MP_FALLSTATE]==3){ //Falling (no action)
			NoAction();
			if(IsSideview()){
				if(OnSidePlatform(Link->X, Link->Y))
					MooshPit[MP_FALLSTATE] = 0;
			}
			else{
				if(Link->Z<=0)
					MooshPit[MP_FALLSTATE] = 0;
			}
		}
	}
}

void MooshPit_ResetEntry(){
	MooshPit[MP_ENTRYX] = Link->X;
	MooshPit[MP_ENTRYY] = Link->Y;
	MooshPit[MP_ENTRYDMAP] = Game->GetCurDMap();
	MooshPit[MP_ENTRYSCREEN] = Game->GetCurDMapScreen();
}

global script MooshPitGlobal{
	void run(){
		MooshPit_Init();
		while(true){
			MooshPit_Update();
			Waitframe();
		}
	}
}

const int TRAMPOLINE_ANIMATION_FRAMES = 10; //The number of frames the trampoline animates after being jumped on

//Combo Setup:
//Combo 1: Trampoline - Still
//Combo 2: Trampoline - Bouncing
//D0: How high the trampoline launches Link
//D1: The number of the flag marking combos Link can jump over.

ffc script Trampoline{
	bool CanWalkFlag(int flag, int x, int y, int dir, int step, bool full_tile) {
		int c=8;
		int xx = x+15;
		int yy = y+15;
		if(full_tile) c=0;
		if(dir==0) return y-step>0&&(ComboFI(x,y+c-step, flag)||ComboFI(x+8,y+c-step, flag)||ComboFI(xx,y+c-step, flag));
		else if(dir==1) return yy+step<176&&(ComboFI(x,yy+step, flag)||ComboFI(x+8,yy+step, flag)||ComboFI(xx,yy+step, flag));
		else if(dir==2) return x-step>0&&(ComboFI(x-step,y+c, flag)||ComboFI(x-step,y+c+7, flag)||ComboFI(x-step,yy, flag));
		else if(dir==3) return xx+step<256&&(ComboFI(xx+step,y+c, flag)||ComboFI(xx+step,y+c+7, flag)||ComboFI(xx+step,yy, flag));
		return false; //invalid direction
	}
	void run(int JumpHeight, int Flag, int Warp){
		int Combo = this->Data;
		int OldX;
		int OldY;
		int AnimCounter = 0;
		Waitframe();
		while(true){
			if(this->Data!=Combo)
				this->Data = Combo;
			if(SquareCollision(Link->X+4, Link->Y+4, 8, this->X+4, this->Y+4, 8)&&Link->Z==0){
				Game->PlaySound(SFX_JUMP);
				if (Warp > 0)
				{
					Link->X = this->X;
					Link->Y = this->Y;
				}
				Link->Jump = JumpHeight;
				OldX = Link->X;
				OldY = Link->Y;
				this->Data = Combo+1;
				AnimCounter = TRAMPOLINE_ANIMATION_FRAMES;
				do{
					if (Warp <= 0)
					{
						if(AnimCounter>0)	
							AnimCounter--;
						else
							this->Data = Combo;
						bool Moving = false;
						if(Link->InputUp&&(CanWalk(Link->X, Link->Y, DIR_UP, 1.5, false)||CanWalkFlag(Flag, Link->X, Link->Y, DIR_UP, 1.5, false))){
							OldY -= 1.5;
							Moving = true;
						}
						else if(Link->InputDown&&(CanWalk(Link->X, Link->Y, DIR_DOWN, 1.5, false)||CanWalkFlag(Flag, Link->X, Link->Y, DIR_DOWN, 1.5, false))){
							OldY += 1.5;
							Moving = true;
						}
						if(Link->InputLeft&&(CanWalk(Link->X, Link->Y, DIR_LEFT, 1.5, false)||CanWalkFlag(Flag, Link->X, Link->Y, DIR_LEFT, 1.5, false))){
							OldX -= 1.5;
							Moving = true;
						}
						else if(Link->InputRight&&(CanWalk(Link->X, Link->Y, DIR_RIGHT, 1.5, false)||CanWalkFlag(Flag, Link->X, Link->Y, DIR_RIGHT, 1.5, false))){
							OldX += 1.5;
							Moving = true;
						}
						if(Moving){
							Link->X = OldX;
							Link->Y = OldY;
						}
						else{
							OldX = Link->X;
							OldY = Link->Y;
						}
					}
					else NoAction();
					if (Link->Z > Link->Y && Warp > 0)
					{
						this->Data = CMB_AUTOWARP;
					}
					Waitframe();
				}while(Link->Z>0);
			}
			Waitframe();
		}
	}
}

ffc script EnterFromBelow
{
	void run()
	{
		if (Link->X >= 16 && Link->X <= 224 && Link->Y >= 16 && Link->Y <= 144)
		{
			Link->Z = 1;
			Link->Jump = 4;
			if (Screen->ComboD[ComboAt(Link->X + 8, Link->Y + 8)] == 5660) Screen->ComboD[ComboAt(Link->X + 8, Link->Y + 8)]++;
		}
	}
}

ffc script EnterFromAbove
{
	void run()
	{
		Waitframe();
		if (!CanWalk(Link->X, Link->Y, DIR_UP, 1, false) && !CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)
		&& !CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false) && !CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false) && Link->Z > 0)
		{
			while(Link->Z > 0) Waitframe();
			Link->Jump = 1.5;
			int Savage = 0;
			int SavageDist = 200;
			for (int i = 175; i >= 0; i--)
			{
				if (Screen->ComboF[i] == 99 && Distance(ComboX(i), ComboY(i), Link->X, Link->Y) < SavageDist)
				{
					Savage = i;
					SavageDist = Distance(ComboX(i), ComboY(i), Link->X, Link->Y);
				}
			}
			if (Savage > 0)
			{
				while (Distance(ComboX(Savage), ComboY(Savage), Link->X, Link->Y) > 2.5)
				{
					Link->X += VectorX(2, Angle(Link->X, Link->Y, ComboX(Savage), ComboY(Savage)));
					Link->Y += VectorY(2, Angle(Link->X, Link->Y, ComboX(Savage), ComboY(Savage)));
					Waitframe();
				}
			}
		}
	}
}
