ffc script Phaserobe
{
	bool CheckPath(int X, int Y, int Angle, int Distance, int SafeDist, int Step){
		for(int i = 0; i<Distance-Step; i+=Step){
			X += VectorX(Step, Angle);
			Y += VectorY(Step, Angle);
			if(Screen->isSolid(X, Y)&&i>SafeDist)
				return false;
		}
		return true;
	}
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		int Store[18];
		//Ghost_CSet = ghost->Attributes[9];
		int LASER_COMBO = Ghost_Data;
		//Ghost_Data = LASER_COMBO + 8;
		Ghost_StoreDefenses(ghost, Store);
		Ghost_Waitframe(this, ghost, true, true);
		Ghost_Data = LASER_COMBO;
		//bool Eppy;
		ghost->CollDetection = false;
		int ChaseCounter = 0;
		int Counter = -1;
		
		int PhaseDraw = 0;
		int PhaseDraw2 = 0;
		int SaveData = LASER_COMBO;
		bool InWall = false;
		
		int LastX = Link->X;
		int LastY = Link->Y;
		
		int teleportcounter = 0;
		int teleportcounter2 = 0;
		int AttackCounter = 0;
		
		int RebootCounter = 0;
		
		int ChaseAngle = Choose (-1, 1);
		
		int HitCounter = 0;
		
		bool JustChase = false;
		
		Ghost_SetFlag(GHF_SET_DIRECTION);
		
		while(true)
		{
			if (true)
			{
				//Trace(0);
				if (Ghost_GotHit()) 
				{
					ChaseAngle*=4;
					ChaseCounter = 90;
					HitCounter = 30;
					LastX = Link->X;
					LastY = Link->Y;
				}
				if (HitCounter > 0) HitCounter--;
				if (PhaseDraw > 0)
				{
					Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
					Ghost_Data = LASER_COMBO + 8;
					ghost->CollDetection = false;
					//Trace(1.1);
				}
				else 
				{
					ghost->CollDetection = true;
					Ghost_SetDefenses(ghost, Store);
					//Trace(1.2);
				}
				PhaseDraw2+=3;
				PhaseDraw2%=360;
				//Trace(2);
				if (Screen->isSolid(Ghost_X, Ghost_Y) || Screen->isSolid(Ghost_X + 15, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 15, Ghost_Y)
				|| Screen->isSolid(Ghost_X, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 8, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 15, Ghost_Y + 8)
				|| Screen->isSolid(Ghost_X + 8, Ghost_Y + 8) || Screen->isSolid(Ghost_X + 7, Ghost_Y + 15) || Screen->isSolid(Ghost_X + 15, Ghost_Y + 7)
				|| Screen->isSolid(Ghost_X, Ghost_Y + 8) || Screen->isSolid(Ghost_X + 8, Ghost_Y) || Screen->isSolid(Ghost_X + 7, Ghost_Y)
				|| Screen->isSolid(Ghost_X, Ghost_Y + 7) || Screen->isSolid(Ghost_X + 8, Ghost_Y + 7) || Screen->isSolid(Ghost_X + 7, Ghost_Y + 8))
				{
					if (teleportcounter < 300 && ChaseCounter <= 0) teleportcounter++;
					Ghost_Data = LASER_COMBO + 8;
					InWall = true;
					if (PhaseDraw < 8) PhaseDraw++;
					else if (PhaseDraw > 8) PhaseDraw--;
					Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2 + 90), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2 + 90), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2 + 180), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2 + 180), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2 + 270), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2 + 270), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
					//Trace(3.1);
				}
				else 
				{
					RebootCounter = 0;
					if (teleportcounter2 > 0) teleportcounter2-=0.2;
					if (teleportcounter > 0) teleportcounter--;
					InWall = false;
					if (PhaseDraw > 0)
					{
						PhaseDraw--;
						Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2 + 90), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2 + 90), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2 + 180), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2 + 180), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX(PhaseDraw, PhaseDraw2 + 270), Ghost_Y + VectorY(PhaseDraw, PhaseDraw2 + 270), SaveData + Ghost_Dir, Ghost_CSet, OP_TRANS);
					}
					else if (Ghost_Data == LASER_COMBO + 8) Ghost_Data = SaveData;
					else SaveData = Ghost_Data;
					//Trace(3.2);
				}
				if ((ChaseCounter <= 45 || ChaseCounter % 2 == 0) && !InWall && PhaseDraw <= 0)
				{
					int Sight = 0;
					for (int i = 0; i <= 70; i+=3)
					{
						int SeeAngle = Angle(Ghost_X, Ghost_Y, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12)) - 35 + i;
						int AngleLink = Angle(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
						int DistLink = Distance(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
						if (Abs(RadtoDeg(angleDifference(DegtoRad(SeeAngle), DegtoRad(AngleLink)))) < 8 && CheckPath(Ghost_X+8, Ghost_Y+8, AngleLink, DistLink, 8, 6)) Sight++;
					}
					if (Sight >= 2) 
					{
						if (ChaseCounter < 30) ChaseCounter = 110;
						else if (ChaseCounter <= 90) ChaseCounter = 90;
						LastX = Link->X;
						LastY = Link->Y;
					}
					else if (ChaseCounter > 30) ChaseCounter-=3;
					//Trace(4);
				}
				if (ChaseCounter <= 0)
				{
					if (teleportcounter >= 300)
					{
						Ghost_UnsetFlag(GHF_SET_DIRECTION);
						teleportcounter++;
						if (PhaseDraw < 40) PhaseDraw+=2;
						else
						{
							int CountWarp = 0;
							teleportcounter2++;
							if (Round(teleportcounter2) >= 3)
							{
								while(true)
								{
									int MehC = FindSpawnPoint(false, false, false, false);
									Ghost_X = ComboX(MehC);
									Ghost_Y = ComboY(MehC);
									if (Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) <= 16 && CountWarp < 10)
									{
										CountWarp++;
										continue;
									}
									break;
								}
							}
							else
							{
								while(true)
								{
									int MehC = FindSpawnPoint(true, false, false, false);
									Ghost_X = ComboX(MehC);
									Ghost_Y = ComboY(MehC);
									if (Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) <= 16 && CountWarp < 10)
									{
										CountWarp++;
										continue;
									}
									break;
								}
							}
							teleportcounter = 0;
						}
						//Trace(5.1);
					}
					else
					{
						//Trace(5.2);
						Ghost_SetFlag(GHF_SET_DIRECTION);
						if (InWall || PhaseDraw > 0) SaveData = LASER_COMBO;
						else Ghost_Data = LASER_COMBO;
						if (Distance(Round(Ghost_X), Round(Ghost_Y), GridX(Ghost_X + 7), GridY(Ghost_Y + 7)) > 1.5 && JustChase)
						{
							Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, GridX(Ghost_X + 7), GridY(Ghost_Y + 7)), 0.5, 4);
							//Trace(5.3);
						}
						else
						{
							JustChase = false;
							if (InWall) Counter = Ghost_ConstantWalk4(Counter, 125, 1, 50, 0);		//Phase around
							else Counter = Ghost_ConstantWalk4(Counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
							//Trace(5.4);
						}
					}
					//Ghost_Data = WalkData;
				}
				else if (ChaseCounter >= 30 && ChaseCounter <= 105)
				{
					JustChase = true;
					if (ChaseCounter <= 90)
					{
						//Trace(6.1);
						AttackCounter++;
						AttackCounter%=20;
						if (AttackCounter == 1)
						{
							if (ghost->Weapon >= 129 && ghost->Weapon <= 145 && ghost->Weapon != 144 && ghost->Weapon != 143)
							{
								if (ghost->Attributes[1] == 1)
								{
									int LastAngle = DegtoRad(Angle(Ghost_X, Ghost_Y, LastX, LastY));
									eweapon Ice;
									if (Ghost_Dir == DIR_UP) Ice = FireEWeapon(EW_SCRIPT3, Ghost_X + 0, Ghost_Y - 8, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, 83, SFX_ICE, 0);
									if (Ghost_Dir == DIR_DOWN) Ice = FireEWeapon(EW_SCRIPT3, Ghost_X + 0, Ghost_Y + 8, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, 83, SFX_ICE, 0);
									if (Ghost_Dir == DIR_LEFT) Ice = FireEWeapon(EW_SCRIPT3, Ghost_X - 8, Ghost_Y + 0, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, 83, SFX_ICE, 0);
									if (Ghost_Dir == DIR_RIGHT) Ice = FireEWeapon(EW_SCRIPT3, Ghost_X + 8, Ghost_Y + 0, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, 83, SFX_ICE, 0);
									SetEWeaponMovement(Ice, EWM_SINE_WAVE, 8, 8);
								}
								else
								{
									int LastAngle = DegtoRad(Angle(Ghost_X, Ghost_Y, LastX, LastY));
									if (Ghost_Dir == DIR_UP) FireEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y - 8, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, -1, -1, 0);
									if (Ghost_Dir == DIR_DOWN) FireEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y + 8, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, -1, -1, 0);
									if (Ghost_Dir == DIR_LEFT) FireEWeapon(ghost->Weapon, Ghost_X - 8, Ghost_Y + 0, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, -1, -1, 0);
									if (Ghost_Dir == DIR_RIGHT) FireEWeapon(ghost->Weapon, Ghost_X + 8, Ghost_Y + 0, LastAngle, ghost->Attributes[0], ghost->WeaponDamage, -1, -1, 0);
								}
							}
						}
						if (AttackCounter < 10)
						{
							if (InWall || PhaseDraw > 0) SaveData = LASER_COMBO + 4;
							else Ghost_Data = LASER_COMBO + 4;
							//Trace(6.2);
						}
						else 
						{
							if (InWall || PhaseDraw > 0) SaveData = LASER_COMBO;
							else Ghost_Data = LASER_COMBO;
							//Trace(6.3);
						}
						if (Distance (LastX, LastY, Ghost_X, Ghost_Y) > 48 && InWall && HitCounter <= 0)
						{                                            //(((Distance (Link->X, Link->Y, Ghost_X, Ghost_Y) > 48 && !InWall) || (Distance (LastX, LastY, Ghost_X, Ghost_Y) > 48 && InWall)) && HitCounter <= 0)
							Ghost_SetFlag(GHF_SET_DIRECTION);
							if (InWall) Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, LastX, LastY), 1.25, 2);
							else Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, LastX, LastY), 0.5, 2);
							//Ghost_MoveTowardLink(0.5, 2);
							//Trace(6.4);
						}
						else if (Distance (LastX, LastY, Ghost_X, Ghost_Y) > 36 || HitCounter > 0)
						{                                            //(((Distance (Link->X, Link->Y, Ghost_X, Ghost_Y) > 36 && !InWall) || (Distance (LastX, LastY, Ghost_X, Ghost_Y) > 36 && InWall)) || HitCounter > 0)
							//Trace(6.5);
							Ghost_UnsetFlag(GHF_SET_DIRECTION);
							if (ChaseAngle == 0) ChaseAngle = Choose(1, -1);
							if (ChaseAngle > 1) ChaseAngle-=0.2;
							else if (ChaseAngle < -1) ChaseAngle+=0.2;
							int CurAngle = Angle(LastX, LastY, Ghost_X, Ghost_Y);
							//else CurAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
							int CurAngle2 = Angle(Ghost_X, Ghost_Y, LastX, LastY);
							//else CurAngle2 = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
							Ghost_Dir = AngleDir4(CurAngle2);
							if (InWall)
							{
								//Trace(6.6);
								RebootCounter++;
								if (RebootCounter >= 150) ChaseCounter = 0;
								int Dist = Distance(LastX, LastY, Ghost_X, Ghost_Y);
								if ((LastX + VectorX(Dist, CurAngle + (ChaseAngle * 2))) <= 240 && (LastX + VectorX(Dist, CurAngle + (ChaseAngle * 2))) >= 0
								&& (LastY + VectorY(Dist, CurAngle + (ChaseAngle * 2))) <= 160 && (LastY + VectorY(Dist, CurAngle + (ChaseAngle * 2))) >= 0)
								{
									Ghost_X = (LastX + VectorX(Dist, (CurAngle + (ChaseAngle * 2)) % 360));
									Ghost_Y = (LastY + VectorY(Dist, (CurAngle + (ChaseAngle * 2)) % 360));
								}
								else
								{
									ChaseAngle *= -1;
									if ((LastX + VectorX(Dist, CurAngle + (ChaseAngle * 2))) <= 240 && (LastX + VectorX(Dist, CurAngle + (ChaseAngle * 2))) >= 0
									&& (LastY + VectorY(Dist, CurAngle + (ChaseAngle * 2))) <= 160 && (LastY + VectorY(Dist, CurAngle + (ChaseAngle * 2))) >= 0)
									{
										Ghost_X = (LastX + VectorX(Dist, (CurAngle + (ChaseAngle * 2)) % 360));
										Ghost_Y = (LastY + VectorY(Dist, (CurAngle + (ChaseAngle * 2)) % 360));
									}
									else Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, LastX, LastY), 1.25, 2);
								}
							}
							else 
							{
								//Trace(6.7);
								int Dist = Distance(LastX, LastY, Ghost_X, Ghost_Y);
								if ((LastX + VectorX(Dist, CurAngle + ChaseAngle)) <= 240 && (LastX + VectorX(Dist, CurAngle + ChaseAngle)) >= 0
								&& (LastY + VectorY(Dist, CurAngle + ChaseAngle)) <= 160 && (LastY + VectorY(Dist, CurAngle + ChaseAngle)) >= 0)
								{
									Ghost_X = (LastX + VectorX(Dist, (CurAngle + ChaseAngle) % 360));
									Ghost_Y = (LastY + VectorY(Dist, (CurAngle + ChaseAngle) % 360));
								}
								else
								{
									ChaseAngle *= -1;
									if ((LastX + VectorX(Dist, CurAngle + ChaseAngle)) <= 240 && (LastX + VectorX(Dist, CurAngle + ChaseAngle)) >= 0
									&& (LastY + VectorY(Dist, CurAngle + ChaseAngle)) <= 160 && (LastY + VectorY(Dist, CurAngle + ChaseAngle)) >= 0)
									{
										Ghost_X = (LastX + VectorX(Dist, (CurAngle + ChaseAngle) % 360));
										Ghost_Y = (LastY + VectorY(Dist, (CurAngle + ChaseAngle) % 360));
									}
									else Ghost_MoveTowardLink(0.5, 2);
								}
							}
						}
						else
						{
							//Trace(6.8);
							Ghost_UnsetFlag(GHF_SET_DIRECTION);
							if (Ghost_X < 236 && Ghost_X > 4 && Ghost_Y < 156 && Ghost_Y > 4)
							{
								if (InWall) Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, LastX, LastY), -1.25, 2);
								else Ghost_MoveTowardLink(-0.5, 2);
							}
						}
					}
				}
				else if (ChaseCounter > 0 && PhaseDraw <= 0)
				{
					Ghost_Data = LASER_COMBO + 12;
					//Trace(7);
				}
				if (ChaseCounter > 0 && ((!InWall && PhaseDraw <= 0) || ChaseCounter < 30 || ChaseCounter > 95)) ChaseCounter--;
			}
			//Trace(ChaseCounter);
			WizzrobeWaitframe(this, ghost, ChaseCounter);
		}
	}
	int WizzrobeWaitframe(ffc this, npc ghost, int ChaseCounter) 
	{
		if (!Ghost_Waitframe(this, ghost, true, false))
		{
			Ghost_HP = 0;
			Quit();
		}
	}
}		