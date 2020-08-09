ffc script Minimentus{
	bool CheckPath(int X, int Y, int Angle, int Distance, int SafeDist, int Step){
		for(int i = 0; i<Distance-Step; i+=Step){
			X += VectorX(Step, Angle);
			Y += VectorY(Step, Angle);
			if(Screen->isSolid(X, Y)&&i>SafeDist)
				return false;
		}
		return true;
	}
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_SET_DIRECTION);
		//Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		//Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		Ghost_CSet = ghost->Attributes[9];
		int StalCombo = Ghost_Data;
		int StandCombo = Ghost_Data + 4;
		int JumpCombo = Ghost_Data + 8;
		int AttackCombo = Ghost_Data + 12;
		int FallCombo = Ghost_Data + 16;
		int Counter;
		int HaltCounter;
		if (ghost->Rate > 0) Counter = Rand((ghost->Rate * 18.75) - 15, (ghost->Rate * 18.75) + 15);
		else Counter = 1;
		if (ghost->Haltrate > 0 && ghost->Haltrate != ghost->Rate) HaltCounter = Rand((ghost->Haltrate * 18.75) - 15, (ghost->Haltrate * 18.75) + 15);
		else HaltCounter = Counter;
		int Angled = 0;
		bool Jumped = false;
		if (Ghost_Z > 0)
		{
			while (Ghost_Z > 0)
			{
				do
				{
					Ghost_Waitframe(this, ghost, true, true);
				}while (ghost->Stun > 0)
			}
		}
		while(true){
			if (Ghost_Z > 0)
			{
				Ghost_MoveAtAngle(Angled, 2, 2);
				Jumped = true;
			}
			else
			{
				if (Jumped)
				{
					Jumped = false;
					if (Screen->ComboT[ComboAt(Ghost_X + 5, Ghost_Y + 5)] != CT_NOGROUNDENEMY || 
					Screen->ComboT[ComboAt(Ghost_X + 10, Ghost_Y + 5)] != CT_NOGROUNDENEMY ||
					Screen->ComboT[ComboAt(Ghost_X + 10, Ghost_Y + 10)] != CT_NOGROUNDENEMY ||
					Screen->ComboT[ComboAt(Ghost_X + 5, Ghost_Y + 10)] != CT_NOGROUNDENEMY)
					{
						Ghost_Data = AttackCombo;
						for (int m = 0; m < 15; m++)
						{
							do
							{
								Ghost_Waitframe(this, ghost, true, true);
							}while (ghost->Stun > 0)
						}
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, 0, 175, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, 0.4, 175, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, -0.4, 175, ghost->WeaponDamage, -1, -1, 0);
						for (int m = 0; m < 15; m++)
						{
							do
							{
								Ghost_Waitframe(this, ghost, true, true);
							}while (ghost->Stun > 0)
						}
					}
				}
				//Trace(Counter);
				if (ghost->Rate > 0) Counter--;
				if (ghost->Haltrate > 0 && ghost->Haltrate != ghost->Rate) HaltCounter--;
				else HaltCounter = Counter;
				if (HaltCounter <= 0)
				{
					Ghost_Data = StandCombo;
					for (int m = 0; m < 30; m++)
					{
						do
						{
							Ghost_Waitframe(this, ghost, true, true);
						}while (ghost->Stun > 0)
					}
					eweapon Flamewar;
					if (ghost->Weapon >= 129 && ghost->Weapon <= 145 && ghost->Weapon != 144 && ghost->Weapon != 143 && ghost->Weapon != 142 && ghost->Weapon != 135 && ghost->Weapon != 134)
					{
						if (Ghost_Dir == DIR_UP) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y - 8, DIR_UP, 200, ghost->WeaponDamage, -1, -1, EWF_ROTATE);
						if (Ghost_Dir == DIR_DOWN) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y + 8, DIR_DOWN, 200, ghost->WeaponDamage, -1, -1, EWF_ROTATE);
						if (Ghost_Dir == DIR_LEFT) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X - 8, Ghost_Y + 0, DIR_LEFT, 200, ghost->WeaponDamage, -1, -1, EWF_ROTATE);
						if (Ghost_Dir == DIR_RIGHT) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 8, Ghost_Y + 0, DIR_RIGHT, 200, ghost->WeaponDamage, -1, -1, EWF_ROTATE);
                    }
					else if (ghost->Weapon == 142)
					{
						Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X, Ghost_Y, 0, 0, ghost->WeaponDamage, -1, -1, 0);
					}
					if (ghost->Haltrate > 0 && ghost->Haltrate != ghost->Rate) HaltCounter = Rand((ghost->Haltrate * 18.75) - 15, (ghost->Haltrate * 18.75) + 15);
					else HaltCounter = Counter;
				}
				if (Counter <= 0)
				{
					Ghost_Data = StalCombo;
					int trycounter = 0;
					int tempDir = Ghost_Dir;
					do
					{
						Ghost_Dir = RandNotCurrent(tempDir, 4);
						trycounter++;
					}while(!Ghost_CanMove(Ghost_Dir, ghost->Step / 100, 2) && trycounter < 4)
					if (ghost->Rate > 0) Counter = Rand((ghost->Rate * 18.75) - 15, (ghost->Rate * 18.75) + 15);
					else Counter = 1;
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
					Ghost_Data = StalCombo;
				}
				if (Screen->ComboT[ComboAt(Ghost_X + 5, Ghost_Y + 5)] == CT_NOGROUNDENEMY && 
				Screen->ComboT[ComboAt(Ghost_X + 10, Ghost_Y + 5)] == CT_NOGROUNDENEMY &&
				Screen->ComboT[ComboAt(Ghost_X + 10, Ghost_Y + 10)] == CT_NOGROUNDENEMY &&
				Screen->ComboT[ComboAt(Ghost_X + 5, Ghost_Y + 10)] == CT_NOGROUNDENEMY && Ghost_Z <= 0)
				{
					for (int m = 0; m < 5; m++)
					{
						do
						{
							Ghost_Waitframe(this, ghost, true, true);
						}while (ghost->Stun > 0)
					}
					Ghost_Data = FallCombo;
					for (int m = 0; m < 25; m++)
					{
						do
						{
							Ghost_Waitframe(this, ghost, true, true);
						}while (ghost->Stun > 0)
					}
					Ghost_HP = -1000;
					ghost->DrawXOffset = -1000;
					lweapon FallingAni = CreateLWeaponAt(LW_SPARKLE, Ghost_X, Ghost_Y);
					FallingAni->UseSprite(131);
					Ghost_Waitframe(this, ghost, true, true);
				}
				if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost))
				{
					Ghost_Jump = 2;
					Game->PlaySound(SFX_JUMP);
					Angled = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					Ghost_Data = JumpCombo;
					Ghost_UnsetFlag(GHF_SET_DIRECTION);
				}
				else
				{
					int Sight = 0;
					for (int i = 0; i <= 70; i+=3)
					{
						int SeeAngle = Angle(Ghost_X, Ghost_Y, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12)) - 35 + i;
						int AngleLink = Angle(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
						int DistLink = Distance(Ghost_X+8, Ghost_Y+8, CenterLinkX(), CenterLinkY());
						if (Abs(RadtoDeg(angleDifference(DegtoRad(SeeAngle), DegtoRad(AngleLink)))) < 6 && CheckPath(Ghost_X+8, Ghost_Y+8, AngleLink, DistLink, 8, 6)) Sight++;
					}
					if (Sight >= 2) 
					{
						Ghost_Data = AttackCombo;
						for (int n = 0; n < 5; n++)
						{
							for (int m = 0; m < 10; m++)
							{
								if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost)) break;
								do
								{
									Ghost_Waitframe(this, ghost, true, true);
								}while (ghost->Stun > 0)
							}
							if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost)) break;
							FireAimedEWeapon(EW_FIRE2, Ghost_X, Ghost_Y, 0, 175, ghost->WeaponDamage, 130, -1, 0);
							for (int m = 0; m < 10; m++)
							{
								if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost)) break;
								do
								{
									Ghost_Waitframe(this, ghost, true, true);
								}while (ghost->Stun > 0)
							}
							if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost)) break;
						}
						Ghost_Data = StandCombo;
						for (int m = 0; m < 10; m++)
						{
							if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost)) break;
							do
							{
								Ghost_Waitframe(this, ghost, true, true);
							}while (ghost->Stun > 0)
						}
						if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost))
						{
							Ghost_Jump = 2;
							Game->PlaySound(SFX_JUMP);
							Angled = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
							Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
							Ghost_Data = JumpCombo;
							Ghost_UnsetFlag(GHF_SET_DIRECTION);
						}
					}
				}
			}
			do
			{
				Ghost_Waitframe(this, ghost, true, true);
			}while (ghost->Stun > 0)
		}
	}
	int StalfosChoose(npc ghost, ffc this)
	{
		int lol = 0;
		int lol2[4];
		for (int dir = 0; dir < 4; dir++)
		{
			if (Ghost_CanMove(dir, ghost->Step / 100, 2) && Ghost_Dir != dir)
			{
				lol2[lol] = dir;
				lol++;
			}
		}
		int lol3 = Rand(lol);
		return lol2[lol3];
	}
}