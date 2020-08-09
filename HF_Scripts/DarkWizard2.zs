const int Agahnim2IntroString = 127;
const int Agahnim2DefeatString = 129;

const int AGAHNIM2_PHASECHANGE_THRESHHOLD = 0.6;

ffc script DarkWizardAgainahnim{
	void run(int enemyid){
		int i; int j; int k;
		
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
		int Fakeoutcounter[3];
		int Fakeoutmax = 0;
		int MaxHP = Ghost_HP;
		Ghost_X = 112;
		Ghost_Y = 32;
		npc clone[2];
		for(i=0; i<2; i++){
			clone[i] = CreateNPCAt(NPC_ENEMYFIRE, Ghost_X, Ghost_Y);
			clone[i]->HP = 1000;
			clone[i]->DrawYOffset = -1000;
			clone[i]->TileWidth = 32;
			clone[i]->TileHeight = 32;
			clone[i]->HitWidth = 32;
			clone[i]->HitHeight = 32;
			Ghost_SetAllDefenses(clone[i], NPCDT_IGNORE);
		}
		int cloneData[2] = {FireData, FireData};
		int vars[16] = {cloneData, MaxHP};
		ghost->CollDetection = false; //no free hits on Link while doing this.
		clone[0]->CollDetection = false;
		clone[1]->CollDetection = false;
		while (Screen->NumNPCs() > 3) Ghost_Waitframe(this, ghost);
		Game->PlaySound(9);
		Screen->ComboD[7]++;
		Screen->ComboD[23]++;
		Screen->ComboD[151]++;
		Screen->ComboD[167]++;
		Screen->ComboD[8]++;
		Screen->ComboD[24]++;
		Screen->ComboD[152]++;
		Screen->ComboD[168]++;
		while (Distance(Link->X, Link->Y, 120, 128) > 20 && Link->Y <= 130) Ghost_Waitframe(this, ghost);
		if (Link->Y > 128) Link->Y = 128;
		Game->PlaySound(9);
		Screen->ComboD[7]--;
		Screen->ComboD[23]--;
		Screen->ComboD[151]--;
		Screen->ComboD[167]--;
		Screen->ComboD[8]--;
		Screen->ComboD[24]--;
		Screen->ComboD[152]--;
		Screen->ComboD[168]--;
		
		for (i = 45; i > 0; i--)
		{
			Ghost_Waitframe(this, ghost);
		}
		int enh[] = "Priest of the Dark Order (LOZ-ALTTP).spc";
		if (!Game->PlayEnhancedMusic(enh, 1)) Game->PlayMIDI(41);
		for (i = 16; i > 0; i-=0.5) //Teleport in animation
		{
			Screen->DrawCombo(3, 112 + i, 32 - (i * 2), FireData + 1, 2, 2, 7, 32 - (i * 2), 32 + (i * 2), 0, 0, 0, -1, 0, true, OP_OPAQUE);
			Ghost_Waitframe(this, ghost);
		}
		Ghost_Data = FireData; //Ghost draws him now
		Ghost_Dir = DIR_DOWN;
		ghost->CollDetection = true; //no free hits on Link while doing this.
		clone[0]->CollDetection = true;
		clone[1]->CollDetection = true;
		for (i = 30; i > 0; i--) //30 frame wait
		{
			D2_Waitframe(this, ghost, clone, vars);
		}
		Screen->Message(Agahnim2IntroString); //SPEAK, MY CREATION!
		if (true)
		{
			int Args[8];
			Args[0] = 33;
			Args[1] = 1;
			int lightning[] = "BossMusicBeatableOnly";
			int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
			Screen->LoadFFC(RunFFCScript(script_num, Args));
		}
		for (i = 30; i > 0; i--) //30 frames pass by
		{
			D2_Waitframe(this, ghost, clone, vars);
		}
		int targetX[3];
		int targetY[3];
		while(Ghost_HP>MaxHP*AGAHNIM2_PHASECHANGE_THRESHHOLD) //Main while loop
		{
			int Attack[3];
			if (Fakeoutcounter[0] < Fakeoutmax) //Agahnim can only use so many "fake out attacks" (or non-reflect ball attacks) before he's forced
			{								 //to use a reflect ball. This "limit" loosens as the fight goes on.
				Attack[0] = Choose(1, 1, 2); //He'll only start using the lightning ball attack at half health.
				if (Attack[0] == 1) Fakeoutcounter[0] = 0; //If he uses the reflect ball, reset the counter.
				else Fakeoutcounter[0]++;
			}
			else //Force him to use reflect ball
			{
				Attack[0] = 1;
				Fakeoutcounter[0] = 0;
			}
			if (Fakeoutcounter[1] < Fakeoutmax) //Agahnim can only use so many "fake out attacks" (or non-reflect ball attacks) before he's forced
			{								 //to use a reflect ball. This "limit" loosens as the fight goes on.
				Attack[1] = Choose(1, 2, 2); //He'll only start using the lightning ball attack at half health.
				if (Attack[1] == 1) Fakeoutcounter[1] = 0; //If he uses the reflect ball, reset the counter.
				else Fakeoutcounter[1]++;
			}
			else //Force him to use reflect ball
			{
				Attack[1] = 1;
				Fakeoutcounter[1] = 0;
			}
			if (Fakeoutcounter[2] < Fakeoutmax) //Agahnim can only use so many "fake out attacks" (or non-reflect ball attacks) before he's forced
			{								 //to use a reflect ball. This "limit" loosens as the fight goes on.
				Attack[2] = Choose(1, 2, 2); //He'll only start using the lightning ball attack at half health.
				if (Attack[2] == 1) Fakeoutcounter[2] = 0; //If he uses the reflect ball, reset the counter.
				else Fakeoutcounter[2]++;
			}
			else //Force him to use reflect ball
			{
				Attack[2] = 1;
				Fakeoutcounter[2] = 0;
			}
			D2_FindTargets(this, ghost, clone, vars, targetX, targetY, 99);
			Game->PlaySound(85); //dash sound
			ghost->CollDetection = false; //no free hits on Link while doing this.
			clone[0]->CollDetection = false;
			clone[1]->CollDetection = false;
			Ghost_Data = FireData;
			cloneData[0] = FireData;
			cloneData[1] = FireData;
			while(!D2_MoveToPlace(this, ghost, clone, vars, targetX, targetY)){
				DrawCounter++; //Increase draw counter
				DrawCounter%=4; //reset draw counter if too high
				if(DrawCounter == 3){
					DW_DrawTrail(Ghost_X, Ghost_Y, Ghost_Data+Ghost_Dir, this->CSet);
					DW_DrawTrail(clone[0]->X, clone[0]->Y, cloneData[0]+clone[0]->Dir, this->CSet);
					DW_DrawTrail(clone[1]->X, clone[1]->Y, cloneData[1]+clone[1]->Dir, this->CSet);
				}
				D2_Waitframe(this, ghost, clone, vars);
			}
			ghost->CollDetection = true; //wouldn't it be funny if this somehow didn't get unset and I was left wondering why he wasn't taking damage
			clone[0]->CollDetection = true;
			clone[1]->CollDetection = true;
			
			if (Ghost_HP <= (MaxHP * 0.7)) Fakeoutmax = 3; //If he's down to his last breath, he can use up to 3 fake outs before before forced to mirror ball
			else if (Ghost_HP <= (MaxHP * 0.8)) Fakeoutmax = 2; //If half health, max 2 fake outs
			else if (Ghost_HP <= (MaxHP * 0.9)) Fakeoutmax = 1; // If only down a quarter, max 1 fake out.
			
			for (i = 30; i > 0; i--)
			{
				D2_Waitframe(this, ghost, clone, vars);
				if (Attack < 3){
					Ghost_Dir = AngleDir8(Angle(Ghost_X + 8, Ghost_Y + 8, Link->X, Link->Y)); //Face Link
					clone[0]->Dir = AngleDir8(Angle(clone[0]->X + 8, clone[0]->Y + 8, Link->X, Link->Y)); //Face Link
					clone[1]->Dir = AngleDir8(Angle(clone[1]->X + 8, clone[1]->Y + 8, Link->X, Link->Y)); //Face Link
				}
			}
			
			Ghost_Data = ChargeData;
			Ghost_Dir = AngleDir8(Angle(Ghost_X + 8, Ghost_Y + 8, Link->X, Link->Y));
			Game->PlaySound(83);
			for (i = 0; i < 272; i+=2)
			{
				if(i==40){
					cloneData[0] = ChargeData;
					Game->PlaySound(83);
				}
				else if(i==80){
					cloneData[1] = ChargeData;
					Game->PlaySound(83);
				}
			
				int j;
				j = Max(0, i);
				if(j==0){
					Ghost_Dir = AngleDir8(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y));
				}
				else if(j<190){
					Ghost_Dir = D2_ChargeAnim(ghost, Ghost_X, Ghost_Y, Ghost_Dir, j);
				}
				else if(j==190){
					int Args[8]; //Attacks are an FFC Script. Script 57 is WizardBall.
					Args[0] = Attack[0] - 1;
					ffc meh = Screen->LoadFFC(RunFFCScript(57, Args)); 
				
					if (Attack[0] == 1)
						meh->Data = BallData + 2; //Set the appearance of the ball.
					else if (Attack[0] == 2)
						meh->Data = BallData + 3;
					else
						meh->Data = BallData + 12;
						
					meh->CSet = 7; //Set CSet.
			
					Ghost_Data = FireData;
					
					Game->PlaySound(84); //Play the firing sound.
			
					D2_PlaceOrb(meh, Ghost_Dir, Ghost_X, Ghost_Y);
				}
				
				j = Max(0, i-40);
				if(j==0){
					clone[0]->Dir = AngleDir8(Angle(clone[0]->X+8, clone[0]->Y+8, Link->X, Link->Y));
				}
				else if(j<190){
					clone[0]->Dir = D2_ChargeAnim(ghost, clone[0]->X, clone[0]->Y, clone[0]->Dir, j);
				}
				else if(j==190){
					int Args[8]; //Attacks are an FFC Script. Script 57 is WizardBall.
					Args[0] = Attack[1] - 1;
					ffc meh = Screen->LoadFFC(RunFFCScript(57, Args)); 
				
					if (Attack[1] == 1)
						meh->Data = BallData + 2; //Set the appearance of the ball.
					else if (Attack[1] == 2)
						meh->Data = BallData + 3;
					else
						meh->Data = BallData + 12;
						
					meh->CSet = 7; //Set CSet.
			
					cloneData[0] = FireData;
					
					Game->PlaySound(84); //Play the firing sound.
			
					D2_PlaceOrb(meh, clone[0]->Dir, clone[0]->X, clone[0]->Y);
				}
				
				j = Max(0, i-80);
				if(j==0){
					clone[1]->Dir = AngleDir8(Angle(clone[1]->X+8, clone[1]->Y+8, Link->X, Link->Y));
				}
				else if(j<190){
					clone[1]->Dir = D2_ChargeAnim(ghost, clone[1]->X, clone[1]->Y, clone[1]->Dir, j);
				}
				else if(j==190){
					int Args[8]; //Attacks are an FFC Script. Script 57 is WizardBall.
					Args[0] = Attack[2] - 1;
					ffc meh = Screen->LoadFFC(RunFFCScript(57, Args)); 
				
					if (Attack[2] == 1)
						meh->Data = BallData + 2; //Set the appearance of the ball.
					else if (Attack[2] == 2)
						meh->Data = BallData + 3;
					else
						meh->Data = BallData + 12;
						
					meh->CSet = 7; //Set CSet.
			
					cloneData[1] = FireData;
					
					Game->PlaySound(84); //Play the firing sound.
			
					D2_PlaceOrb(meh, clone[1]->Dir, clone[1]->X, clone[1]->Y);
				}
				
				D2_Waitframe(this, ghost, clone, vars);
			}
			D2_Waitframe(this, ghost, clone, vars);
			
			while (NumEWeaponsOf(EW_SCRIPT2) > 0 || NumLWeaponsOf(LW_SCRIPT5) > 0) D2_Waitframe(this, ghost, clone, vars);
			
			for (int i = 30; i > 0; i--)
			{
				D2_Waitframe(this, ghost, clone, vars);
			}
		}
		lweapon death = CreateLWeaponAt(LW_SCRIPT10, clone[0]->X+8, clone[0]->Y+8);
		clone[0]->HP = -1000;
		death->UseSprite(23);
		death->ASpeed = 8;
		death->NumFrames = 2;
		death->DeadState = 16;
		Game->PlaySound(SFX_EDEAD);
		
		death = CreateLWeaponAt(LW_SCRIPT10, clone[1]->X+8, clone[1]->Y+8);
		clone[1]->HP = -1000;
		death->UseSprite(23);
		death->ASpeed = 8;
		death->NumFrames = 2;
		death->DeadState = 16;
		Game->PlaySound(SFX_EDEAD);
		
		Fakeoutcounter[0] = 0;
		Fakeoutmax = 3;
		int FireIceLightning = 0;
		while(true){
			int attack;
			if(ThunderCounter<=0){
				ThunderCounter = 5;
				attack = 5;
			}
			else if(Fakeoutcounter[0]<Fakeoutmax){
				attack = Rand(1, 4); //He'll only start using the lightning ball attack at half health.
				if (attack == 1) Fakeoutcounter[0] = 0; //If he uses the reflect ball, reset the counter.
				else Fakeoutcounter[0]++;
			}
			else{
				attack = 1;
				Fakeoutcounter[0] = 0;
			}
			ThunderCounter--;
			
			int LightningDir = -1;
			
			if(attack==5)
				LightningDir = D2_FindTargets(this, ghost, clone, vars, targetX, targetY, -1);
			else if(attack==3)
				LightningDir = D2_FindTargets(this, ghost, clone, vars, targetX, targetY, -2);
			else
				D2_FindTargets(this, ghost, clone, vars, targetX, targetY, 99);
			
			Game->PlaySound(85); //dash sound
			ghost->CollDetection = false; //no free hits on Link while doing this.
			Ghost_Data = FireData;
			
			while(!D2_MoveToPlace(this, ghost, clone, vars, targetX, targetY)){
				DrawCounter++; //Increase draw counter
				DrawCounter%=4; //reset draw counter if too high
				if(DrawCounter == 3){
					DW_DrawTrail(Ghost_X, Ghost_Y, Ghost_Data+Ghost_Dir, this->CSet);
				}
				D2B_Waitframe(this, ghost, vars);
			}
			
			ghost->CollDetection = true; //wouldn't it be funny if this somehow didn't get unset and I was left wondering why he wasn't taking damage
			
			if(attack!=5 && attack !=3){ //Reflect shot
				for (i = 30; i > 0; i--)
				{
					D2B_Waitframe(this, ghost, vars);
					if (attack < 3){
						Ghost_Dir = AngleDir8(Angle(Ghost_X + 8, Ghost_Y + 8, Link->X, Link->Y)); //Face Link
					}
				}
				
				Ghost_Data = ChargeData;
				Ghost_Dir = AngleDir8(Angle(Ghost_X + 8, Ghost_Y + 8, Link->X, Link->Y));
				Game->PlaySound(83);
				for (i = 0; i < 272; i+=2)
				{
				
					int j;
					j = Max(0, i);
					if(j==0){
						Ghost_Dir = AngleDir8(Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y));
					}
					else if(j<190){
						Ghost_Dir = D2_ChargeAnim(ghost, Ghost_X, Ghost_Y, Ghost_Dir, j);
					}
					else if(j==190){
						int Args[8]; //Attacks are an FFC Script. Script 57 is WizardBall.

						ffc meh;
						if (FireIceLightning == 0 || attack < 3)
						{
							if (attack < 3) Args[0] = attack - 1;
							else Args[0] = attack - 2;
							meh = Screen->LoadFFC(RunFFCScript(57, Args)); 
						
							if (attack == 1)
								meh->Data = BallData + 2; //Set the appearance of the ball.
							else if (attack == 2)
								meh->Data = BallData + 3;
							else
								meh->Data = BallData + 12;
								
							meh->CSet = 7; //Set CSet.
						}
						else if (FireIceLightning == 1)
						{
							Args[0] = 8;
							int lightning[] = "FireExplode";
							int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
							meh = Screen->LoadFFC(RunFFCScript(script_num, Args)); 
						}
						else if (FireIceLightning == 2)
						{
							Args[0] = 3;
							meh = Screen->LoadFFC(RunFFCScript(57, Args)); 
						
							meh->Data = BallData + 16;
								
							meh->CSet = 7; //Set CSet.
						}
				
						Ghost_Data = FireData;
						
						Game->PlaySound(84); //Play the firing sound.
				
						D2_PlaceOrb(meh, Ghost_Dir, Ghost_X, Ghost_Y);
					}
					
					D2B_Waitframe(this, ghost, vars);
				}
				D2B_Waitframe(this, ghost, vars);
				
				while (NumEWeaponsOf(EW_SCRIPT2) > 0 || NumLWeaponsOf(LW_SCRIPT5) > 0) D2B_Waitframe(this, ghost, vars);
				
				for (int i = 30; i > 0; i--)
				{
					D2B_Waitframe(this, ghost, vars);
				}
			}
			else if (attack == 5)
			{
				Ghost_Dir = LightningDir;
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
					D2B_Waitframe(this, ghost, vars);
				}
				Ghost_Data = FireData; 
				int Args[8];
				int script_num;
				if (FireIceLightning == 0)
				{
					Args[0] = LightningDir; //Set direction of lightning
					Args[1] = 3;
					int lightning[] = "Lightning";
					script_num = Game->GetFFCScript(lightning); //Lightning is a script.
					FireIceLightning = Choose (1, 2);
				}
				else if (FireIceLightning == 1)
				{
					Args[0] = ghost->WeaponDamage; //Set direction of lightning
					Args[1] = LightningDir;
					int lightning[] = "FireShock";
					script_num = Game->GetFFCScript(lightning); //Lightning is a script.
					FireIceLightning = Choose (0, 2);
				}
				else if (FireIceLightning == 2)
				{
					Args[0] = LightningDir; //Set direction of lightning
					int lightning[] = "IceRing";
					script_num = Game->GetFFCScript(lightning); //Lightning is a script.
					FireIceLightning = Choose (0, 1);
				}
				ffc meh = Screen->LoadFFC(RunFFCScript(script_num, Args)); //Load the lightning script.
				meh->X = Ghost_X + 16;
				meh->Y = Ghost_Y + 16;
				while(meh->InitD[2] < 1) D2B_Waitframe(this, ghost, vars);
				meh->InitD[2] = 0;
				for (int i = 0; i < 30; i+=2) D2B_Waitframe(this, ghost, vars);
				ThunderCounter = 4;
			}
			else if (attack == 3)
			{
				if (Link->X > Ghost_X + 8) Ghost_Data = BallData + 4;
				else Ghost_Data = BallData + 8;
				Ghost_Dir = DIR_DOWN;
				for (int i = 30; i > 0; i--)
				{
					D2B_Waitframe(this, ghost, vars);
				}
				if (FireIceLightning == 0)
				{
					eweapon Home = FireEWeapon(EW_FIREBALL, Ghost_X + 8, Ghost_Y + 8, DegtoRad(90), 125, 4, 105, 13, EWF_UNBLOCKABLE|EWF_NO_COLLISION);
					SetEWeaponMovement(Home, EWM_HOMING, DegtoRad(4), 240);
					SetEWeaponDeathEffect(Home, EWD_RUN_SCRIPT, 58); //Script 58 is LightningCaller
					Home->Misc[0] = BallData + 2;
				}
				else if (FireIceLightning == 1)
				{
					int Args[8];
					Args[0] = 8; //Set direction of lightning
					Args[1] = 8;
					Args[2] = 4;
					Args[3] = 90;
					int lightning[] = "HomingFire";
					int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
					ffc meh = Screen->LoadFFC(RunFFCScript(script_num, Args)); //Load the lightning script.
					D2_PlaceOrb(meh, Ghost_Dir, Ghost_X, Ghost_Y);
				}
				else if (FireIceLightning == 2)
				{
					int lightning[] = "MeteorSwarm";
					int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
					ffc meh = Screen->LoadFFC(RunFFCScript(script_num, 0)); //Load the lightning script.
				}
				for (int i = 30; i > 0; i--)
				{
					D2B_Waitframe(this, ghost, vars);
				}
				Ghost_Data = FireData;
				
				for (int i = 30; i > 0; i--)
				{
					D2B_Waitframe(this, ghost, vars);
				}
			}
			D2B_Waitframe(this, ghost, vars);
		}
	}
	int D2_ChargeAnim(npc ghost, int x, int y, int dir, int i){
		int BallData = ghost->Attributes[10] + 16; //The ball data
		if (dir == DIR_DOWN)
		{
			Screen->FastCombo(3, x - 8 + Max(Floor((i - 30) / 10), 0), y, BallData + 2, 7, OP_OPAQUE);
			Screen->FastCombo(3, x + 24 - Max(Floor((i - 30) / 10), 0), y, BallData + 2, 7, OP_OPAQUE);
		}
		else if (dir == DIR_UP || dir == DIR_RIGHTUP || dir == DIR_LEFTUP)
		{
			Screen->FastCombo(2, x - 8 + Max(Floor((i - 30) / 10), 0), y - 8, BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
			Screen->FastCombo(2, x + 24 - Max(Floor((i - 30) / 10), 0), y - 8, BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
		}
		else if (dir == DIR_LEFT)
		{
			Screen->FastCombo(3, x - 4, y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
			Screen->FastCombo(3, x - 4, y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
		}
		else if (dir == DIR_RIGHT)
		{
			Screen->FastCombo(3, x + 20, y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
			Screen->FastCombo(3, x + 20, y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
		}
		else if (dir == DIR_LEFTDOWN)
		{
			Screen->FastCombo(3, x + 8 - Max(Floor((i - 30) / 20), 0), y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
			Screen->FastCombo(3, x - 8 + Max(Floor((i - 30) / 20), 0), y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
		}
		else if (dir == DIR_RIGHTDOWN)
		{
			Screen->FastCombo(3, x + 8 + Max(Floor((i - 30) / 20), 0), y + 12 - Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
			Screen->FastCombo(3, x + 24 - Max(Floor((i - 30) / 20), 0), y - 4 + Max(Floor((i - 30) / 20), 0), BallData + Min(Floor(i /10), 2), 7, OP_OPAQUE);
		}
		return AngleDir8(Angle(x + 8, y + 8, Link->X, Link->Y));
						
	}
	void D2_PlaceOrb(ffc meh, int dir, int x, int y){
		if (dir == DIR_DOWN)
		{
			meh->X = x + 8;
			meh->Y = y;
		}
		else if (dir == DIR_UP || dir == DIR_RIGHTUP || dir == DIR_LEFTUP)
		{
			meh->X = x + 8;
			meh->Y = y;
		}
		else if (dir == DIR_LEFT)
		{
			meh->X = x - 4;
			meh->Y = y + 8;
		}
		else if (dir == DIR_RIGHT)
		{
			meh->X = x + 20;
			meh->Y = y + 8;
		}
		else if (dir == DIR_LEFTDOWN)
		{
			meh->X = x - 8;
			meh->Y = y + 8;
		}
		else if (dir == DIR_RIGHTDOWN)
		{
			meh->X = x + 24;
			meh->Y = y + 8;
		}
	}
	bool DW_DrawTrail(int x, int y, int cmb, int cs){
		lweapon trail = CreateLWeaponAt(LW_SCRIPT10, x, y);
		trail->Extend = 3;
		trail->TileWidth = 2;
		trail->TileHeight = 2;
		trail->OriginalTile = Game->ComboTile(cmb);
		trail->Tile = trail->OriginalTile;
		trail->CSet = cs;
		trail->DrawYOffset = 0;
		trail->DrawStyle = DS_PHANTOM;
		trail->DeadState = 20;
	}
	bool DW_SwordCollision(lweapon sword, npc ghost){
		return RectCollision(sword->X + 2, sword->Y + 2, sword->X + 13, sword->Y + 13, ghost->X + 2, ghost->Y + 2, ghost->X + 29, ghost->Y + 29);
	}
	int D2_FindTargets(ffc this, npc ghost, npc clone, int vars, int targetX, int targetY, int flag){
		bool validPos;
		
		if(flag==-1){
			int NewDir = 0;
			while(!validPos){
				int pos = Choose(39, 66, 76, 119);
				if(ComboX(pos)!=Ghost_X||ComboY(pos)!=Ghost_Y){
					targetX[0] = ComboX(pos);
					targetY[0] = ComboY(pos);
					if (pos == 39) NewDir = DIR_DOWN;
					else if (pos == 66)
					{
						NewDir = DIR_RIGHT;
						targetY[0]+=8;
					}
					else if (pos == 76) 
					{
						NewDir = DIR_LEFT;
						targetY[0]+=8;
					}
					else NewDir = DIR_UP;
					validPos = true;
				}
				//Waitframe();
			}
			return NewDir;
		}
		if (flag==-2){
			int NewDir = 0;
			while(!validPos){
				int pos = Choose(36, 38, 40, 42);
				if(ComboX(pos)!=Ghost_X||ComboY(pos)!=Ghost_Y){
					targetX[0] = ComboX(pos);
					targetY[0] = ComboY(pos);
					NewDir = DIR_DOWN;
					validPos = true;
				}
			}
			return NewDir;
		}
		//Choose(ComboAt(64, 32), ComboAt(96, 32), ComboAt(128, 32), ComboAt(160, 32));
		
		while(!validPos){
			int pos = Rand(176);
			//Screen->FastCombo(6, ComboX(pos), ComboY(pos), 69, 7, 128);
			if(Screen->ComboF[pos]==flag){
				//Screen->FastCombo(6, ComboX(pos), ComboY(pos), 68, 7, 128);
				if(ComboX(pos)!=Ghost_X||ComboY(pos)!=Ghost_Y){
					targetX[0] = ComboX(pos);
					targetY[0] = ComboY(pos);
					validPos = true;
				}
			}
			//Waitframe();
		}
		
		if(!clone[0]->isValid()||!clone[1]->isValid()){
			return -1;
		}
		
		validPos = false;
		
		while(!validPos){
			int pos = Rand(176);
			//Screen->FastCombo(6, ComboX(pos), ComboY(pos), 69, 8, 128);
			if(Screen->ComboF[pos]==flag){
				//Screen->FastCombo(6, ComboX(pos), ComboY(pos), 68, 8, 128);
				int x = ComboX(pos);
				int y = ComboY(pos);
				if(x!=clone[0]->X||y!=clone[0]->Y){
					if(Abs(x-targetX[0])>16||Abs(y-targetY[0])>16){
						targetX[1] = x;
						targetY[1] = y;
						validPos = true;
					}
				}
			}
			//Waitframe();
		}
		
		validPos = false;
		
		while(!validPos){
			int pos = Rand(176);
			//Screen->FastCombo(6, ComboX(pos), ComboY(pos), 69, 9, 128);
			if(Screen->ComboF[pos]==flag){
				//Screen->FastCombo(6, ComboX(pos), ComboY(pos), 68, 9, 128);
				int x = ComboX(pos);
				int y = ComboY(pos);
				if(x!=clone[1]->X||y!=clone[1]->Y){
					if((Abs(x-targetX[0])>16||Abs(y-targetY[0])>16)&&(Abs(x-targetX[1])>16||Abs(y-targetY[1])>16)){
						targetX[2] = x;
						targetY[2] = y;
						validPos = true;
					}
				}
			}
			//Waitframe();
		}
	}
	bool D2_MoveToPlace(ffc this, npc ghost, npc clone, int vars, int targetX, int targetY){
		bool inPlace[3];
		if(Distance(Ghost_X, Ghost_Y, targetX[0], targetY[0])>3){
			Ghost_MoveAtAngle(Angle(Ghost_X, Ghost_Y, targetX[0], targetY[0]), 3, 0);
		}
		else{
			Ghost_X = targetX[0];
			Ghost_Y = targetY[0];
			inPlace[0] = true;
		}
		
		if(!clone[0]->isValid()||!clone[1]->isValid()){
			return inPlace[0];
		}
		
		for(int i=1; i<3; i++){
			int angle = Angle(clone[i-1]->X, clone[i-1]->Y, targetX[i], targetY[i]);
			int dist = Distance(clone[i-1]->X, clone[i-1]->Y, targetX[i], targetY[i]);
			if(dist>3){
				clone[i-1]->X += VectorX(3, angle);
				clone[i-1]->Y += VectorY(3, angle);
			}
			else{
				clone[i-1]->X = targetX[i];
				clone[i-1]->Y = targetY[i];
				inPlace[i] = true;
			}
		}
		return (inPlace[0]&&inPlace[1]&&inPlace[2]);
	}
	void D2_Draw(ffc this, npc ghost, npc clone, int vars){
		int cloneData = vars[0];
		if(Link->HP>0){
			Screen->DrawCombo(2, clone[0]->X, clone[0]->Y, cloneData[0]+clone[0]->Dir, 2, 2, ghost->CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
			Screen->DrawCombo(2, clone[1]->X, clone[1]->Y, cloneData[1]+clone[1]->Dir, 2, 2, ghost->CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
		}
	}
	void D2_Waitframe(ffc this, npc ghost, npc clone, int vars)
	{
		Ghost_HP = Max(Ghost_HP, vars[1]*AGAHNIM2_PHASECHANGE_THRESHHOLD);
		D2_Draw(this, ghost, clone, vars);
		for (int i = Screen->NumLWeapons(); i > 0; i--) //Shock Link if he attacks Agahnim directly
		{
			lweapon eh = Screen->LoadLWeapon(i);
			if ((eh->ID == LW_SWORD || eh->ID == LW_SCRIPT3) && (DW_SwordCollision(eh, ghost) || DW_SwordCollision(eh, clone[0]) || DW_SwordCollision(eh, clone[1])))
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
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
	void D2B_Waitframe(ffc this, npc ghost, int vars)
	{
		for (int i = Screen->NumLWeapons(); i > 0; i--) //Shock Link if he attacks Agahnim directly
		{
			lweapon eh = Screen->LoadLWeapon(i);
			if ((eh->ID == LW_SWORD || eh->ID == LW_SCRIPT3) && DW_SwordCollision(eh, ghost))
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
			Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
			Screen->Message(Agahnim2DefeatString);
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