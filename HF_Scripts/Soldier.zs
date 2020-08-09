const int SFX_BEGINCHASE = 80;

ffc script LttP_Soldier
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
		int WalkData = Ghost_Data;
		int RunData = Ghost_Data + 4;
		int StandData = Ghost_Data + 8;
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_SetFlag(GHF_4WAY);
		int ChaseCounter = 0;
		eweapon Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 99, 0, EWF_UNBLOCKABLE);
		int SwordTile = Sword->Tile;
		Sword->Tile+=Ghost_Dir;
		if (Ghost_Dir == DIR_UP) 
		{
			Sword->HitXOffset+=11;
			Sword->HitYOffset+=4;
			Sword->HitWidth = 5;
			Sword->HitHeight = 12;
		}
		else if (Ghost_Dir == DIR_DOWN) 
		{
			Sword->HitXOffset+=2;
			//Sword->HitYOffset+=4;
			Sword->HitWidth = 5;
			Sword->HitHeight = 12;
		}
		else if (Ghost_Dir == DIR_LEFT) 
		{
			Sword->HitXOffset+=4;
			Sword->HitYOffset+=9;
			Sword->HitWidth = 12;
			Sword->HitHeight = 5;
		}
		else if (Ghost_Dir == DIR_RIGHT) 
		{
			//Sword->HitXOffset+=4;
			Sword->HitYOffset+=9;
			Sword->HitWidth = 12;
			Sword->HitHeight = 5;
		}
		int DrawCounter = 0;
		int Counter = Rand(90, 180);
		int BounceCounter = 0;
		int BounceAngle = 0;
		int PushArray[2];
		
		while(true)
		{
			if (Ghost_Dir == DIR_UP)
			{
				if (Link->HP > 0) Screen->FastCombo(3, this->X, this->Y, this->Data, this->CSet, OP_OPAQUE);
			}
			if (BounceCounter > 0)
			{
				Ghost_UnsetFlag(GHF_SET_DIRECTION);
				Ghost_Data = StandData;
				int bouncetime = Rand(1, 2);
				Ghost_MoveAtAngle(BounceAngle, bouncetime, 4);
				PushArray[0] += VectorX(bouncetime, (0-BounceAngle+180) % 360);
				PushArray[1] += VectorY(bouncetime, (0-BounceAngle) % 360);
				BounceCounter--;
			}
			else
			{
				Ghost_SetFlag(GHF_SET_DIRECTION);
				for(int i = Screen->NumLWeapons(); i > 0; i--)
				{
					lweapon Parry = Screen->LoadLWeapon(i);
					if (Parry->ID == LW_SWORD || Parry->ID == LW_SCRIPT3)
					{
						if (Collision(Sword, Parry) && (Link->Action == LA_ATTACKING || Link->Action == LA_CHARGING))
						{
							if (Link->Action == LA_CHARGING) Link->Action = LA_NONE;
							BounceAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
							BounceCounter = 16;
							Game->PlaySound(57);
							lweapon Sparkle = CreateLWeaponAt(LW_SPARKLE, 
							Midpoint(Parry->X + Parry->HitXOffset, Sword->X + Sword->HitXOffset), 
							Midpoint(Parry->Y + Parry->HitYOffset, Sword->Y + Sword->HitYOffset));
							Sparkle->UseSprite(101);
						}
						break;
					}
				}
				if (ChaseCounter <= 35)
				{
					int Sight = 0;
					int SeeAngle = Angle(Ghost_X, Ghost_Y, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12));
					int AngleLink = Angle(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
					int DistLink = Distance(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
					if (Abs(RadtoDeg(angleDifference(DegtoRad(SeeAngle), DegtoRad(AngleLink)))) < 70)
					{
						SeeAngle -= 35;
						for (int i = 0; i <= 70; i+=3)
						{
							if (Abs(RadtoDeg(angleDifference(DegtoRad(SeeAngle + i), DegtoRad(AngleLink)))) < 8 && CheckPath(Ghost_X+8, Ghost_Y+8, AngleLink, DistLink, 8, 6)) Sight++;
						}
					}
					if (Sight >= 2) 
					{
						if (ChaseCounter < 30) ChaseCounter = 135;
						else ChaseCounter = 90;
					}
				}
				if (ChaseCounter <= 0)
				{
					Counter--;
					if (Counter <= 0)
					{
						Ghost_Data = StandData;
						if (Counter <= -30)
						{
							Ghost_Data = StandData;
							Ghost_Dir = RandNotCurrent(Ghost_Dir, 4);
							Counter = Rand(90, 180);
						}
					}
					else
					{
						Ghost_SetFlag(GHF_SET_DIRECTION);
						if (!Ghost_CanMove(Ghost_Dir, ghost->Step / 100, 2))
						{
							Ghost_UnsetFlag(GHF_SET_DIRECTION);
							Counter = -1;
						}
						else Ghost_Move(Ghost_Dir, ghost->Step / 100, 2);
						Ghost_Data = WalkData;
					}
				}
				else if (ChaseCounter >= 30 && ChaseCounter <= 105)
				{
					if (ChaseCounter <= 90)
					{
						Ghost_MoveTowardLink(1, 2);
					}
					Ghost_Data = RunData;
					if (ChaseCounter == 105) Game->PlaySound(SFX_BEGINCHASE);
				}
				else if (ChaseCounter > 0)
				{
					Ghost_Data = StandData;
				}
				if (ChaseCounter > 0) ChaseCounter--;
			}
			if (!Sword->isValid()) 
			{
				Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 99, 0, EWF_UNBLOCKABLE);
				if (Ghost_Dir == DIR_UP) 
				{
					Sword->HitXOffset+=11;
					Sword->HitYOffset+=4;
					Sword->HitWidth = 5;
					Sword->HitHeight = 12;
				}
				else if (Ghost_Dir == DIR_DOWN) 
				{
					Sword->HitXOffset+=2;
					//Sword->HitYOffset+=4;
					Sword->HitWidth = 5;
					Sword->HitHeight = 12;
				}
				else if (Ghost_Dir == DIR_LEFT) 
				{
					Sword->HitXOffset+=4;
					Sword->HitYOffset+=9;
					Sword->HitWidth = 12;
					Sword->HitHeight = 5;
				}
				else if (Ghost_Dir == DIR_RIGHT) 
				{
					//Sword->HitXOffset+=4;
					Sword->HitYOffset+=9;
					Sword->HitWidth = 12;
					Sword->HitHeight = 5;
				}
			}
			DrawCounter = DarknutWaitframe(this, ghost, Sword, SwordTile, DrawCounter, ChaseCounter, PushArray);
		}
	}
	int DarknutWaitframe(ffc this, npc ghost, eweapon Sword, int SwordTile, int DrawCounter, int ChaseCounter, int PushArray) 
	{
		if (ChaseCounter >= 30 && ChaseCounter <= 105) DrawCounter += 2;
		if (ChaseCounter <= 0) DrawCounter++;
		HandlePushArray(PushArray, 0);
		DrawCounter %= 32;
		if (DrawCounter >= 28)
		{
			Sword->X = Ghost_X + InFrontX(Ghost_Dir, 0);
			Sword->Y = Ghost_Y + InFrontY(Ghost_Dir, 0);
		}
		else
		{
			Sword->X = Ghost_X + InFrontX(Ghost_Dir, 3);
			Sword->Y = Ghost_Y + InFrontY(Ghost_Dir, 3);
		}
		Sword->Tile = SwordTile;
		Sword->Tile+=Ghost_Dir;
		Sword->DeadState = -1;
		if (Ghost_Dir == DIR_UP) Sword->Behind = true;
		else Sword->Behind = false;
		
		Sword->HitXOffset=0;
		Sword->HitYOffset=0;
		if (Ghost_Dir == DIR_UP) 
		{
			Sword->HitXOffset+=11;
			Sword->HitYOffset+=4;
			Sword->HitWidth = 5;
			Sword->HitHeight = 12;
		}
		else if (Ghost_Dir == DIR_DOWN) 
		{
			Sword->HitXOffset+=2;
			//Sword->HitYOffset+=4;
			Sword->HitWidth = 5;
			Sword->HitHeight = 12;
		}
		else if (Ghost_Dir == DIR_LEFT) 
		{
			Sword->HitXOffset+=4;
			Sword->HitYOffset+=9;
			Sword->HitWidth = 12;
			Sword->HitHeight = 5;
		}
		else if (Ghost_Dir == DIR_RIGHT) 
		{
			//Sword->HitXOffset+=4;
			Sword->HitYOffset+=9;
			Sword->HitWidth = 12;
			Sword->HitHeight = 5;
		}
		
		if (!Ghost_Waitframe(this, ghost, true, false))
		{
			Remove(Sword);
			Ghost_HP = 0;
			Quit();
		}
		return DrawCounter;
	}
}		