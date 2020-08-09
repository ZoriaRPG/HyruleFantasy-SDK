ffc script BetterAquamentus
{
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		int WakeData = Ghost_Data;
		int MainData = Ghost_Data + 4;
		int BlowData = Ghost_Data + 8;
		
		ghost->Extend = 3;
		Ghost_TileWidth = 3;
		Ghost_TileHeight = 2;
		
		while (true)
		{
			if (Abs((Ghost_X + (0.5 * ghost->HitWidth)) - (Link->X + 8)) > 12 && Abs((Ghost_Y + (0.5 * ghost->HitHeight)) - (Link->Y + 8)) > 12);
			{
				Ghost_MoveTowardLink(ghost->Step * 0.01, 2);
			}
			if (Ghost_X <= 32 || Ghost_Y <= 16 || Ghost_Y + 32 >= 144)
			{
				angle = Angle(Ghost_X, Ghost_Y, original_x, original_y);
				y_greater = false;
				if (Ghost_Y >= original_y)
				{
					y_greater = true;
				}
				y_done = false;
				while (Ghost_X < original_x || !y_done)
				{
					Ghost_MoveAtAngle(angle, ghost->Step * 0.04, 2);
					if (y_greater && Ghost_Y <= original_y)
					{
						y_done = true;
					}
					else if (!y_greater && Ghost_Y >= original_y)
					{
						y_done = true;
					}
					BetterAqua_Ghost_Waitframe(this, ghost);
				}
			}
			if (timer_attack <= 0)
			{
				if (Ghost_HP > maxHP * 0.5)
				{
					choice = Rand(6);
					if (choice == 5)
					{
						Aqua_RamAttack(this, ghost, original_x, original_y, aspeed);
					}
					else
					{
						Aqua_FireballAttack(this, ghost, maxHP);
					}
				}
				else if (Ghost_HP <= maxHP * 0.5 && Ghost_HP > maxHP * 0.25)
				{
					choice = Rand(7);
					if (choice == 5 || choice == 4)
					{
						Aqua_RamAttack(this, ghost, original_x, original_y, aspeed);
					}
					if (choice == 3)
					{
						Aqua_StompAttack(this, ghost, original_x, original_y, aspeed);
					}
					else
					{
						Aqua_FireballAttack(this, ghost, maxHP);
					}
				}
				else if (Ghost_HP <= maxHP * 0.25)
				{
					choice = Rand(9);
					if (choice == 5 || choice == 4 || choice == 3)
					{
						Aqua_RamAttack(this, ghost, original_x, original_y, aspeed);
					}
					if (choice == 6 || choice == 2)
					{
						Aqua_StompAttack(this, ghost, original_x, original_y, aspeed);
					}
					else
					{
						Aqua_FireballAttack(this, ghost, maxHP);
					}
				}
				timer_attack = Rand(120, 240);
			}
			
			if (Ghost_HP <= (maxHP / 3) * 2 && !turn_cset10)
			{
				Ghost_CSet = 10;
				turn_cset10 = true;
			}
			if (Ghost_HP <= maxHP / 3 && !turn_cset8)
			{
				Ghost_CSet = 8;
				turn_cset8 = true;
			}
			if (timer_attack > 0)
			{
				timer_attack--;
			}
			BetterAqua_Ghost_Waitframe(this, ghost);
		}
	}
}

void Aqua_FireballAttack(ffc this, npc ghost, int maxHP)
{
	if (Ghost_HP >(maxHP / 3))
	{
		ghost->Misc[0] = 0;
		ghost->OriginalTile = TILE_AQUA2;
	}
	for (int i = 0; i < 20; i++)
	{
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	float angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
	float initangle = angle - 30;
	int numshots = 3;
	for (int i = 0; i < 10; i++)
	{
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	if (Ghost_HP <= (maxHP / 3) * 2)
	{
		initangle = angle - 60;
		numshots = 5;
	}
	if (Ghost_HP <= (maxHP / 3))
	{
		angle+=180;
		Ghost_Jump = 2;
		BetterAqua_Ghost_Waitframe(this, ghost);
		while (Ghost_Z > 0)
		{
			Ghost_MoveAtAngle(angle, ghost->Step * 0.08, 4);
			BetterAqua_Ghost_Waitframe(this, ghost);
		}
		ghost->Misc[0] = 0;
		ghost->OriginalTile = TILE_AQUA2;
		angle = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
		initangle = angle - 80;
		numshots = 9;
		for (int i = 0; i < numshots; i++)
		{
			FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(initangle + (20 * i)), 150, ghost->WeaponDamage, -1, -1, 0);
			for (int k = 0; k < 3; k++)
			{
				BetterAqua_Ghost_Waitframe(this, ghost);
			}
		}
	}
	else for (int i = 0; i < numshots; i++)
	{
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(initangle + (30 * i)), 150, ghost->WeaponDamage, -1, -1, 0);
	}
	for (int i = 0; i < 10; i++)
	{
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	ghost->Misc[0] = 0;
	ghost->OriginalTile = TILE_AQUA1;
}

void Facade_Wake(ffc this, npc ghost, int original_x, int original_y, int aspeed)
{
	int time;
	float angle;
	int timer_collide;
	int storedDefense[18];
	
	float jump = 4;
	int t;
	int t0;
	int t1;
	int t2;
	float v;
	
	ghost->ASpeed = aspeed * 0.5;
	ghost->Misc[0] = 2;
	Ghost_StoreDefenses(ghost, storedDefense);
	Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
	for (int i = 0; i < 45; i++)
	{
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	angle = Angle(Ghost_X + (0.5 * ghost->HitWidth), Ghost_Y + (0.5 * ghost->HitHeight), Link->X + 8, Link->Y + 8);
	//while (Ghost_CanMove(DIR_UP, ghost->Step * 0.08, 64) && Ghost_CanMove(DIR_DOWN, ghost->Step * 0.08, 64) && Ghost_CanMove(DIR_LEFT, ghost->Step * 0.08, 64))
	while (!Screen->isSolid(Ghost_X + 16, Ghost_Y + 11) && !Screen->isSolid(Ghost_X + 3, Ghost_Y + 16) && !Screen->isSolid(Ghost_X + 29, Ghost_Y + 16) && !Screen->isSolid(Ghost_X + 16, Ghost_Y + 29))
	{
		//Ghost_MoveAtAngle(angle, ghost->Step * 0.08, 4);
		Ghost_X += VectorX(ghost->Step * 0.08, angle);
		Ghost_Y += VectorY(ghost->Step * 0.08, angle);
		timer_collide++;
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	Game->PlaySound(SFX_AQUA_WALLCRASH);
	angle += 180;
	angle %=360;
	Ghost_Jump = 1;
	ghost->ASpeed = aspeed;
	BetterAqua_Ghost_Waitframe(this, ghost);
	while (Ghost_Z > 0)
	{
		Ghost_MoveAtAngle(angle, ghost->Step * 0.08, 4);
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	angle = Angle(Ghost_X, Ghost_Y, original_x, original_y);
	Ghost_SetFlag(GHF_NO_FALL);
	int AZ = 0.5;
	ghost->OriginalTile = TILE_AQUA3;
	ghost->Misc[0] = 2;
	ghost->ASpeed = aspeed * 0.75;
	while (Ghost_Z < 64)
	{
		Ghost_Z+=AZ;
		AZ+=0.05;
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	ghost->ASpeed = aspeed / 2;
	while (Distance(Ghost_X, Ghost_Y, original_x, original_y) > 3)
	{
		Ghost_MoveAtAngle(angle, ghost->Step * 0.02, 4);
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	Ghost_UnsetFlag(GHF_NO_FALL);
	ghost->OriginalTile = TILE_AQUA1;
	ghost->Misc[0] = 2;
	while (Ghost_Z > 0)
	{
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	ghost->Misc[0] = 0;
	Game->PlaySound(SFX_AQUA_STOMP);
	Screen->Quake = 4;
	ghost->ASpeed = aspeed;
	Ghost_SetDefenses(ghost, storedDefense);
}

void Aqua_StompAttack(ffc this, npc ghost, int original_x, int original_y, int aspeed)
{
	int time;
	float angle;
	int timer_collide;
	int storedDefense[18];
	
	float jump = 4;
	int t;
	int t0;
	int t1;
	int t2;
	float v;
	
	angle = Angle(Ghost_X, Ghost_Y, Link->X - 8, Link->Y - 8);
	t0 = (2 * jump) / GRAVITY;
	t1 = (jump + TERMINAL_VELOCITY) / GRAVITY;
	t2 = ((-0.5 * GRAVITY * Pow(t1, 2)) + (jump * t1)) / TERMINAL_VELOCITY;
	if (t0 > t1)
	{
		t = t1 + t2;
	}
	else
	{
		t = t0;
	}
	v = Distance(Ghost_X, Ghost_Y, Link->X - 8, Link->Y - 8) / t;
	ghost->ASpeed = aspeed;
	Ghost_Jump = jump;
	ghost->Misc[0] = 2;
	for (int i = 0; i < t; i++)
	{
		Ghost_MoveAtAngle(angle, v, 2);
		BetterAqua_Ghost_Waitframe(this, ghost);
	}
	ghost->Misc[0] = 0;
	ghost->OriginalTile = TILE_AQUA1;
	Game->PlaySound(SFX_AQUA_STOMP);
	Screen->Quake = 4;
}

void Facade_Waitframe(ffc this, npc ghost)
{
	if (Ghost_Z > 0)
	{		
		if(GH_SHADOW_TRANSLUCENT>0) Screen->DrawTile(1, Ghost_X+8, Ghost_Y+16, GH_SHADOW_TILE+__ghzhData[__GHI_SHADOW_FRAME], 1, 1, GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
		else Screen->DrawTile(1, Ghost_X+8, Ghost_Y+16, GH_SHADOW_TILE+__ghzhData[__GHI_SHADOW_FRAME], 1, 1, GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
	}
	ghost->Misc[1]++;
	if (ghost->Misc[1] > 120)
	{
		Game->PlaySound(24);
		ghost->Misc[1] = 0;
	}
	if (ghost->Misc[0] != 2)
	{
		if (ghost->Misc[0] == 1)
		{
			if (Link->X < Ghost_X)
			{
				ghost->OriginalTile -= 120;
				ghost->Misc[0] = 0;
			}
		}
		else if (Link->X > Ghost_X + 15)
		{
			ghost->OriginalTile += 120;
			ghost->Misc[0] = 1;
		}
	}
	Ghost_Waitframe(this, ghost, 1, true);
}