ffc script SomariaRod{
	void run(int damage, int wandsprite, int flamesprite, int speed, int cost, int freezeduration){
		lweapon wand = LweaponInit (this, LW_GHOSTED, damage, wandsprite, 0);
		int somcost = cost;
		MeleeWeaponSlash90Alt(this, wand, wand->Misc[LWEAPON_MISC_ORIGTILE], 8, 12, 88, 0, NPCD_WAND, 0, 2);
		int ffcs[] = "SomariaBlock";
		int slot = Game->GetFFCScript(ffcs);
		if(CountFFCsRunning(slot)>0) somcost = 0;
		if (!AmmoManager(CR_MAGIC, somcost, 104, false)){
			MeleeWeaponEndStrike(this, wand, wand->Misc[LWEAPON_MISC_ORIGTILE], 12, 2, 2);
		}
		int it = GetItemID(wand);
		int args[8] = {damage, flamesprite, speed, freezeduration, 0, 0 ,0, it};
		int i = FindSomariaPlatform(true);
		if(i>-1){
			Game->PlaySound(SFX_SOMARIA);
			ffc f = Screen->LoadFFC(i);
			f->InitD[3] = 0;
			lweapon poof = CreateLWeaponAt(LW_SCRIPT10, f->X-8, f->Y-8);
			poof->UseSprite(SPR_SOMARIAPLATFORMPOOF);
			poof->Extend = 3;
			poof->TileWidth = 3;
			poof->TileHeight = 3;
			poof->DeadState = poof->NumFrames*poof->ASpeed;
		}
		else if(CountFFCsRunning(slot)==0){
			RunFFCScript(slot, 0);
		}
		else{
			ffc block = Screen->LoadFFC(FindFFCRunning(slot));
			if(block->InitD[0]==1){
				block->InitD[0] = 3; //State 3: Dying (Beams)
			}
		}
		//PutFFCInFrontOfLink(magic, 16);
		Game->PlaySound(SFX_FIRE);
		MeleeWeaponEndStrike(this, wand, wand->Misc[LWEAPON_MISC_ORIGTILE], 12, 2, 2);
	}	
}

const int CF_ELEVATOR = 100; //Combo flag marking elevator tracks
const int CF_ELEVATORSTOP = 12; //Combo flag marking that you can get off an elevator
const int CF_ELEVATORNOTURN = 8; 

const int SFX_ELEVATOR_START = 0; //Sound that plays when an elevator starts moving
const int SFX_ELEVATOR_PERSISTENT = 0; //Sound that plays while an elevator moves

const int ELEVATOR_SFX_FREQ = 4; //How often the persistent sound plays

const int ELEVATOR_STEP = 2; //How fast elevators move along tracks

const int LM_ACTION = 2; //Link->Misc for special actions
const int LMA_ON_ELEVATOR = 1; //Link->Misc state for being on an elevator

const int ELEVATOR_ACTIVEDIST = 12;

ffc script Elevator{
	void run(int offX, int offY, int combo, int active){
		int elevatorX = this->X+offX;
		int elevatorY = this->Y+offY;
		int elevatorDir;
		int targetX; int targetY;
		int sfxTimer;
		bool onElevator;
		int data = this->Data;
		this->Data = FFCS_INVISIBLE_COMBO;
		Waitframe();
		int vars[16];
		if(combo>0){
			if(Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR){
				this->Data = combo;
				this->InitD[3] = 1; //Active
			}
			else{
				this->InitD[3] = 0;
			}
			vars[0] = combo;
		}
		else{
			this->InitD[3] = 1; //Active
			this->Data = data;
			vars[0] = data;
		}
		if(Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR&&ComboFI(Link->X+8, Link->Y+8, CF_ELEVATOR)){
			elevatorX = ComboX(ComboAt(Link->X+8, Link->Y+8));
			elevatorY = ComboY(ComboAt(Link->X+8, Link->Y+8));
			this->X = elevatorX-offX;
			this->Y = elevatorY-offY;
			
			if(elevatorX==0)
				elevatorDir = DIR_RIGHT;
			else if(elevatorX==240)
				elevatorDir = DIR_LEFT;
			else if(elevatorY==0)
				elevatorDir = DIR_DOWN;
			else if(elevatorY==160)
				elevatorDir = DIR_UP;
			
			targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
			targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
			Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
		}
		else if(Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR)
			Link->Misc[LM_ACTION] = 0;
		while(true){
			while(Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR){
				while(Distance(elevatorX, elevatorY, targetX, targetY)>ELEVATOR_STEP&&Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR){
					if(SFX_ELEVATOR_PERSISTENT>0){
						sfxTimer++;
						if(sfxTimer>ELEVATOR_SFX_FREQ){
							sfxTimer = 0;
							Game->PlaySound(SFX_ELEVATOR_PERSISTENT);
						}
					}
					int angle = Angle(elevatorX, elevatorY, targetX, targetY);
					elevatorX += VectorX(ELEVATOR_STEP, angle);
					elevatorY += VectorY(ELEVATOR_STEP, angle);
					this->X = elevatorX-offX;
					this->Y = elevatorY-offY;
					Link->X = elevatorX;
					Link->Y = elevatorY;
					Link->Jump = 0;
					Elevator_Waitframe(this, vars);
				}
				elevatorX = targetX;
				elevatorY = targetY;
				this->X = elevatorX-offX;
				this->Y = elevatorY-offY;
				if(Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR){
					Link->X = elevatorX;
					Link->Y = elevatorY;
				}
				if(ComboFI(elevatorX+8, elevatorY+8, CF_ELEVATORSTOP)){
					Link->Misc[LM_ACTION] = 0;
					if(Link->InputUp&&CheckElevator(elevatorX, elevatorY, DIR_UP)){
						elevatorDir = DIR_UP;
						targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
						targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
						Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					}
					else if(Link->InputDown&&CheckElevator(elevatorX, elevatorY, DIR_DOWN)){
						elevatorDir = DIR_DOWN;
						targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
						targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
						Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					}
					else if(Link->InputLeft&&CheckElevator(elevatorX, elevatorY, DIR_LEFT)){
						elevatorDir = DIR_LEFT;
						targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
						targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
						Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					}
					else if(Link->InputRight&&CheckElevator(elevatorX, elevatorY, DIR_RIGHT)){
						elevatorDir = DIR_RIGHT;
						targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
						targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
						Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					}
					else{
						while(!Link->PressUp&&!Link->PressDown&&!Link->PressLeft&&!Link->PressRight){
							Elevator_Waitframe(this, vars);
						}
						Elevator_Waitframe(this, vars);
					}
				}
				else{
					int oldDir = elevatorDir;
					elevatorDir = -1;
					for(int i=0; i<4&&elevatorDir==-1; i++){
						if(OppositeDir(oldDir)!=i){
							if(CheckElevator(elevatorX, elevatorY, i))
								elevatorDir = i;
						}
					}
					if(elevatorDir==-1)
						elevatorDir = oldDir;
					if(ComboFI(elevatorX, elevatorY, CF_ELEVATORNOTURN))
						elevatorDir = oldDir;
					
					targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
					targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
					if(ElevatorNumBranches(elevatorX, elevatorY)>2&&!ComboFI(elevatorX+8, elevatorY+8, CF_ELEVATORNOTURN)){
						elevatorDir = -1;
						while(elevatorDir==-1&&Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR){
							this->X = elevatorX-offX;
							this->Y = elevatorY-offY;
							Link->X = elevatorX;
							Link->Y = elevatorY;
							Link->Jump = 0;
							if(Link->InputUp&&CheckElevator(elevatorX, elevatorY, DIR_UP)){
								elevatorDir = DIR_UP;
								targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
								targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
								Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
							}
							else if(Link->InputDown&&CheckElevator(elevatorX, elevatorY, DIR_DOWN)){
								elevatorDir = DIR_DOWN;
								targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
								targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
								Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
							}
							else if(Link->InputLeft&&CheckElevator(elevatorX, elevatorY, DIR_LEFT)){
								elevatorDir = DIR_LEFT;
								targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
								targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
								Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
							}
							else if(Link->InputRight&&CheckElevator(elevatorX, elevatorY, DIR_RIGHT)){
								elevatorDir = DIR_RIGHT;
								targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
								targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
								Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
							}
							Elevator_Waitframe(this, vars);
						}
					}
				}
			}
			elevatorX = this->X+offX;
			elevatorY = this->Y+offY;
			if(Distance(elevatorX, elevatorY, Link->X, Link->Y)<ELEVATOR_ACTIVEDIST){
				if(Link->Dir==DIR_UP&&Link->InputUp&&CheckElevator(elevatorX, elevatorY, DIR_UP)){
					elevatorDir = DIR_UP;
					targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
					targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
					Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					Game->PlaySound(SFX_ELEVATOR_START);
				}
				else if(Link->Dir==DIR_DOWN&&Link->InputDown&&CheckElevator(elevatorX, elevatorY, DIR_DOWN)){
					elevatorDir = DIR_DOWN;
					targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
					targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
					Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					Game->PlaySound(SFX_ELEVATOR_START);
				}
				else if(Link->Dir==DIR_LEFT&&Link->InputLeft&&CheckElevator(elevatorX, elevatorY, DIR_LEFT)){
					elevatorDir = DIR_LEFT;
					targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
					targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
					Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					Game->PlaySound(SFX_ELEVATOR_START);
				}
				else if(Link->Dir==DIR_RIGHT&&Link->InputRight&&CheckElevator(elevatorX, elevatorY, DIR_RIGHT)){
					elevatorDir = DIR_RIGHT;
					targetX = ElevatorTargetX(elevatorX, elevatorY, elevatorDir);
					targetY = ElevatorTargetY(elevatorX, elevatorY, elevatorDir);
					Link->Misc[LM_ACTION] = LMA_ON_ELEVATOR;
					Game->PlaySound(SFX_ELEVATOR_START);
				}
			}
			Elevator_Waitframe(this, vars);
		}
	}
	void Elevator_Waitframe(ffc this, int vars){
		this->EffectWidth = this->TileWidth*16;
		this->EffectHeight = this->TileHeight*16;
		if(Link->Action==LA_FROZEN){
			while(Link->Action==LA_FROZEN){
				if(Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR&&Distance(Link->X, Link->Y, this->X+8, this->Y+8)>8){
					this->InitD[3] = 0;
					Link->Misc[LM_ACTION] = 0;
					this->Data = FFCS_INVISIBLE_COMBO;
					lweapon poof = CreateLWeaponAt(LW_SCRIPT10, this->X-8, this->Y-8);
					poof->UseSprite(SPR_SOMARIAPLATFORMPOOF);
					poof->Extend = 3;
					poof->TileWidth = 3;
					poof->TileHeight = 3;
					poof->DeadState = poof->NumFrames*poof->ASpeed;
				}
				Waitframe();
			}
		}
		if(this->InitD[3]==0){
			this->Data = GH_INVISIBLE_COMBO;
			this->Flags[FFCF_ETHEREAL] = true;
			if(Link->Misc[LM_ACTION]==LMA_ON_ELEVATOR)
				Link->Misc[LM_ACTION] = 0;
		}
		else{
			this->Data = vars[0];
			this->Flags[FFCF_ETHEREAL] = false;
		}
		Waitframe();
	}
	bool CheckElevator(int elevatorX, int elevatorY, int elevatorDir){
		int x; int y;
		if(elevatorDir==DIR_UP){
			x = elevatorX+8;
			y = elevatorY-8;
			if(ComboFI(x, y, CF_ELEVATOR)||ComboFI(x, y, CF_ELEVATORSTOP))
				return true;
		}
		else if(elevatorDir==DIR_DOWN){
			x = elevatorX+8;
			y = elevatorY+24;
			if(ComboFI(x, y, CF_ELEVATOR)||ComboFI(x, y, CF_ELEVATORSTOP))
				return true;
		}
		else if(elevatorDir==DIR_LEFT){
			x = elevatorX-8;
			y = elevatorY+8;
			if(ComboFI(x, y, CF_ELEVATOR)||ComboFI(x, y, CF_ELEVATORSTOP))
				return true;
		}
		else if(elevatorDir==DIR_RIGHT){
			x = elevatorX+24;
			y = elevatorY+8;
			if(ComboFI(x, y, CF_ELEVATOR)||ComboFI(x, y, CF_ELEVATORSTOP))
				return true;
		}
		return false;
	}
	int ElevatorNumBranches(int elevatorX, int elevatorY){
		int count;
		for(int i=0; i<4; i++){
			if(CheckElevator(elevatorX, elevatorY, i))
				count++;
		}
		return count;
	}
	int ElevatorTargetX(int elevatorX, int elevatorY, int elevatorDir){
		if(elevatorDir==DIR_LEFT)
			return elevatorX-16;
		else if(elevatorDir==DIR_RIGHT)
			return elevatorX+16;
		else
			return elevatorX;
	}
	int ElevatorTargetY(int elevatorX, int elevatorY, int elevatorDir){
		if(elevatorDir==DIR_UP)
			return elevatorY-16;
		else if(elevatorDir==DIR_DOWN)
			return elevatorY+16;
		else
			return elevatorY;
	}
}