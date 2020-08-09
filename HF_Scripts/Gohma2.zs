//import "std.zh"
//import "string.zh"
//import "ghost.zh"
//import "ffcscript.zh"
//import "stdExtra.zh"

const int DARK_SPRITE = 94;
const int DARK_ORIG_TILE = 15405;
const int BOSS_MIDI = 36;
const int BURST_SPRITE = 96;
const int PARTICLE_SPRITE = 97;

ffc script Armogohma2
{
	
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		int Ghosty = 0;
		npc FallNPC = NULL;
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
		this->InitD[1] = 1;
		this->InitD[2] = Ghosty;
		this->InitD[3] = 1;
		npc Legs1 = CreateNPCAt(ghost->Attributes[0], Ghost_X - 15, Ghost_Y);
		npc Legs2 = CreateNPCAt(ghost->Attributes[1], Ghost_X + 15, Ghost_Y);
		CreateNPCAt(ghost->Attributes[2], Ghost_X - 16, Ghost_Y - 16);
		Legs1->HP = 105;
		Ghost_CSet = ghost->Attributes[8];
		int MaxHP = Ghost_HP;
		int GohmaData = Ghost_Data;
		int EyeData = Ghost_Data + 1;
		
		Game->PlayMIDI(0);
		
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
		
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		
		int Circled = 0;
		
		for (int i = 0; i < 180 || Screen->NumEWeapons() > 0; i++)
		{
			if (i % 12 == 0 && i < 180)
			{
				int Meh1X = VectorX(Rand(24,40), Rand(1, 360));
				int Meh1Y = VectorY(Rand(24,40), Rand(1, 360));
				eweapon Meh1 = FireEWeapon(EW_FIREBALL, Ghost_X + Meh1X, Ghost_Y + Meh1Y, DegtoRad(Angle(Ghost_X + Meh1X, Ghost_Y + Meh1Y, Ghost_X, Ghost_Y)), 100, 0, PARTICLE_SPRITE, SFX_CHARGE1, EWF_NO_COLLISION);
				int Meh2X = VectorX(Rand(24,40), Rand(1, 360));
				int Meh2Y = VectorY(Rand(24,40), Rand(1, 360));
				eweapon Meh2 = FireEWeapon(EW_FIREBALL, Ghost_X + Meh2X, Ghost_Y + Meh2Y, DegtoRad(Angle(Ghost_X + Meh2X, Ghost_Y + Meh2Y, Ghost_X, Ghost_Y)), 100, 0, PARTICLE_SPRITE, SFX_CHARGE1, EWF_NO_COLLISION);
			}
			for (int k = Screen->NumEWeapons(); k > 0; k--)
			{
				eweapon Meh = Screen->LoadEWeapon(k);
				if (Meh->ID == EW_FIREBALL)
				{
					Meh->Angle = DegtoRad(Angle(Meh->X, Meh->Y, Ghost_X, Ghost_Y));
					if (Distance(Meh->X, Meh->Y, Ghost_X, Ghost_Y) <= 10)
					{
						Remove(Meh);
						Circled++;
					}
				}
			}
			Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, Circled / 3, 0x95, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 2) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 2, 0x94, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 4) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 4, 0x93, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 6) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 4, 0x91, 3, 0, 0, 0, true, OP_OPAQUE);
			GohmaWait(ghost, this, Legs1, Legs2);
		}
		for (int i = 0; i < 120; i++)
		{
			Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, Circled / 3, 0x95, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 2) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 2, 0x94, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 4) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 4, 0x93, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 6) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 4, 0x91, 3, 0, 0, 0, true, OP_OPAQUE);
			GohmaWait(ghost, this, Legs1, Legs2);
		}
		for (; Circled > 8; Circled-=2)
		{
			Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, Circled / 3, 0x95, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 2) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 2, 0x94, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 4) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 4, 0x93, 3, 0, 0, 0, true, OP_OPAQUE);
			if (Circled > 6) Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (Circled / 3) - 4, 0x91, 3, 0, 0, 0, true, OP_OPAQUE);
			GohmaWait(ghost, this, Legs1, Legs2);
		}
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(0), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(45), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(135), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(180), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(225), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(270), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(315), 300, 0, BURST_SPRITE, SFX_FIREBALL, EWF_NO_COLLISION);
		Ghost_CSet = ghost->Attributes[9];
		int Arg[8];
		Arg[0] = BOSS_MIDI;
		Arg[1] = 12;
		RunFFCScript(1, Arg);
		for (int k = 0; k < 90; k++)
		{
			GohmaWait(ghost, this, Legs1, Legs2);
		}
		this->InitD[3] = 0;
		while(this->InitD[4] != 1)
		{
			GohmaWait(ghost, this, Legs1, Legs2);
			Left = GohmaMove (ghost, this, Left);
			GohmaCounter--;
			if (GohmaCounter <= 0)
			{
				for (int k = 0; (k < 225 && Ghost_HP > (MaxHP / 3)) || (k < 285 && Ghost_HP <= (MaxHP / 3)); k++)
				{
					GohmaWait(ghost, this, Legs1, Legs2);
					if (Ghost_HP > (MaxHP / 3)) Left = GohmaMove (ghost, this, Left);
					if (Ghost_HP > (MaxHP / 3))
					{
						if (k % 45 == 0)
						{
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
							FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						}
					}
					else
					{
						if (k % 120 == 0)
						{
							eweapon Fire1 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 200, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire2 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 225, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire3 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire4 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 275, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire5 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 300, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
						
							eweapon Fire6 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 200, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire7 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 225, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire8 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 250, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire9 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 275, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire10 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.6, 300, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
						
							eweapon Fire11 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 200, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire12 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 225, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire13 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 250, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire14 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 275, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							eweapon Fire15 = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.6, 300, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
							
							Fire1->Misc[0] = 2;
							Fire2->Misc[0] = 2; 
							Fire3->Misc[0] = 2; 
							Fire4->Misc[0] = 2; 
							Fire5->Misc[0] = 2;
							Fire6->Misc[0] = 2;
							Fire7->Misc[0] = 2;
							Fire8->Misc[0] = 2;
							Fire9->Misc[0] = 2;
							Fire10->Misc[0] = 2;
							Fire11->Misc[0] = 2;
							Fire12->Misc[0] = 2;
							Fire13->Misc[0] = 2;
							Fire14->Misc[0] = 2;
							Fire15->Misc[0] = 2;
						}
					}
				}
				for (int k = 90; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2);
					Left = GohmaMove (ghost, this, Left);
					Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (k % 30), 12, 3, 0, 0, 0, false, OP_OPAQUE);
					if (k == 20) Game->PlaySound(77);
				}
				int LaserX = Ghost_X + 8;
				int LaserY = Ghost_Y + 16;
				int LaserX2[30] = {Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, 
				Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, 
				Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, 
				Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8};
				int LaserY2[30] = {Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, 
				Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, 
				Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, 
				Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16};
				int LaserX3[30] = {Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, 
				Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, 
				Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, 
				Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8, Ghost_X + 8};
				int LaserY3[30] = {Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, 
				Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, 
				Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, 
				Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16};
				int LaserAngle = 90;
				bool LeftLaser = false;
				Ghost_Data = EyeData;
				this->InitD[3] = 1;
				int BoomCounter = 0;
				int WaitCounter = 30;
				if (Link->X < Ghost_X) LeftLaser = true;
				Ghost_SetDefenses(ghost, Store);
				while ((LaserY < 144 && LaserX > 32 && LaserX < 224) || (LaserY2[29] < 144 && LaserX2[29] > 32 && LaserX2[29] < 224) || (LaserY3[29] < 144 && LaserX3[29] > 32 && LaserX3[29] < 224))
				{
					GohmaWait(ghost, this, Legs1, Legs2);
					if (this->InitD[4] == 1) Ghost_Data = GohmaData;
					BoomCounter++;
					BoomCounter%=4;
					if (LaserY < 144 && LaserX > 32 && LaserX < 224)
					{
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
					if (WaitCounter > 0) WaitCounter--;
					if (LaserY2[0] < 144 && LaserX2[0] > 32 && LaserX2[0] < 224)
					{
						LaserX2[0] += VectorX(3, LaserAngle + 35);
						LaserY2[0] += VectorY(3, LaserAngle + 35);
					}
					if (LaserY2[29] < 144 && LaserX2[29] > 32 && LaserX2[29] < 224)
					{
						for (int i = 29; i > 0; i--)
						{
							LaserX2[i] = LaserX2[i - 1];
							LaserY2[i] = LaserY2[i - 1];
						}
						if (WaitCounter <= 0)
						{
							if (BoomCounter == 3)
							{
								eweapon Hey = FireAimedEWeapon(EW_FIRE, LaserX2[29] - 8 + Rand(-2, 2), LaserY2[29] - 8 + Rand(-2, 2), 0, 0, 0, 80, 0, EWF_NO_COLLISION);
								SetEWeaponLifespan(Hey, EWL_TIMER, 30);
								SetEWeaponDeathEffect(Hey, EWD_EXPLODE, ghost->WeaponDamage * 2);
							}
							if (BoomCounter%2 == 0)
							{					
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX2[29], LaserY2[29], 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX2[29] - 1, LaserY2[29], 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX2[29], LaserY2[29] - 1, 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX2[29] + 1, LaserY2[29], 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX2[29], LaserY2[29] + 1, 12, 1, 0, 0, 0, OP_OPAQUE);
							}
							else
							{
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX2[29], LaserY2[29], 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX2[29] - 1, LaserY2[29], 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX2[29], LaserY2[29] - 1, 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX2[29] + 1, LaserY2[29], 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX2[29], LaserY2[29] + 1, 11, 1, 0, 0, 0, OP_OPAQUE);
							}
						}
					}
					if (LaserY3[0] < 144 && LaserX3[0] > 32 && LaserX3[0] < 224)
					{
						LaserX3[0] += VectorX(3, LaserAngle - 35);
						LaserY3[0] += VectorY(3, LaserAngle - 35); 
					}
					if (LaserY3[29] < 144 && LaserX3[29] > 32 && LaserX3[29] < 224)
					{
						for (int i = 29; i > 0; i--)
						{
							LaserX3[i] = LaserX3[i - 1];
							LaserY3[i] = LaserY3[i - 1];
						}
						if (WaitCounter <= 0)
						{
							if (BoomCounter == 3)
							{
								eweapon Hey = FireAimedEWeapon(EW_FIRE, LaserX3[29] - 8 + Rand(-2, 2), LaserY3[29] - 8 + Rand(-2, 2), 0, 0, 0, 80, 0, EWF_NO_COLLISION);
								SetEWeaponLifespan(Hey, EWL_TIMER, 30);
								SetEWeaponDeathEffect(Hey, EWD_EXPLODE, ghost->WeaponDamage * 2);
							}
							if (BoomCounter%2 == 0)
							{					
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX3[29], LaserY3[29], 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX3[29] - 1, LaserY3[29], 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX3[29], LaserY3[29] - 1, 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX3[29] + 1, LaserY3[29], 12, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX3[29], LaserY3[29] + 1, 12, 1, 0, 0, 0, OP_OPAQUE);
							}
							else
							{
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 8, LaserX3[29], LaserY3[29], 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 7, Ghost_Y + 8, LaserX3[29] - 1, LaserY3[29], 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 7, LaserX3[29], LaserY3[29] - 1, 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 9, Ghost_Y + 8, LaserX3[29] + 1, LaserY3[29], 11, 1, 0, 0, 0, OP_OPAQUE);
								Screen->Line(3, Ghost_X + 8, Ghost_Y + 9, LaserX3[29], LaserY3[29] + 1, 11, 1, 0, 0, 0, OP_OPAQUE);
							}
						}
					}
					if (BoomCounter%8 == 0) Game->PlaySound(76);
				}
				for (int k = 150; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2);
					if (this->InitD[4] == 1) Ghost_Data = GohmaData;
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
					GohmaWait(ghost, this, Legs1, Legs2);
				}
				int Angular = Angle (Ghost_X, Ghost_Y, Link->X, Link->Y);
				while(!(Screen->isSolid(Ghost_X - 18, Ghost_Y + 8) || Ghost_X - 18 <= 0) && !(Screen->isSolid(Ghost_X + 34, Ghost_Y + 8) || Ghost_X + 34 >= 255)
				&& !(Screen->isSolid(Ghost_X + 8, Ghost_Y - 2) || Ghost_Y -2 <= 0) && !(Screen->isSolid(Ghost_X + 8, Ghost_Y + 18) || Ghost_Y + 18 >= 175))
				{
					if (Sign(angleDifference(DegtoRad(Angular), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) > 0) Angular+=0.4;
					if (Sign(angleDifference(DegtoRad(Angular), DegtoRad(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)))) < 0) Angular-=0.4;
					Ghost_MoveAtAngle(Angular, 2, 4);
					GohmaWait(ghost, this, Legs1, Legs2);
				}
				Screen->Quake = 4;
				Game->PlaySound(SFX_BOMB);
				Ghost_Jump = 1;
				this->InitD[3] = 1;
				GohmaWait(ghost, this, Legs1, Legs2);
				while (Ghost_Z > 0)
				{
					GohmaWait(ghost, this, Legs1, Legs2);
					Ghost_MoveAtAngle(Angular + 180, 1, 4);
					Screen->Quake = 4;
				}
				this->InitD[3] = 0;
				for (int k = 45; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2);
					Left = GohmaMove (ghost, this, Left);
					if (Ghost_Y < 48) Ghost_Move(DIR_DOWN, 1, 4);
					if (Ghost_Y > 48) Ghost_Move(DIR_UP, 1, 4);
					Screen->Quake = 4;
					if (k % 15 == 0)
					{
						if ((Screen->NumNPCs() - NumNPCsOf(280) + NumNPCsOf(294) + NumNPCsOf(295)) < 6)
						{
							if (Link->HP <= 48) FallNPC = SpawnNPC(Choose(289, 289, 289, 303, 303, 304));
							else
							{
								if (Screen->NumNPCs() < 5 && Link->HP > 80) FallNPC = SpawnNPC(Choose(294, 295, 303, 289, 289, 53, 261));
								else FallNPC = SpawnNPC(Choose(303, 289, 289, 53, 261));
							}
							if (FallNPC->ID == 294 || FallNPC->ID == 295)
							{
								FallNPC->WeaponDamage /= 2;
								FallNPC->HP /= 4;
							}
							if (FallNPC->ID == 53)
							{
								FallNPC->HP /= 3;
							}
							FallNPC->Z = 100;
						}
						else
						{
							eweapon Fall = FireEWeapon(EW_FIREBALL, Rand(48, 192), Rand(32, 128), 0, 0, 0, SP_BOMB, 0, EWF_NO_COLLISION|EWF_SHADOW);
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
					GohmaWait(ghost, this, Legs1, Legs2);
				}
				while (Ghost_Y > 48)
				{
					Ghost_Move(DIR_UP, 1, 4);
					Left = GohmaMove (ghost, this, Left);
					GohmaWait(ghost, this, Legs1, Legs2);
				}
			}
		}
		Ghost_HP = MaxHP;
		//120, 72
		while (Floor(Ghost_X) != 120 && Floor(Ghost_Y) != 72)
		{
			Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, 120, 72), 1, 4);
			Gohma2Wait(ghost, this, Legs1, Legs2);
		}
		this->InitD[3] = 1;
		for (int k = 45; k > 0; k--)
		{
			Gohma2Wait(ghost, this, Legs1, Legs2);
		}
		int Angulared = 0;
		for (int k = 240; k > 0; k--)
		{
			Angulared += 1.5;
			Angulared%=360;
			if (k % 4 == 0)
			{
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(Angulared), 300, 0, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad((Angulared + 90) % 360), 300, 0, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad((Angulared + 180) % 360), 300, 0, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad((Angulared + 270) % 360), 300, 0, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
			}
			Gohma2Wait(ghost, this, Legs1, Legs2);
		}
		Ghost_StartFlashing();
		Game->PlaySound(SFX_CHARGE1);
		this->InitD[3] = 0;
		for (int k = 90; k > 0; k--)
		{
			Ghost_Move(DIR_UP, 0.35, 4);
			Gohma2Wait(ghost, this, Legs1, Legs2);
		}
		this->InitD[3] = 2;
		for (int k = 30; k > 0; k--)
		{
			//Ghost_Move(DIR_UP, 0.35, 4);
			Gohma2Wait(ghost, this, Legs1, Legs2);
		}
		while(!(Screen->isSolid(Ghost_X + 8, Ghost_Y + 18) || Ghost_Y + 18 >= 175))
		{
			Ghost_Move(DIR_DOWN, 2, 4);
			Gohma2Wait(ghost, this, Legs1, Legs2);
		}
		int Args[8];
		Args[0] = 7;
		int Scrolled = RunFFCScript(38, Args);
		ffc Scroll = Screen->LoadFFC(Scrolled);
		Scroll->Flags[FFCF_IGNOREHOLDUP] = true;
		Scroll->Flags[FFCF_PRELOAD] = true;
		Screen->Quake = 4;
		Game->PlaySound(SFX_BOMB);
		Ghost_Jump = 1;
		this->InitD[3] = 1;
		Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
		while (Ghost_Z > 0)
		{
			Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
			Ghost_Move(DIR_UP, 1, 4);
			Screen->Quake = 4;
		}
		for (int k = 4; k > 0; k--)
		{
			npc Fall;
			if (Link->HP > (Link->MaxHP / 2)) Fall = SpawnNPC(Choose(303, 289));
			else Fall = SpawnNPC(303);
			Fall->Z = 100;
		}
		for (int k = 300; k > 0; k--)
		{
			Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
		}
		this->InitD[3] = 0;
		while(Ghost_Y > 16)
		{
			Ghost_Y--;
			Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
		}
		for (int k = 180; k > 0; k--)
		{
			Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
		}
		GohmaCounter = Rand(150, 210);
		while(true)
		{
			GohmaCounter--;
			//Trace(GohmaCounter);
			if (GohmaCounter <= 0)
			{
				bool goingleft = true;
				//Trace(901);
				if (Rand(1, 2) < 2) goingleft = false;
				if (goingleft)
				{
					//Trace(902);
					while(Ghost_X > 96)
					{
						Ghost_Move(DIR_LEFT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(903);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(904);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					//Trace(904);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(905);
					while(Ghost_X < 112)
					{
						Ghost_Move(DIR_RIGHT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(906);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(907);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(908);
					while(Ghost_X < 128)
					{
						Ghost_Move(DIR_RIGHT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(909);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(910);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(911);
					while(Ghost_X < 144)
					{
						Ghost_Move(DIR_RIGHT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(912);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(913);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(914);
				}
				else
				{
					//Trace(952);
					while(Ghost_X < 144)
					{
						Ghost_Move(DIR_RIGHT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
						//Trace(953);
					}
					//Trace(953);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(954);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(955);
					while(Ghost_X > 128)
					{
						Ghost_Move(DIR_LEFT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(956);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(957);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(958);
					while(Ghost_X > 112)
					{
						Ghost_Move(DIR_LEFT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(959);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(960);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(961);
					while(Ghost_X  > 96)
					{
						Ghost_Move(DIR_LEFT, 1, 4);
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(962);
					for (int k = 30; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(963);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 150, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 300, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, DegtoRad(90), 350, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 15; k > 0; k--)
					{
						Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					}
					//Trace(964);
				}
				//Trace(1000);
				for (int k = 90; k > 0; k--)
				{
					GohmaWait(ghost, this, Legs1, Legs2);
					Screen->Circle(3, Ghost_X + 8, Ghost_Y + 8, (k % 30), 12, 3, 0, 0, 0, false, OP_OPAQUE);
					if (k == 20) Game->PlaySound(77);
				}
				//Trace(1001);
				int LaserX = Ghost_X + 8;
				int LaserY = Ghost_Y + 16;
				int LaserAngle = 90;
				bool LeftLaser = false;
				Ghost_Data = EyeData;
				int BoomCounter = 0;
				if (Link->X < Ghost_X) LeftLaser = true;
				Ghost_SetDefenses(ghost, Store);
				while (LaserY < 144 && LaserX > 32 && LaserX < 224)
				{
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
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
				for (int k = 180; k > 0; k--)
				{
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
				}
				Ghost_Data = GohmaData;
				Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
				ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
				GohmaCounter = Rand(150, 210);
				Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
			}
			if (GohmaCounter % 45 == 0 && Rand(1,3) < 2 && Ghost_HP <= MaxHP)
			{
				while(Ghost_X < 120)
				{
					Ghost_Move(DIR_RIGHT, 1, 4);
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
				}
				while(Ghost_X > 120)
				{
					Ghost_Move(DIR_LEFT, 1, 4);
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
				}
				for (int k = 30; k > 0; k--)
				{
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
				}
				int BounceAngle = DegtoRad(Choose(135,45));
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 200, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 225, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 250, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 275, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 300, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				for (int k = 30; k > 0; k--)
				{
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
				}
				if (BounceAngle == 45) BounceAngle = 135;
				else BounceAngle = 45;
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 200, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 225, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 250, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 275, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, BounceAngle, 300, ghost->WeaponDamage, DARK_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE);
			}
			else if (GohmaCounter % 45 == 0 && Rand(1,3) < 2 && Ghost_HP <= MaxHP)
			{
				Ghost_Data = EyeData;
				Ghost_SetDefenses(ghost, Store);
				for (int k = 90; k > 0; k--)
				{
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
					if (k % 30 == 0)
					{
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0.8, 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
						FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, -0.8, 200, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					}
				}
				for (int k = 60; k > 0; k--)
				{
					Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
				}
				Ghost_Data = GohmaData;
				Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
				ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
			}
			Gohma3Wait(ghost, this, Legs1, Legs2, Scroll);
		}
	}
	void Gohma2Wait(npc ghost, ffc this, npc Legs1, npc Legs2)
	{
		Legs1->X = Ghost_X - 15;
		Legs2->X = Ghost_X + 15;
		Legs1->Y = Ghost_Y;
		Legs2->Y = Ghost_Y;
		
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		
		HandleWeapons();
		
		if (!Ghost_Waitframe(this, ghost, false, false))
		{
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon Ctrl_Alt_Dlt = Screen->LoadEWeapon(i);
				Remove(Ctrl_Alt_Dlt);
			}
			for (int i = Screen->NumNPCs(); i > 3; i--)
			{
				npc Head = Screen->LoadNPC(i);
				Head->HP = 0;
			}
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			for (int i = Screen->NumNPCs(); i > 0; i--)
			{
				npc Head = Screen->LoadNPC(i);
				Head->HP = 0;
			}
			Quit();
		}
	}
	void Gohma3Wait(npc ghost, ffc this, npc Legs1, npc Legs2, ffc Scrolled)
	{
		Legs1->X = Ghost_X - 15;
		Legs2->X = Ghost_X + 15;
		Legs1->Y = Ghost_Y;
		Legs2->Y = Ghost_Y;
		
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		
		HandleWeapons2();
		
		if (this->InitD[3] == 1 && Scrolled->InitD[2] == 1)
		{
			Ghost_Y-=0.1807;
		}
		
		if (!Ghost_Waitframe(this, ghost, false, false))
		{
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon Ctrl_Alt_Dlt = Screen->LoadEWeapon(i);
				Remove(Ctrl_Alt_Dlt);
			}
			for (int i = Screen->NumNPCs(); i > 3; i--)
			{
				npc Head = Screen->LoadNPC(i);
				Head->HP = 0;
			}
			Scrolled->InitD[1] = 2;
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			for (int i = Screen->NumNPCs(); i > 0; i--)
			{
				npc Head = Screen->LoadNPC(i);
				Head->HP = 0;
			}
			Game->SetDMapScreenD(21, 14, 1, 1);
			Scrolled->InitD[1] = 1;
			Quit();
		}
	}
	void GohmaWait(npc ghost, ffc this, npc Legs1, npc Legs2)
	{
		Legs1->X = Ghost_X - 15;
		Legs2->X = Ghost_X + 15;
		Legs1->Y = Ghost_Y;
		Legs2->Y = Ghost_Y;
		
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		
		HandleWeapons();
		
		if ((!Ghost_Waitframe(this, ghost, false, false)) || Ghost_HP <= 0)
		{
			Ghost_HP = 4;
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon Ctrl_Alt_Dlt = Screen->LoadEWeapon(i);
				Remove(Ctrl_Alt_Dlt);
			}
			for (int i = Screen->NumNPCs(); i > 3; i--)
			{
				npc Head = Screen->LoadNPC(i);
				Head->HP = 0;
			}
			this->InitD[4] = 1;
		}
		if (this->InitD[4] == 1)
		{
			this->InitD[3] = 0;
			Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
			ghost->Defense[NPCD_STOMP] = NPCDT_STUNORBLOCK;
		}
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
	void HandleWeapons()
	{
		for (int i = Screen->NumEWeapons(); i > 0; i--)
		{
			eweapon Bounce = Screen->LoadEWeapon(i);
			if (Bounce->OriginalTile == DARK_ORIG_TILE)
			{
				if (Screen->isSolid(Bounce->X - 2, Bounce->Y + 8) || Bounce->X - 2 <= 0)
				{
					if (Bounce->Misc[0] > 0)
					{
						Bounce->Angle = DegtoRad((90 + (90 - RadtoDeg(Bounce->Angle))) % 360);
						Bounce->Misc[0]--;
					}
					else Remove(Bounce);
				}
				if (Screen->isSolid(Bounce->X + 18, Bounce->Y + 8) || Bounce->X + 18 >= 255)
				{
					if (Bounce->Misc[0] > 0)
					{
						Bounce->Angle = DegtoRad((270 + (270 - RadtoDeg(Bounce->Angle))) % 360);
						Bounce->Misc[0]--;
					}
					else Remove(Bounce);
				}
				
				// Change Y velocity when bouncing on horizontal surface.
				if (Screen->isSolid(Bounce->X + 8, Bounce->Y - 2) || Bounce->Y -2 <= 0)
				{
					if (Bounce->Misc[0] > 0)
					{
						Bounce->Angle = DegtoRad((180 + (180 - RadtoDeg(Bounce->Angle))) % 360);
						Bounce->Misc[0]--;
					}
					else Remove(Bounce);
				}
				if (Screen->isSolid(Bounce->X + 8, Bounce->Y + 18) || Bounce->Y + 18 >= 175)
				{
					if (Bounce->Misc[0] > 0)
					{
						Bounce->Angle = DegtoRad((0 + (0 - RadtoDeg(Bounce->Angle))) % 360);
						Bounce->Misc[0]--;
					}
					else Remove(Bounce);
				}
			}
		}
	}
	void HandleWeapons2()
	{
		for (int i = Screen->NumEWeapons(); i > 0; i--)
		{
			eweapon Bounce = Screen->LoadEWeapon(i);
			if (Bounce->OriginalTile == DARK_ORIG_TILE)
			{
				if (Screen->isSolid(Bounce->X - 2, Bounce->Y + 8) || Bounce->X - 2 <= 0)
				{
					Bounce->Angle = DegtoRad((90 + (90 - RadtoDeg(Bounce->Angle))) % 360);
					Bounce->Misc[0]--;
				}
				if (Screen->isSolid(Bounce->X + 18, Bounce->Y + 8) || Bounce->X + 18 >= 255)
				{
					Bounce->Angle = DegtoRad((270 + (270 - RadtoDeg(Bounce->Angle))) % 360);
					Bounce->Misc[0]--;
				}
			}
		}
	}
}

ffc script GohmaLeg2
{

	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		ffc Great;
		for (int i = 1; i <= 32; i++)
		{
			Great = Screen->LoadFFC(i);
			if (Great->InitD[1] == 1) break;
		}
		Ghost_CSet = Great->CSet;
		npc GohmaBody = Screen->LoadNPC(Great->InitD[2]);
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

ffc script GohmaTop2
{

	void run(int enemyID)
	{
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		ffc Great;
		for (int i = 1; i <= 32; i++)
		{
			Great = Screen->LoadFFC(i);
			if (Great->InitD[1] == 1) break;
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
