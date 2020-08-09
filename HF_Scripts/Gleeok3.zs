//import "std.zh"
//import "string.zh"
//import "ghost.zh"
//import "ffcscript.zh"
//import "stdExtra.zh"



ffc script Gleeok3
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
		int MaxHP = Ghost_HP;
		int GleeokData = Ghost_Data;
		eweapon Blitz[4];
		int Blitzing = 0;
		int Blitzer = 0;
		int BlitzCounter = 120;
		bool Jumped = false;
		int Walking = Ghost_X;
		int WalkCounter = Rand(90, 150);
		while(true)
		{
			GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
			if (Round(Ghost_X) == Walking) WalkCounter--;
			else
			{
				if (Walking < Ghost_X) Ghost_Move(DIR_LEFT, 1, 4);
				else Ghost_Move(DIR_RIGHT, 1, 4);
			}
			if (WalkCounter <= 0)
			{
				Walking = Rand(32, 192);
				WalkCounter = Rand(90, 150);
			}
			if (Ghost_HP < (MaxHP / 2))
			{
				if (Round(Ghost_X) == Walking && !Jumped)
				{
					Ghost_Jump = 2;
					do
					{
						GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
					} while (Ghost_Z > 0)
					Screen->Quake = 4;
					Game->PlaySound(SFX_BOMB);
					Blitz[0] = FireEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y + 8, 0, 0, 16, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					Blitz[1] = FireEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y + 8, 0, 0, 16, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					Blitz[2] = FireEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y + 8, 0, 0, 16, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					Blitz[3] = FireEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y + 8, 0, 0, 16, SP_FIREBALL, SFX_FIREBALL, EWF_UNBLOCKABLE);
					for (int k = 0; k < 32; k++)
					{
						Blitzer++;
						Blitzing+=2;
						Blitzing%=360;
						for (int i = 0; i < 4; i++)
						{
							Blitz[i]->DeadState = -1;
							Blitz[i]->X = Ghost_X + 8;
							Blitz[i]->Y = Ghost_Y + 8;
							Blitz[i]->HitXOffset = VectorX(Blitzer, Blitzing + (90 * i));
							Blitz[i]->HitYOffset = VectorY(Blitzer, Blitzing + (90 * i));
							Blitz[i]->DrawXOffset = VectorX(Blitzer, Blitzing + (90 * i));
							Blitz[i]->DrawYOffset = VectorY(Blitzer, Blitzing + (90 * i));
						}
						GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
					}
					Jumped = true;
				}
				Blitzing+=2;
				Blitzing%=360;
				for (int i = 0; i < 4; i++)
				{
					Blitz[i]->DeadState = -1;
					Blitz[i]->DeadState = -1;
					Blitz[i]->X = Ghost_X + 8;
					Blitz[i]->Y = Ghost_Y + 8;
					Blitz[i]->HitXOffset = VectorX(Blitzer, Blitzing + (90 * i));
					Blitz[i]->HitYOffset = VectorY(Blitzer, Blitzing + (90 * i));
					Blitz[i]->DrawXOffset = VectorX(Blitzer, Blitzing + (90 * i));
					Blitz[i]->DrawYOffset = VectorY(Blitzer, Blitzing + (90 * i));
				}
				if (BlitzCounter > 0 && Round(Ghost_X) == Walking) BlitzCounter--;
				if (Round(Ghost_X) == Walking && BlitzCounter<=0)
				{
					for (int k = 0; k < 48; k++)
					{
						Blitzing+=3;
						for (int i = 0; i < 4; i++)
						{
							Blitz[i]->DeadState = -1;
							Blitz[i]->X = Ghost_X + 8;
							Blitz[i]->Y = Ghost_Y + 8;
							Blitz[i]->HitXOffset = VectorX(Blitzer, Blitzing + (90 * i));
							Blitz[i]->HitYOffset = VectorY(Blitzer, Blitzing + (90 * i));
							Blitz[i]->DrawXOffset = VectorX(Blitzer, Blitzing + (90 * i));
							Blitz[i]->DrawYOffset = VectorY(Blitzer, Blitzing + (90 * i));
						}
						GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
					}
					for (int j = 0; j < 1; j++)
					{
						for (int k = 0; k < 48; k++)
						{
							Blitzing+=3;
							Blitzing%=360;
							Blitzer+=1.5;
							for (int i = 0; i < 4; i++)
							{
								Blitz[i]->DeadState = -1;
								Blitz[i]->X = Ghost_X + 8;
								Blitz[i]->Y = Ghost_Y + 8;
								Blitz[i]->HitXOffset = VectorX(Blitzer, Blitzing + (90 * i));
								Blitz[i]->HitYOffset = VectorY(Blitzer, Blitzing + (90 * i));
								Blitz[i]->DrawXOffset = VectorX(Blitzer, Blitzing + (90 * i));
								Blitz[i]->DrawYOffset = VectorY(Blitzer, Blitzing + (90 * i));
							}
							GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
						}
						for (int k = 0; k < 48; k++)
						{
							Blitzing+=3;
							Blitzing%=360;
							Blitzer-=1.5;
							for (int i = 0; i < 4; i++)
							{
								Blitz[i]->DeadState = -1;
								Blitz[i]->X = Ghost_X + 8;
								Blitz[i]->Y = Ghost_Y + 8;
								Blitz[i]->HitXOffset = VectorX(Blitzer, Blitzing + (90 * i));
								Blitz[i]->HitYOffset = VectorY(Blitzer, Blitzing + (90 * i));
								Blitz[i]->DrawXOffset = VectorX(Blitzer, Blitzing + (90 * i));
								Blitz[i]->DrawYOffset = VectorY(Blitzer, Blitzing + (90 * i));
							}
							GleeokWait(ghost, this, Head1, Head2, Head3, NeckXArray1, NeckXArray2, NeckXArray3, NeckYArray1, NeckYArray2, NeckYArray3, NeckArray);
						}
					}
					BlitzCounter = 120;
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
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			Quit();
		}
	}
}

ffc script GleeokHead3
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
						if (Ghost_X < GleeokBody->X - 26) Ghost_X +=2.5;
						if (Ghost_X > GleeokBody->X + 40) Ghost_X -=2.5;
						GleeokHeadWait(ghost, this);
					}
					Ghost_Data++;
					for (int k = 0; k < 15; k++)
					{
						if (Ghost_X < GleeokBody->X - 26) Ghost_X +=2.5;
						if (Ghost_X > GleeokBody->X + 40) Ghost_X -=2.5;
						Ghost_Z = GleeokBody->Z;
						GleeokHeadWait(ghost, this);
					}
					//for (int k = 48; k >= 0; k--)
					//if (k % 24 == 0) 
					//GleeokHeadWait(ghost, this);
					eweapon Nub; 
					Nub = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, 0);
					SetEWeaponMovement(Nub, EWM_HOMING_REAIM, 1, 45);
					for (int k = 0; k < 25; k++)
					{
						Ghost_Z = GleeokBody->Z;
						if (Ghost_X < GleeokBody->X - 26) Ghost_X +=2.5;
						if (Ghost_X > GleeokBody->X + 40) Ghost_X -=2.5;
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
			if (Ghost_X < GleeokBody->X - 26) Ghost_X +=2.5;
			if (Ghost_X > GleeokBody->X + 40) Ghost_X -=2.5;
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

ffc script FlamingGleeokHead3
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
					//for (int k = 48; k >= 0; k--)
					//{
					//if (k % 24 == 0)
					//GleeokHeadWait(ghost, this);
					eweapon Nub;
					Nub = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y + 6, 0, 250, ghost->WeaponDamage, SP_FIREBALL, SFX_FIREBALL, 0);
					//SetEWeaponMovement(Nub, EWM_HOMING_REAIM, 1, 45);
					SetEWeaponLifespan(Nub, EWL_TIMER, 45);
					SetEWeaponDeathEffect(Nub, EWD_4_FIREBALLS_RANDOM, SP_FIREBALL);
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