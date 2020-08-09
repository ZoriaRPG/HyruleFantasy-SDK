ffc script KrackoStare
{
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		int MainData = Ghost_Data;
		int AttackData = Ghost_Data + 8;
		int CenterData = Ghost_Data + 16;
		int HurtData = Ghost_Data + 17;
		
		Ghost_TileWidth = 3;
		Ghost_TileHeight = 3;
		Ghost_X += 8;
		
		int store[18];
		Ghost_StoreDefenses(ghost, store);
		Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
		
		npc Shell = Screen->CreateNPC(ghost->Attributes[0]);
		Shell->X = Ghost_X - 16;
		Shell->Y = Ghost_Y - 8;
		
		Ghost_SetFlag(GHF_8WAY);
		int AttackCounter = 0;
		int AttackInfo[16];
		AttackInfo[2] = Angle(Ghost_X + 24, Ghost_Y + 24, Link->X + 8, Link->Y + 8);
		
		while (Shell->isValid())
		{
			Ghost_Dir = AngleDir8(Angle(Ghost_X + 24, Ghost_Y + 24, Link->X + 8, Link->Y + 8));
			AttackCounter++;
			if (AttackCounter >= 180)
			{
				if (Angle(Ghost_X + 24, Ghost_Y + 24, Link->X + 8, Link->Y + 8) > AttackInfo[2]) AttackInfo[3]++;
				else if (Angle(Ghost_X + 24, Ghost_Y + 24, Link->X + 8, Link->Y + 8) < AttackInfo[2]) AttackInfo[3]--;
			}
			AttackInfo[2] = Angle(Ghost_X + 24, Ghost_Y + 24, Link->X + 8, Link->Y + 8);
			if (AttackCounter >= 240)
			{
				Ghost_Data = AttackData;
				if (AttackCounter == 240)
				{
					if (Abs(AttackInfo[3]) > 55) AttackInfo[0] = 1;
					else AttackInfo[0] = 0;
				}
				if (AttackInfo[0] == 0)
				{
					if (AttackCounter % 15 == 0 && AttackCounter >= 285)
					{
						eweapon Ice = FireAimedEWeapon(EW_SCRIPT3, Ghost_X + 16, Ghost_Y + 16, 0, 250, ghost->WeaponDamage, 83, SFX_ICE, 0);
						SetEWeaponMovement(Ice, EWM_SINE_WAVE, 4, 8);
					}
					if (AttackCounter >= 355) AttackCounter = 0;
				}
				else if (AttackInfo[0] == 1 && AttackCounter >= 240)
				{
					if (AttackCounter == 240) 
					{
						if (AttackInfo[3] > 0) AttackInfo[1] = Angle(Ghost_X + 16, Ghost_Y + 16, Link->X, Link->Y) + RadtoDeg(0.8);
						else if (AttackInfo[3] < 0) AttackInfo[1] = Angle(Ghost_X + 16, Ghost_Y + 16, Link->X, Link->Y) - RadtoDeg(0.8);
						else AttackInfo[0] = 0;
						
						AttackInfo[4] = 1;
						AttackInfo[5] = Ghost_X + 16;
						AttackInfo[6] = Ghost_Y + 16;
						if (AttackInfo[0] == 1) Game->PlaySound(107);
					}
					if (AttackCounter % 10 == 0 && AttackInfo[0] == 1)
					{
						int lightning[] = "FrostCircle";
						int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
						int Args[8];
						Args[0] = 8 * AttackInfo[4];
						Args[1] = 180;
						ffc meh = Screen->LoadFFC(RunFFCScript(script_num, Args));
						meh->X = AttackInfo[5] + VectorX(((8 * AttackInfo[4]) / 2), AttackInfo[1]);
						meh->Y = AttackInfo[6] + VectorY(((8 * AttackInfo[4]) / 2), AttackInfo[1]);
						AttackInfo[5] = meh->X;
						AttackInfo[6] = meh->Y;
						AttackInfo[4]++;
						Game->PlaySound(SFX_ICE);
						//eweapon Ice = FireEWeapon(EW_SCRIPT3, Ghost_X + 16, Ghost_Y + 16, AttackInfo[1], 300, ghost->WeaponDamage, 83, SFX_ICE, 0);
						//SetEWeaponMovement(Ice, EWM_SINE_WAVE, 4, 8);
					}
					if (AttackCounter >= 300) AttackCounter = -45;
				}
				AttackInfo[3] = 0;
			}
			else Ghost_Data = MainData;
			Ghost_Waitframe(this, ghost, 1, true);
		}
		Ghost_SetDefenses(ghost, store);
	}
}

ffc script IceShell
{
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		
		Ghost_TileWidth = 4;
		Ghost_TileHeight = 4;
		
		int attackcounter = 0;
		
		Ghost_AddCombo(Ghost_Data + 1, 64, 0, 1, 4);
		ghost->HitWidth = 80;
		ghost->HitHeight = 56;
		
		while (true)
		{
			if (Ghost_GotHit())
			{
				attackcounter++;
				if (attackcounter >= 5)
				{
					Game->PlaySound(66);
					for (int i = 0; i < 176; i++)
					{
						if (Screen->ComboD[i] >= 10816 && Screen->ComboD[i] < 10848)
						{
							Screen->ComboD[i] = (((Screen->ComboD[i] - 10816) + 16) % 32) + 10816;
						}
					}
					attackcounter = 0;
				}
			}
			Ghost_Waitframe(this, ghost, 1, true);
		}
	}
}