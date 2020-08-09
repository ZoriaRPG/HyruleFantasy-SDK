ffc script Vire{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_8WAY);
		Ghost_SetFlag(GHF_SET_DIRECTION);
		//Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		if(ghost->Attributes[5] != 0) Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetSize(this, ghost, 2, 1);
		Ghost_SetHitOffsets(ghost, 0, 0, 4, 4);
		int FlyData = Ghost_Data;
		int FireData = Ghost_Data + 8;
		int Counter = Rand(ghost->Attributes[0], ghost->Attributes[1]);
		int Counterthing = -1;
		while(true){
			Ghost_Z = 8;
			Counterthing = Ghost_ConstantWalk8(Counterthing, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
			Counter--;
			if (Counter <= 0)
			{
				Ghost_Data = FireData;
				int RandAttack = Rand(1, 2);
				if (RandAttack == 1 || ghost->Attributes[2] <= 0)
				{
					if (ghost->Attributes[4] == 0) 
					{
						for (int i = 0; i < 60; i++) Ghost_Waitframe(this, ghost, true, true);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, 0, 200, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, 0.8, 200, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, -0.8, 200, ghost->WeaponDamage, -1, -1, 0);
					}
					else
					{
						for (int i = 0; i < 30; i++) Ghost_Waitframe(this, ghost, true, true);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, 1.2, 200, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, -1.2, 200, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, 0.4, 200, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, -0.4, 200, ghost->WeaponDamage, -1, -1, 0);
						for (int i = 0; i < 30; i++) Ghost_Waitframe(this, ghost, true, true);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, 0, 300, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, 0.8, 300, ghost->WeaponDamage, -1, -1, 0);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y, -0.8, 300, ghost->WeaponDamage, -1, -1, 0);
					}
					for (int i = 0; i < 45; i++) Ghost_Waitframe(this, ghost, true, true);
				}
				else
				{
					for (int i = 0; i < 30; i++) Ghost_Waitframe(this, ghost, true, true);
					for (int i = 0; i < ghost->Attributes[3]; i++) CreateNPCAt(ghost->Attributes[2], Ghost_X + 8, Ghost_Y);
					for (int i = 0; i < 30; i++) Ghost_Waitframe(this, ghost, true, true);
				}
				Ghost_Data = FlyData;
				Counter = Rand(ghost->Attributes[0], ghost->Attributes[1]);
			}
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}