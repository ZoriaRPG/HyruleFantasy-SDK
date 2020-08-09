// ----------------------------------------------------------------------
// Constants

//Common Constant, only need to define once per script file.
const int BIG_LINK                        = 0;   //Set this constant to 1 if using the Large Link Hit Box feature.
 
//Constants used by Bottomless Pits & Lava.
const int CT_HOLELAVA              = 128; //Combo type to use for pit holes and lava."No Ground Enemies by default"
const int CF_PIT                                = 100;  //The combo flag to register combos as pits.
const int CF_LAVA                          = 101;  //The combo flag to register combos as lava.
const int WPS_LINK_FALL          = 92;  //The weapon sprite to display when Link falls into a pit. "Sprite 88 by default"
const int WPS_LINK_LAVA          = 93;  //The weapon sprite to display when Link drowns in lava. "Sprite 89 by default"
const int SFX_LINK_FALL          = 73;  //The sound to play when Link falls into a pit. "SFX_FALL by default"
const int SFX_LINK_LAVA          = 55;  //The sound to play when Link drowns in Lava. "SFX_SPLASH by default.
const int CMB_AUTOWARP            = 3128; //The first of your four transparent autowarp combos.
const int HOLE_DAMAGE          = 8;   //Damage in hit points to inflict on link. "One Heart Container is worth 16 hit points"
const int LAVA_DAMAGE          = 16;   //Damage in hit points to inflict on link. "One Heart Container is worth 16 hit points"


//Array Indices of PitsLava[]
const int HL_FALLING               = 0;
const int HL_WARPING               = 1;
const int HL_OLDDMAP               = 2;
const int HL_OLDSCREEN             = 3;
const int HL_STARTX                = 4;
const int HL_STARTY                = 5;
const int HL_STARTDIR              = 6;

//Global variables used by Bottomless Pits & Lava.
int Falling;
bool Warping;


global script Slot_2{
   void run(){
   
   //StartGhostZH(); //! Enable if using ghost.zh
        InitHoleLava(); //Inits Tamamo's holes and lava.
   
   //UpdateGhostZH1();//! Enable if using ghost.zh
            
   
   
   
   
   
   
     //Initialize variables used to store Link's strating position on Screen Init.
        int olddmap = Game->GetCurDMap();
        int oldscreen = Game->GetCurDMapScreen();
        int startx = Link->X;
        int starty = Link->Y;
        int startdir = Link->Dir;
 
        //Clear global variables used by Bottomless pits.
        Falling = 0;
        Warping = false;
   
   
   
	
      while(true){
      
       if(Link->Action != LA_SCROLLING)
            {
                Update_HoleLava(startx, starty, olddmap, oldscreen, startdir);
                if(Link->Z==0 && !Falling && (oldscreen != Game->GetCurDMapScreen() || olddmap != Game->GetCurDMap()))
                {
                    olddmap = Game->GetCurDMap();
                    oldscreen = Game->GetCurDMapScreen();
                    startx = Link->X;
                    starty = Link->Y;
                    startdir = Link->Dir;
                }
            }

         Waitdraw();
		
        
	 //UpdateGhostZH2(); //! Enable if using ghost.zh
			//LREx1Ex2ItemSwitch(); //! Enable if you want to allow A+B item switchign with Ex1/Ex2
			if (Link->Action != LA_SCROLLING ) RunHoleLava(); //Main Tamamo Holes and Lava function.

         Waitframe();

      }//end whileloop
   }//end run
}//end global slot2

//Arrays -------------------------------------------------------------------------------
float PitsLava[7]; //Array for Holelava.



// Moving Platform
//This function simply checks if that the center of Link is within the bounds of the ffc.
//EJO - might want to refine offsets for more lenient behavior, especially vertical bounds

bool OnPlatform (ffc this){
    if(CenterLinkX() < this->X - 4) return false;
    else if(CenterLinkX() >= this->X + this->EffectWidth + 4) return false;
    else if(CenterLinkY() < this->Y - 4) return false;
    else if(CenterLinkY() >= this->Y + this->EffectHeight + 4) return false;
    else return true;
    }
    
//This script turns a moving ffc into a platform so it carries Link.
ffc script Platform{
    void run(){
        //Initialize two variables to store the position of the ffc the previous frame.
        float oldx = this->X;
        float oldy = this->Y;
        //Initialize two variables to store the change in Link's position each frame.
        float linkx;
        float linky;
        //Loop Indefinitely.
        while(true){
            //Check if Link is on the platform and is not mid-air.
            if(OnPlatform(this) && Link->Z == 0){
                //Increment linkx by the change in the ffc's position along the x axis.
				linkx += this->X - oldx;
                //Check if the absolute value of linkx truncated to an int doesn't = 0.
                if(linkx<<0 != 0){
					int Dir = 0;
					if (linkx < 0) Dir = DIR_LEFT;
					else Dir = DIR_RIGHT;
                    //Increment link's position by linkx truncated removed.
                    if (CanWalk(Link->X, Link->Y, Dir, Abs(linkx<<0), false)) Link->X += linkx<<0;
                    //Decrement linkx by itself rounded down.
                    linkx -= linkx<<0;
                }
                //Vertical Movement is the same as horizontal movement just along the y axis.
                linky += this->Y - oldy;
                if(linky<<0 != 0){
					int Dir = 0;
					if (linky < 0) Dir = DIR_UP;
					else Dir = DIR_DOWN;
                    if (CanWalk(Link->X, Link->Y, Dir, Abs(linky<<0), false)) Link->Y += linky<<0;
                    linky -= linky<<0;
                }
            }
            //Set oldx and oldy to the ffc's current position.
            oldx = this->X;
            oldy = this->Y;
            //Waitframe to prevent lag.
            Waitframe();
        }
    }
}
//F1.7 Pits and Lava


//Used to determine if Link is on a Pit or Lava combo.
int OnPitCombo()
{
    int moving_platform[] = "Platform";
    int script_num = Game->GetFFCScript(moving_platform);
    int comboLoc = ComboAt(Link->X+8, Link->Y + Cond(BIG_LINK==0, 12, 8));
    for (int i = 1; i <= 32; i++)
	{
		ffc f = Screen->LoadFFC(i);
		if (f->Script == script_num && OnPlatform(f))
			return 0;
	}
    if(Screen->ComboT[comboLoc] != CT_HOLELAVA)
        return 0;
    else if(Screen->ComboI[comboLoc] == CF_PIT || Screen->ComboI[comboLoc] == CF_LAVA)
        return Screen->ComboI[comboLoc];
    else if(Screen->ComboF[comboLoc] == CF_PIT || Screen->ComboF[comboLoc] == CF_LAVA)
        return Screen->ComboF[comboLoc];
    else
        return 0;
}
 
//Snaps Link to the combo so he appears completely over pit and lava combos.
void SnaptoGrid()
{
	int x = Link->X;
	int y = Link->Y + Cond(BIG_LINK==0, 8, 0);
	int comboLoc = ComboAt(x, y);
 
	//X Axis
	if(Screen->ComboT[comboLoc] == CT_HOLELAVA && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc+1] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc);
	else if(Screen->ComboT[comboLoc+1] == CT_HOLELAVA && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc+1);
	if(Cond(y % 16 == 0, false, Screen->ComboT[comboLoc+16] == CT_HOLELAVA) && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc+17] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc+16);
	else if(Cond(y % 16 == 0, false, Screen->ComboT[comboLoc+17] == CT_HOLELAVA) && Cond(x % 16 == 0, true, Screen->ComboT[comboLoc+16] != CT_HOLELAVA))
		Link->X = ComboX(comboLoc+17);
 
	//Y Axis
	if(Screen->ComboT[comboLoc] == CT_HOLELAVA && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc+16] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc);
	else if(Screen->ComboT[comboLoc+16] == CT_HOLELAVA && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc+16);
	if(Cond(x % 16 == 0, false, Screen->ComboT[comboLoc+1] == CT_HOLELAVA) && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc+17] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc+1);
	else if(Cond(x % 16 == 0, false, Screen->ComboT[comboLoc+17] == CT_HOLELAVA) && Cond(y % 16 == 0, true, Screen->ComboT[comboLoc+1] != CT_HOLELAVA))
		Link->Y = ComboY(comboLoc+17);
}

//Used to make Ex1/Ex2 switch items like L&R for A+B subscreens.
void LREx1Ex2ItemSwitch()
{
	if (Link->PressL && Link->Action != LA_SCROLLING)
	{
		Link->SelectBWeapon(DIR_LEFT);
	}
	if (Link->PressR && Link->Action != LA_SCROLLING)
	{
		Link->SelectBWeapon(DIR_RIGHT);
	}
	if (Link->PressEx1 && Link->Action != LA_SCROLLING)
	{
		Link->SelectAWeapon(DIR_LEFT);
	}
	if (Link->PressEx2 && Link->Action != LA_SCROLLING)
	{
		Link->SelectAWeapon(DIR_RIGHT);
	}
}

//Hole_Lava Init. Call before Waitdraw().
void InitHoleLava(){
	//Initialize variables used to store Link's strating position on Screen Init.
			PitsLava[HL_OLDDMAP] = Game->GetCurDMap();
            PitsLava[HL_OLDSCREEN] = Game->GetCurDMapScreen();
            PitsLava[HL_STARTX] = Link->X;
            PitsLava[HL_STARTY] = Link->Y;
            PitsLava[HL_STARTDIR] = Link->Dir;
 
			//Clear global variables used by Bottomless pits.
			PitsLava[HL_FALLING] = 0;
			PitsLava[HL_WARPING] = 0;
}

//Main Hole_Lava Rountine. Call after Waitdraw().
void RunHoleLava(){
    Update_HoleLava(PitsLava[HL_STARTX], PitsLava[HL_STARTY], PitsLava[HL_OLDDMAP], PitsLava[HL_OLDSCREEN], PitsLava[HL_STARTDIR]);
    if(Link->Z==0 && !PitsLava[HL_FALLING] && ( PitsLava[HL_OLDSCREEN] != Game->GetCurDMapScreen() || PitsLava[HL_OLDDMAP] != Game->GetCurDMap() ) && !OnPitCombo() )
    {
        PitsLava[HL_OLDDMAP] = Game->GetCurDMap();
        PitsLava[HL_OLDSCREEN] = Game->GetCurDMapScreen();
        PitsLava[HL_STARTX] = Link->X;
        PitsLava[HL_STARTY] = Link->Y;
        PitsLava[HL_STARTDIR] = Link->Dir;
    }
}

//Handles Pit Combo Functionality.
void Update_HoleLava(int x, int y, int dmap, int scr, int dir)
{
	lweapon hookshot = LoadLWeaponOf(LW_HOOKSHOT);
	if(hookshot->isValid()) return;
	
	if (PegasusDash >= 0 && Link->Item[155] == true) return;
	else StopDash();
 
	if(PitsLava[HL_FALLING])
	{
		if(IsSideview()) Link->Jump=0;
		PitsLava[HL_FALLING]--;
		if(PitsLava[HL_FALLING] == 1)
		{
			int buffer[] = "Holelava";
			if(CountFFCsRunning(Game->GetFFCScript(buffer)))
			{
				ffc f = Screen->LoadFFC(FindFFCRunning(Game->GetFFCScript(buffer)));
				PitsLava[HL_WARPING] = 1;
				if(f->InitD[1]==0)
				{
					f->InitD[6] = x;
					f->InitD[7] = y;
				}
			}
			else
			{
				int comboflag = OnPitCombo();
				Link->X = x;
				Link->Y = y;
				Link->Dir = dir;
				Link->DrawXOffset -= Cond(Link->DrawXOffset < 0, -1000, 1000);
				Link->HitXOffset -= Cond(Link->HitXOffset < 0, -1000, 1000);
				Link->HP -= Cond(comboflag == CF_PIT, HOLE_DAMAGE, LAVA_DAMAGE);
				Link->Action = LA_GOTHURTLAND;
				Link->HitDir = -1;
				Game->PlaySound(SFX_OUCH);
				if(Game->GetCurDMap()!=dmap || Game->GetCurDMapScreen()!=scr)
				Link->PitWarp(dmap, scr);
			}
			NoAction();
			Link->Action = LA_NONE;
		}
	}
	else if(Link->Z==0 && OnPitCombo() && !PitsLava[HL_WARPING])
	{
		Link->DrawXOffset += Cond(Link->DrawXOffset < 0, -1000, 1000);
		Link->HitXOffset += Cond(Link->HitXOffset < 0, -1000, 1000);
		int comboflag = OnPitCombo();
		SnaptoGrid();
		Game->PlaySound(Cond(comboflag == CF_PIT, SFX_LINK_FALL, SFX_LINK_LAVA));
		lweapon dummy = CreateLWeaponAt(LW_SPARKLE, Link->X, Link->Y);
		dummy->UseSprite(Cond(comboflag == CF_PIT, WPS_LINK_FALL, WPS_LINK_LAVA));
		dummy->DeadState = Max(1, dummy->NumFrames + 1)*(dummy->ASpeed + 1);
		dummy->DrawXOffset = 0;
		dummy->DrawYOffset = 0;
		PitsLava[HL_FALLING] = dummy->DeadState;
		NoAction();
		Link->Action = LA_NONE;
	}
}

//Holes and Lava Main ffc
 
ffc script Holelava
{
	void run(int warp, bool position, int damage)
	{
		while(true)
		{
			while(!PitsLava[HL_WARPING]) Waitframe();
			if(warp > 0)
			{
				this->Data = CMB_AUTOWARP+warp-1;
				this->Flags[FFCF_CARRYOVER] = true;
				Waitframe();
				this->Data = FFCS_INVISIBLE_COMBO;
				this->Flags[FFCF_CARRYOVER] = false;
				Link->Z = Link->Y;
				PitsLava[HL_WARPING] = 0;
				Link->DrawXOffset -= Cond(Link->DrawXOffset < 0, -1000, 1000);
				Link->HitXOffset -= Cond(Link->HitXOffset < 0, -1000, 1000);
				Quit();
			}
			if(position)
			{
				Link->X = this->X;
				Link->Y = this->Y;
			}
			else
			{
				Link->X = this->InitD[6];
				Link->Y = this->InitD[7];
			}
			if(damage)
			{
				Link->HP -= damage;
				Link->Action = LA_GOTHURTLAND;
				Link->HitDir = -1;
				Game->PlaySound(SFX_OUCH);
			}
			Link->DrawXOffset -= Cond(Link->DrawXOffset < 0, -1000, 1000);
			Link->HitXOffset -= Cond(Link->HitXOffset < 0, -1000, 1000);
			PitsLava[HL_WARPING] = 0;
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
		if (Link->X >= 16 && Link->X <= 240 && Link->Y >= 16 && Link->Y <= 160)
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
