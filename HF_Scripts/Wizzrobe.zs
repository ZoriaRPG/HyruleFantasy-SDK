ffc script Wizzrobe{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		int Store[18];
		//Ghost_CSet = ghost->Attributes[9];
		int LASER_COMBO = Ghost_Data;
		Ghost_Data = LASER_COMBO + 8;
		Ghost_StoreDefenses(ghost, Store);
		Ghost_Waitframe(this, ghost, true, true);
		if (Ghost_Z <= 0)
		{
			Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
			Ghost_Data = LASER_COMBO + 8;
		}
		else Ghost_Data = LASER_COMBO;
		//bool Eppy;
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
					if (ghost->Attributes[1] <= 0) for (int i = 0; i < 60; i+=2)
					{
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Ghost_Waitframe(this, ghost, true, true);
					}
					else for (int i = 0; i < 60; i+=2)
					{
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
						Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
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
			if (ghost->Attributes[1] <= 0) for (int i = 60; i > 0; i-=2)
			{
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Ghost_Waitframe(this, ghost, true, true);
			}
			else for (int i = 60; i > 0; i-=2)
			{
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
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
			if (ghost->Weapon >= 129 && ghost->Weapon <= 145 && ghost->Weapon != 144 && ghost->Weapon != 143)
			{
				if (Ghost_Dir == DIR_UP) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y - 8, DIR_UP, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
				if (Ghost_Dir == DIR_DOWN) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y + 8, DIR_DOWN, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
				if (Ghost_Dir == DIR_LEFT) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X - 8, Ghost_Y + 0, DIR_LEFT, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
				if (Ghost_Dir == DIR_RIGHT) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 8, Ghost_Y + 0, DIR_RIGHT, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
			}
			//SetEWeaponMovement(Flamewar, EWM_VEER, Ghost_Dir, 0.05);
			for (int i = 30; i > 0; i--)
			{
				Ghost_Waitframe(this, ghost, true, true);
			}
			Ghost_Data = LASER_COMBO + 8;
			Ghost_StoreDefenses(ghost, Store);
			Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
			ghost->CollDetection = false;
			if (ghost->Attributes[1] <= 0) for (int i = 0; i < 60; i+=2)
			{
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Ghost_Waitframe(this, ghost, true, true);
			}
			else for (int i = 0; i < 60; i+=2)
			{
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
				Ghost_Waitframe(this, ghost, true, true);
			}
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}

ffc script WalkRobe{
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
		int Counter = Rand(120, 240);
		int Useless = -1;
		while(true){
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
				if (ghost->Attributes[1] <= 0) for (int i = 0; i < 60; i+=2)
				{
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Ghost_Waitframe(this, ghost, true, true);
				}
				else for (int i = 0; i < 60; i+=2)
				{
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Ghost_Waitframe(this, ghost, true, true);
				}
				int CountWarp = 0;
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
				//Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				if (ghost->Attributes[1] <= 0) for (int i = 60; i > 0; i-=2)
				{
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Ghost_Waitframe(this, ghost, true, true);
				}
				else for (int i = 60; i > 0; i-=2)
				{
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
					Ghost_Waitframe(this, ghost, true, true);
				}
				ghost->CollDetection = true;
				Ghost_Data = LASER_COMBO;
				Ghost_SetDefenses(ghost, Store);
				Counter = Rand(120, 240);
			}
			else
			{
				Counter--;
				if (Counter <= 0)
				{
					if (Rand(1, 3) < 2)
					{
						Ghost_Data = LASER_COMBO + 8;
						Ghost_StoreDefenses(ghost, Store);
						Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
						ghost->CollDetection = false;
						if (ghost->Attributes[1] <= 0) for (int i = 0; i < 60; i+=2)
						{
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Ghost_Waitframe(this, ghost, true, true);
						}
						else for (int i = 0; i < 60; i+=2)
						{
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Ghost_Waitframe(this, ghost, true, true);
						}
						int CountWarp = 0;
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
						//Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
						if (ghost->Attributes[1] <= 0) for (int i = 60; i > 0; i-=2)
						{
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), LASER_COMBO + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Ghost_Waitframe(this, ghost, true, true);
						}
						else for (int i = 60; i > 0; i-=2)
						{
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, i * 3), Ghost_Y + VectorY((i / 6) * 4, i * 3), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 90), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 90), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 180), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 180), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Screen->FastCombo(3, Ghost_X + VectorX((i / 6) * 4, (i * 3) + 270), Ghost_Y + VectorY((i / 6) * 4, (i * 3) + 270), ghost->Attributes[1] + Ghost_Dir, Ghost_CSet, OP_TRANS);
							Ghost_Waitframe(this, ghost, true, true);
						}
						ghost->CollDetection = true;
						Ghost_Data = LASER_COMBO;
						Ghost_SetDefenses(ghost, Store);
						Counter = Rand(120, 240);
					}
					else Counter = Rand(60, 120);
				}
				if ((Link->X > Ghost_X && Ghost_Dir == DIR_RIGHT && Link->Y > Ghost_Y - 12 && Link->Y < Ghost_Y + 12) ||
				(Link->X < Ghost_X && Ghost_Dir == DIR_LEFT && Link->Y > Ghost_Y - 12 && Link->Y < Ghost_Y + 12) ||
				(Link->Y > Ghost_Y && Ghost_Dir == DIR_DOWN && Link->X > Ghost_X - 12 && Link->X < Ghost_X + 12) ||
				(Link->Y < Ghost_Y && Ghost_Dir == DIR_UP && Link->X > Ghost_X - 12 && Link->X < Ghost_X + 12))
				{
					for (int i = 30; i > 0; i--)
					{
						Ghost_Waitframe(this, ghost, true, true);
					}
					while ((Link->X > Ghost_X && Ghost_Dir == DIR_RIGHT && Link->Y > Ghost_Y - 12 && Link->Y < Ghost_Y + 12) ||
					(Link->X < Ghost_X && Ghost_Dir == DIR_LEFT && Link->Y > Ghost_Y - 12 && Link->Y < Ghost_Y + 12) ||
					(Link->Y > Ghost_Y && Ghost_Dir == DIR_DOWN && Link->X > Ghost_X - 12 && Link->X < Ghost_X + 12) ||
					(Link->Y < Ghost_Y && Ghost_Dir == DIR_UP && Link->X > Ghost_X - 12 && Link->X < Ghost_X + 12))
					{
						Ghost_Data = LASER_COMBO + 4;
						eweapon Flamewar;
						if (ghost->Weapon >= 129 && ghost->Weapon <= 145 && ghost->Weapon != 144 && ghost->Weapon != 143)
						{
							if (Ghost_Dir == DIR_UP) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y - 8, DIR_UP, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
							if (Ghost_Dir == DIR_DOWN) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 0, Ghost_Y + 8, DIR_DOWN, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
							if (Ghost_Dir == DIR_LEFT) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X - 8, Ghost_Y + 0, DIR_LEFT, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
							if (Ghost_Dir == DIR_RIGHT) Flamewar = FireNonAngularEWeapon(ghost->Weapon, Ghost_X + 8, Ghost_Y + 0, DIR_RIGHT, ghost->Attributes[0], ghost->WeaponDamage, -1, 32, 0);
						}
						//SetEWeaponMovement(Flamewar, EWM_VEER, Ghost_Dir, 0.05);
						for (int i = 10; i > 0; i--)
						{
							Ghost_Waitframe(this, ghost, true, true);
						}
						Ghost_Data = LASER_COMBO;
						for (int i = 10; i > 0; i--)
						{
							Ghost_Waitframe(this, ghost, true, true);
						}
					}
				}
				Useless = Ghost_ConstantWalk4(Useless, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
			}
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}