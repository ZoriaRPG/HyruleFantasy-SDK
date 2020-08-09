const int Agahnim1IntroString = 101;
const int Agahnim1DefeatString = 104;

ffc script DarkWizard{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_8WAY);
		//Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
		Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		int FireData = Ghost_Data; //Firing/default data
		int ChargeData = Ghost_Data + 8; //Charging up an attack data
		int BallData = Ghost_Data + 16; //The ball data
		Ghost_Data = GH_INVISIBLE_COMBO;
		int Store[18];
		Ghost_SetSize(this, ghost, 2, 2);
		int ThunderCounter = 4;
		int DrawCounter = 0;
		int Fakeoutcounter = 0;
		int Fakeoutmax = 0;
		int MaxHP = Ghost_HP;
		for (int i = 45; i > 0; i--)
		{
			DarkWait(this, ghost); //Wait for 45 frames
		}
		int enh[] = "Priest of the Dark Order (LOZ-ALTTP).spc";
		if (!Game->PlayEnhancedMusic(enh, 1)) Game->PlayMIDI(41);
		for (int i = 16; i > 0; i-=0.5) //Teleport in animation
		{
			Screen->DrawCombo(3, 112 + i, 32 - (i * 2), FireData + 1, 2, 2, 7, 32 - (i * 2), 32 + (i * 2), 0, 0, 0, -1, 0, true, OP_OPAQUE);
			DarkWait(this, ghost);
		}
		Ghost_Data = FireData; //Ghost draws him now
		Ghost_Dir = DIR_DOWN;
		for (int i = 30; i > 0; i--) //30 frame wait
		{
			DarkWait(this, ghost);
		}
		Screen->Message(Agahnim1IntroString); //SPEAK, MY CREATION
		if (true)
		{
			int Args[8];
			Args[0] = 33;
			Args[1] = 1;
			int lightning[] = "BossMusicBeatableOnly";
			int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
			Screen->LoadFFC(RunFFCScript(script_num, Args));
		}
		for (int i = 30; i > 0; i--) //30 frames pass by
		{
			DarkWait(this, ghost);
		}
		while(true) //Main while loop
		{
			if (ThunderCounter > 0) //In the original LttP, Agahnim used lightning every 4 attacks. Recreating that here.
			{
				int Attack = 0;
				if (Fakeoutcounter < Fakeoutmax) //Agahnim can only use so many "fake out attacks" (or non-reflect ball attacks) before he's forced
				{								 //to use a reflect ball. This "limit" loosens as the fight goes on.
					if (Ghost_HP > (MaxHP / 2)) Attack = Rand(1, 3); //He'll only start using the lightning ball attack at half health.
					else Attack = Rand(1, 4);
					if (Attack == 1) Fakeoutcounter = 0; //If he uses the reflect ball, reset the counter.
					else Fakeoutcounter++;
				}
				else //Force him to use reflect ball
				{
					Attack = 1;
					Fakeoutcounter = 0;
				}
				ThunderCounter--; //Decrease the countdown before he uses thunder.
				int Zoom;
				if (Attack != 3) Zoom = FindSpawnPoint(-1, 99); //Where will he teleport to? Currently only flag 99, but this'll likely be changed if conflicts with the door script happen.
				else if (Attack == 3) Zoom = Choose(ComboAt(64, 32), ComboAt(96, 32), ComboAt(128, 32), ComboAt(160, 32)); //He'll "teleport" (dash) to the top of the room to use his summon lightningbolt attack
				if (Attack != 3) while(Distance(ComboX(Zoom), ComboY(Zoom), Ghost_X, Ghost_Y) <= 48) Zoom = FindSpawnPoint(-1, 99); //Don't make him teleport too close to his current location.
				int ZoomX[5] = {Ghost_X + 16, Ghost_X + 16, Ghost_X + 16, Ghost_X + 16, Ghost_X + 16}; //Set up afterimages
				int ZoomY[5] = {Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16};
				Game->PlaySound(85); //dash sound
				ghost->CollDetection = false; //no free hits on Link while doing this.
				while(Distance(ComboX(Zoom), ComboY(Zoom), Ghost_X, Ghost_Y) > 3) //While he's not currently at the new location
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, ComboX(Zoom), ComboY(Zoom)), 2, 4); //Move him
					DrawCounter++; //Increase draw counter
					DrawCounter%=4; //reset draw counter if too high
					if (DrawCounter == 3) //every 4 frames, update afterimages
					{
						ShiftArray(ZoomX);
						ShiftArray(ZoomY);
						ZoomX[0] = Ghost_X + 16;
						ZoomY[0] = Ghost_Y + 16;
					}
					if (ZoomX[0] != 0) DrawCombo(2, ZoomX[0], ZoomY[0], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64); //Make sure it's not 0 before drawing afterimages
					if (ZoomX[1] != 0) DrawCombo(2, ZoomX[1], ZoomY[1], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[2] != 0) DrawCombo(2, ZoomX[2], ZoomY[2], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[3] != 0) DrawCombo(2, ZoomX[3], ZoomY[3], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[4] != 0) DrawCombo(2, ZoomX[4], ZoomY[4], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					DarkWait(this, ghost);
				}
				if (Ghost_HP <= (MaxHP / 4)) Fakeoutmax = 3; //If he's down to his last breath, he can use up to 3 fake outs before before forced to mirror ball
				else if (Ghost_HP <= (MaxHP / 2)) Fakeoutmax = 2; //If half health, max 2 fake outs
				else if (Ghost_HP <= (MaxHP / 4) * 3) Fakeoutmax = 1; // If only down a quarter, max 1 fake out.
				Ghost_X = ComboX(Zoom);
				Ghost_Y = ComboY(Zoom);
				ShiftArray(ZoomX);
				ShiftArray(ZoomY);
				ZoomX[0] = Ghost_X + 16;
				ZoomY[0] = Ghost_Y + 16;
				if (ZoomX[0] != 0) DrawCombo(2, ZoomX[0], ZoomY[0], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64); //Make sure not 0 before drawing.
				if (ZoomX[1] != 0) DrawCombo(2, ZoomX[1], ZoomY[1], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				if (ZoomX[2] != 0) DrawCombo(2, ZoomX[2], ZoomY[2], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				if (ZoomX[3] != 0) DrawCombo(2, ZoomX[3], ZoomY[3], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				if (ZoomX[4] != 0) DrawCombo(2, ZoomX[4], ZoomY[4], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				DarkWait(this, ghost);
				do //Wait for the afterimages to fade.
				{
					DrawCounter++;
					DrawCounter%=4;
					if (DrawCounter == 3) //Let's get rid of those afterimages
					{
						ShiftArray(ZoomX);
						ShiftArray(ZoomY);
						ZoomX[0] = 0;
						ZoomY[0] = 0;
					}
					if (ZoomX[0] != 0) DrawCombo(2, ZoomX[0], ZoomY[0], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[1] != 0) DrawCombo(2, ZoomX[1], ZoomY[1], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[2] != 0) DrawCombo(2, ZoomX[2], ZoomY[2], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					else ghost->CollDetection = true; //Turn on collision once he's down to only 2 afterimages.
					if (ZoomX[3] != 0) DrawCombo(2, ZoomX[3], ZoomY[3], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[4] != 0) DrawCombo(2, ZoomX[4], ZoomY[4], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					DarkWait(this, ghost);
				}while (ZoomX[4] != 0)
				for (int i = 30; i > 0; i--)
				{
					DarkWait(this, ghost);
					if (Attack < 3) Ghost_Dir = AngleDir8(Angle(Ghost_X + 8, Ghost_Y + 8, Link->X, Link->Y)); //Face Link
				}
				
				Ghost_Data = ChargeData;
				if (Attack < 3) Ghost_Dir = AngleDir8(Angle(Ghost_X + 8, Ghost_Y + 8, Link->X, Link->Y));
				else Ghost_Dir = DIR_DOWN; //He's facing down if he's using summon lightning
				Game->PlaySound(83);
				if (Attack != 3) //Do charge up animation for non-summon lightning attacks
				{
					for (int i = 0; i < 190; i+=2)
					{
						if (Ghost_Dir == DIR_DOWN)
						{
							Screen->FastCombo(3, Ghost_X - 8 + Max(Floor((i - 30) / 10), 0), Ghost_Y, BallData + 2, 7, OP_OPAQUE);
							Screen->FastCombo(3, Ghost_X + 24 - Max(Floor((i - 30) / 10), 0), Ghost_Y, BallData + 2, 7, OP_OPAQUE);
						}
						else if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_RIGHTUP || Ghost_Dir == DIR_LEFTUP)
						{
							Screen->FastCombo(2, Ghost_X - 8 + Max(Floor((i - 30) / 10), 0), Ghost_Y - 8, BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
							Screen->FastCombo(2, Ghost_X + 24 - Max(Floor((i - 30) / 10), 0), Ghost_Y - 8, BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						}
						else if (Ghost_Dir == DIR_LEFT)
						{
							Screen->FastCombo(3, Ghost_X - 4, Ghost_Y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
							Screen->FastCombo(3, Ghost_X - 4, Ghost_Y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						}
						else if (Ghost_Dir == DIR_RIGHT)
						{
							Screen->FastCombo(3, Ghost_X + 20, Ghost_Y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
							Screen->FastCombo(3, Ghost_X + 20, Ghost_Y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						}
						else if (Ghost_Dir == DIR_LEFTDOWN)
						{
							Screen->FastCombo(3, Ghost_X + 8 - Max(Floor((i - 30) / 20), 0), Ghost_Y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
							Screen->FastCombo(3, Ghost_X - 8 + Max(Floor((i - 30) / 20), 0), Ghost_Y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						}
						else if (Ghost_Dir == DIR_RIGHTDOWN)
						{
							Screen->FastCombo(3, Ghost_X + 8 + Max(Floor((i - 30) / 20), 0), Ghost_Y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
							Screen->FastCombo(3, Ghost_X + 24 - Max(Floor((i - 30) / 20), 0), Ghost_Y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						}
						Ghost_Dir = AngleDir8(Angle(Ghost_X + 8, Ghost_Y + 8, Link->X, Link->Y));
						DarkWait(this, ghost);
					}
					int Args[8]; //Attacks are an FFC Script. Script 57 is WizardBall.
					if (Attack < 3) Args[0] = Attack - 1;
					else Args[0] = Attack - 2;
					ffc meh = Screen->LoadFFC(RunFFCScript(57, Args)); 
					if (Attack == 1) meh->Data = BallData + 2; //Set the appearance of the ball.
					else if (Attack == 2) meh->Data = BallData + 3;
					else meh->Data = BallData + 12;
					meh->CSet = 7; //Set CSet.
					Ghost_Data = FireData;
					Game->PlaySound(84); //Play the firing sound.
					
					if (Ghost_Dir == DIR_DOWN)
					{
						meh->X = Ghost_X + 8;
						meh->Y = Ghost_Y;
					}
					else if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_RIGHTUP || Ghost_Dir == DIR_LEFTUP)
					{
						meh->X = Ghost_X + 8;
						meh->Y = Ghost_Y;
					}
					else if (Ghost_Dir == DIR_LEFT)
					{
						meh->X = Ghost_X - 4;
						meh->Y = Ghost_Y + 8;
					}
					else if (Ghost_Dir == DIR_RIGHT)
					{
						meh->X = Ghost_X + 20;
						meh->Y = Ghost_Y + 8;
					}
					else if (Ghost_Dir == DIR_LEFTDOWN)
					{
						meh->X = Ghost_X - 8;
						meh->Y = Ghost_Y + 8;
					}
					else if (Ghost_Dir == DIR_RIGHTDOWN)
					{
						meh->X = Ghost_X + 24;
						meh->Y = Ghost_Y + 8;
					}
					
					DarkWait(this, ghost);
					
					while (NumEWeaponsOf(EW_SCRIPT2) > 0 || NumLWeaponsOf(LW_SCRIPT5) > 0) DarkWait(this, ghost);
				}
				else //Summon homing lightning bolts.
				{
					if (Link->X > Ghost_X + 8) Ghost_Data = BallData + 4;
					else Ghost_Data = BallData + 8;
					for (int i = 30; i > 0; i--)
					{
						DarkWait(this, ghost);
					}
					eweapon Home = FireEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y + 8, DegtoRad(90), 125, 4, 105, 13, EWF_UNBLOCKABLE|EWF_NO_COLLISION);
					SetEWeaponMovement(Home, EWM_HOMING, DegtoRad(4), 240);
					SetEWeaponDeathEffect(Home, EWD_RUN_SCRIPT, 58); //Script 58 is LightningCaller
					Home->Misc[0] = BallData + 2;
					for (int i = 30; i > 0; i--)
					{
						DarkWait(this, ghost);
					}
					Ghost_Data = FireData;
				}
				
				for (int i = 30; i > 0; i--)
				{
					DarkWait(this, ghost);
				}
				
			}
			else //Do that one big lightning attack from LttP
			{
				int Zoom = Choose(ComboAt(176, 72), ComboAt(112, 32), ComboAt(48, 72), ComboAt(112, 112)); //Teleport to the sides of the room
				//int Zoom = ComboAt(112, 112);
				int Chosen = -1;
				if (Zoom == ComboAt(176, 72)) Chosen = DIR_LEFT;
				else if (Zoom == ComboAt(112, 32)) Chosen = DIR_DOWN;
				else if (Zoom == ComboAt(48, 72)) Chosen = DIR_RIGHT;
				else if (Zoom == ComboAt(112, 112)) Chosen = DIR_UP;
				int ZoomX[5] = {Ghost_X + 16, Ghost_X + 16, Ghost_X + 16, Ghost_X + 16, Ghost_X + 16};
				int ZoomY[5] = {Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16, Ghost_Y + 16};
				Game->PlaySound(85);
				ghost->CollDetection = false;
				while(Distance(ComboX(Zoom), ComboY(Zoom), Ghost_X, Ghost_Y) > 3) //Do the teleport stuff, with aftereffects and stuff.
				{
					Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, ComboX(Zoom), ComboY(Zoom)), 2, 4);
					DrawCounter++;
					DrawCounter%=4;
					if (DrawCounter == 3)
					{
						ShiftArray(ZoomX);
						ShiftArray(ZoomY);
						ZoomX[0] = Ghost_X + 16;
						ZoomY[0] = Ghost_Y + 16;
					}
					if (ZoomX[0] != 0) DrawCombo(2, ZoomX[0], ZoomY[0], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[1] != 0) DrawCombo(2, ZoomX[1], ZoomY[1], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[2] != 0) DrawCombo(2, ZoomX[2], ZoomY[2], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[3] != 0) DrawCombo(2, ZoomX[3], ZoomY[3], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[4] != 0) DrawCombo(2, ZoomX[4], ZoomY[4], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					DarkWait(this, ghost);
				}
				if (Ghost_HP <= (MaxHP / 4)) Fakeoutmax = 3; //Copypaste code because too lazy to remove.
				else if (Ghost_HP <= (MaxHP / 2)) Fakeoutmax = 2;
				else if (Ghost_HP <= (MaxHP / 4) * 3) Fakeoutmax = 1;
				
				Ghost_X = ComboX(Zoom);
				Ghost_Y = ComboY(Zoom);
				ShiftArray(ZoomX);
				ShiftArray(ZoomY);
				ZoomX[0] = Ghost_X + 16;
				ZoomY[0] = Ghost_Y + 16;
				if (ZoomX[0] != 0) DrawCombo(2, ZoomX[0], ZoomY[0], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				if (ZoomX[1] != 0) DrawCombo(2, ZoomX[1], ZoomY[1], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				if (ZoomX[2] != 0) DrawCombo(2, ZoomX[2], ZoomY[2], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				if (ZoomX[3] != 0) DrawCombo(2, ZoomX[3], ZoomY[3], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				if (ZoomX[4] != 0) DrawCombo(2, ZoomX[4], ZoomY[4], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
				DarkWait(this, ghost);
				do //Clean up the afterimages
				{
					DrawCounter++;
					DrawCounter%=4;
					if (DrawCounter == 3)
					{
						ShiftArray(ZoomX);
						ShiftArray(ZoomY);
						ZoomX[0] = 0;
						ZoomY[0] = 0;
					}
					if (ZoomX[0] != 0) DrawCombo(2, ZoomX[0], ZoomY[0], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[1] != 0) DrawCombo(2, ZoomX[1], ZoomY[1], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[2] != 0) DrawCombo(2, ZoomX[2], ZoomY[2], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					else ghost->CollDetection = true;
					if (ZoomX[3] != 0) DrawCombo(2, ZoomX[3], ZoomY[3], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					if (ZoomX[4] != 0) DrawCombo(2, ZoomX[4], ZoomY[4], this->Data, 2, 2, 7, 32, 32, 0, 0, 0, -1, 0, true, 64);
					DarkWait(this, ghost);
				}while (ZoomX[4] != 0)
				Ghost_Dir = Chosen;
				Ghost_Data = ChargeData;
				Game->PlaySound(83);
				for (int i = 0; i < 190; i+=2)
				{
					if (Ghost_Dir == DIR_DOWN)
					{
						Screen->FastCombo(3, Ghost_X - 8 + Max(Floor((i - 30) / 10), 0), Ghost_Y, BallData + 2, 7, OP_OPAQUE);
						Screen->FastCombo(3, Ghost_X + 24 - Max(Floor((i - 30) / 10), 0), Ghost_Y, BallData + 2, 7, OP_OPAQUE);
					}
					else if (Ghost_Dir == DIR_UP || Ghost_Dir == DIR_RIGHTUP || Ghost_Dir == DIR_LEFTUP)
					{
						Screen->FastCombo(2, Ghost_X - 8 + Max(Floor((i - 30) / 10), 0), Ghost_Y - 8, BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						Screen->FastCombo(2, Ghost_X + 24 - Max(Floor((i - 30) / 10), 0), Ghost_Y - 8, BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
					}
					else if (Ghost_Dir == DIR_LEFT)
					{
						Screen->FastCombo(3, Ghost_X - 4, Ghost_Y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						Screen->FastCombo(3, Ghost_X - 4, Ghost_Y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
					}
					else if (Ghost_Dir == DIR_RIGHT)
					{
						Screen->FastCombo(3, Ghost_X + 20, Ghost_Y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
						Screen->FastCombo(3, Ghost_X + 20, Ghost_Y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
					}
					DarkWait(this, ghost);
				}
				Ghost_Data = FireData; 
				int Args[8];
				Args[0] = Chosen; //Set direction of lightning
				Args[1] = 1;
				int lightning[] = "Lightning";
				int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
				ffc meh = Screen->LoadFFC(RunFFCScript(script_num, Args)); //Load the lightning script.
				meh->X = Ghost_X + 16;
				meh->Y = Ghost_Y + 16;
				while(meh->InitD[2] < 1) DarkWait(this, ghost);
				meh->InitD[2] = 0;
				for (int i = 0; i < 30; i+=2) DarkWait(this, ghost);
				ThunderCounter = 4;
			}
		}
	}
	void DarkWait(ffc this, npc ghost)
	{
		for (int i = Screen->NumLWeapons(); i > 0; i--) //Shock Link if he attacks Agahnim directly
		{
			lweapon eh = Screen->LoadLWeapon(i);
			if ((eh->ID == LW_SWORD || eh->ID == LW_SCRIPT3) && RectCollision(eh->X + 2, eh->Y + 2, eh->X + 13, eh->Y + 13, Ghost_X + 2, Ghost_Y + 2, Ghost_X + 29, Ghost_Y + 29))
			{
				int Args[8];
				Args[0] = 4;
				int lightning[] = "ShockLink";
				int script_num = Game->GetFFCScript(lightning);
				if (CountFFCsRunning(script_num) <= 0) Screen->LoadFFC(RunFFCScript(script_num, Args));
			}
		}
		if (!Ghost_Waitframe(this, ghost, false, false)) //Defeat animation/string.
		{
			Ghost_HP = 1;
			Screen->Message(Agahnim1DefeatString);
			Ghost_Waitframe(this, ghost, false, false);
			int NiceData = this->Data;
			Ghost_Data = GH_INVISIBLE_COMBO;
			for (int i = 0; i <= 16; i+=0.5)
			{
				Screen->DrawCombo(3, Ghost_X + i, Ghost_Y - (i * 2), NiceData, 2, 2, 7, 32 - (i * 2), 32 + (i * 2), 0, 0, 0, -1, 0, true, OP_OPAQUE);
				Ghost_Waitframe(this, ghost, false, false);
			}
			for (int i = 30; i > 0; i--)
			{
				Ghost_Waitframe(this, ghost, true, true);
			}
			Ghost_HP = 0;
			Ghost_X = -32;
			Ghost_Y = -32;
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}

ffc script WizardBall
{
	void run(int Type)
	{
		eweapon Ball = Screen->CreateEWeapon(EW_SCRIPT2);
		lweapon Ball2;
		Ball->UseSprite(104);
		Ball->X = this->X;
		Ball->Y = this->Y;
		Ball->Step = 200;
		Ball->Angle = DegtoRad(Angle(Ball->X, Ball->Y, Link->X, Link->Y));
		Ball->Angular = true;
		Ball->Damage = 4;
		bool Reflected = false;
		int Counter = 0;
		//int PhantomX[25];
		//int PhantomY[25];
		//for (int l = 0; l < 25; l++)
		//{
		//	PhantomX[l] = Ball->X;
		//	PhantomY[l] = Ball->Y;
		//}
		while(Ball->isValid())
		{
			this->X = Ball->X;
			this->Y = Ball->Y;
			if (Type == 0)
			{
				Counter++;
				Counter%=4;
				if (Counter == 3)
				{
					lweapon Sparkled = Screen->CreateLWeapon(LW_SPARKLE);
					Sparkled->X = Ball->X - Ball->DrawXOffset;
					Sparkled->Y = Ball->Y - Ball->DrawYOffset;
					Sparkled->UseSprite(106);
				}
				//ShiftArray(PhantomX);
				//ShiftArray(PhantomY);
				//PhantomX[0] = Ball->X;
				//PhantomY[0] = Ball->Y;
				//Screen->FastCombo(3, PhantomX[12], PhantomY[12], this->Data - 2, 7, OP_OPAQUE);
				//Screen->FastCombo(3, PhantomX[8], PhantomY[8], this->Data - 1, 7, OP_OPAQUE);
				//Screen->FastCombo(3, PhantomX[4], PhantomY[4], this->Data, 7, OP_OPAQUE);
			}
			Screen->FastCombo(3, this->X, this->Y, this->Data, this->CSet, OP_OPAQUE);
			if (Type == 1)
			{
				if (Screen->isSolid(Ball->X, Ball->Y + 8) || Ball->X - 2 <= 0) Remove(Ball);
				if (Screen->isSolid(Ball->X + 15, Ball->Y + 8) || Ball->X + 18 >= 255) Remove(Ball);
				if (Screen->isSolid(Ball->X + 8, Ball->Y) || Ball->Y -2 <= 0) Remove(Ball);
				if (Screen->isSolid(Ball->X + 8, Ball->Y + 15) || Ball->Y + 18 >= 175) Remove(Ball);
				
				if (Sign(angleDifference(DegtoRad(Ball->Angle), DegtoRad(Angle(Ball->X, Ball->Y, Link->X, Link->Y)))) > 0)
				{
					int Temp = RadtoDeg(Ball->Angle);
					Temp += 0.2;
					Ball->Angle = DegtoRad(Temp);
				}
				else if (Sign(angleDifference(DegtoRad(Ball->Angle), DegtoRad(Angle(Ball->X, Ball->Y, Link->X, Link->Y)))) < 0)
				{
					int Temp = RadtoDeg(Ball->Angle);
					Temp -= 0.2;
					Ball->Angle = DegtoRad(Temp);
				}
			}
			if (LinkCollision(Ball) && Type == 2)
			{
				int Args[8];
				Args[0] = 4;
				int lightning[] = "ShockLink";
				int script_num = Game->GetFFCScript(lightning);
				if (CountFFCsRunning(script_num) <= 0) Screen->LoadFFC(RunFFCScript(script_num, Args));
			}
			if (LinkCollision(Ball) && Type == 3)
			{
				Remove(Ball);
				int Args[8];
				Args[0] = 32;
				Args[1] = 450;
				int lightning[] = "FrostCircle";
				int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
				ffc meh = Screen->LoadFFC(RunFFCScript(script_num, Args));
				meh->X = this->X;
				meh->Y = this->Y;
				Game->PlaySound(SFX_ICE);
				this->Data = 0;
				this->Script = 0;
				Quit();
			}
			for(int i = Screen->NumLWeapons(); i > 0; i--)
			{
				lweapon Loaded = Screen->LoadLWeapon(i);
				if ((Loaded->ID == LW_SWORD || Loaded->ID == LW_SCRIPT3) && SquareCollision(Loaded->X + 2, Loaded->Y + 2, 12, Ball->X + 2, Ball->Y + 2, 12))
				{
					if (Link->Action != LA_CHARGING)
					{
						if (Type == 0 )
						{
							Remove(Ball);
							Ball2 = Screen->CreateLWeapon(LW_SCRIPT5);
							Ball2->UseSprite(104);
							Ball2->X = this->X;
							Ball2->Y = this->Y;
							Ball2->Step = 200;
							Ball2->Angle = DegtoRad(Angle(Link->X, Link->Y, Ball2->X, Ball2->Y));
							Ball2->Angular = true;
							Ball2->Damage = 4;
							Reflected = true;
							Game->PlaySound(84);
						}
						else if (Type == 1)
						{
							FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(90), 200, 4, 103, 32, EWF_UNBLOCKABLE);
							FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(30), 200, 4, 103, 32, EWF_UNBLOCKABLE);
							FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(150), 200, 4, 103, 32, EWF_UNBLOCKABLE);
							FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(210), 200, 4, 103, 32, EWF_UNBLOCKABLE);
							FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(270), 200, 4, 103, 32, EWF_UNBLOCKABLE);
							FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(330), 200, 4, 103, 32, EWF_UNBLOCKABLE);
							
							Remove(Ball);
							this->Data = 0;
							this->Script = 0;
							Quit();
						}
						else if (Type == 3)
						{
							Remove(Ball);
							int Args[8];
							Args[0] = 32;
							Args[1] = 450;
							int lightning[] = "FrostCircle";
							int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
							ffc meh = Screen->LoadFFC(RunFFCScript(script_num, Args));
							meh->X = this->X;
							meh->Y = this->Y;
							Game->PlaySound(SFX_ICE);
							this->Data = 0;
							this->Script = 0;
							Quit();
						}
					}
					else if (Type == 2)
					{
						int Args[8];
						Args[0] = 4;
						int lightning[] = "ShockLink";
						int script_num = Game->GetFFCScript(lightning);
						if (CountFFCsRunning(script_num) <= 0) Screen->LoadFFC(RunFFCScript(script_num, Args));
					}
				}
			}
			Waitframe();
		}
		if (Type == 1)
		{
			FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(90), 200, 4, 103, 32, EWF_UNBLOCKABLE);
			FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(30), 200, 4, 103, 32, EWF_UNBLOCKABLE);
			FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(150), 200, 4, 103, 32, EWF_UNBLOCKABLE);
			FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(210), 200, 4, 103, 32, EWF_UNBLOCKABLE);
			FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(270), 200, 4, 103, 32, EWF_UNBLOCKABLE);
			FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad(330), 200, 4, 103, 32, EWF_UNBLOCKABLE);
			this->Data = 0;
			this->Script = 0;
			Quit();
		}
		if (Reflected)
		{
			while(Ball2->isValid())
			{
				this->X = Ball2->X;
				this->Y = Ball2->Y;
				Counter++;
				Counter%=4;
				if (Counter == 3)
				{
					lweapon Sparkled = Screen->CreateLWeapon(LW_SPARKLE);
					Sparkled->X = Ball2->X - Ball2->DrawXOffset;
					Sparkled->Y = Ball2->Y - Ball2->DrawYOffset;
					Sparkled->UseSprite(106);
				}
				//ShiftArray(PhantomX);
				//ShiftArray(PhantomY);
				//PhantomX[0] = Ball2->X;
				//PhantomY[0] = Ball2->Y;
				//Screen->FastCombo(3, PhantomX[12], PhantomY[12], this->Data - 2, 7, OP_OPAQUE);
				//Screen->FastCombo(3, PhantomX[8], PhantomY[8], this->Data - 1, 7, OP_OPAQUE);
				//Screen->FastCombo(3, PhantomX[4], PhantomY[4], this->Data, 7, OP_OPAQUE);
				Screen->FastCombo(3, this->X, this->Y, this->Data, this->CSet, OP_OPAQUE);
				Waitframe();
			}
		}
		this->Data = 0;
		this->Script = 0;
	}
}

ffc script ShockLink
{
	void run(int Damage)
	{
		eweapon wpn;
        int oldLinkX;
        int oldLinkY;
        bool oldLinkInvis;
        bool oldLinkColl;
       
        // Set this so other Bari's don't activate
        this->Misc[BARI_IDX_SHOCKING]=1;
        
        // Remember Link's data
        oldLinkX=Link->X;
        oldLinkY=Link->Y;
        oldLinkInvis=Link->Invisible;
        oldLinkColl=Link->CollDetection;
        
        // Hurt Link, hide him, draw the shock graphic, and play the sound
        Link->HP-=(Damage*4);
        
        Link->Invisible=true;
        Link->CollDetection=false;
        
        lweapon graphic=Screen->CreateLWeapon(LW_SCRIPT1);
        graphic->UseSprite(BARI_WPS_SHOCK);
        graphic->X=Link->X;
        graphic->Y=Link->Y;
        graphic->CollDetection=false;
        graphic->DeadState=BARI_SHOCK_TIME;
        
        Game->PlaySound(BARI_SFX_SHOCK);
        Screen->Quake=Max(Screen->Quake, 30);
                    
        for(int j=0; j<BARI_SHOCK_TIME; j++)
        {
            NoAction();
            Link->X=oldLinkX;
            Link->Y=oldLinkY;
            Waitframe();
                        
            // Make Link visible again if he died
            if(Link->HP<=0)
                Link->Invisible=oldLinkInvis;
        }
                     
        // Unhide Link, stop flashing
        Link->Invisible=oldLinkInvis;
        Link->CollDetection=oldLinkColl;
        this->Misc[BARI_IDX_SHOCKING]=0;
    }
}