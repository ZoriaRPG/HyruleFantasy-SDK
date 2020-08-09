//import "std.zh"
//import "string.zh"
//import "ghost.zh"
//import "ffcscript.zh"
//import "stdExtra.zh"

//+12 -12
//+14 +0
//+14 +8

ffc script Armogohma
{
	
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		if (Screen->D[1] > 0)
		{
			ghost->HP = 0;
			for (int i = Screen->NumNPCs(); i > 0; i--)
			{
				npc kill = Screen->LoadNPC(i);
				kill->HP = 0;
			}
			this->Data = 0;
			this->Script = 0;
			Quit();
		}
		
		int Ghosty = 0;
		
		for (int i = Screen->NumNPCs(); i > 0; i--)
		{
			npc Ghoster = Screen->LoadNPC(i);
			if (Ghoster == ghost)
			{
				Ghosty = i;
				break;
			}
		}
		
		//Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		this->InitD[1] = 2;
		this->InitD[2] = Ghosty;
		this->InitD[3] = 0;
		npc Legs1 = CreateNPCAt(ghost->Attributes[0], Ghost_X - 15, Ghost_Y);
		npc Legs2 = CreateNPCAt(ghost->Attributes[1], Ghost_X + 15, Ghost_Y);
		CreateNPCAt(ghost->Attributes[2], Ghost_X - 16, Ghost_Y - 16);
		Legs1->HP = 105;
		int MaxHP = Ghost_HP;
		int GohmaData = Ghost_Data;
		int EyeData = Ghost_Data + 1;
		int SlitData = Ghost_Data + 2;
		int GrabR1Data = Ghost_Data + 3;
		int GrabR2Data = Ghost_Data + 4;
		int GrabL1Data = Ghost_Data + 5;
		int GrabL2Data = Ghost_Data + 6;
		int LaserData = Ghost_Data + 7;
		int JumpData = Ghost_Data + 8;
		int ClawData = ghost->Attributes[9];
		
		Ghost_SetHitOffsets(ghost, 0, -4, -4, -4);
		
		int GoPath = Rand(1, 5);
		int GohmaCounter = Rand (150, 210);
		int LaserCounter = 3;
		int Store[18];
		Ghost_StoreDefenses(ghost, Store);
		Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
		ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
		while(Ghost_HP > (MaxHP / 2))
		{
			GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
			GoPath = GohmaMove (ghost, this, GoPath);
			GohmaCounter--;
			if (GohmaCounter <= 0)
			{
				for (int k = 0; k < 225; k++)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					GoPath = GohmaMove (ghost, this, GoPath);
					if (k % 45 == 0)
					{
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					}
				}
				for (int k = 90; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					GoPath = GohmaMove2 (ghost, this, GoPath);
					Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (k % 30), 12, 3, 0, 0, 0, false, OP_OPAQUE);
					if (k == 20) Game->PlaySound(77);
				}
				int LaserX = Ghost_X + 8;
				int LaserY = Ghost_Y + 16;
				int LaserAngle = 90;
				bool LeftLaser = false;
				Ghost_Data = EyeData;
				this->InitD[3] = 1;
				int BoomCounter = 0;
				if (Link->X < Ghost_X) LeftLaser = true;
				Ghost_SetDefenses(ghost, Store);
				while (LaserY < 144 && LaserX > 32 && LaserX < 224)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					BoomCounter++;
					BoomCounter%=4;
					if (BoomCounter == 3)
					{
						eweapon Hey = FireAimedEWeapon(EW_FIRE, LaserX - 8 + Rand(-2, 2), LaserY - 8 + Rand(-2, 2), 0, 0, 0, 80, 0, EWF_NO_COLLISION);
						SetEWeaponLifespan(Hey, EWL_TIMER, 30);
						SetEWeaponDeathEffect(Hey, EWD_EXPLODE, ghost->WeaponDamage * 2);
					}
					if (LeftLaser && Sign(angleDifference(DegtoRad(LaserAngle), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) > 0 && Link->X < Ghost_X) LaserAngle+=2.5;
					if (!LeftLaser && Sign(angleDifference(DegtoRad(LaserAngle), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) < 0 && Link->X > Ghost_X) LaserAngle-=2.5;
					LaserX += VectorX(3, LaserAngle);
					LaserY += VectorY(3, LaserAngle); 
					if (BoomCounter%8 == 0) Game->PlaySound(76);
					if (BoomCounter%2 == 0)
					{					
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX, LaserY, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX - 1, LaserY, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX, LaserY - 1, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX + 1, LaserY, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX, LaserY + 1, 12, 1, 0, 0, 0, OP_OPAQUE);
					}
					else
					{
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX, LaserY, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX - 1, LaserY, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX, LaserY - 1, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX + 1, LaserY, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX, LaserY + 1, 11, 1, 0, 0, 0, OP_OPAQUE);
					}
				}
				for (int k = 120; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Ghost_Data = GohmaData;
				this->InitD[3] = 0;
				Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
				ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
				GohmaCounter = Rand (150, 210);
				LaserCounter--;
			}
		}
		int StayCounter[1];
		StayCounter[0] = 0;
		GohmaCounter = 180;
		while(true)
		{
			GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
			GoPath = GohmaMove3 (ghost, this, GoPath, StayCounter);
			GohmaCounter--;
			if (GohmaCounter == 120)
			{
				Ghost_Data = GrabR1Data;
				this->InitD[3] = 3;
				for (int k = 0; k < 30; k++)
				{
					FastCombo(3, Ghost_X + 12, Ghost_Y - 12, ClawData + 5, Ghost_CSet, OP_OPAQUE);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Ghost_Data = GrabR2Data;
				this->InitD[3] = 4;
				for (int k = 0; k < 15; k++)
				{
					FastCombo(3, Ghost_X + 14, Ghost_Y, ClawData + 4, Ghost_CSet, OP_OPAQUE);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Screen->Quake = 4;
				if (true)
				{
					npc Fall = SpawnNPC(385);
					Fall->X = Clamp(Fall->X, 48, 192);
					Fall->Z = 100;
				}
				Game->PlaySound(SFX_BOMB);
				Game->PlaySound(SFX_FALL);
				for (int k = 0; k < 15; k++)
				{
					FastCombo(3, Ghost_X + 14, Ghost_Y + 8, ClawData + 4, Ghost_CSet, OP_OPAQUE);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Ghost_Data = GrabR1Data;
				this->InitD[3] = 3;
				for (int k = 0; k < 15; k++)
				{
					FastCombo(3, Ghost_X + 12, Ghost_Y - 12, ClawData + 5, Ghost_CSet, OP_OPAQUE);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Screen->Quake = 4;
				if (true)
				{
					npc Fall2 = SpawnNPC(385);
					Fall2->X = Clamp(Fall2->X, 48, 192);
					Fall2->Z = 100;
				}
				Game->PlaySound(SFX_BOMB);
				Game->PlaySound(SFX_FALL);
				Ghost_Data = GrabR2Data;
				this->InitD[3] = 4;
				for (int k = 0; k < 15; k++)
				{
					FastCombo(3, Ghost_X + 14, Ghost_Y + 8, ClawData + 4, Ghost_CSet, OP_OPAQUE);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Ghost_Data = GrabR1Data;
				this->InitD[3] = 3;
				for (int k = 0; k < 15; k++)
				{
					FastCombo(3, Ghost_X + 12, Ghost_Y - 12, ClawData + 5, Ghost_CSet, OP_OPAQUE);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Screen->Quake = 4;
				if (true)
				{
					npc Fall3 = SpawnNPC(385);
					Fall3->X = Clamp(Fall3->X, 48, 192);
					Fall3->Z = 100;
				}
				Game->PlaySound(SFX_BOMB);
				Game->PlaySound(SFX_FALL);
				Ghost_Data = GrabR2Data;
				this->InitD[3] = 4;
				for (int k = 0; k < 30; k++)
				{
					FastCombo(3, Ghost_X + 14, Ghost_Y + 8, ClawData + 4, Ghost_CSet, OP_OPAQUE);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Ghost_Data = GohmaData;
				this->InitD[3] = 0;
			}
			if (GohmaCounter <= 0)
			{
				for (int k = 0; k < 225; k++)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					GoPath = GohmaMove (ghost, this, GoPath);
					if (k % 45 == 0)
					{
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					}
				}
				for (int k = 90; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					GoPath = GohmaMove2 (ghost, this, GoPath);
					Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (k % 30), 12, 3, 0, 0, 0, false, OP_OPAQUE);
					if (k == 20) Game->PlaySound(77);
				}
				int LaserX = Ghost_X + 8;
				int LaserY = Ghost_Y + 16;
				int LaserAngle = 90;
				bool LeftLaser = false;
				Ghost_Data = EyeData;
				this->InitD[3] = 1;
				int BoomCounter = 0;
				if (Link->X < Ghost_X) LeftLaser = true;
				Ghost_SetDefenses(ghost, Store);
				while (LaserY < 144 && LaserX > 32 && LaserX < 224)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					BoomCounter++;
					BoomCounter%=4;
					if (BoomCounter == 3)
					{
						eweapon Hey = FireAimedEWeapon(EW_FIRE, LaserX - 8 + Rand(-2, 2), LaserY - 8 + Rand(-2, 2), 0, 0, 0, 80, 0, EWF_NO_COLLISION);
						SetEWeaponLifespan(Hey, EWL_TIMER, 30);
						SetEWeaponDeathEffect(Hey, EWD_EXPLODE, ghost->WeaponDamage * 2);
					}
					if (LeftLaser && Sign(angleDifference(DegtoRad(LaserAngle), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) > 0 && Link->X < Ghost_X) LaserAngle+=2.5;
					if (!LeftLaser && Sign(angleDifference(DegtoRad(LaserAngle), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) < 0 && Link->X > Ghost_X) LaserAngle-=2.5;
					LaserX += VectorX(3, LaserAngle);
					LaserY += VectorY(3, LaserAngle); 
					if (BoomCounter%8 == 0) Game->PlaySound(76);
					if (BoomCounter%2 == 0)
					{					
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX, LaserY, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX - 1, LaserY, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX, LaserY - 1, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX + 1, LaserY, 12, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX, LaserY + 1, 12, 1, 0, 0, 0, OP_OPAQUE);
					}
					else
					{
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX, LaserY, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX - 1, LaserY, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX, LaserY - 1, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX + 1, LaserY, 11, 1, 0, 0, 0, OP_OPAQUE);
						Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX, LaserY + 1, 11, 1, 0, 0, 0, OP_OPAQUE);
					}
				}
				for (int k = 120; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Ghost_Data = GohmaData;
				this->InitD[3] = 0;
				Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
				ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
				GohmaCounter = Rand (150, 210);
				LaserCounter--;
			}
		}
	}
	void GohmaWait(npc ghost, ffc this, npc Legs1, npc Legs2, int GohmaData, int EyeData)
	{
		//Trace(ghost->Defense[NPCD_BRANG]);
		//Trace(ghost->Defense[NPCD_HOOKSHOT]);
		Legs1->X = Ghost_X - 15;
		Legs2->X = Ghost_X + 15;
		Legs1->Y = Ghost_Y;
		Legs2->Y = Ghost_Y;
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		if (!Ghost_Waitframe(this, ghost, false, false))
		{
			Ghost_HP = 4;
			Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
			ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
			Ghost_Data = GohmaData;
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon Ctrl_Alt_Dlt = Screen->LoadEWeapon(i);
				Remove(Ctrl_Alt_Dlt);
			}
			for (int i = Screen->NumNPCs(); i > 4; i--)
			{
				npc Head = Screen->LoadNPC(i);
				Head->HP = 0;
			}
			this->InitD[3] = 0;
			while(Ghost_X < 120)
			{
				Ghost_Move(DIR_RIGHT, 1, 4);
				GohmaWaitMini(ghost, this, Legs1, Legs2);
			}
			while(Ghost_X > 120)
			{
				Ghost_Move(DIR_LEFT, 1, 4);
				GohmaWaitMini(ghost, this, Legs1, Legs2);
			}
			this->InitD[3] = 1;
			for (int k = 60; k > 0; k--)
			{
				GohmaWaitMini(ghost, this, Legs1, Legs2);
			}
			Ghost_Data = EyeData;
			for (int k = 15; k > 0; k--)
			{
				GohmaWaitMini(ghost, this, Legs1, Legs2);
			}
			ffc FFC = Screen->LoadFFC(GetUnusedFFC());
			FFC->Data = CMB_AUTOWARP;
		}
	}
	void GohmaWaitMini(npc ghost, ffc this, npc Legs1, npc Legs2)
	{
		Legs1->X = Ghost_X - 15;
		Legs2->X = Ghost_X + 15;
		Legs1->Y = Ghost_Y;
		Legs2->Y = Ghost_Y;
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		Ghost_Waitframe(this, ghost, false, false);
	}
	int GohmaMove (npc ghost, ffc this, int GoPath)
	{
		Ghost_Dir = DIR_DOWN;
		this->InitD[3] = 0;
		int fakepath = GoPath;
		if (GoPath == 2)
		{
			if (Distance (Ghost_X, Ghost_Y, 120, 48) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 48), 1, 4);
			}
			else
			{
				Ghost_X = 120;
				Ghost_Y = 48;
				GoPath = Rand(1, 5);
				if (GoPath == 2) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 2) GoPath = 0;
			}
		}
		else if (GoPath == 0)
		{
			if (Distance (Ghost_X, Ghost_Y, 72, 64) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 72, 64), 1, 4);
			}
			else
			{
				Ghost_X = 72;
				Ghost_Y = 64;
				GoPath = Rand(1, 5);
				if (GoPath == 0) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 0) GoPath = 0;
			}
		}
		else if (GoPath == 5)
		{
			if (Distance (Ghost_X, Ghost_Y, 168, 64) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 168, 64), 1, 4);
			}
			else
			{
				Ghost_X = 168;
				Ghost_Y = 64;
				GoPath = Rand(1, 5);
				if (GoPath == 5) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 5) GoPath = 0;
			}
		}
		else if (GoPath == 1)
		{
			if (Distance (Ghost_X, Ghost_Y, 96, 72) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 96, 72), 1, 4);
			}
			else
			{
				Ghost_X = 96;
				Ghost_Y = 72;
				GoPath = Rand(1, 5);
				if (GoPath == 1) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 1) GoPath = 0;
			}
		}
		else if (GoPath == 4)
		{
			if (Distance (Ghost_X, Ghost_Y, 144, 72) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 144, 72), 1, 4);
			}
			else
			{
				Ghost_X = 144;
				Ghost_Y = 72;
				GoPath = Rand(1, 5);
				if (GoPath == 4) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 4) GoPath = 0;
			}
		}
		else
		{
			if (Distance (Ghost_X, Ghost_Y, 120, 80) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 80), 1, 4);
			}
			else
			{
				Ghost_X = 120;
				Ghost_Y = 80;
				GoPath = Rand(1, 5);
				if (GoPath == 3) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 3) GoPath = 0;
			}
		}
		return GoPath;
	}
	int GohmaMove2 (npc ghost, ffc this, int GoPath)
	{
		Ghost_Dir = DIR_DOWN;
		this->InitD[3] = 0;
		int fakepath = GoPath;
		if (GoPath == 2)
		{
			if (Distance (Ghost_X, Ghost_Y, 120, 48) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 48), 1, 4);
			}
			else
			{
				Ghost_X = 120;
				Ghost_Y = 48;
				GoPath = Rand(1, 5);
				if (GoPath == 2) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 2) GoPath = 0;
			}
		}
		else if (GoPath == 0)
		{
			if (Distance (Ghost_X, Ghost_Y, 72, 48) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 72, 48), 1, 4);
			}
			else
			{
				Ghost_X = 72;
				Ghost_Y = 48;
				GoPath = Rand(1, 5);
				if (GoPath == 0) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 0) GoPath = 0;
			}
		}
		else if (GoPath == 5)
		{
			if (Distance (Ghost_X, Ghost_Y, 168, 48) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 168, 48), 1, 4);
			}
			else
			{
				Ghost_X = 168;
				Ghost_Y = 48;
				GoPath = Rand(1, 5);
				if (GoPath == 5) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 5) GoPath = 0;
			}
		}
		else if (GoPath == 1)
		{
			if (Distance (Ghost_X, Ghost_Y, 96, 56) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 96, 56), 1, 4);
			}
			else
			{
				Ghost_X = 96;
				Ghost_Y = 56;
				GoPath = Rand(1, 5);
				if (GoPath == 1) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 1) GoPath = 0;
			}
		}
		else if (GoPath == 4)
		{
			if (Distance (Ghost_X, Ghost_Y, 144, 56) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 144, 56), 1, 4);
			}
			else
			{
				Ghost_X = 144;
				Ghost_Y = 56;
				GoPath = Rand(1, 5);
				if (GoPath == 4) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 4) GoPath = 0;
			}
		}
		else
		{
			if (Distance (Ghost_X, Ghost_Y, 120, 56) > 1)
			{
				Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 56), 1, 4);
			}
			else
			{
				Ghost_X = 120;
				Ghost_Y = 56;
				GoPath = Rand(1, 5);
				if (GoPath == 3) GoPath = 0;
				while (Link->X < Ghost_X && GoPath > fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				while (Link->Y > Ghost_Y && GoPath < fakepath && fakepath != 0 && fakepath != 5) GoPath = Rand(1, 5);
				if (GoPath == 3) GoPath = 0;
			}
		}
		return GoPath;
	}
	int GohmaMove3 (npc ghost, ffc this, int GoPath, int StayCounter)
	{
		Ghost_Dir = DIR_DOWN;
		if (StayCounter[0] > 0) 
		{
			StayCounter[0]--;
			this->InitD[3] = 1;
		}
		else
		{
			this->InitD[3] = 0;
			if (GoPath == 0)
			{
				if (Distance (Ghost_X, Ghost_Y, 120, 48) > 1)
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 48), 1, 4);
				}
				else
				{
					Ghost_X = 120;
					Ghost_Y = 48;
					GoPath = Rand(1, 5);
					StayCounter[0] = 45;
				}
			}
			else if (GoPath == 1)
			{
				if (Distance (Ghost_X, Ghost_Y, 72, 64) > 1)
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 72, 64), 1, 4);
				}
				else
				{
					Ghost_X = 72;
					Ghost_Y = 64;
					GoPath = Rand(1, 5);
					if (GoPath == 1) GoPath = 0;
					StayCounter[0] = 45;
				}
			}
			else if (GoPath == 2)
			{
				if (Distance (Ghost_X, Ghost_Y, 168, 64) > 1)
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 168, 64), 1, 4);
				}
				else
				{
					Ghost_X = 168;
					Ghost_Y = 64;
					GoPath = Rand(1, 5);
					if (GoPath == 2) GoPath = 0;
					StayCounter[0] = 45;
				}
			}
			else if (GoPath == 3)
			{
				if (Distance (Ghost_X, Ghost_Y, 96, 72) > 1)
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 96, 72), 1, 4);
				}
				else
				{
					Ghost_X = 96;
					Ghost_Y = 72;
					GoPath = Rand(1, 5);
					if (GoPath == 3) GoPath = 0;
					StayCounter[0] = 45;
				}
			}
			else if (GoPath == 4)
			{
				if (Distance (Ghost_X, Ghost_Y, 144, 72) > 1)
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 144, 72), 1, 4);
				}
				else
				{
					Ghost_X = 144;
					Ghost_Y = 72;
					GoPath = Rand(1, 5);
					if (GoPath == 4) GoPath = 0;
					StayCounter[0] = 45;
				}
			}
			else
			{
				if (Distance (Ghost_X, Ghost_Y, 120, 80) > 1)
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 80), 1, 4);
				}
				else
				{
					Ghost_X = 120;
					Ghost_Y = 80;
					GoPath = Rand(0, 4);
					StayCounter[0] = 45;
				}
			}
		}
		return GoPath;
	}
}

ffc script GohmaLeg
{

	void run(int enemyID)
	{
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		ffc Great;
		for (int i = 1; i <= 32; i++)
		{
			Great = Screen->LoadFFC(i);
			if (Great->InitD[1] == 2) break;
		}
		npc GohmaBody = Screen->LoadNPC(Great->InitD[2]);
		Ghost_CSet = Great->CSet;
		int WalkData = Ghost_Data;
		int StopData = Ghost_Data + 1;
		int ChargeData = Ghost_Data + 2;
		int GrabR1Data = Ghost_Data + 3;
		int GrabR2Data = Ghost_Data + 4;
		int GrabL1Data = Ghost_Data + 5;
		int GrabL2Data = Ghost_Data + 6;
		int JumpData = Ghost_Data + 7;
		bool Lefty = false;
		if (Ghost_HP == 105) Lefty = true;
		Ghost_SetHitOffsets(ghost, 0, 2, 4, 4);
		while(true)
		{
			Ghost_CSet = Great->CSet;
			if (Great->InitD[3] == 0 && Ghost_Data != WalkData) Ghost_Data = WalkData;
			if (Great->InitD[3] == 1 && Ghost_Data != StopData) Ghost_Data = StopData;
			if (Great->InitD[3] == 2 && Ghost_Data != ChargeData) Ghost_Data = ChargeData;
			if (Great->InitD[3] == 3 && Ghost_Data != GrabR1Data) Ghost_Data = GrabR1Data;
			if (Great->InitD[3] == 4 && Ghost_Data != GrabR2Data) Ghost_Data = GrabR2Data;
			if (Great->InitD[3] == 5 && Ghost_Data != GrabL1Data) Ghost_Data = GrabL1Data;
			if (Great->InitD[3] == 6 && Ghost_Data != GrabL2Data) Ghost_Data = GrabL2Data;
			if (Great->InitD[3] == 7 && Ghost_Data != JumpData) Ghost_Data = JumpData;
			GohmaWait(this, ghost, GohmaBody, Lefty);
		}
	}
	void GohmaWait(ffc this, npc ghost, npc Body, bool Lefty)
	{
		if (Lefty) 
		{
			Ghost_X = Body->X - 16;
			Ghost_Y = Body->Y;
			Ghost_Z = Body->Z;
		}
		else 
		{
			Ghost_X = Body->X + 16;
			Ghost_Y = Body->Y;
			Ghost_Z = Body->Z;
		}
		Ghost_Waitframe(this, ghost, true, true);
	}
}

ffc script GohmaTop
{

	void run(int enemyID)
	{
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		ffc Great;
		for (int i = 1; i <= 32; i++)
		{
			Great = Screen->LoadFFC(i);
			if (Great->InitD[1] == 2) break;
		}
		npc GohmaBody = Screen->LoadNPC(Great->InitD[2]);
		int WalkData = Ghost_Data;
		int StopData = Ghost_Data + 1;
		int ChargeData = Ghost_Data + 2;
		Ghost_CSet = Great->CSet;
		Ghost_SetSize(this, ghost, 3, 1);
		Ghost_SetHitOffsets(ghost, 0, 0, 4, 4);
		while(true)
		{
			Ghost_CSet = Great->CSet;
			if (Great->InitD[3] == 0 && Ghost_Data != WalkData) Ghost_Data = WalkData;
			if (Great->InitD[3] == 1 && Ghost_Data != StopData) Ghost_Data = StopData;
			if (Great->InitD[3] == 2 && Ghost_Data != ChargeData) Ghost_Data = ChargeData;
			GohmaWait(this, ghost, GohmaBody);
		}
	}
	void GohmaWait(ffc this, npc ghost, npc Body)
	{
		Ghost_X = Body->X - 16;
		Ghost_Y = Body->Y - 16;
		Ghost_Z = Body->Z;
		Ghost_Waitframe(this, ghost, true, true);
	}
}

float Choose(float a, float b, float c, float d, float e, float f, float g) {
  int r = Rand(7);
  if (r==0) return a;
  else if (r==1) return b;
  else if (r==2) return c;
  else if (r==3) return d;
  else if (r==4) return e;
  else if (r==5) return f;
  else return g;
}

float Choose(float a, float b, float c, float d, float e, float f, float g, float h) {
  int r = Rand(8);
  if (r==0) return a;
  else if (r==1) return b;
  else if (r==2) return c;
  else if (r==3) return d;
  else if (r==4) return e;
  else if (r==5) return f;
  else if (r==6) return g;
  else return h;
}

ffc script Armos_Gohma
{
	void run(int enemyID)
	{
		 npc ghost;
		 float step;
		 int jumpSound;
		
		 // Initialize - come to life and set the combo
		 ghost=Ghost_InitAutoGhost(this, enemyID);
		 Ghost_SetFlag(GHF_NORMAL);
		 Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		 Ghost_SetFlag(GHF_SET_OVERLAY);
		 Game->PlaySound(ghost->Attributes[ARMOS_ATTR_START_SOUND]);
		
		 step=ghost->Step/100;
		 jumpSound=ghost->Attributes[ARMOS_ATTR_JUMP_SOUND];
		
		 // Just jump toward Link forever
		 while (Ghost_Z > 0)
		 {
			Ghost_Waitframe(this, ghost, true, true);
		 }
		 Ghost_SetFlag(GHF_FAKE_Z);
		 while(true)
		 {
			 if(Ghost_Z==0 && Ghost_Jump<=0)
			 {
				 Ghost_Jump=ARMOS_JUMP_HEIGHT;
				 Game->PlaySound(jumpSound);
			 }
			
			 Ghost_MoveTowardLink(step, 3);
			 Ghost_Waitframe(this, ghost, true, true);
		 }
	}
}