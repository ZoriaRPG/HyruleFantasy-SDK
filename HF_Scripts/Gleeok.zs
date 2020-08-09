//import "std.zh"
//import "string.zh"
//import "ghost.zh"
//import "ffcscript.zh"
//import "stdExtra.zh"

ffc script GleeokKilled
{
	void run()
	{
		if (Screen->NumNPCs() < 1)
		{
			//SetLayerComboD(1, 75, 3358);
			SetLayerComboD(1, 86, 3358);
			SetLayerComboD(1, 87, 3356);
			SetLayerComboD(1, 90, 3354);
			SetLayerComboD(1, 101, 3352);
			//SetLayerComboD(1, 104, 3356);
			//SetLayerComboD(1, 105, 3356);
			SetLayerComboD(1, 106, 3358);
			SetLayerComboD(1, 116, 3356);
			SetLayerComboD(1, 123, 3348);
			SetLayerComboD(3, 52, 0);
			SetLayerComboD(3, 53, 0);
			SetLayerComboD(3, 36, 0);
			SetLayerComboD(3, 37, 0);
			SetLayerComboD(3, 20, 0);
			SetLayerComboD(3, 21, 0);
			SetLayerComboD(3, 58, 0);
			SetLayerComboD(3, 59, 0);
			SetLayerComboD(3, 42, 0);
			SetLayerComboD(3, 43, 0);
			SetLayerComboD(3, 26, 0);
			SetLayerComboD(3, 27, 0);
		}
	}
}

ffc script Gleeok
{
	
	void run(int enemyID)
	{
		int NeckXArray1[6];
		int NeckXArray2[6];
		int NeckYArray1[6];
		int NeckYArray2[6];
		int NeckArray[3];
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		//SetLayerComboD(1, 75, 3358);
		SetLayerComboD(1, 86, 3358);
		SetLayerComboD(1, 87, 3356);
		SetLayerComboD(1, 90, 3354);
		SetLayerComboD(1, 101, 3352);
		//SetLayerComboD(1, 104, 3356);
		//SetLayerComboD(1, 105, 3356);
		SetLayerComboD(1, 106, 3358);
		SetLayerComboD(1, 116, 3356);
		SetLayerComboD(1, 123, 3348);
		SetLayerComboD(3, 52, 0);
		SetLayerComboD(3, 53, 0);
		SetLayerComboD(3, 36, 0);
		SetLayerComboD(3, 37, 0);
		SetLayerComboD(3, 20, 0);
		SetLayerComboD(3, 21, 0);
		SetLayerComboD(3, 58, 0);
		SetLayerComboD(3, 59, 0);
		SetLayerComboD(3, 42, 0);
		SetLayerComboD(3, 43, 0);
		SetLayerComboD(3, 26, 0);
		SetLayerComboD(3, 27, 0);
		
		//Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		this->InitD[1] = 1;
		npc Head1;
		npc Head2;
		Head1 = CreateNPCAt(ghost->Attributes[0], Ghost_X - 4, Ghost_Y + 36);
		Head2 = CreateNPCAt(ghost->Attributes[0], Ghost_X + 20, Ghost_Y + 36);
		Ghost_CSet = 7;
		Ghost_SetSize(this, ghost, 2, 2);
		bool Jumped = false;
		int MaxHP = Ghost_HP;
		while(true)
		{
			GleeokWait(ghost, this, Head1, Head2, NeckXArray1, NeckXArray2, NeckYArray1, NeckYArray2, NeckArray);
			if (Ghost_HP <= (MaxHP / 2) && !Jumped)
			{
				Ghost_Jump = 2;
				do
				{
					GleeokWait(ghost, this, Head1, Head2, NeckXArray1, NeckXArray2, NeckYArray1, NeckYArray2, NeckArray);
				} while (Ghost_Z > 0)
				Screen->Quake = 4;
				Game->PlaySound(SFX_BOMB);
				for (int k = 0; k < 60; k++)
				{
					GleeokWait(ghost, this, Head1, Head2, NeckXArray1, NeckXArray2, NeckYArray1, NeckYArray2, NeckArray);
				}
				Game->PlaySound(SFX_SEA);
				SetLayerComboD(3, 52, 6108);
				SetLayerComboD(3, 53, 6109);
				SetLayerComboD(3, 36, 6104);
				SetLayerComboD(3, 37, 6105);
				SetLayerComboD(3, 20, 6100);
				SetLayerComboD(3, 21, 6101);
				SetLayerComboD(3, 58, 6108);
				SetLayerComboD(3, 59, 6109);
				SetLayerComboD(3, 42, 6104);
				SetLayerComboD(3, 43, 6105);
				SetLayerComboD(3, 26, 6100);
				SetLayerComboD(3, 27, 6101);
				for (int k = 0; k < 60; k++)
				{
					GleeokWait(ghost, this, Head1, Head2, NeckXArray1, NeckXArray2, NeckYArray1, NeckYArray2, NeckArray);
				}
				SetLayerComboD(3, 52, 0);
				SetLayerComboD(3, 53, 0);
				SetLayerComboD(3, 36, 6108);
				SetLayerComboD(3, 37, 6109);
				SetLayerComboD(3, 20, 6100);
				SetLayerComboD(3, 21, 6101);
				SetLayerComboD(3, 58, 0);
				SetLayerComboD(3, 59, 0);
				SetLayerComboD(3, 42, 6108);
				SetLayerComboD(3, 43, 6109);
				SetLayerComboD(3, 26, 6100);
				SetLayerComboD(3, 27, 6101);
				
				SetLayerComboD(1, 86, 0);
				SetLayerComboD(1, 87, 0);
				SetLayerComboD(1, 90, 0);
				SetLayerComboD(1, 101, 0);
				SetLayerComboD(1, 106, 0);
				SetLayerComboD(1, 116, 0);
				SetLayerComboD(1, 123, 0);
				for (int i = 34; i <= 38; i++)
				{
					Screen->ComboD[i] = 6045;
				}
				for (int i = 41; i <= 45; i++)
				{
					Screen->ComboD[i] = 6045;
				}
				for (int i = 50; i <= 54; i++)
				{
					Screen->ComboD[i] = 6049;
				}
				for (int i = 57; i <= 61; i++)
				{
					Screen->ComboD[i] = 6049;
				}
				Screen->ComboD[66] = 6049;
				for (int i = 69; i <= 74; i++)
				{
					Screen->ComboD[i] = 6049;
				}
				for (int i = 71; i <= 72; i++)
				{
					Screen->ComboD[i] = 6045;
				}
				Screen->ComboD[77] = 6049;
				Screen->ComboD[82] = 6049;
				for (int i = 85; i <= 90; i++)
				{
					Screen->ComboD[i] = 6049;
				}
				Screen->ComboD[93] = 6049;
				Screen->ComboD[98] = 6049;
				Screen->ComboD[101] = 6049;
				Screen->ComboD[106] = 6049;
				Screen->ComboD[109] = 6049;
				for (int i = 114; i <= 117; i++)
				{
					Screen->ComboD[i] = 6049;
				}
				for (int i = 115; i <= 116; i++)
				{
					Screen->ComboD[i] = 6045;
				}
				for (int i = 122; i <= 125; i++)
				{
					Screen->ComboD[i] = 6049;
				}
				for (int i = 123; i <= 124; i++)
				{
					Screen->ComboD[i] = 6045;
				}
				for (int i = 130; i <= 141; i++)
				{
					Screen->ComboD[i] = 6049;
				}
				for (int i = 134; i <= 137; i++)
				{
					Screen->ComboD[i] = 6045;
				}
				Jumped = true;
			}
		}
	}
	void GleeokWait(npc ghost, ffc this, npc Head1, npc Head2, int NeckXArray1, int NeckXArray2, int NeckYArray1, int NeckYArray2, int NeckArray)
	{
		NeckArray[2]++;
		NeckArray[2]%=16;
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		if ((Head1->HP <= 0 || !Head1->isValid()) && NeckArray[2] == 14 && NeckArray[0] < 6) 
		{
			NeckArray[0]++;
			FireAimedEWeapon(EW_BOMBBLAST, NeckXArray1[NeckArray[0] - 1], NeckYArray1[NeckArray[0] - 1], 0, 0, 0, -1, SFX_BOMB, EWF_NO_COLLISION);
		}
		if ((Head2->HP <= 0 || !Head2->isValid()) && NeckArray[2] == 14 && NeckArray[1] < 6) 
		{
			NeckArray[1]++;
			FireAimedEWeapon(EW_BOMBBLAST, NeckXArray2[NeckArray[1] - 1], NeckYArray2[NeckArray[1] - 1], 0, 0, 0, -1, SFX_BOMB, EWF_NO_COLLISION);
		}
		for (int i = 0; i < 6; i++)
		{
			if (Head1->isValid()) 
			{
				NeckXArray1[i] = Head1->X + VectorX((Distance(Head1->X, Head1->Y, ghost->X + 8, ghost->Y + 28) / 5) * i, Angle(Head1->X, Head1->Y, ghost->X + 8, ghost->Y + 28));
				NeckYArray1[i] = Head1->Y - 8 + VectorY((Distance(Head1->X, Head1->Y, ghost->X + 8, ghost->Y + 28) / 5) * i, Angle(Head1->X, Head1->Y, ghost->X + 8, ghost->Y + 28));
			}
			if (Head2->isValid()) 
			{
				NeckXArray2[i] = Head2->X + VectorX((Distance(Head2->X, Head2->Y, ghost->X + 8, ghost->Y + 28) / 5) * i, Angle(Head2->X, Head2->Y, ghost->X + 8, ghost->Y + 28));
				NeckYArray2[i] = Head2->Y - 8 + VectorY((Distance(Head2->X, Head2->Y, ghost->X + 8, ghost->Y + 28) / 5) * i, Angle(Head2->X, Head2->Y, ghost->X + 8, ghost->Y + 28));
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
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			Quit();
		}
	}
}

ffc script GleeokHead
{

	void run(int enemyID)
	{
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_CSet = 7;
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
					FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, 0);
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
			if (Ghost_X - 2 <= 88)
			{
				Ghost_Vx = ghost->Step * 0.01;
			}
			if (Ghost_X + 2 >= 152)
			{
				Ghost_Vx = -1 * ghost->Step * 0.01;
			}
			
			if (Ghost_Y -2 <= 72)
			{
				Ghost_Vy = ghost->Step * 0.01;
			}
			if (Ghost_Y + 2 >= 104)
			{
				Ghost_Vy = -1 * ghost->Step * 0.01;
			}
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

ffc script FlamingGleeokHead
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
					FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, 0);
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

int GetUnusedFFC()
{
	ffc theFFC;
    
    // Find an FFC not already in use
    for(int i=FFCS_MIN_FFC; i<=FFCS_MAX_FFC; i++)
    {
        theFFC=Screen->LoadFFC(i);
        
        if(theFFC->Script!=0 ||
         (theFFC->Data!=0 && theFFC->Data!=FFCS_INVISIBLE_COMBO) ||
         theFFC->Flags[FFCF_CHANGER])
            continue;
        
        return i;
	}
}