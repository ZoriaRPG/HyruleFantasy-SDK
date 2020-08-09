ffc script IceRobe{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		int Store[18];
		Ghost_CSet = ghost->Attributes[9];
		int LASER_COMBO = Ghost_Data;
		Ghost_StoreDefenses(ghost, Store);
		Ghost_Waitframe(this, ghost, true, true);
		if (Ghost_Z <= 0)
		{
			Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
			Ghost_Data = LASER_COMBO + 8;
		}
		else Ghost_Data = LASER_COMBO;
		bool Eppy;
		ghost->CollDetection = false;
		while(true){
			while(true)
			{
				if (Ghost_Z > 0)
				{
					while (Ghost_Z > 0)
					{
						Ghost_Waitframe(this, ghost, true, true);
					}
					for (int i = 20; i > 0; i--)
					{
						Ghost_Waitframe(this, ghost, true, true);
					}
					Ghost_Data = LASER_COMBO + 8;
					Ghost_StoreDefenses(ghost, Store);
					Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
					ghost->CollDetection = false;
					for (int i = 0; i < 60; i+=2)
					{
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Ghost_Waitframe(this, ghost, true, true);
					}
				}
				int MehC = FindSpawnPoint(true, true, true, true);
				Ghost_X = ComboX(MehC);
				Ghost_Y = ComboY(MehC);
				if (Ghost_X != GridX(Link->X) && Ghost_Y != GridY(Link->Y))
				{
					int Lel = Rand(2);
					if (Lel == 1)
					{
						Ghost_X = GridX(Link->X + 8);
					}
					else
					{
						Ghost_Y = GridY(Link->Y + 8);
					}
					if (Ghost_X == GridX(Link->X + 8) && Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) <= 16)
					{
						if (Ghost_Y > Link->Y && Ghost_Y <= 160) Ghost_Y += 16;
						else if (Ghost_Y < Link->Y && Ghost_Y >= 16) Ghost_Y -= 16;
						else continue;
					}
					if (Ghost_Y == GridY(Link->Y + 8) && Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) <= 16)
					{
						if (Ghost_X > Link->X && Ghost_X <= 240) Ghost_X += 16;
						else if (Ghost_X < Link->X && Ghost_X >= 16) Ghost_X -= 16;
						else continue;
					}
				}
				break;
			}
			Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
			for (int i = 60; i > 0; i-=2)
			{
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Ghost_Waitframe(this, ghost, true, true);
			}
			ghost->CollDetection = true;
			Ghost_Data = LASER_COMBO;
			Ghost_SetDefenses(ghost, Store);
			for (int i = 30; i > 0; i--)
			{
				Ghost_Waitframe(this, ghost, true, true);
			}
			Ghost_Data = LASER_COMBO + 4;
			eweapon Flamewar;
			if (Ghost_Dir == DIR_UP) Flamewar = FireEWeapon(EW_SCRIPT3, Ghost_X + 0, Ghost_Y - 8, DegtoRad(270), 200, ghost->WeaponDamage, 83, SFX_ICE, 0);
			if (Ghost_Dir == DIR_DOWN) Flamewar = FireEWeapon(EW_SCRIPT3, Ghost_X + 0, Ghost_Y + 8, DegtoRad(90), 200, ghost->WeaponDamage, 83, SFX_ICE, 0);
			if (Ghost_Dir == DIR_LEFT) Flamewar = FireEWeapon(EW_SCRIPT3, Ghost_X - 8, Ghost_Y + 0, DegtoRad(180), 200, ghost->WeaponDamage, 83, SFX_ICE, 0);
			if (Ghost_Dir == DIR_RIGHT) Flamewar = FireEWeapon(EW_SCRIPT3, Ghost_X + 8, Ghost_Y + 0, DegtoRad(0), 200, ghost->WeaponDamage, 83, SFX_ICE, 0);			
			SetEWeaponMovement(Flamewar, EWM_SINE_WAVE, 8, 8);
			for (int i = 30; i > 0; i--)
			{
				Ghost_Waitframe(this, ghost, true, true);
			}
			Ghost_Data = LASER_COMBO + 8;
			Ghost_StoreDefenses(ghost, Store);
			Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
			ghost->CollDetection = false;
			for (int i = 0; i < 60; i+=2)
			{
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Ghost_Waitframe(this, ghost, true, true);
			}
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}