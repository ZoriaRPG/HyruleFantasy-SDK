ffc script ZoraKnight{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		int shotFreq = Ghost_GetAttribute(ghost, 0, 120);
		int combo = ghost->Attributes[10];
		bool inWater = true;
		ghost->CollDetection = false;
		Ghost_Data = GH_INVISIBLE_COMBO;
		int shotCounter;
		int moveAngle;
		int BounceCounter = 0;
		int BounceAngle = 0;
		int PushArray[2];
		while(true){
			Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
			if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<112){
				if(Ghost_Data==GH_INVISIBLE_COMBO){
					ghost->CollDetection = false;
					Ghost_Data = combo;
					Ghost_Waitframes(this, ghost, 32);
					ghost->CollDetection = true;
					Ghost_Data = combo+4;
					shotCounter = shotFreq;
				}
				Ghost_Waitframes(this, ghost, 16);
				Ghost_Data = combo+4;	
				Ghost_Waitframes(this, ghost, 16);
				Screen->Message(176);
				Ghost_Waitframes(this, ghost, 8);
				int landCombo = RZ_FindLand(AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)));
				if(landCombo>-1){
					if(RZ_CanPlace(ComboX(landCombo), ComboY(landCombo))){
						int dist = Distance(Ghost_X, Ghost_Y, ComboX(landCombo), ComboY(landCombo));
						moveAngle = Angle(Ghost_X, Ghost_Y, ComboX(landCombo), ComboY(landCombo));
						Ghost_Dir = AngleDir4(moveAngle);
						Ghost_Jump = 2;
						Game->PlaySound(SFX_SPLASH);
						Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
						Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
						Ghost_Y -= 8;
						for(int i=0; i<26; i++){
							Ghost_X += VectorX(dist/26, moveAngle);
							Ghost_Y += VectorY(dist/26, moveAngle);
							Ghost_Waitframe(this, ghost);
						}
						Ghost_X = ComboX(landCombo);
						Ghost_Y = ComboY(landCombo)-16;
						inWater = false;
						ghost->CollDetection = true;
						break;
					}
				}
			}
			Ghost_Waitframe(this, ghost);
		}
		int AttackCooldown = Rand(240, 300);
		int Attack2Cooldown = Rand(330, 510);
		int MaxHP = Ghost_HP;
		while(Ghost_HP > MaxHP / 2){
			if(Abs(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))>5)
				moveAngle = WrapDegrees(moveAngle+Sign(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))*5);
			else
				moveAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
			Ghost_Dir = AngleDir4(moveAngle);
			Ghost_MoveAtAngle(moveAngle, ghost->Step/100, 0);
			for(int i = Screen->NumLWeapons(); i > 0; i--)
			{
				lweapon Parry = Screen->LoadLWeapon(i);
				if (Parry->ID == LW_SWORD || Parry->ID == LW_SCRIPT3)
				{
					if (Distance(Parry->X, Parry->Y, Ghost_X, Ghost_Y + 16) <= 24)
					{
						eweapon Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
						Ghost_Transform(this, ghost, combo+20, -1, 1, 2);
						Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
						for (int l = 12; l >= 0; l--)
						{
							if (Ghost_Dir == DIR_UP) Screen->FastCombo (3, this->X, this->Y, Ghost_Data, 9, OP_OPAQUE);
							if (!Sword->isValid()) Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
							Sword->Tile = Sword->OriginalTile;
							Sword->Tile+=Ghost_Dir;
							Sword->DeadState = -1;
							if (Collision(Sword, Parry) && (Link->Action == LA_ATTACKING || Link->Action == LA_CHARGING))
							{
								BounceAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
								BounceCounter = 16;
								Game->PlaySound(57);
								lweapon Sparkle = CreateLWeaponAt(LW_SPARKLE, Parry->X, Parry->Y);
								Sparkle->UseSprite(101);
							}
							Sword->X = Ghost_X + InFrontX(Ghost_Dir, 1);
							Sword->Y = Ghost_Y + 16 + InFrontY(Ghost_Dir, 1);
							if (!Sword->isValid()) Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
							if(Ghost_GotHit())
							{
								Remove(Sword);
								break;
							}
							BounceCounter = ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
						}
						Remove(Sword);
						Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
						Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
					}
					break;
				}
			}
			if (AttackCooldown <= 0)
			{
				Ghost_Transform(this, ghost, combo+24, -1, 1, 2);
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				int attackangle = Angle(Ghost_X, Ghost_Y + 16, Link->X, Link->Y);
				for(int i = 0; i < 60; i++)
				{
					BounceCounter = ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
				}
				Ghost_Transform(this, ghost, combo+20, -1, 1, 2);
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				eweapon Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
				Ghost_Vx = VectorX(4.5, attackangle);
				Ghost_Vy = VectorY(4.5, attackangle);
				for(int i = 0; i < 180; i++)
				{
					if (i % 3 == 0) Zora_DrawTrail(this->X, this->Y, this->Data, 9);
				
					if (!Ghost_CanMove(DIR_LEFT, Abs(Ghost_Vx), 4) && Ghost_Vx < 0) Ghost_Vx = -Ghost_Vx;
					else if (!Ghost_CanMove(DIR_RIGHT, Abs(Ghost_Vx), 4) && Ghost_Vx > 0) Ghost_Vx = -Ghost_Vx;
					
					// Change Y velocity when bouncing on horizontal surface.
					if (!Ghost_CanMove(DIR_UP, Abs(Ghost_Vy), 4) && Ghost_Vy < 0) Ghost_Vy = -Ghost_Vy;
					else if (!Ghost_CanMove(DIR_DOWN, Abs(Ghost_Vy), 4) && Ghost_Vy > 0) Ghost_Vy = -Ghost_Vy;
					
					if (!Sword->isValid()) Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
					
					Sword->Tile = Sword->OriginalTile;
					Sword->Tile+=Ghost_Dir;
					Sword->DeadState = -1;
					
					Sword->X = Ghost_X + InFrontX(Ghost_Dir, 0);
					Sword->Y = Ghost_Y + 16 + InFrontY(Ghost_Dir, 0);
					
					if (Ghost_Dir == DIR_UP) Screen->FastCombo (3, this->X, this->Y, Ghost_Data, 9, OP_OPAQUE);
					
					BounceCounter = ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
				}
				Remove(Sword);
				Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				AttackCooldown = Rand(300, 480);
				Ghost_Vx = 0;
				Ghost_Vy = 0;
			}
			else AttackCooldown--;
			if (Attack2Cooldown <= 0)
			{
				Ghost_Transform(this, ghost, combo+28, -1, 1, 2);
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				for(int i = 0; i < 30; i++)
				{
					BounceCounter = ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
				}
				eweapon Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 128, 0, EWF_UNBLOCKABLE);
				int swordangle = Angle(Ghost_X, Ghost_Y + 16, Sword->X, Sword->Y);
				Ghost_Transform(this, ghost, combo+20, -1, 1, 2);
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				for(int i = 0; i < 120; i++)
				{
					swordangle+=16;
					swordangle%=360;
					if (!Sword->isValid()) FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 128, 0, EWF_UNBLOCKABLE);
					Sword->DeadState = -1;
					Sword->DrawXOffset = VectorX((60 - Abs(i - 60)) * 2, swordangle);
					Sword->DrawYOffset = VectorY((60 - Abs(i - 60)) * 2, swordangle);
					Sword->HitXOffset = VectorX((60 - Abs(i - 60)) * 2, swordangle);
					Sword->HitYOffset = VectorY((60 - Abs(i - 60)) * 2, swordangle);
					BounceCounter = ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
				}
				Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				Attack2Cooldown = Rand(450, 600);
				Remove(Sword);
			}
			else Attack2Cooldown--;
			if(Ghost_GotHit()){
				int stunCount = 16;
				int knockbackCount = 2;
				Ghost_Transform(this, ghost, combo+16, -1, 1, 1);
				Ghost_Y += 8;
				int knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
				while(stunCount>0){
					stunCount--;
					if(Ghost_GotHit()){
						stunCount = 16;
						knockbackCount = 2;
						knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
					}
					if(knockbackCount>0){
						Ghost_MoveAtAngle(knockbackAngle, knockbackCount, 0);
						knockbackCount -= 0.2;
					}
					BounceCounter = ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
				}
				Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
					Ghost_Y -= 8;
			}
			BounceCounter = ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
		}
		Screen->Message(178);
		ZoraWait(this, ghost, PushArray, BounceAngle, BounceCounter);
		this->Flags[FFCF_LENSVIS] = true;
		SpawnNPC(360);
		SpawnNPC(360);
		SpawnNPC(360);
		SpawnNPC(360);
		int spawncounter = 0;
		int truecombo = Ghost_Data + Ghost_Dir;
		int truedata = Ghost_Data;
		Ghost_Data = GH_INVISIBLE_COMBO;
		while(true)
		{
			spawncounter++;
			spawncounter %= 240;
			if (spawncounter == 149) SpawnNPC(360);
			if(Abs(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))>5)
				moveAngle = WrapDegrees(moveAngle+Sign(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))*5);
			else
				moveAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
			Ghost_Dir = AngleDir4(moveAngle);
			Ghost_MoveAtAngle(moveAngle, ghost->Step/100, 0);
			for(int i = Screen->NumLWeapons(); i > 0; i--)
			{
				lweapon Parry = Screen->LoadLWeapon(i);
				if (Parry->ID == LW_SWORD || Parry->ID == LW_SCRIPT3)
				{
					if (Distance(Parry->X, Parry->Y, Ghost_X, Ghost_Y + 16) <= 24)
					{
						eweapon Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
						Ghost_Transform(this, ghost, combo+20, -1, 1, 2);
						truecombo = Ghost_Data + Ghost_Dir;
						truedata = Ghost_Data;
						Ghost_Data = GH_INVISIBLE_COMBO;
						Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
						for (int l = 12; l >= 0; l--)
						{
							if (Ghost_Dir == DIR_UP) Screen->FastCombo (3, this->X, this->Y, Ghost_Data, 9, OP_OPAQUE);
							if (!Sword->isValid()) Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
							Sword->Tile = Sword->OriginalTile;
							Sword->Tile+=Ghost_Dir;
							Sword->DeadState = -1;
							if (Collision(Sword, Parry) && (Link->Action == LA_ATTACKING || Link->Action == LA_CHARGING))
							{
								BounceAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
								BounceCounter = 16;
								Game->PlaySound(57);
								lweapon Sparkle = CreateLWeaponAt(LW_SPARKLE, Parry->X, Parry->Y);
								Sparkle->UseSprite(101);
							}
							Sword->X = Ghost_X + InFrontX(Ghost_Dir, 1);
							Sword->Y = Ghost_Y + 16 + InFrontY(Ghost_Dir, 1);
							if (!Sword->isValid()) Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
							if(Ghost_GotHit())
							{
								Remove(Sword);
								break;
							}
							truecombo = truedata + Ghost_Dir;
							BounceCounter = ZoraWait2(this, ghost, PushArray, BounceAngle, BounceCounter, truecombo);
						}
						Remove(Sword);
						Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
						truecombo = Ghost_Data + Ghost_Dir;
						truedata = Ghost_Data;
						Ghost_Data = GH_INVISIBLE_COMBO;
						Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
					}
					break;
				}
			}
			if (AttackCooldown <= 0)
			{
				Ghost_Transform(this, ghost, combo+24, -1, 1, 2);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				int attackangle = Angle(Ghost_X, Ghost_Y + 16, Link->X, Link->Y);
				for(int i = 0; i < 60; i++)
				{
					truecombo = truedata + Ghost_Dir;
					if (i % 6 == 0) Game->PlaySound(86);
					BounceCounter = ZoraWait2(this, ghost, PushArray, BounceAngle, BounceCounter, truecombo);
				}
				Ghost_Transform(this, ghost, combo+20, -1, 1, 2);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				eweapon Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
				Ghost_Vx = VectorX(4.5, attackangle);
				Ghost_Vy = VectorY(4.5, attackangle);
				Game->PlaySound(95);
				for(int i = 0; i < 180; i++)
				{
					if (i % 3 == 0) Zora_DrawTrail2(this->X, this->Y, this->Data, 9);
				
					if (!Ghost_CanMove(DIR_LEFT, Abs(Ghost_Vx), 4) && Ghost_Vx < 0) Ghost_Vx = -Ghost_Vx;
					else if (!Ghost_CanMove(DIR_RIGHT, Abs(Ghost_Vx), 4) && Ghost_Vx > 0) Ghost_Vx = -Ghost_Vx;
					
					// Change Y velocity when bouncing on horizontal surface.
					if (!Ghost_CanMove(DIR_UP, Abs(Ghost_Vy), 4) && Ghost_Vy < 0) Ghost_Vy = -Ghost_Vy;
					else if (!Ghost_CanMove(DIR_DOWN, Abs(Ghost_Vy), 4) && Ghost_Vy > 0) Ghost_Vy = -Ghost_Vy;
					
					if (!Sword->isValid()) Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 12), Ghost_Y + InFrontY(Ghost_Dir, 12), Ghost_Dir, 0, ghost->WeaponDamage, 129, 0, EWF_UNBLOCKABLE);
					
					Sword->Tile = Sword->OriginalTile;
					Sword->Tile+=Ghost_Dir;
					Sword->DeadState = -1;
					
					Sword->X = Ghost_X + InFrontX(Ghost_Dir, 0);
					Sword->Y = Ghost_Y + 16 + InFrontY(Ghost_Dir, 0);
					
					if (Ghost_Dir == DIR_UP) Screen->FastCombo (3, this->X, this->Y, Ghost_Data, 9, OP_OPAQUE);
					
					truecombo = truedata + Ghost_Dir;
					BounceCounter = ZoraWait2(this, ghost, PushArray, BounceAngle, BounceCounter, truecombo);
				}
				Remove(Sword);
				Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				AttackCooldown = Rand(300, 480);
				Ghost_Vx = 0;
				Ghost_Vy = 0;
			}
			else AttackCooldown--;
			if (Attack2Cooldown <= 0)
			{
				Ghost_Transform(this, ghost, combo+28, -1, 1, 2);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				for(int i = 0; i < 30; i++)
				{
					truecombo = truedata + Ghost_Dir;
					BounceCounter = ZoraWait2(this, ghost, PushArray, BounceAngle, BounceCounter, truecombo);
				}
				Game->PlaySound(95);
				eweapon Sword = FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 128, 0, EWF_UNBLOCKABLE);
				int swordangle = Angle(Ghost_X, Ghost_Y + 16, Sword->X, Sword->Y);
				Ghost_Transform(this, ghost, combo+20, -1, 1, 2);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				for(int i = 0; i < 120; i++)
				{
					swordangle+=16;
					swordangle%=360;
					if (!Sword->isValid()) FireNonAngularEWeapon(EW_BEAM, Ghost_X + InFrontX(Ghost_Dir, 15), Ghost_Y + 16 + InFrontY(Ghost_Dir, 15), Ghost_Dir, 0, ghost->WeaponDamage, 128, 0, EWF_UNBLOCKABLE);
					Sword->DeadState = -1;
					Sword->DrawXOffset = VectorX((60 - Abs(i - 60)) * 2, swordangle);
					Sword->DrawYOffset = VectorY((60 - Abs(i - 60)) * 2, swordangle);
					Sword->HitXOffset = VectorX((60 - Abs(i - 60)) * 2, swordangle);
					Sword->HitYOffset = VectorY((60 - Abs(i - 60)) * 2, swordangle);
					truecombo = truedata + Ghost_Dir;
					BounceCounter = ZoraWait2(this, ghost, PushArray, BounceAngle, BounceCounter, truecombo);
				}
				Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
				Attack2Cooldown = Rand(450, 600);
				Remove(Sword);
			}
			else Attack2Cooldown--;
			if(Ghost_GotHit()){
				int stunCount = 16;
				int knockbackCount = 2;
				Ghost_Transform(this, ghost, combo+16, -1, 1, 1);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_Y += 8;
				int knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
				while(stunCount>0){
					stunCount--;
					if(Ghost_GotHit()){
						stunCount = 16;
						knockbackCount = 2;
						knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
					}
					if(knockbackCount>0){
						Ghost_MoveAtAngle(knockbackAngle, knockbackCount, 0);
						knockbackCount -= 0.2;
					}
					truecombo = truedata + Ghost_Dir;
					BounceCounter = ZoraWait2(this, ghost, PushArray, BounceAngle, BounceCounter, truecombo);
				}
				Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
				truecombo = Ghost_Data + Ghost_Dir;
				truedata = Ghost_Data;
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
					Ghost_Y -= 8;
			}
			truecombo = truedata + Ghost_Dir;
			BounceCounter = ZoraWait2(this, ghost, PushArray, BounceAngle, BounceCounter, truecombo);
		}
	}
	int ZoraWait(ffc this, npc ghost, int PushArray, int BounceAngle, int BounceCounter)
	{
		if (BounceCounter > 0)
		{
			Ghost_UnsetFlag(GHF_SET_DIRECTION);
			int bouncetime = Rand(1, 2);
			Ghost_MoveAtAngle(BounceAngle, bouncetime, 4);
			PushArray[0] += VectorX(bouncetime, (0-BounceAngle+180) % 360);
			PushArray[1] += VectorY(bouncetime, (0-BounceAngle) % 360);
			BounceCounter--;
		}
		HandlePushArray(PushArray, 0);
		Screen->DrawCombo (0, this->X, this->Y + (16 * this->TileHeight), this->Data, this->TileWidth, this->TileHeight, this->CSet, -1, -1, 0, 0, 0, -1, 2, true, OP_TRANS);
		if (!Ghost_Waitframe(this, ghost, 1, true))
		{
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon Kill = Screen->LoadEWeapon(i);
				Remove(Kill);
			}
			for (int i = Screen->NumNPCs(); i > 0; i--)
			{
				npc Kill = Screen->LoadNPC(i);
				Remove(Kill);
			}
		}
		Ghost_SetFlag(GHF_SET_DIRECTION);
		return BounceCounter;
	}
	int ZoraWait2(ffc this, npc ghost, int PushArray, int BounceAngle, int BounceCounter, int truecombo)
	{
		if (BounceCounter > 0)
		{
			Ghost_UnsetFlag(GHF_SET_DIRECTION);
			int bouncetime = Rand(1, 2);
			Ghost_MoveAtAngle(BounceAngle, bouncetime, 4);
			PushArray[0] += VectorX(bouncetime, (0-BounceAngle+180) % 360);
			PushArray[1] += VectorY(bouncetime, (0-BounceAngle) % 360);
			BounceCounter--;
		}
		HandlePushArray(PushArray, 0);
		Screen->DrawCombo (0, this->X, this->Y + (16 * this->TileHeight), truecombo, this->TileWidth, this->TileHeight, this->CSet, -1, -1, 0, 0, 0, -1, 2, true, OP_TRANS);
		Ghost_Waitframe(this, ghost);
		Ghost_SetFlag(GHF_SET_DIRECTION);
		return BounceCounter;
	}
	float RZ_AngDiff(float angle1, float angle2)
	{
		float dif = WrapDegrees(angle2) - WrapDegrees(angle1);
	   
		if(dif >= 180)
			dif -= 360;
		else if(dif <= -180)
			dif += 360;
		   
		return dif;
	}
	bool RZ_IsWater(int x, int y){
		int ct = Screen->ComboT[ComboAt(x, y)];
		if(ct==CT_WATER)
			return true;
		if(ct==CT_DIVEWARP||ct==CT_DIVEWARPB||ct==CT_DIVEWARPC||ct==CT_DIVEWARPD)
			return true;
		if(ct==CT_SWIMWARP||ct==CT_SWIMWARPB||ct==CT_SWIMWARPC||ct==CT_SWIMWARPD)
			return true;
		return false;
	}
	bool RZ_CanPlace(int X, int Y){
		for(int x=0; x<=15; x=Min(x+8, 15)){
			for(int y=0; y<=15; y=Min(y+8, 15)){
				if(Screen->isSolid(X+x, Y+y))
					return false;
				if(y==15)
					break;
			}
			if(x==15)
				break;
		}
		return true;
	}
	int RZ_FindLand(int dir){
		int x; int y;
		if(dir==DIR_UP){
			x = Ghost_X+8;
			y = Ghost_Y-1;
		}
		else if(dir==DIR_DOWN){
			x = Ghost_X+8;
			y = Ghost_Y+16;
		}
		else if(dir==DIR_LEFT){
			x = Ghost_X-1;
			y = Ghost_Y+8;
		}
		else if(dir==DIR_RIGHT){
			x = Ghost_X+16;
			y = Ghost_Y+8;
		}	
		if(!RZ_IsWater(x, y))
			return ComboAt(x, y);
		for(int i=0; i<=15; i=Min(i+15, 15)){
			if(dir==DIR_UP){
				x = Ghost_X+i;
				y = Ghost_Y-1;
			}
			else if(dir==DIR_DOWN){
				x = Ghost_X+i;
				y = Ghost_Y+16;
			}
			else if(dir==DIR_LEFT){
				x = Ghost_X-1;
				y = Ghost_Y+i;
			}
			else if(dir==DIR_RIGHT){
				x = Ghost_X+16;
				y = Ghost_Y+i;
			}	
			if(!RZ_IsWater(x, y))
				return ComboAt(x, y);
			if(i==15)
				break;
		}
		return -1;
	}
	int RZ_FindWater(int dir){
		int x; int y;
		if(dir==DIR_UP){
			x = Ghost_X+8;
			y = Ghost_Y-1;
		}
		else if(dir==DIR_DOWN){
			x = Ghost_X+8;
			y = Ghost_Y+16;
		}
		else if(dir==DIR_LEFT){
			x = Ghost_X-1;
			y = Ghost_Y+8;
		}
		else if(dir==DIR_RIGHT){
			x = Ghost_X+16;
			y = Ghost_Y+8;
		}	
		y += 16;
		if(RZ_IsWater(x, y))
			return ComboAt(x, y);
		for(int i=0; i<=15; i=Min(i+15, 15)){
			if(dir==DIR_UP){
				x = Ghost_X+i;
				y = Ghost_Y-1;
			}
			else if(dir==DIR_DOWN){
				x = Ghost_X+i;
				y = Ghost_Y+16;
			}
			else if(dir==DIR_LEFT){
				x = Ghost_X-1;
				y = Ghost_Y+i;
			}
			else if(dir==DIR_RIGHT){
				x = Ghost_X+16;
				y = Ghost_Y+i;
			}	
			y += 16;
			if(RZ_IsWater(x, y))
				return ComboAt(x, y);
			if(i==15)
				break;
		}
		return -1;
	}
	bool Zora_DrawTrail(int x, int y, int cmb, int cs){
		lweapon trail = CreateLWeaponAt(LW_SCRIPT10, x, y);
		trail->Extend = 3;
		trail->TileWidth = 1;
		trail->TileHeight = 2;
		trail->OriginalTile = Game->ComboTile(cmb);
		trail->Tile = trail->OriginalTile;
		trail->CSet = cs;
		trail->DrawYOffset = 0;
		trail->DrawStyle = DS_PHANTOM;
		trail->DeadState = 20;
	}
	bool Zora_DrawTrail2(int x, int y, int cmb, int cs){
		lweapon trail = CreateLWeaponAt(LW_SCRIPT9, x, y);
		trail->Extend = 3;
		trail->TileWidth = 1;
		trail->TileHeight = 2;
		trail->OriginalTile = Game->ComboTile(cmb);
		trail->Tile = trail->OriginalTile;
		trail->CSet = cs;
		trail->DrawXOffset = -256;
		trail->DrawYOffset = -176;
		trail->DrawStyle = DS_PHANTOM;
		trail->DeadState = 20;
	}
}

ffc script ZoraDecoy{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		int shotFreq = Ghost_GetAttribute(ghost, 0, 120);
		int combo = ghost->Attributes[10];
		bool inWater = true;
		ghost->CollDetection = false;
		Ghost_Data = GH_INVISIBLE_COMBO;
		int shotCounter;
		int moveAngle;
		while(true){
			if(inWater){
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<112){
					if(Ghost_Data==GH_INVISIBLE_COMBO){
						ghost->CollDetection = false;
						Ghost_Data = combo;
						Ghost_Waitframes(this, ghost, 32);
						ghost->CollDetection = true;
						Ghost_Data = combo+4;
						shotCounter = shotFreq;
					}
					if(shotCounter>0)
						shotCounter--;
					else if(Rand(16)==0){
						Ghost_Data = combo+8;
						Ghost_Waitframes(this, ghost, 32);
						eweapon e = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, 0, 250, ghost->WeaponDamage, -1, -1, 0);
						Ghost_Waitframes(this, ghost, 32);
						Ghost_Data = combo+4;
						shotCounter = shotFreq;
					}
					if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<48){
						int landCombo = RZ_FindLand(AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)));
						if(landCombo>-1){
							if(RZ_CanPlace(ComboX(landCombo), ComboY(landCombo))){
								int dist = Distance(Ghost_X, Ghost_Y, ComboX(landCombo), ComboY(landCombo));
								moveAngle = Angle(Ghost_X, Ghost_Y, ComboX(landCombo), ComboY(landCombo));
								Ghost_Dir = AngleDir4(moveAngle);
								Ghost_Jump = 2;
								Game->PlaySound(SFX_SPLASH);
								Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
								Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
								Ghost_Y -= 8;
								for(int i=0; i<26; i++){
									Ghost_X += VectorX(dist/26, moveAngle);
									Ghost_Y += VectorY(dist/26, moveAngle);
									Ghost_Waitframe(this, ghost);
								}
								Ghost_X = ComboX(landCombo);
								Ghost_Y = ComboY(landCombo)-16;
								inWater = false;
								ghost->CollDetection = true;
							}
						}
					}
				}
				else{
					if(Ghost_Data>combo){
						ghost->CollDetection = false;
						Ghost_Data = combo;
						Ghost_Waitframes(this, ghost, 32);
						Ghost_Data = GH_INVISIBLE_COMBO;
					}
				}
			}
			else{
				int waterCombo = RZ_FindWater(Ghost_Dir);
				if(waterCombo>-1){
					int dist = Distance(Ghost_X, Ghost_Y+16, ComboX(waterCombo), ComboY(waterCombo));
					moveAngle = Angle(Ghost_X, Ghost_Y+16, ComboX(waterCombo), ComboY(waterCombo));
					Ghost_Jump = 2;
					Game->PlaySound(SFX_JUMP);
					for(int i=0; i<26; i++){
						Ghost_X += VectorX(dist/26, moveAngle);
						Ghost_Y += VectorY(dist/26, moveAngle);
						Ghost_Waitframe(this, ghost);
					}
					Ghost_Transform(this, ghost, combo+4, -1, 1, 1);
					Ghost_Y += 8;
					Ghost_X = ComboX(waterCombo);
					Ghost_Y = ComboY(waterCombo);
					inWater = true;
					ghost->CollDetection = true;
					Ghost_Waitframes(this, ghost, 32);
				}
				else{
					if(Abs(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))>5)
						moveAngle = WrapDegrees(moveAngle+Sign(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))*5);
					else
						moveAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
					Ghost_Dir = AngleDir4(moveAngle);
					Ghost_MoveAtAngle(moveAngle, ghost->Step/100, 0);
					if(Ghost_GotHit()){
						int stunCount = 48;
						int knockbackCount = 2;
						Ghost_Transform(this, ghost, combo+16, -1, 1, 1);
						Ghost_Y += 8;
						int knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						while(stunCount>0){
							stunCount--;
							if(Ghost_GotHit()){
								stunCount = 48;
								knockbackCount = 2;
								knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
							}
							if(knockbackCount>0){
								Ghost_MoveAtAngle(knockbackAngle, knockbackCount, 0);
								knockbackCount -= 0.2;
							}
							Ghost_Waitframe(this, ghost);
						}
						Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
						Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
						Ghost_Y -= 8;
					}
				}
			}
			Ghost_Waitframe(this, ghost);
		}
	}
	float RZ_AngDiff(float angle1, float angle2)
	{
		float dif = WrapDegrees(angle2) - WrapDegrees(angle1);
	   
		if(dif >= 180)
			dif -= 360;
		else if(dif <= -180)
			dif += 360;
		   
		return dif;
	}
	bool RZ_IsWater(int x, int y){
		int ct = Screen->ComboT[ComboAt(x, y)];
		if(ct==CT_WATER)
			return true;
		if(ct==CT_DIVEWARP||ct==CT_DIVEWARPB||ct==CT_DIVEWARPC||ct==CT_DIVEWARPD)
			return true;
		if(ct==CT_SWIMWARP||ct==CT_SWIMWARPB||ct==CT_SWIMWARPC||ct==CT_SWIMWARPD)
			return true;
		return false;
	}
	bool RZ_CanPlace(int X, int Y){
		for(int x=0; x<=15; x=Min(x+8, 15)){
			for(int y=0; y<=15; y=Min(y+8, 15)){
				if(Screen->isSolid(X+x, Y+y))
					return false;
				if(y==15)
					break;
			}
			if(x==15)
				break;
		}
		return true;
	}
	int RZ_FindLand(int dir){
		int x; int y;
		if(dir==DIR_UP){
			x = Ghost_X+8;
			y = Ghost_Y-1;
		}
		else if(dir==DIR_DOWN){
			x = Ghost_X+8;
			y = Ghost_Y+16;
		}
		else if(dir==DIR_LEFT){
			x = Ghost_X-1;
			y = Ghost_Y+8;
		}
		else if(dir==DIR_RIGHT){
			x = Ghost_X+16;
			y = Ghost_Y+8;
		}	
		if(!RZ_IsWater(x, y))
			return ComboAt(x, y);
		for(int i=0; i<=15; i=Min(i+15, 15)){
			if(dir==DIR_UP){
				x = Ghost_X+i;
				y = Ghost_Y-1;
			}
			else if(dir==DIR_DOWN){
				x = Ghost_X+i;
				y = Ghost_Y+16;
			}
			else if(dir==DIR_LEFT){
				x = Ghost_X-1;
				y = Ghost_Y+i;
			}
			else if(dir==DIR_RIGHT){
				x = Ghost_X+16;
				y = Ghost_Y+i;
			}	
			if(!RZ_IsWater(x, y))
				return ComboAt(x, y);
			if(i==15)
				break;
		}
		return -1;
	}
	int RZ_FindWater(int dir){
		int x; int y;
		if(dir==DIR_UP){
			x = Ghost_X+8;
			y = Ghost_Y-1;
		}
		else if(dir==DIR_DOWN){
			x = Ghost_X+8;
			y = Ghost_Y+16;
		}
		else if(dir==DIR_LEFT){
			x = Ghost_X-1;
			y = Ghost_Y+8;
		}
		else if(dir==DIR_RIGHT){
			x = Ghost_X+16;
			y = Ghost_Y+8;
		}	
		y += 16;
		if(RZ_IsWater(x, y))
			return ComboAt(x, y);
		for(int i=0; i<=15; i=Min(i+15, 15)){
			if(dir==DIR_UP){
				x = Ghost_X+i;
				y = Ghost_Y-1;
			}
			else if(dir==DIR_DOWN){
				x = Ghost_X+i;
				y = Ghost_Y+16;
			}
			else if(dir==DIR_LEFT){
				x = Ghost_X-1;
				y = Ghost_Y+i;
			}
			else if(dir==DIR_RIGHT){
				x = Ghost_X+16;
				y = Ghost_Y+i;
			}	
			y += 16;
			if(RZ_IsWater(x, y))
				return ComboAt(x, y);
			if(i==15)
				break;
		}
		return -1;
	}
}