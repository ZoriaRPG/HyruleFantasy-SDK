ffc script Beamos2{
	//This function draws the parts of the beamos in the right order
	void Beamos_Draw(ffc this, npc ghost, int Combo, int EyeAngle){
		int EyeX = Ghost_X+VectorX(8, EyeAngle);
		int EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
		int EyeCombo = Combo+2+AngleDir8(EyeAngle);
		if(Link->HP>0){
			if(EyeAngle<=0)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
			Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
			if(EyeAngle>0)
				Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
			Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
		}
	}
	//This function checks the path of the beamos' laser before firing
	bool CheckPath(int X, int Y, int Angle, int Distance, int SafeDist, int Step){
		for(int i = 0; i<Distance-Step; i+=Step){
			X += VectorX(Step, Angle);
			Y += VectorY(Step, Angle);
			if(Screen->isSolid(X, Y)&&i>SafeDist && Screen->ComboT[ComboAt(X, Y)] != CT_HOOKSHOTONLY && Screen->ComboT[ComboAt(X, Y)] != CT_LADDERHOOKSHOT)
				return false;
		}
		return true;
	}
	//This function checks if the laser is colliding with Link and deals damage
	void CheckBeamosLaser(npc ghost, int StartX, int StartY, int EndX, int EndY){
		if(lineBoxCollision(StartX, StartY, EndX, EndY, Link->X, Link->Y, Link->X+Link->HitWidth, Link->Y+Link->HitHeight, 0)){
			eweapon e = FireEWeapon(EW_SCRIPT10, Link->X+InFrontX(Link->Dir, 10), Link->Y+InFrontY(Link->Dir, 10), 0, 0, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE);
			SetEWeaponLifespan(e, EWL_TIMER, 1);
			SetEWeaponDeathEffect(e, EWD_VANISH, 0);
			e->DrawYOffset = -1000;
		}
	}
	void CheckBeamosLaser2(npc ghost, int StartX, int StartY, int EndX, int EndY){
		for (int i = 1; i <= Screen->NumNPCs(); i++)
		{
			npc MahBoi = Screen->LoadNPC(i);
			if(lineBoxCollision(StartX, StartY, EndX, EndY, MahBoi->X + MahBoi->HitXOffset, MahBoi->Y + MahBoi->HitYOffset, MahBoi->X + MahBoi->HitXOffset + MahBoi->HitWidth - 1, MahBoi->Y + MahBoi->HitYOffset + MahBoi->HitHeight - 1, 0)
			&& (MahBoi->Defense[NPCD_SCRIPT] == NPCDT_NONE || MahBoi->Defense[NPCD_SCRIPT] == NPCDT_HALFDAMAGE || MahBoi->Defense[NPCD_SCRIPT] == NPCDT_QUARTERDAMAGE)){
				lweapon e = Screen->CreateLWeapon(LW_SCRIPT6);
				e->Dir = MahBoi->Dir;
				e->Damage = ghost->Damage;
				e->Step = 0;
				e->X = MahBoi->X + MahBoi->HitXOffset;
				e->Y = MahBoi->Y + MahBoi->HitYOffset;
				e->CollDetection = true;
				e->DrawYOffset = -1000;
				e->Misc[5] = 2;
			}
		}
	}
	void run(int enemyid, int lifted){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int StartAngle = ghost->Attributes[0];
		int IncrementAngle = ghost->Attributes[1];
		int LaserCooldown = ghost->Attributes[2];
		int NoCollision = ghost->Attributes[3];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, ghost->CSet, 1, 2);
		Ghost_Y-=8;
		if(NoCollision==1)
			ghost->CollDetection = false;
		Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
		int EyeAngle = WrapDegrees(StartAngle);
		this->Flags[FFCF_IGNOREHOLDUP] = true;
		int push[2];
		int lastDir[8];
		while(true){
			if (this->InitD[1] == 0)
			{
				EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
				int EyeX = Ghost_X+VectorX(8, EyeAngle);
				int EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
				int AngleLink = Angle(EyeX+8, EyeY+8, CenterLinkX(), CenterLinkY());
				int DistLink = Distance(EyeX+8, EyeY+8, CenterLinkX(), CenterLinkY());
				//Check if the eye is aimed at Link and there's a clear path before firing
				if(Abs(angleDifference(EyeAngle, AngleLink))<BEAMOS_IMPRECISION&&CheckPath(EyeX+8, EyeY+8, AngleLink, DistLink, BEAMOS_LASER_MINDIST, 6)){
					int Angle = Angle(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
					int LStartX = EyeX+8;
					int LStartY = EyeY+8;
					int LEndX = LStartX;
					int LEndY = LStartY;
					int LaserLength = 0;
					bool LaserEnded = false;
					//Play the line of sight sound and flash briefly
					Game->PlaySound(SFX_BEAMOS_SIGHT);
					Ghost_StartFlashing(BEAMOS_FLASHFRAMES);
					for(int i=0; i<BEAMOS_FLASHFRAMES; i++){
						Beamos_Draw(this, ghost, Combo, EyeAngle);
						ElephantStatue_ConveyorMovement(this, push, lastDir);
						SolidObjects_Add(this->X, this->Y+16, 16, 16);
						if (this->InitD[1] != 0) break;
						Ghost_Waitframe(this, ghost, true, true);
					}
					if (this->InitD[1] == 0)
					{
						//Fire the laser until it reaches full length or hits a wall
						Game->PlaySound(SFX_BEAMOS_LASER);
						while(Distance(LStartX, LStartY, LEndX, LEndY)<BEAMOS_LASER_LENGTH&&!LaserEnded){
							int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
							LEndX += VectorX(BEAMOS_LASER_SPEED, Angle);
							LEndY += VectorY(BEAMOS_LASER_SPEED, Angle);
							LaserLength += BEAMOS_LASER_SPEED;
							if((Screen->isSolid(LEndX, LEndY)&&Distance(EyeX+8, EyeY+8, LEndX, LEndY)>=BEAMOS_LASER_MINDIST&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_HOOKSHOTONLY&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_LADDERHOOKSHOT)||(LEndX<-16||LEndX>272||LEndY<-16||LEndY>192))
								LaserEnded = true;
							//Draw everything in order
							int EyeCombo = Combo+2+AngleDir8(EyeAngle);
							if(Link->HP>0){
								if(EyeAngle<=0){
									if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
									Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
									Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
									Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								}
								if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
								if(EyeAngle>0){
									if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
									Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
									Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
									Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								}
								if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
							}
							CheckBeamosLaser(ghost, LStartX, LStartY, LEndX, LEndY);
							ElephantStatue_ConveyorMovement(this, push, lastDir);
							SolidObjects_Add(this->X, this->Y+16, 16, 16);
							Ghost_Waitframe(this, ghost, true, true);
						}
						//If it reaches full length
						if(!LaserEnded){
							while((!Screen->isSolid(LEndX, LEndY)&&!(LEndX<-16||LEndX>272||LEndY<-16||LEndY>192)&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_HOOKSHOTONLY&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_LADDERHOOKSHOT)||Distance(EyeX+8, EyeY+8, LEndX, LEndY)<BEAMOS_LASER_MINDIST){
								int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
								LStartX += VectorX(BEAMOS_LASER_SPEED, Angle);
								LStartY += VectorY(BEAMOS_LASER_SPEED, Angle);
								LEndX += VectorX(BEAMOS_LASER_SPEED, Angle);
								LEndY += VectorY(BEAMOS_LASER_SPEED, Angle);
								if(Screen->isSolid(LEndX, LEndY))
									LaserEnded = true;
								if(EyeAngle<=0){
									Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
									Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
								}
								Beamos_Draw(this, ghost, Combo, EyeAngle);
								if(EyeAngle>0){
									Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
									Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
								}
								Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
								Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
								CheckBeamosLaser(ghost, LStartX, LStartY, LEndX, LEndY);
								ElephantStatue_ConveyorMovement(this, push, lastDir);
								SolidObjects_Add(this->X, this->Y+16, 16, 16);
								Ghost_Waitframe(this, ghost, true, true);
							}
						}
						//Once the laser has hit a wall, make the ends meet again
						while(Distance(LStartX, LStartY, LEndX, LEndY)>BEAMOS_LASER_SPEED){
							int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
							if(LaserLength>BEAMOS_LASER_LENGTH){
								LStartX += VectorX(BEAMOS_LASER_SPEED, Angle);
								LStartY += VectorY(BEAMOS_LASER_SPEED, Angle);
							}
							if(LaserLength<=BEAMOS_LASER_LENGTH)
								LaserLength += BEAMOS_LASER_SPEED;
							//Draw everything in order
							int EyeCombo = Combo+2+AngleDir8(EyeAngle);
							if(Link->HP>0){
								if(EyeAngle<=0){
									if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
									Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
									Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
									if(LaserLength<=BEAMOS_LASER_LENGTH)
										Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
									Screen->FastCombo(LAYER_BEAMOS2, LEndX-8, LEndY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								}
								if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
								if(EyeAngle>0){
									if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
									Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, Angle, true, 128);
									Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
									if(LaserLength<=BEAMOS_LASER_LENGTH)
										Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
									Screen->FastCombo(LAYER_BEAMOS2, LEndX-8, LEndY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								}
								if (this->InitD[1] == 0) Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
							}
							CheckBeamosLaser(ghost, LStartX, LStartY, LEndX, LEndY);
							ElephantStatue_ConveyorMovement(this, push, lastDir); 
							SolidObjects_Add(this->X, this->Y+16, 16, 16);
							Ghost_Waitframe(this, ghost, true, true);
						}
						for(int i=0; i<LaserCooldown; i++){
							EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
							if (this->InitD[1] == 0) Beamos_Draw(this, ghost, Combo, EyeAngle);
							ElephantStatue_ConveyorMovement(this, push, lastDir);
							SolidObjects_Add(this->X, this->Y+16, 16, 16);
							Ghost_Waitframe(this, ghost, true, true);
						}
					}
				}
				if (this->InitD[1] == 0) Beamos_Draw(this, ghost, Combo, EyeAngle);
				//ElephantStatue_ConveyorMovement(this, push, lastDir);
				SolidObjects_Add(this->X, this->Y+16, 16, 16);
			}
			else
			{
				int str[] = "UsePowerBracelet";
				int ffcs = Game->GetFFCScript(str);
				ffc bracelet = Screen->LoadFFC(FindFFCRunning(ffcs));
				EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
				if (this->InitD[1] != 0)
				{
					Ghost_X = bracelet->InitD[1];
					Ghost_Y = bracelet->InitD[2];
					if (this->InitD[1] == 2) this->InitD[1] = 0;
				}
				if (this->InitD[1] == 2) this->InitD[1] = 0;
				int Pos[4];
				int EyeX = bracelet->InitD[1]+VectorX(8, EyeAngle);
				int EyeY = bracelet->InitD[2]+4+VectorY(5, EyeAngle);
				Pos[0] = EyeX+8;
				Pos[1] = EyeY+8;
				CheckPathLine(Pos, EyeAngle, 255, BEAMOS_LASER_MINDIST, BEAMOS_LASER_SPEED);
				bool found = false;
				for (int i = 1; i <= Screen->NumNPCs(); i++)
				{
					npc MahBoi = Screen->LoadNPC(i);
					if (lineBoxCollision(Pos[0], Pos[1], Pos[2], Pos[3], MahBoi->X + MahBoi->HitXOffset, MahBoi->Y + MahBoi->HitYOffset, MahBoi->X + MahBoi->HitXOffset + MahBoi->HitWidth - 1, MahBoi->Y + MahBoi->HitYOffset + MahBoi->HitHeight - 1, 0)
					&& (MahBoi->Defense[NPCD_SCRIPT] == NPCDT_NONE || MahBoi->Defense[NPCD_SCRIPT] == NPCDT_HALFDAMAGE || MahBoi->Defense[NPCD_SCRIPT] == NPCDT_QUARTERDAMAGE)) found = true;
				}
				if (found && this->InitD[1] == 1)
				{
					int LStartX = EyeX+8;
					int LStartY = EyeY+8;
					int LEndX = LStartX;
					int LEndY = LStartY;
					int LaserLength = 0;
					bool LaserEnded = false;
					//Play the line of sight sound and flash briefly
					Game->PlaySound(SFX_BEAMOS_SIGHT);
					Ghost_StartFlashing(BEAMOS_FLASHFRAMES);
					for(int i=0; i<BEAMOS_FLASHFRAMES; i++){
						this->InitD[6] = this->CSet;
						if (this->InitD[1] != 1) 
						{
							Beamos_Draw(this, ghost, Combo, EyeAngle);
							SolidObjects_Add(this->X, this->Y+16, 16, 16);
						}
						ElephantStatue_ConveyorMovement(this, push, lastDir);
						if (this->InitD[1] != 0)
						{
							Ghost_X = bracelet->InitD[1];
							Ghost_Y = bracelet->InitD[2];
							if (this->InitD[1] == 2) this->InitD[1] = 0;
						}
						Ghost_Waitframe(this, ghost, true, true);
					}
					
					
					//Fire the laser until it reaches full length or hits a wall
					Game->PlaySound(SFX_BEAMOS_LASER);
					while(Distance(LStartX, LStartY, LEndX, LEndY)<BEAMOS_LASER_LENGTH&&!LaserEnded){
						this->InitD[6] = this->CSet;
						int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
						LEndX += VectorX(BEAMOS_LASER_SPEED, EyeAngle);
						LEndY += VectorY(BEAMOS_LASER_SPEED, EyeAngle);
						LaserLength += BEAMOS_LASER_SPEED;
						if (this->InitD[1] == 1)
						{
							EyeX = bracelet->InitD[1]+VectorX(8, EyeAngle);
							EyeY = bracelet->InitD[2]+4+VectorY(5, EyeAngle);
						}
						else
						{
							EyeX = Ghost_X+VectorX(8, EyeAngle);
							EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
						}
						if((Screen->isSolid(LEndX, LEndY)&&Distance(EyeX+8, EyeY+8, LEndX, LEndY)>=BEAMOS_LASER_MINDIST&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_HOOKSHOTONLY&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_LADDERHOOKSHOT)||(LEndX<-16||LEndX>272||LEndY<-16||LEndY>192))
							LaserEnded = true;
						//Draw everything in order
						int EyeCombo = Combo+2+AngleDir8(EyeAngle);
						if(Link->HP>0){
							if(EyeAngle<=0){
								Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
								Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, EyeAngle, true, 128);
								Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
								Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								if (this->InitD[1] == 1) Screen->FastCombo(LAYER_BEAMOS2, bracelet->InitD[1], bracelet->InitD[2], Combo, this->CSet, 128);
							}
							if (this->InitD[1] != 1) Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
							if(EyeAngle>0){
								if (this->InitD[1] != 1) Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
								Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, EyeAngle, true, 128);
								Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
								Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
							}
							if (this->InitD[1] != 1) Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
						}
						CheckBeamosLaser2(ghost, LStartX, LStartY, LEndX, LEndY);
						ElephantStatue_ConveyorMovement(this, push, lastDir);
						if (this->InitD[1] != 1) SolidObjects_Add(this->X, this->Y+16, 16, 16);
						if (this->InitD[1] != 0)
						{
							Ghost_X = bracelet->InitD[1];
							Ghost_Y = bracelet->InitD[2];
							if (this->InitD[1] == 2) this->InitD[1] = 0;
						}
						Ghost_Waitframe(this, ghost, true, true);
					}
					//If it reaches full length
					if(!LaserEnded){
						while((!Screen->isSolid(LEndX, LEndY)&&!(LEndX<-16||LEndX>272||LEndY<-16||LEndY>192)&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_HOOKSHOTONLY&&Screen->ComboT[ComboAt(LEndX, LEndY)]!=CT_LADDERHOOKSHOT)||Distance(EyeX+8, EyeY+8, LEndX, LEndY)<BEAMOS_LASER_MINDIST){
							this->InitD[6] = this->CSet;
							if (this->InitD[1] == 1)
							{
								EyeX = bracelet->InitD[1]+VectorX(8, EyeAngle);
								EyeY = bracelet->InitD[2]+4+VectorY(5, EyeAngle);
							}
							else
							{
								EyeX = Ghost_X+VectorX(8, EyeAngle);
								EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
							}
							int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
							LStartX += VectorX(BEAMOS_LASER_SPEED, EyeAngle);
							LStartY += VectorY(BEAMOS_LASER_SPEED, EyeAngle);
							LEndX += VectorX(BEAMOS_LASER_SPEED, EyeAngle);
							LEndY += VectorY(BEAMOS_LASER_SPEED, EyeAngle);
							if(Screen->isSolid(LEndX, LEndY))
								LaserEnded = true;
							if(EyeAngle<=0){
								Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, EyeAngle, true, 128);
								Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							}
							if (this->InitD[1] != 1) Beamos_Draw(this, ghost, Combo, EyeAngle);
							if(EyeAngle>0){
								Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, EyeAngle, true, 128);
								Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							}
							Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, EyeAngle, true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							CheckBeamosLaser2(ghost, LStartX, LStartY, LEndX, LEndY);
							ElephantStatue_ConveyorMovement(this, push, lastDir);
							if (this->InitD[1] != 1) SolidObjects_Add(this->X, this->Y+16, 16, 16);
							if (this->InitD[1] != 0)
							{
								Ghost_X = bracelet->InitD[1];
								Ghost_Y = bracelet->InitD[2];
								if (this->InitD[1] == 2) this->InitD[1] = 0;
							}
							Ghost_Waitframe(this, ghost, true, true);
						}
					}
					//Once the laser has hit a wall, make the ends meet again
					while(Distance(LStartX, LStartY, LEndX, LEndY)>BEAMOS_LASER_SPEED){
						this->InitD[6] = this->CSet;
						int LDist = Distance(LStartX, LStartY, LEndX, LEndY);
						if(LaserLength>BEAMOS_LASER_LENGTH){
							LStartX += VectorX(BEAMOS_LASER_SPEED, EyeAngle);
							LStartY += VectorY(BEAMOS_LASER_SPEED, EyeAngle);
						}
						if(LaserLength<=BEAMOS_LASER_LENGTH)
							LaserLength += BEAMOS_LASER_SPEED;
						//Draw everything in order
						int EyeCombo = Combo+2+AngleDir8(EyeAngle);
						if (this->InitD[1] == 1)
						{
							EyeX = bracelet->InitD[1]+VectorX(8, EyeAngle);
							EyeY = bracelet->InitD[2]+4+VectorY(5, EyeAngle);
						}
						else
						{
							EyeX = Ghost_X+VectorX(8, EyeAngle);
							EyeY = Ghost_Y+4+VectorY(5, EyeAngle);
						}
						if(Link->HP>0){
							if(EyeAngle<=0){
								Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
								Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, EyeAngle, true, 128);
								Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
								if(LaserLength<=BEAMOS_LASER_LENGTH)
									Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								Screen->FastCombo(LAYER_BEAMOS2, LEndX-8, LEndY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								if (this->InitD[1] == 1) Screen->FastCombo(LAYER_BEAMOS2, bracelet->InitD[1], bracelet->InitD[2], Combo, this->CSet, 128);
							}
							if (this->InitD[1] != 1) Screen->FastCombo(LAYER_BEAMOS2, Ghost_X, Ghost_Y, Combo, this->CSet, 128);
							if(EyeAngle>0){
								if (this->InitD[1] != 1) Screen->FastCombo(LAYER_BEAMOS2, EyeX, EyeY, EyeCombo, this->CSet, 128);
								Screen->Rectangle(LAYER_BEAMOS2, LStartX, LStartY-1, LStartX+LDist, LStartY+1, COLOR_BEAMOS_LASER2, 1, LStartX, LStartY, EyeAngle, true, 128);
								Screen->Line(LAYER_BEAMOS2, LStartX, LStartY, LEndX, LEndY, COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
								if(LaserLength<=BEAMOS_LASER_LENGTH)
									Screen->FastCombo(LAYER_BEAMOS2, LStartX-8, LStartY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
								Screen->FastCombo(LAYER_BEAMOS2, LEndX-8, LEndY-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
							}
							if (this->InitD[1] != 1) Screen->FastCombo(LAYER_BEAMOS1, Ghost_X, Ghost_Y+16, Combo+1, this->CSet, 128);
						}
						CheckBeamosLaser2(ghost, LStartX, LStartY, LEndX, LEndY);
						ElephantStatue_ConveyorMovement(this, push, lastDir); 
						if (this->InitD[1] != 1) SolidObjects_Add(this->X, this->Y+16, 16, 16);
						if (this->InitD[1] != 0)
						{
							Ghost_X = bracelet->InitD[1];
							Ghost_Y = bracelet->InitD[2];
							if (this->InitD[1] == 2) this->InitD[1] = 0;
						}
						Ghost_Waitframe(this, ghost, true, true);
					}
					for(int i=0; i<LaserCooldown; i++){
						this->InitD[6] = this->CSet;
						EyeAngle = WrapDegrees(EyeAngle+IncrementAngle);
						if (this->InitD[1] != 1) Beamos_Draw(this, ghost, Combo, EyeAngle);
						ElephantStatue_ConveyorMovement(this, push, lastDir);
						SolidObjects_Add(this->X, this->Y+16, 16, 16);
						if (this->InitD[1] != 0)
						{
							Ghost_X = bracelet->InitD[1];
							Ghost_Y = bracelet->InitD[2];
							if (this->InitD[1] == 2) this->InitD[1] = 0;
						}
						Ghost_Waitframe(this, ghost, true, true);
					}
				}
				if (this->InitD[1] == 2) this->InitD[1] = 0;
			}
			this->InitD[4] = EyeAngle;
			this->InitD[5] = Combo;
			this->InitD[6] = this->CSet;
			ElephantStatue_ConveyorMovement(this, push, lastDir);
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
	void CheckPathLine(int Pos, int Angle, int MaxDistance, int SafeDist, int Step){
		Pos[2] = Pos[0];
		Pos[3] = Pos[1];
		for(int i = 0; i<MaxDistance-Step; i+=Step){
			Pos[2] += VectorX(Step, Angle);
			Pos[3] += VectorY(Step, Angle);
			if(Screen->isSolid(Pos[2], Pos[3])&&i>SafeDist && Screen->ComboT[ComboAt(Pos[2], Pos[3])] != CT_HOOKSHOTONLY && Screen->ComboT[ComboAt(Pos[2], Pos[3])] != CT_LADDERHOOKSHOT)
			{
				Pos[2] -= VectorX(Step, Angle);
				Pos[3] -= VectorY(Step, Angle);
				return;
			}
		}
		return;
	}
	void ElephantStatue_ConveyorMovement(ffc f, int push, int lastDir){
		bool dir[4];
		for(int x=0; x<2; x++){
			for(int y=0; y<2; y++){
				int ct = Screen->ComboT[ComboAt(Ghost_X+15*x, Ghost_Y+16+15*y)];
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
		
		f->InitD[2] = 0;
		f->InitD[3] = 0;
		if(dir[DIR_UP]){
			f->InitD[3] -= 0.6;
			push[1] -= 0.6;
		
		}
		if(dir[DIR_DOWN]){
			f->InitD[3] += 0.6;
			push[1] += 0.6;
		}
		if(dir[DIR_LEFT]){
			f->InitD[2] -= 0.6;
			push[0] -= 0.6;
		}
		if(dir[DIR_RIGHT]){
			f->InitD[2] += 0.6;
			push[0] += 0.6;
		}
		
		int sizeX = Abs(push[0]);
		int sizeY = Abs(push[1]);
		if(sizeY>=1){
			for(int i=0; i<sizeY; i++){
				if(push[1]<0){
					if(LinkMovement_CanWalk(Ghost_X, Ghost_Y+16, DIR_UP, 1, true, true))
						Ghost_Y--;
					push[1]++;
				}
				else if(push[1]>0){
					if(LinkMovement_CanWalk(Ghost_X, Ghost_Y+16, DIR_DOWN, 1, true, true))
						Ghost_Y++;
					push[1]--;
				}
			}
		}
		if(sizeX>=1){
			for(int i=0; i<sizeX; i++){
				if(push[0]<0){
					if(LinkMovement_CanWalk(Ghost_X, Ghost_Y+16, DIR_LEFT, 1, true, true))
						Ghost_X--;
					push[0]++;
				}
				else if(push[0]>0){
					if(LinkMovement_CanWalk(Ghost_X, Ghost_Y+16, DIR_RIGHT, 1, true, true))
						Ghost_X++;
					push[0]--;
				}
			}
		}
	}
}

void LWeaponLifespan()
{
	for (int i = 1; i <= Screen->NumLWeapons(); i++)
	{
		lweapon Boi = Screen->LoadLWeapon(i);
		if (Boi->Misc[5] > 1) Boi->Misc[5]--;
		else if (Boi->Misc[5] == 1) Boi->DeadState = 0;
	}
}

