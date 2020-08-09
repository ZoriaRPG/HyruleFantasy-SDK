const int SFX_BOSSFIREBALL = 32;

ffc script Mothula
{
	void run(int enemyID)
	{
		if(Screen->D[6] == 1) Quit();
		npc ghost = Ghost_InitAutoGhost(this,enemyID);
		Ghost_Data = 10002;
		Ghost_TileWidth = 2;
		Ghost_TileHeight = 2;
		Ghost_Z = 6;
		int angle_v;
		Ghost_SetFlag(GHF_NO_FALL);
		Ghost_SetFlag(GHF_FLYING_ENEMY);
		Ghost_SetFlag(GHF_FAKE_Z);
		Ghost_SetFlag(GHF_SET_OVERLAY);

		npc bat[5];
		npc bat2[8];
		int DefenseStore[18];
		int x_offset = 8;
		int y_offset = 0;
		int i_shot = 0;
		float angle = 0;
		float angle2 = 0;
		int Bat1Count[5] = {0, 0, 0, 0, 0};
		int Bat2Count[8] = {0, 0, 0, 0, 0, 0, 0, 0};
		
		int counter = 0;
		
		bool firing = false;
		int firecountdown = 120 + Rand(240);
		
		bool rising = true;
		int flashcounter = 0;
		int movecounter = -1;
		
		int MaxHP = Ghost_HP;
		
		bool Phase2 = false;
		
		for (int i = 0; i <= 4; i++)
		{
			bat[i] = Screen->CreateNPC(269);
		}
		for (int i = 0; i <= 7; i++)
		{
			bat2[i] = Screen->CreateNPC(269);
		}
		for (int j = 0; j <= 17; j++)
		{
			DefenseStore[j] = ghost->Defense[j];
			ghost->Defense[j] = NPCDT_IGNORE;
		}
			
		int angle3 = 90;
		while(true)
		{
			angle3+=3;
			angle3%=360;
			if (Phase2)
			{
				if (Distance(Ghost_X, Ghost_Y, Link->X, Link->Y) > 2)
				{
					angle2 = Angle(Ghost_X, Ghost_Y, Link->X, Link->Y);
					Ghost_Ax = VectorX(0.032, angle2);
					Ghost_Ay = VectorY(0.032, angle2);
				}
				else
				{
					Ghost_Ax = 0;
					Ghost_Ay = 0;
				}
			}
			else
			{
				if (Distance(Ghost_X, Ghost_Y, Link->X + VectorX(40, angle3) - 8, Link->Y + VectorY(40, angle3) - 8) > 2)
				{
					angle2 = Angle(Ghost_X, Ghost_Y, Link->X + VectorX(40, angle3) - 8, Link->Y + VectorY(40, angle3) - 8);
					Ghost_Ax = VectorX(0.032, angle2);
					Ghost_Ay = VectorY(0.032, angle2);
				}
				else
				{
					Ghost_Ax = 0;
					Ghost_Ay = 0;
				}
			}
			angle_v = RadtoDeg(ArcTan(Ghost_Vx, Ghost_Vy));
			if (Ghost_Vx >= 0)
			{
				if (Ghost_Vx > VectorX(0.5, angle_v))
				{
					Ghost_Vx = VectorX(0.5, angle_v);
				}
			}
			else
			{
				if (Ghost_Vx < VectorX(0.5, angle_v))
				{
					Ghost_Vx = VectorX(0.5, angle_v);
				}
			}
			if (Ghost_Vy >= 0)
			{
				if (Ghost_Vy > VectorY(0.5, angle_v))
				{
					Ghost_Vy = VectorY(0.5, angle_v);
				}
			}
			else
			{
				if (Ghost_Vy < VectorY(0.5, angle_v))
				{
					Ghost_Vy = VectorY(0.5, angle_v);
				}
			}
		
			if (NumNPCsOf(269) == 0)
			{
				for (int j = 0; j <= 17; j++)
				{
					ghost->Defense[j] = DefenseStore[j];
				}
				Phase2 = true;
			}
			firecountdown--;
			if(!firing) counter++;
			for (int i = 0; i <= 4; i++)
			{
				if(Bat1Count[i]==0)
				{
					bat[i]->X = Ghost_X + 8 + VectorX(8, angle + (i * 72));
					bat[i]->Y = Ghost_Y + 8 + VectorY(8, angle + (i * 72));
					bat[i]->DrawYOffset = 0 - Ghost_Z;
					bat[i]->Z = 1;
					for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
					{
						lweapon l = Screen->LoadLWeapon(j);
						if(l->ID==LW_HOOKSHOT&&Collision(l, bat[i])&&l->Misc[15]==0)
						{
							l->DeadState = WDS_BOUNCE;
							l->Misc[15] = 1;
							bat[i]->X = l->X;
							bat[i]->Y = l->Y;
							Bat1Count[i] = 1;
						}
					}
				}
				else if(Bat1Count[i]==1)
				{
					lweapon l;
					for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
					{
						l = Screen->LoadLWeapon(j);
						if(l->ID==LW_HOOKSHOT)
						{
							break;
						}
					}
					if(l->isValid())
					{
						bat[i]->X = l->X;
						bat[i]->Y = l->Y;
						if(Distance(bat[i]->X, bat[i]->Y, Link->X, Link->Y)<18)
						{
							Bat1Count[i] = 2;
							for (int j = 0; j <= 17; j++)
							{
								if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
								else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
							}
						}
					}
					else
					{
						Bat1Count[i] = 2;
						for (int j = 0; j <= 17; j++)
						{
							if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
							else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
						}
					}
				}
				else if(Bat1Count[i]>=2)
				{
					Bat1Count[i]++;
					if (Bat1Count[i] > 120)
					{
						bat[i]->X += VectorX(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						bat[i]->Y += VectorY(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
						{
							Bat1Count[i] = 0;
							for (int j = 0; j <= 17; j++)
							{
								if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
								else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
							}
						}
					}
					else if (Bat1Count[i] > 45)
					{
						bat[i]->X += VectorX(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						bat[i]->Y += VectorY(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
						{
							Bat1Count[i] = 0;
							for (int j = 0; j <= 17; j++)
							{
								if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
								else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
							}
						}
					}
				}
			}
			for (int i = 0; i <= 7; i++)
			{
				if(Bat2Count[i]==0)
				{
					bat2[i]->X = Ghost_X + 8 + VectorX(16, (0 - angle + (i * 45)) % 360);
					bat2[i]->Y = Ghost_Y + 8 + VectorY(16, (0 - angle + (i * 45)) % 360);
					bat2[i]->DrawYOffset = 0 - Ghost_Z;
					bat2[i]->Z = 1;
					for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
					{
						lweapon l = Screen->LoadLWeapon(j);
						if(l->ID==LW_HOOKSHOT&&Collision(l, bat2[i])&&l->Misc[15]==0)
						{
							l->DeadState = WDS_BOUNCE;
							l->Misc[15] = 1;
							bat2[i]->X = l->X;
							bat2[i]->Y = l->Y;
							Bat2Count[i] = 1;
						}
					}
				}
				else if(Bat2Count[i]==1)
				{
					lweapon l;
					for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
					{
						l = Screen->LoadLWeapon(j);
						if(l->ID==LW_HOOKSHOT)
						{
							break;
						}
					}
					if(l->isValid())
					{
						bat2[i]->X = l->X;
						bat2[i]->Y = l->Y;
						if(Distance(bat2[i]->X, bat2[i]->Y, Link->X, Link->Y)<18)
						{
							Bat2Count[i] = 2;
							for (int j = 0; j <= 17; j++)
							{
								if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
								else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
							}
						}
					}
					else
					{
						Bat2Count[i] = 2;
						for (int j = 0; j <= 17; j++)
						{
							if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
							else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
						}
					}
				}
				else if(Bat2Count[i]>=2)
				{
					Bat2Count[i]++;
					if (Bat2Count[i] > 120)
					{
						bat2[i]->X += VectorX(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						bat2[i]->Y += VectorY(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
						{
							Bat2Count[i] = 0;
							for (int j = 0; j <= 17; j++)
							{
								if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
								else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
							}
						}
					}
					else if (Bat2Count[i] > 45)
					{
						bat2[i]->X += VectorX(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						bat2[i]->Y += VectorY(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
						if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
						{
							Bat2Count[i] = 0;
							for (int j = 0; j <= 17; j++)
							{
								if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
								else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
							}
						}
					}
				}
			}
			angle+= 2;

			if(!firing)
			{
				if(counter < 6)
				{
					if(rising) Ghost_Z = Ghost_Z + 0.04; 
					if(!rising) Ghost_Z = Ghost_Z - 0.04; 
				}
				if(counter >= 6 && counter < 18)
				{
					if(rising) Ghost_Z = Ghost_Z + 0.12;
					if(!rising) Ghost_Z = Ghost_Z - 0.12;
				}
				if(counter >= 18 && counter < 32)
				{
					if(rising) Ghost_Z = Ghost_Z + 0.25;
					if(!rising) Ghost_Z = Ghost_Z - 0.25;
				}
				if(counter >= 32 && counter < 50)
				{
					if(rising) Ghost_Z = Ghost_Z + 0.12;
					if(!rising) Ghost_Z = Ghost_Z - 0.12;
				}
				if(counter >= 50 && counter < 56)
				{
					if(rising) Ghost_Z = Ghost_Z + 0.04;
					if(!rising) Ghost_Z = Ghost_Z - 0.04;
				}
				if(counter >= 56)
				{
					counter = 0;
					rising = !rising;
				}	
			}

			if(firecountdown <= 0)
			{
				firing = true;
				if (Phase2)
				{
					if (Ghost_HP > (MaxHP / 2))
					{
						Ghost_Ax = 0;
						Ghost_Ay = 0;
						Ghost_Vx = 0;
						Ghost_Vy = 0;
					}
					while(firing)
					{
						i_shot++;
						if(i_shot == 24)
						{	
							eweapon wp1 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, -0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
							eweapon wp2 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0, 256, ghost->WeaponDamage, 95, SFX_BOSSFIREBALL, EWF_UNBLOCKABLE);
							eweapon wp3 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
						}

						if(i_shot == 48)
						{
							eweapon wp1 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, -0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
							eweapon wp2 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0, 256, ghost->WeaponDamage, 95, SFX_BOSSFIREBALL, EWF_UNBLOCKABLE);
							eweapon wp3 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
						}

						if(i_shot == 72)
						{
							eweapon wp1 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, -0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
							eweapon wp2 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0, 256, ghost->WeaponDamage, 95, SFX_BOSSFIREBALL, EWF_UNBLOCKABLE);
							eweapon wp3 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
						}

						if(i_shot == 96)
						{
							eweapon wp1 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, -0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
							eweapon wp2 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0, 256, ghost->WeaponDamage, 95, SFX_BOSSFIREBALL, EWF_UNBLOCKABLE);
							eweapon wp3 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
						}

						if(i_shot == 96)
						{
							eweapon wp1 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, -0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
							eweapon wp2 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0, 256, ghost->WeaponDamage, 95, SFX_BOSSFIREBALL, EWF_UNBLOCKABLE);
							eweapon wp3 = FireAimedEWeapon(129,Ghost_X + 8, (Ghost_Y + 8) - Ghost_Z, 0.5, 256, ghost->WeaponDamage, 95, 0, EWF_UNBLOCKABLE);
						}

						if(i_shot == 240)
						{
							firing = false;
							firecountdown = 120 + Rand(240);
							i_shot = 0;
						}
		
						bool stillAlive = Ghost_Waitframe(this, ghost, false, false);
						if(!stillAlive)
						{
							Screen->D[6] = 1;
							Ghost_DeathAnimation(this, ghost, 2);
							for(int i=0;i<= Screen->NumNPCs();i++)
							{
								npc kill = Screen->LoadNPC(i); 
								kill->HP = 0;
							}
							Quit();
						}
		
					}
				}
				else
				{
					Ghost_Ax = 0;
					Ghost_Ay = 0;
					Ghost_Vx = 0;
					Ghost_Vy = 0;
					while(firing)
					{
						i_shot++;
						if (i_shot < 45)
						{
							for (int i = 0; i <= 4; i++)
							{
								if(Bat1Count[i]==0)
								{
									bat[i]->X = Ghost_X + 8 + VectorX(8, angle + (i * 72));
									bat[i]->Y = Ghost_Y + 8 + VectorY(8, angle + (i * 72));
									bat[i]->DrawYOffset = 0 - Ghost_Z;
									bat[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat[i]->X = l->X;
											bat[i]->Y = l->Y;
											Bat1Count[i] = 1;
										}
									}
								}
								else if(Bat1Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat[i]->X = l->X;
										bat[i]->Y = l->Y;
										if(Distance(bat[i]->X, bat[i]->Y, Link->X, Link->Y)<18)
										{
											Bat1Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat1Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat1Count[i]>=2)
								{
									Bat1Count[i]++;
									if (Bat1Count[i] > 120)
									{
										bat[i]->X += VectorX(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat1Count[i] > 45)
									{
										bat[i]->X += VectorX(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							for (int i = 0; i <= 7; i++)
							{
								
								if(Bat2Count[i]==0)
								{
									bat2[i]->X = Ghost_X + 8 + VectorX(16, (0 - angle + (i * 45)) % 360);
									bat2[i]->Y = Ghost_Y + 8 + VectorY(16, (0 - angle + (i * 45)) % 360);
									bat2[i]->DrawYOffset = 0 - Ghost_Z;
									bat2[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat2[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat2[i]->X = l->X;
											bat2[i]->Y = l->Y;
											Bat2Count[i] = 1;
										}
									}
								}
								else if(Bat2Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat2[i]->X = l->X;
										bat2[i]->Y = l->Y;
										if(Distance(bat2[i]->X, bat2[i]->Y, Link->X, Link->Y)<18)
										{
											Bat2Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat2Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat2Count[i]>=2)
								{
									Bat2Count[i]++;
									if (Bat2Count[i] > 120)
									{
										bat2[i]->X += VectorX(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat2Count[i] > 45)
									{
										bat2[i]->X += VectorX(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							angle+= 4;
						}
						else if (i_shot < 105)
						{
							for (int i = 0; i <= 4; i++)
							{
								if(Bat1Count[i]==0)
								{
									bat[i]->X = Ghost_X + 8 + VectorX(8 + (i_shot - 45), angle + (i * 72));
									bat[i]->Y = Ghost_Y + 8 + VectorY(8 + (i_shot - 45), angle + (i * 72));
									bat[i]->DrawYOffset = 0 - Ghost_Z;
									bat[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat[i]->X = l->X;
											bat[i]->Y = l->Y;
											Bat1Count[i] = 1;
										}
									}
								}
								else if(Bat1Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat[i]->X = l->X;
										bat[i]->Y = l->Y;
										if(Distance(bat[i]->X, bat[i]->Y, Link->X, Link->Y)<18)
										{
											Bat1Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat1Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat1Count[i]>=2)
								{
									Bat1Count[i]++;
									if (Bat1Count[i] > 120)
									{
										bat[i]->X += VectorX(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat1Count[i] > 45)
									{
										bat[i]->X += VectorX(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							for (int i = 0; i <= 7; i++)
							{
								if(Bat2Count[i]==0)
								{
									bat2[i]->X = Ghost_X + 8 + VectorX(16 + ((i_shot - 45) * 1.5), (0 - angle + (i * 45)) % 360);
									bat2[i]->Y = Ghost_Y + 8 + VectorY(16 + ((i_shot - 45) * 1.5), (0 - angle + (i * 45)) % 360);
									bat2[i]->DrawYOffset = 0 - Ghost_Z;
									bat2[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat2[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat2[i]->X = l->X;
											bat2[i]->Y = l->Y;
											Bat2Count[i] = 1;
										}
									}
								}
								else if(Bat2Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat2[i]->X = l->X;
										bat2[i]->Y = l->Y;
										if(Distance(bat2[i]->X, bat2[i]->Y, Link->X, Link->Y)<18)
										{
											Bat2Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat2Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat2Count[i]>=2)
								{
									Bat2Count[i]++;
									if (Bat2Count[i] > 120)
									{
										bat2[i]->X += VectorX(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat2Count[i] > 45)
									{
										bat2[i]->X += VectorX(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							angle+= 4;
						}
						else if (i_shot < 165)
						{
							for (int i = 0; i <= 4; i++)
							{
								if(Bat1Count[i]==0)
								{
									bat[i]->X = Ghost_X + 8 + VectorX(68 - (i_shot - 105), angle + (i * 72));
									bat[i]->Y = Ghost_Y + 8 + VectorY(68 - (i_shot - 105), angle + (i * 72));
									bat[i]->DrawYOffset = 0 - Ghost_Z;
									bat[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat[i]->X = l->X;
											bat[i]->Y = l->Y;
											Bat1Count[i] = 1;
										}
									}
								}
								else if(Bat1Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat[i]->X = l->X;
										bat[i]->Y = l->Y;
										if(Distance(bat[i]->X, bat[i]->Y, Link->X, Link->Y)<18)
										{
											Bat1Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat1Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat1Count[i]>=2)
								{
									Bat1Count[i]++;
									if (Bat1Count[i] > 120)
									{
										bat[i]->X += VectorX(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat1Count[i] > 45)
									{
										bat[i]->X += VectorX(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							for (int i = 0; i <= 7; i++)
							{
								
								if(Bat2Count[i]==0)
								{
									bat2[i]->X = Ghost_X + 8 + VectorX(106 - ((i_shot - 105) * 1.5), (0 - angle + (i * 45)) % 360);
									bat2[i]->Y = Ghost_Y + 8 + VectorY(106 - ((i_shot - 105) * 1.5), (0 - angle + (i * 45)) % 360);
									bat2[i]->DrawYOffset = 0 - Ghost_Z;
									bat2[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat2[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat2[i]->X = l->X;
											bat2[i]->Y = l->Y;
											Bat2Count[i] = 1;
										}
									}
								}
								else if(Bat2Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat2[i]->X = l->X;
										bat2[i]->Y = l->Y;
										if(Distance(bat2[i]->X, bat2[i]->Y, Link->X, Link->Y)<18)
										{
											Bat2Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat2Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat2Count[i]>=2)
								{
									Bat2Count[i]++;
									if (Bat2Count[i] > 120)
									{
										bat2[i]->X += VectorX(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat2Count[i] > 45)
									{
										bat2[i]->X += VectorX(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							angle+= 4;
						}
						else if (i_shot < 195)
						{
							for (int i = 0; i <= 4; i++)
							{
								if(Bat1Count[i]==0)
								{
									bat[i]->X = Ghost_X + 8 + VectorX(8, angle + (i * 72));
									bat[i]->Y = Ghost_Y + 8 + VectorY(8, angle + (i * 72));
									bat[i]->DrawYOffset = 0 - Ghost_Z;
									bat[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat[i]->X = l->X;
											bat[i]->Y = l->Y;
											Bat1Count[i] = 1;
										}
									}
								}
								else if(Bat1Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat[i]->X = l->X;
										bat[i]->Y = l->Y;
										if(Distance(bat[i]->X, bat[i]->Y, Link->X, Link->Y)<18)
										{
											Bat1Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat1Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat1Count[i]>=2)
								{
									Bat1Count[i]++;
									if (Bat1Count[i] > 120)
									{
										bat[i]->X += VectorX(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(2.5, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat1Count[i] > 45)
									{
										bat[i]->X += VectorX(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat[i]->Y += VectorY(1.25, Angle(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat[i]->X, bat[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat1Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat[i]->Defense[j] == NPCDT_HALFDAMAGE) bat[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat[i]->Defense[j] == NPCDT_NONE) bat[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							for (int i = 0; i <= 7; i++)
							{
								if(Bat2Count[i]==0)
								{
									bat2[i]->X = Ghost_X + 8 + VectorX(16, (0 - angle + (i * 45)) % 360);
									bat2[i]->Y = Ghost_Y + 8 + VectorY(16, (0 - angle + (i * 45)) % 360);
									bat2[i]->DrawYOffset = 0 - Ghost_Z;
									bat2[i]->Z = 1;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										lweapon l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT&&Collision(l, bat2[i])&&l->Misc[15]==0)
										{
											l->DeadState = WDS_BOUNCE;
											l->Misc[15] = 1;
											bat2[i]->X = l->X;
											bat2[i]->Y = l->Y;
											Bat2Count[i] = 1;
										}
									}
								}
								else if(Bat2Count[i]==1)
								{
									lweapon l;
									for(int j=1; j<=Screen->NumLWeapons()&&j<10; j++)
									{
										l = Screen->LoadLWeapon(j);
										if(l->ID==LW_HOOKSHOT)
										{
											break;
										}
									}
									if(l->isValid())
									{
										bat2[i]->X = l->X;
										bat2[i]->Y = l->Y;
										if(Distance(bat2[i]->X, bat2[i]->Y, Link->X, Link->Y)<18)
										{
											Bat2Count[i] = 2;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
											}
										}
									}
									else
									{
										Bat2Count[i] = 2;
										for (int j = 0; j <= 17; j++)
										{
											if (bat2[i]->Defense[j] == NPCDT_QUARTERDAMAGE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											else if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_NONE;
										}
									}
								}
								else if(Bat2Count[i]>=2)
								{
									Bat2Count[i]++;
									if (Bat2Count[i] > 120)
									{
										bat2[i]->X += VectorX(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(2.5, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
									else if (Bat2Count[i] > 45)
									{
										bat2[i]->X += VectorX(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										bat2[i]->Y += VectorY(1.25, Angle(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))));
										if (Distance(bat2[i]->X, bat2[i]->Y, Ghost_X + 8 + VectorX(8, angle + (i * 72)), Ghost_Y + 8 + VectorY(8, angle + (i * 72))) < 4)
										{
											Bat2Count[i] = 0;
											for (int j = 0; j <= 17; j++)
											{
												if (bat2[i]->Defense[j] == NPCDT_HALFDAMAGE) bat2[i]->Defense[j] = NPCDT_QUARTERDAMAGE;
												else if (bat2[i]->Defense[j] == NPCDT_NONE) bat2[i]->Defense[j] = NPCDT_HALFDAMAGE;
											}
										}
									}
								}
							}
							angle+= 4;
						}
						if(i_shot >= 195)
						{
							firing = false;
							firecountdown = 120 + Rand(240);
							i_shot = 0;
						}
		
						bool stillAlive = Ghost_Waitframe(this, ghost, false, false);
						if(!stillAlive)
						{
							Screen->D[6] = 1;
							Ghost_DeathAnimation(this, ghost, 2);
							for(int i=0;i<= Screen->NumNPCs();i++)
							{
								npc kill = Screen->LoadNPC(i); 
								kill->HP = 0;
							}
							Quit();
						}
					}
				}
			}
			bool stillAlive = Ghost_Waitframe(this, ghost, false, false);
			if(!stillAlive)
			{
				Screen->D[6] = 1;
				Ghost_DeathAnimation(this, ghost, 2);
				for(int i=0;i<= Screen->NumNPCs();i++)
				{
					npc kill = Screen->LoadNPC(i); 
					kill->HP = 0;
				}
				Quit();
			}
		}
	}
	int HookCollide(int x, int y, int height, int width)
	{
		for (int i = Screen->NumLWeapons(); i > 0; i--)
		{
			lweapon Hook = Screen->LoadLWeapon(i);
			if (Hook->ID == LW_HOOKSHOT && RectCollision(Hook->X, Hook->Y, Hook->X + 15, Hook->Y + 15, x, y, x + 15, y + 15)) 
			{
				return i;
			}
		}
		return -1;
	}
}
