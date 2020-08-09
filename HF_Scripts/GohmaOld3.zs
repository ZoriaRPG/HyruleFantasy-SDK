//import "std.zh"
//import "string.zh"
//import "ghost.zh"
//import "ffcscript.zh"
//import "stdExtra.zh"

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
		Ghost_CSet = ghost->Attributes[9];
		int MaxHP = Ghost_HP;
		int GohmaData = Ghost_Data;
		int EyeData = Ghost_Data + 1;
		
		Ghost_SetHitOffsets(ghost, 0, -4, -4, -4);
		
		bool Left;
		if (Rand(1,2) < 2) Left = true;
		else Left = false;
		int GohmaCounter = Rand (150, 210);
		int LaserCounter = 3;
		int Store[18];
		Ghost_StoreDefenses(ghost, Store);
		Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
		ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
		while(true)
		{
			GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
			Left = GohmaMove (ghost, this, Left);
			GohmaCounter--;
			if (GohmaCounter <= 0)
			{
				for (int k = 0; k < 225; k++)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					Left = GohmaMove (ghost, this, Left);
					if (k % 45 == 0)
					{
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 150, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 200, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 300, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 350, ghost->WeaponDamage, SPRITE_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					}
				}
				for (int k = 90; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					Left = GohmaMove (ghost, this, Left);
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
			
			if (Ghost_HP < ((MaxHP / 3) * 2) && GohmaCounter % 45 == 0 && ((Rand (1, 3) < 2 && (Screen->NumNPCs() - NumNPCsOf(280)) <= 3) || (Rand (1, 9) < 2 && (Screen->NumNPCs() - NumNPCsOf(280)) > 3)))
			{
				this->InitD[3] = 2;
				for (int k = 45; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				int Angular = Angle (Ghost_X, Ghost_Y, Link->X, Link->Y);
				while(!(Screen->isSolid(Ghost_X - 18, Ghost_Y + 8) || Ghost_X - 18 <= 0) && !(Screen->isSolid(Ghost_X + 34, Ghost_Y + 8) || Ghost_X + 34 >= 255)
				&& !(Screen->isSolid(Ghost_X + 8, Ghost_Y - 2) || Ghost_Y -2 <= 0) && !(Screen->isSolid(Ghost_X + 8, Ghost_Y + 18) || Ghost_Y + 18 >= 175))
				{
					if (Sign(angleDifference(DegtoRad(Angular), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) > 0) Angular+=0.4;
					if (Sign(angleDifference(DegtoRad(Angular), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) < 0) Angular-=0.4;
					Ghost_MoveAtAngle(Angular, 2, 4);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				Screen->Quake = 4;
				Game->PlaySound(SFX_BOMB);
				Ghost_Jump = 1;
				this->InitD[3] = 1;
				GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				while (Ghost_Z > 0)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					Ghost_MoveAtAngle(Angular + 180, 1, 4);
					Screen->Quake = 4;
				}
				for (int k = 45; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
					Left = GohmaMove (ghost, this, Left);
					if (Ghost_Y < 48) Ghost_Move(DIR_DOWN, 1, 4);
					if (Ghost_Y > 48) Ghost_Move(DIR_UP, 1, 4);
					Screen->Quake = 4;
					if (k % 15 == 0)
					{
						if ((Screen->NumNPCs() - NumNPCsOf(280)) < 6)
						{
							npc Fall;
							if (NumNPCsOf(280) < 2) Fall = SpawnNPC(Choose(290, 288, 303, 53, 91, 52, 280));
							else Fall = SpawnNPC(Choose(290, 288, 303, 53, 91, 52));
							if (Fall->ID == 288 || Fall->ID == 290)
							{
								Fall->WeaponDamage /= 2;
								Fall->HP /= 4;
							}
							Fall->X = Clamp(Fall->X, 48, 192);
							Fall->Z = 100;
						}
						else
						{
							eweapon Fall = FireEWeapon(EW_FIREBALL, Rand(48, 192), Rand(32, 128), 0, 0, 0, SPRITE_BOMB, 0, EWF_NO_COLLISION|EWF_SHADOW);
							SetEWeaponMovement(Fall, EWM_FALL, 100, EWMF_DIE);
							SetEWeaponDeathEffect(Fall, EWD_EXPLODE, ghost->WeaponDamage * 2);
						}
						Game->PlaySound(SFX_FALL);
					}
				}
				this->InitD[3] = 0;
				while (Ghost_Y < 48)
				{
					Ghost_Move(DIR_DOWN, 1, 4);
					Left = GohmaMove (ghost, this, Left);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
				while (Ghost_Y > 48)
				{
					Ghost_Move(DIR_UP, 1, 4);
					Left = GohmaMove (ghost, this, Left);
					GohmaWait(ghost, this, Legs1, Legs2, GohmaData, EyeData);
				}
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
	bool GohmaMove (npc ghost, ffc this, bool Left)
	{
		Ghost_Dir = DIR_DOWN;
		if (Left)
		{
			Ghost_Move(DIR_LEFT, 1, 4);
			if (Ghost_X <= 72) Left = false;
		}
		else
		{
			Ghost_Move(DIR_RIGHT, 1, 4);
			if (Ghost_X >= 168) Left = true;
		}
		return Left;
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
		bool Lefty = false;
		if (Ghost_HP == 105) Lefty = true;
		Ghost_SetHitOffsets(ghost, 0, 2, 4, 4);
		while(true)
		{
			Ghost_CSet = Great->CSet;
			if (Great->InitD[3] == 0 && Ghost_Data != WalkData) Ghost_Data = WalkData;
			if (Great->InitD[3] == 1 && Ghost_Data != StopData) Ghost_Data = StopData;
			if (Great->InitD[3] == 2 && Ghost_Data != ChargeData) Ghost_Data = ChargeData;
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