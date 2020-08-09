//import "std.zh"
//import "string.zh"
//import "ghost.zh"
//import "ffcscript.zh"
//import "stdExtra.zh"



ffc script Gleeok2
{
	
	void run(int enemyID)
	{
		int NeckXArray1[6];
		int NeckXArray2[6];
		int NeckXArray3[6];
		int NeckYArray1[6];
		int NeckYArray2[6];
		int NeckYArray3[6];
		int NeckArray[4];
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		
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
		this->InitD[1] = 1;
		this->InitD[2] = Ghosty;
		npc Head1 = CreateNPCAt(ghost->Attributes[0], Ghost_X - 8, Ghost_Y + 36);
		npc Head2 = CreateNPCAt(ghost->Attributes[0], Ghost_X + 24, Ghost_Y + 36);
		npc Head3 = CreateNPCAt(ghost->Attributes[0], Ghost_X + 8, Ghost_Y + 36);
		Ghost_CSet = 7;
		Ghost_SetSize(this, ghost, 2, 2);
		int Jump = Rand (150, 210);
		int MaxHP = Ghost_HP;
		int Place = 2;
		bool LeftLava = false;
		int GleeokData = Ghost_Data;
		int DashData = Ghost_Data + 6;
		while(true)
		{
			Jump--;
			GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
			if (Jump <= 0)
			{
				Ghost_Jump = 15;
				do
				{
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				} while (Ghost_Z < 140)

				if (Place == 1)
				{
					Place = Choose(2, 3);
				}
				else if (Place == 2)
				{
					Place = Choose(1, 3);
				}
				else if (Place == 3)
				{
					Place = Choose(1, 2);
				}
				if (Place == 1)
				{
					Ghost_X = 32;
					Ghost_Y = 32;
				}
				if (Place == 2)
				{
					Ghost_X = 112;
					Ghost_Y = 32;
				}
				if (Place == 3)
				{
					Ghost_X = 192;
					Ghost_Y = 32;
				}
				Ghost_Jump = -15;
				do
				{
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				} while (Ghost_Z > 0)
				Screen->Quake = 4;
				Game->PlaySound(SFX_BOMB);
				if (Ghost_HP < (MaxHP / 2))
				{
					FireNonAngularEWeapon(EW_FIRE2, Ghost_X, Ghost_Y + 16, DIR_DOWN, 300, 8, -1, SFX_FIRE, 0);
					FireNonAngularEWeapon(EW_FIRE2, Ghost_X + 16, Ghost_Y + 16, DIR_DOWN, 300, 8, -1, SFX_FIRE, 0);
				}
				for (int k = 0; k < 60; k++)
				{
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				}
				Game->PlaySound(SFX_FIRE);
				if (LeftLava)
				{
					Screen->ComboD[25] = 2955;
					Screen->ComboD[26] = 2955;
					Screen->ComboD[27] = 2955;
					Screen->ComboD[20] = 2953;
					Screen->ComboD[21] = 2953;
					Screen->ComboD[22] = 2953;
					Screen->ComboD[58] = 2701;
					Screen->ComboD[74] = 2701;
					Screen->ComboD[90] = 2701;
					Screen->ComboD[106] = 2701;
					Screen->ComboD[122] = 2701;
					
					
					Screen->ComboD[36] = 3136;
					Screen->ComboD[37] = 3137;
					Screen->ComboD[38] = 3138;
					Screen->ComboD[52] = 3219;
					Screen->ComboD[53] = 2712;
					Screen->ComboD[54] = 3218;
					Screen->ComboD[68] = 3223;
					Screen->ComboD[69] = 2712;
					Screen->ComboD[70] = 3222;
					Screen->ComboD[84] = 3140;
					Screen->ComboD[85] = 2712;
					Screen->ComboD[86] = 3142;
					Screen->ComboD[100] = 3219;
					Screen->ComboD[101] = 2712;
					Screen->ComboD[102] = 3218;
					Screen->ComboD[116] = 3223;
					Screen->ComboD[117] = 2712;
					Screen->ComboD[118] = 3222;
					Screen->ComboD[132] = 3144;
					Screen->ComboD[133] = 3145;
					Screen->ComboD[134] = 3146;
					
					Screen->ComboC[41] = 3;
					Screen->ComboC[42] = 3;
					Screen->ComboC[43] = 3;
					Screen->ComboC[57] = 3;
					Screen->ComboC[58] = 3;
					Screen->ComboC[59] = 3;
					Screen->ComboC[73] = 3;
					Screen->ComboC[74] = 3;
					Screen->ComboC[75] = 3;
					Screen->ComboC[89] = 3;
					Screen->ComboC[90] = 3;
					Screen->ComboC[91] = 3;
					Screen->ComboC[105] = 3;
					Screen->ComboC[106] = 3;
					Screen->ComboC[107] = 3;
					Screen->ComboC[121] = 3;
					Screen->ComboC[122] = 3;
					Screen->ComboC[123] = 3;
					Screen->ComboC[137] = 3;
					Screen->ComboC[138] = 3;
					Screen->ComboC[139] = 3;
				}
				else
				{
					Screen->ComboD[20] = 2955;
					Screen->ComboD[21] = 2955;
					Screen->ComboD[22] = 2955;
					Screen->ComboD[25] = 2953;
					Screen->ComboD[26] = 2953;
					Screen->ComboD[27] = 2953;
					Screen->ComboD[53] = 2701;
					Screen->ComboD[69] = 2701;
					Screen->ComboD[85] = 2701;
					Screen->ComboD[101] = 2701;
					Screen->ComboD[117] = 2701;
					
					Screen->ComboD[41] = 3136;
					Screen->ComboD[42] = 3137;
					Screen->ComboD[43] = 3138;
					Screen->ComboD[57] = 3219;
					Screen->ComboD[58] = 2712;
					Screen->ComboD[59] = 3218;
					Screen->ComboD[73] = 3223;
					Screen->ComboD[74] = 2712;
					Screen->ComboD[75] = 3222;
					Screen->ComboD[89] = 3140;
					Screen->ComboD[90] = 2712;
					Screen->ComboD[91] = 3142;
					Screen->ComboD[105] = 3219;
					Screen->ComboD[106] = 2712;
					Screen->ComboD[107] = 3218;
					Screen->ComboD[121] = 3223;
					Screen->ComboD[122] = 2712;
					Screen->ComboD[123] = 3222;
					Screen->ComboD[137] = 3144;
					Screen->ComboD[138] = 3145;
					Screen->ComboD[139] = 3146;
					
					Screen->ComboC[36] = 3;
					Screen->ComboC[37] = 3;
					Screen->ComboC[38] = 3;
					Screen->ComboC[52] = 3;
					Screen->ComboC[53] = 3;
					Screen->ComboC[54] = 3;
					Screen->ComboC[68] = 3;
					Screen->ComboC[69] = 3;
					Screen->ComboC[70] = 3;
					Screen->ComboC[84] = 3;
					Screen->ComboC[85] = 3;
					Screen->ComboC[86] = 3;
					Screen->ComboC[100] = 3;
					Screen->ComboC[101] = 3;
					Screen->ComboC[102] = 3;
					Screen->ComboC[116] = 3;
					Screen->ComboC[117] = 3;
					Screen->ComboC[118] = 3;
					Screen->ComboC[132] = 3;
					Screen->ComboC[133] = 3;
					Screen->ComboC[134] = 3;
				}
				for (int k = 0; k < 60; k++)
				{
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				}
				if (LeftLava)
				{
					Screen->ComboD[41] = Rand(2658, 2659);
					Screen->ComboD[42] = Rand(2658, 2659);
					Screen->ComboD[43] = Rand(2658, 2659);
					Screen->ComboD[57] = Rand(2662, 2663);
					Screen->ComboD[58] = Rand(2662, 2663);
					Screen->ComboD[59] = Rand(2662, 2663);
					Screen->ComboD[73] = Rand(2662, 2663);
					Screen->ComboD[74] = Rand(2662, 2663);
					Screen->ComboD[75] = Rand(2662, 2663);
					Screen->ComboD[89] = Rand(2662, 2663);
					Screen->ComboD[90] = Rand(2662, 2663);
					Screen->ComboD[91] = Rand(2662, 2663);
					Screen->ComboD[105] = Rand(2662, 2663);
					Screen->ComboD[106] = Rand(2662, 2663);
					Screen->ComboD[107] = Rand(2662, 2663);
					Screen->ComboD[121] = Rand(2662, 2663);
					Screen->ComboD[122] = Rand(2662, 2663);
					Screen->ComboD[123] = Rand(2662, 2663);
					Screen->ComboD[137] = Rand(2662, 2663);
					Screen->ComboD[138] = Rand(2662, 2663);
					Screen->ComboD[139] = Rand(2662, 2663);
					LeftLava = false;
				}
				else
				{
					Screen->ComboD[36] = Rand(2658, 2659);
					Screen->ComboD[37] = Rand(2658, 2659);
					Screen->ComboD[38] = Rand(2658, 2659);
					Screen->ComboD[52] = Rand(2662, 2663);
					Screen->ComboD[53] = Rand(2662, 2663);
					Screen->ComboD[54] = Rand(2662, 2663);
					Screen->ComboD[68] = Rand(2662, 2663);
					Screen->ComboD[69] = Rand(2662, 2663);
					Screen->ComboD[70] = Rand(2662, 2663);
					Screen->ComboD[84] = Rand(2662, 2663);
					Screen->ComboD[85] = Rand(2662, 2663);
					Screen->ComboD[86] = Rand(2662, 2663);
					Screen->ComboD[100] = Rand(2662, 2663);
					Screen->ComboD[101] = Rand(2662, 2663);
					Screen->ComboD[102] = Rand(2662, 2663);
					Screen->ComboD[116] = Rand(2662, 2663);
					Screen->ComboD[117] = Rand(2662, 2663);
					Screen->ComboD[118] = Rand(2662, 2663);
					Screen->ComboD[132] = Rand(2662, 2663);
					Screen->ComboD[133] = Rand(2662, 2663);
					Screen->ComboD[134] = Rand(2662, 2663);
					LeftLava = true;
				}
				Jump = Rand (150, 210);
			}
			if (((Link->X > Ghost_X - 12 && Link->X < Ghost_X + 28) && (Head1->HP <= 0 || !Head2->isValid()) && (Head1->HP <= 0 || !Head2->isValid()) && (Head3->HP <= 0 || !Head3->isValid()) && NeckArray[2] >= 6 && NeckArray[1] >= 6) && NeckArray[0] >= 6)
			{
				Ghost_Data = DashData;
				for (int k = 0; k < 45; k++)
				{
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				}
				int Counting = 0;
				while (Ghost_Y + 18 < 128)
				{
					Counting++;
					Counting %= 5;
					if (Counting == 4) FireAimedEWeapon(EW_FIRE, Ghost_X + 8, Ghost_Y + 8, 0, 0, 0, -1, SFX_FIRE, 0);
					Ghost_Move(DIR_DOWN, 3, 4);
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				}
				FireAimedEWeapon(EW_FIRE, Ghost_X + 8, Ghost_Y + 8, 0, 0, 0, -1, SFX_FIRE, 0);
				Ghost_Data = GleeokData;
				Screen->Quake = 4;
				Game->PlaySound(SFX_BOMB);
				for (int k = 0; k < 20; k++)
				{
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				}
				while (Ghost_Y -2 > 32)
				{
					Ghost_Move(DIR_UP, 1, 4);
					GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
				}
			}
		}
	}
	void GleeokWait(npc ghost, ffc this, npc Head1, npc Head2, npc Head3, int NeckXArray1, int NeckXArray2, int NeckXArray3, int NeckYArray1, int NeckYArray2, int NeckYArray3, int NeckArray)
	{
		NeckArray[3]++;
		NeckArray[3]%=16;
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		if ((Head1->HP <= 0 || !Head1->isValid()) && NeckArray[3] == 14 && NeckArray[0] < 6) 
		{
			NeckArray[0]++;
			FireAimedEWeapon(EW_BOMBBLAST, NeckXArray1[NeckArray[0] - 1], NeckYArray1[NeckArray[0] - 1], 0, 0, 0, -1, SFX_BOMB, EWF_NO_COLLISION);
		}
		if ((Head2->HP <= 0 || !Head2->isValid()) && NeckArray[3] == 14 && NeckArray[1] < 6) 
		{
			NeckArray[1]++;
			FireAimedEWeapon(EW_BOMBBLAST, NeckXArray2[NeckArray[1] - 1], NeckYArray2[NeckArray[1] - 1], 0, 0, 0, -1, SFX_BOMB, EWF_NO_COLLISION);
		}
		if ((Head3->HP <= 0 || !Head3->isValid()) && NeckArray[3] == 14 && NeckArray[2] < 6) 
		{
			NeckArray[2]++;
			FireAimedEWeapon(EW_BOMBBLAST, NeckXArray3[NeckArray[2] - 1], NeckYArray3[NeckArray[2] - 1], 0, 0, 0, -1, SFX_BOMB, EWF_NO_COLLISION);
		}
		for (int i = 0; i < 6; i++)
		{
			if (Head1->isValid()) 
			{
				NeckXArray1[i] = Head1->X + VectorX((Distance(Head1->X, Head1->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z) / 5) * i, Angle(Head1->X, Head1->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z));
				NeckYArray1[i] = Head1->Y - 8 - Ghost_Z + VectorY((Distance(Head1->X, Head1->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z) / 5) * i, Angle(Head1->X, Head1->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z));
			}
			if (Head2->isValid()) 
			{
				NeckXArray2[i] = Head2->X + VectorX((Distance(Head2->X, Head2->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z) / 5) * i, Angle(Head2->X, Head2->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z));
				NeckYArray2[i] = Head2->Y - 8 - Ghost_Z + VectorY((Distance(Head2->X, Head2->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z) / 5) * i, Angle(Head2->X, Head2->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z));
			}
			if (Head3->isValid()) 
			{
				NeckXArray3[i] = Head3->X + VectorX((Distance(Head3->X, Head3->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z) / 5) * i, Angle(Head3->X, Head3->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z));
				NeckYArray3[i] = Head3->Y - 8 - Ghost_Z + VectorY((Distance(Head3->X, Head3->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z) / 5) * i, Angle(Head3->X, Head3->Y - Ghost_Z, ghost->X + 8, ghost->Y + 28 - Ghost_Z));
			}
			if (i >= NeckArray[0])
			{
				if (i <= 2) Screen->FastCombo (2, NeckXArray1[i], NeckYArray1[i], Ghost_Data + 1, 0, OP_OPAQUE);
				else Screen->FastCombo (3, NeckXArray1[i], NeckYArray1[i], Ghost_Data + 1, 0, OP_OPAQUE);
			}
			if (i >= NeckArray[1])
			{
				if (i <= 2) Screen->FastCombo (2, NeckXArray2[i], NeckYArray2[i], Ghost_Data + 1, 0, OP_OPAQUE);
				else Screen->FastCombo (3, NeckXArray2[i], NeckYArray2[i], Ghost_Data + 1, 0, OP_OPAQUE);
			}
			if (i >= NeckArray[2])
			{
				if (i <= 2) Screen->FastCombo (2, NeckXArray3[i], NeckYArray3[i], Ghost_Data + 1, 0, OP_OPAQUE);
				else Screen->FastCombo (3, NeckXArray3[i], NeckYArray3[i], Ghost_Data + 1, 0, OP_OPAQUE);
			}
		}
		if (!Ghost_Waitframe(this, ghost, false, false))
		{
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon Ctrl_Alt_Dlt = Screen->LoadEWeapon(i);
				Remove(Ctrl_Alt_Dlt);
			}
			for (int i = Screen->NumNPCs(); i > 0; i--)
			{
				npc Head = Screen->LoadNPC(i);
				Head->HP = 0;
			}
			Screen->ComboD[36] = 3136;
			Screen->ComboD[37] = 3137;
			Screen->ComboD[38] = 3138;
			Screen->ComboD[52] = 3219;
			Screen->ComboD[53] = 2712;
			Screen->ComboD[54] = 3218;
			Screen->ComboD[68] = 3223;
			Screen->ComboD[69] = 2712;
			Screen->ComboD[70] = 3222;
			Screen->ComboD[84] = 3140;
			Screen->ComboD[85] = 2712;
			Screen->ComboD[86] = 3142;
			Screen->ComboD[100] = 3219;
			Screen->ComboD[101] = 2712;
			Screen->ComboD[102] = 3218;
			Screen->ComboD[116] = 3223;
			Screen->ComboD[117] = 2712;
			Screen->ComboD[118] = 3222;
			Screen->ComboD[132] = 3144;
			Screen->ComboD[133] = 3145;
			Screen->ComboD[134] = 3146;
			
			Screen->ComboD[41] = 3136;
			Screen->ComboD[42] = 3137;
			Screen->ComboD[43] = 3138;
			Screen->ComboD[57] = 3219;
			Screen->ComboD[58] = 2712;
			Screen->ComboD[59] = 3218;
			Screen->ComboD[73] = 3223;
			Screen->ComboD[74] = 2712;
			Screen->ComboD[75] = 3222;
			Screen->ComboD[89] = 3140;
			Screen->ComboD[90] = 2712;
			Screen->ComboD[91] = 3142;
			Screen->ComboD[105] = 3219;
			Screen->ComboD[106] = 2712;
			Screen->ComboD[107] = 3218;
			Screen->ComboD[121] = 3223;
			Screen->ComboD[122] = 2712;
			Screen->ComboD[123] = 3222;
			Screen->ComboD[137] = 3144;
			Screen->ComboD[138] = 3145;
			Screen->ComboD[139] = 3146;
			
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			Quit();
		}
	}
}

ffc script GleeokHead2
{

	void run(int enemyID)
	{
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_CSet = 7;
		ffc Great;
		for (int i = 1; i <= 32; i++)
		{
			Great = Screen->LoadFFC(i);
			if (Great->InitD[1] == 1) break;
		}
		npc GleeokBody = Screen->LoadNPC(Great->InitD[2]);
		int InitX = Ghost_X - GleeokBody->X;
		int InitY = Ghost_Y - GleeokBody->Y;
		if (Rand(1, 2) == 1)
		{
			Ghost_Vx = ghost->Step * 0.01;
		}
		else
		{
			Ghost_Vx = -1 * ghost->Step * 0.01;
		}
		
		if (Rand(1, 2) == 1)
		{
			Ghost_Vy = ghost->Step * 0.01;
		}
		else
		{
			Ghost_Vy = -1 * ghost->Step * 0.01;
		}
		int Counter = 180;
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		while(true)
		{
			Counter--;
			if (Ghost_Z > 0)
			{
				InitX = Ghost_X - GleeokBody->X;
				InitY = Ghost_Y - GleeokBody->Y;
			}
			if (Counter <= 0)
			{
				if (Rand(1, 3) < 3) Counter = 30;
				else if (Ghost_Z <= 0)
				{
					Ghost_Vx = 0;
					Ghost_Vy = 0;
					for (int k = 0; k < 15; k++)
					{
						Ghost_Z = GleeokBody->Z;
						if (Ghost_X < GleeokBody->X - 26) Ghost_X +=80;
						if (Ghost_X > GleeokBody->X + 40) Ghost_X -=80;
						GleeokHeadWait(ghost, this);
					}
					Ghost_Data++;
					for (int k = 0; k < 15; k++)
					{
						if (Ghost_X < GleeokBody->X - 26) Ghost_X +=80;
						if (Ghost_X > GleeokBody->X + 40) Ghost_X -=80;
						Ghost_Z = GleeokBody->Z;
						GleeokHeadWait(ghost, this);
					}
					FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, 0);
					for (int k = 0; k < 25; k++)
					{
						Ghost_Z = GleeokBody->Z;
						if (Ghost_X < GleeokBody->X - 26) Ghost_X +=80;
						if (Ghost_X > GleeokBody->X + 40) Ghost_X -=80;
						GleeokHeadWait(ghost, this);
					}
					if (Rand(1, 2) == 1)
					{
						Ghost_Vx = ghost->Step * 0.01;
					}
					else
					{
						Ghost_Vx = -1 * ghost->Step * 0.01;
					}
					
					if (Rand(1, 2) == 1)
					{
						Ghost_Vy = ghost->Step * 0.01;
					}
					else
					{
						Ghost_Vy = -1 * ghost->Step * 0.01;
					}
					Ghost_Data--;
					Counter = Rand(90, 120);
				}
				else Counter = Rand(90, 120);
			}
			if (Ghost_Z <= 0)
			{
				if (Ghost_Vx == 0 || Ghost_Vy == 0)
				{
					if (Rand(1, 2) == 1)
					{
						Ghost_Vx = ghost->Step * 0.01;
					}
					else
					{
						Ghost_Vx = -1 * ghost->Step * 0.01;
					}
					
					if (Rand(1, 2) == 1)
					{
						Ghost_Vy = ghost->Step * 0.01;
					}
					else
					{
						Ghost_Vy = -1 * ghost->Step * 0.01;
					}
				}
				if (Ghost_X - 2 <= GleeokBody->X - 24)
				{
					Ghost_Vx = ghost->Step * 0.01;
				}
				if (Ghost_X + 2 >= GleeokBody->X + 40)
				{
					Ghost_Vx = -1 * ghost->Step * 0.01;
				}
				
				if (Ghost_Y -2 <= GleeokBody->Y + 40)
				{
					Ghost_Vy = ghost->Step * 0.01;
				}
				if (Ghost_Y + 2 >=  GleeokBody->Y + 72)
				{
					Ghost_Vy = -1 * ghost->Step * 0.01;
				}
			}
			else
			{
				Ghost_Vx = 0;
				Ghost_Vy = 0;
			}
			if (Ghost_X < GleeokBody->X - 26) Ghost_X +=80;
			if (Ghost_X > GleeokBody->X + 40) Ghost_X -=80;
			Ghost_Z = GleeokBody->Z;
			GleeokHeadWait(ghost, this);
		}
	}
	void GleeokHeadWait(npc ghost, ffc this)
	{
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		if (!Ghost_Waitframe(this, ghost, false, false))
		{
			int tempX = Ghost_X;
			int tempY = Ghost_Y;
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			CreateNPCAt(ghost->Attributes[0], tempX, tempY);
			Quit();
		}
	}
}

ffc script FlamingGleeokHead2
{

	void run(int enemyID)
	{
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_CSet = 8;
		if (Rand(1, 2) == 1)
		{
			Ghost_Vx = ghost->Step * 0.01;
		}
		else
		{
			Ghost_Vx = -1 * ghost->Step * 0.01;
		}
		
		if (Rand(1, 2) == 1)
		{
			Ghost_Vy = ghost->Step * 0.01;
		}
		else
		{
			Ghost_Vy = -1 * ghost->Step * 0.01;
		}
		int Counter = 180;
		Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		Ghost_SetFlag(GHF_STUN);
		while(true)
		{
			Counter--;
			if (Counter <= 0)
			{
				if (Rand(1, 3) < 3) Counter = 30;
				else
				{
					Ghost_Vx = 0;
					Ghost_Vy = 0;
					for (int k = 0; k < 15; k++)
					{
						GleeokHeadWait(ghost, this);
					}
					Ghost_Data++;
					for (int k = 0; k < 15; k++)
					{
						GleeokHeadWait(ghost, this);
					}
					for (int k = 48; k >= 0; k--)
					{
						if (k % 12 == 0) FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, 0);
						GleeokHeadWait(ghost, this);
					}
					for (int k = 0; k < 25; k++)
					{
						GleeokHeadWait(ghost, this);
					}
					if (Rand(1, 2) == 1)
					{
						Ghost_Vx = ghost->Step * 0.01;
					}
					else
					{
						Ghost_Vx = -1 * ghost->Step * 0.01;
					}
					
					if (Rand(1, 2) == 1)
					{
						Ghost_Vy = ghost->Step * 0.01;
					}
					else
					{
						Ghost_Vy = -1 * ghost->Step * 0.01;
					}
					Ghost_Data--;
					Counter = Rand(90, 120);
				}
			}
			if (Ghost_X - 2 <= 32)
			{
				Ghost_Vx = ghost->Step * 0.01;
			}
			if (Ghost_X + 2 >= 208)
			{
				Ghost_Vx = -1 * ghost->Step * 0.01;
			}
			
			// Change Y velocity when bouncing on horizontal surface.
			if (Ghost_Y -2 <= 32)
			{
				Ghost_Vy = ghost->Step * 0.01;
			}
			if (Ghost_Y + 2 >= 128)
			{
				Ghost_Vy = -1 * ghost->Step * 0.01;
			}
			GleeokHeadWait(ghost, this);
		}
	}
	void GleeokHeadWait(npc ghost, ffc this)
	{
		if (!Ghost_Waitframe(this, ghost, false, false))
		{
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			Quit();
		}
	}
}