ffc script Stalfos{
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
		int HeadCombo = Ghost_Data + 12;
		int HeadData = Ghost_Dir;
		int Counter = Rand(90, 180);
		int Angled = 0;
		bool Jumped = false;
		if (Ghost_Z > 0)
		{
			while (Ghost_Z > 0)
			{
				do
				{
					if (Link->HP > 0) Screen->FastCombo(3, Ghost_X, Ghost_Y - Ghost_Z - 2, HeadCombo + HeadData, this->CSet, OP_OPAQUE);
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
					if (ghost->Attributes[0] > 0)
					{
						Ghost_Data = StalCombo;
						for (int m = 0; m < 15; m++)
						{
							do
							{
								if (Link->HP > 0) Screen->FastCombo(3, Ghost_X, Ghost_Y - Ghost_Z - 2, HeadCombo + HeadData, this->CSet, OP_OPAQUE);
								Ghost_Waitframe(this, ghost, true, true);
							}while (ghost->Stun > 0)
						}
						FireAimedEWeapon(EW_ARROW, Ghost_X, Ghost_Y, 0, 175, ghost->WeaponDamage, -1, -1, 0);
						for (int m = 0; m < 15; m++)
						{
							do
							{
								if (Link->HP > 0) Screen->FastCombo(3, Ghost_X, Ghost_Y - Ghost_Z - 2, HeadCombo + HeadData, this->CSet, OP_OPAQUE);
								Ghost_Waitframe(this, ghost, true, true);
							}while (ghost->Stun > 0)
						}
					}
				}
				//Trace(Counter);
				Counter--;
				if (Counter <= 0)
				{
					if (Counter == -2) HeadData = RandNotCurrent(Ghost_Dir, 4);
					Ghost_Data = StandCombo;
					if (Counter <= -30)
					{
						Ghost_Data = StalCombo;
						Ghost_Dir = HeadData;
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
					Ghost_Data = StalCombo;
				}
				if (Link->Action == LA_ATTACKING && ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) && Is_Within_Proximity(ghost))
				{
					Ghost_Jump = 2;
					Game->PlaySound(SFX_JUMP);
					Angled = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
					Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
					Ghost_Data = JumpCombo;
					HeadData = Ghost_Dir;
					Ghost_UnsetFlag(GHF_SET_DIRECTION);
				}
			}
			do
			{
				if (Link->HP > 0) Screen->FastCombo(3, Ghost_X, Ghost_Y - Ghost_Z - 2, HeadCombo + HeadData, this->CSet, OP_OPAQUE);
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

int RandNotCurrent(int Current, int MaxRand)
{
	int TempMax = Max(1, MaxRand - 1);
	int Random = Rand(TempMax);
	if (Random >= Current) Random++;
	return Random;
}