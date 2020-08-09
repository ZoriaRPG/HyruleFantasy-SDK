ffc script Megadorm{
	void run(int enemyid){
		int i; int j; int k;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int TailID = ghost->Attributes[0];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, -1, 3, 3);
		Ghost_SetHitOffsets(ghost, 16, 16, 16, 16);
		ghost->CollDetection = true;
		npc tail = CreateNPCAt(TailID, Ghost_X+8, Ghost_Y+8);
		tail->HP = 1000;
		int TrackX[120];
		int TrackY[120];
		for(i=0; i<120; i++){
			TrackX[i] = Ghost_X+16;
			TrackY[i] = Ghost_Y+16;
		}
		int Spacing[6] = {0, 26, 22, 18, 16, 12};
		int Radius[6] = {19, 14, 10, 10, 5, 0};
		int BounceFrames[6];
		int BounceAngle[6];
		int PushArray[2];
		int Vars[16] = {0, 0, TrackX, TrackY, Spacing, BounceFrames, BounceAngle, PushArray, Radius, -1, 0, 0};
		k = 0;
		Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
		ghost->CollDetection = false;
		//int Step = 100;
		int lastk = 0;
		while(true){
			int Duration = 120;
			int Multiplier = 1;
			if(Vars[10]>0)
				Multiplier = 1.5;
			Duration = 120*Multiplier;
			for(i=0; i<Duration; i++){
				Multiplier = 1;
				if(Vars[10]>0)
					Multiplier = 1.5;
				int Speed = 2; 
				if (ghost->Step > 0) Speed = (ghost->Step / 100);
				int VX = VectorX(2, Vars[1]);
				int VY = VectorY(2, Vars[1]);
				if((VX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0))||(VX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0)))
					VX = -VX;
				if((VY<0&&!Ghost_CanMove(DIR_UP, 1, 0))||(VY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0)))
					VY = -VY;
				Vars[1] = Angle(0, 0, VX, VY);
				Ghost_MoveAtAngle(Vars[1], Speed*Multiplier, 0);
				Vars[1] = WrapDegrees(Vars[1]+(2*k)*Multiplier);
				Moldorm_Waitframe(this, ghost, tail, Vars);
			}
			if(Vars[10]>0)
				k = Rand(-1, 1);
			else
				k = Rand(-2, 2);
			if(lastk==0&&k==0)
				k = Choose(-1, 1);
			lastk = k;
		}
	}
	void Moldorm_Waitframe(ffc this, npc ghost, npc tail, int Vars){
		int i; int j; int k;
		//Vars[0] = Flash frames
		//Vars[1] = Angle
		int Combo = ghost->Attributes[10];
		int TrackX = Vars[2];
		int TrackY = Vars[3];
		int Spacing = Vars[4];
		int BounceFrames = Vars[5];
		int BounceAngle = Vars[6];
		int PushArray = Vars[7];
		int Radius = Vars[8];
		//Vars[9] = Currently Bouncing
		//Vars[10] = Speedup counter
		//Vars[11] = SFX counter;
		Vars[11] = (Vars[11]+1)%360;
		if(Vars[10]>0){
			if(Vars[11]%8==0){
				Game->PlaySound(SFX_MOLDORM_SKITTER);
			}
			Vars[10]--;
		}
		else if(Vars[11]%12==0){
			Game->PlaySound(SFX_MOLDORM_SKITTER);
		}
		DEATHWORM(Ghost_X+16, Ghost_Y+16, TrackX, TrackY);
		int Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5];
		int X; int Y; int Angle;
		int CSet = Ghost_CSet;
		if(Vars[0]>0){
			CSet = 9-(Vars[0]>>1);
			Vars[0]--;
		}
		Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5];
		X = TrackX[Pos];
		Y = TrackY[Pos];
		Screen->FastCombo(2, X-8, Y-8, Combo+5, CSet, 128);
		if(tail->isValid()){
			tail->DrawYOffset = -1000;
			if(tail->HP<1000){
				Ghost_HP = Max(1, Ghost_HP+(tail->HP-1000));
				Vars[0] = 32;
				Vars[10] = 300;
			}
			tail->X = X-8;
			tail->Y = Y-8;
			tail->HP = 1000;
			tail->Stun = 4;
		}
		for(int i=4; i>=0; i--){
			Pos -= Spacing[i+1];
			X = TrackX[Pos];
			Y = TrackY[Pos];
			if(BounceFrames[i]>0){
				if (i > 0) DrawComboMoldorm(2, X, Y, Combo+i, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, 48+4*Sin(BounceFrames[i]*5.625*8), 48+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(15+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(15+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+6+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(15+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(15+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+6+AngleDir8(Angle), CSet, 128);
				}
				if(BounceFrames[i]>16){
					PushArray[0] += VectorX(3, BounceAngle[i]);
					PushArray[1] += VectorY(3, BounceAngle[i]);
				}
				BounceFrames[i]--;
				Link->HitDir = 8;
			}
			else{
				if (i > 0) DrawComboMoldorm(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(15, Angle), Y-8+VectorY(15, Angle), Combo+6+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(15, Angle), Y-8+VectorY(15, Angle), Combo+6+AngleDir8(Angle), CSet, 128);
				}
				if(Link->Action!=LA_GOTHURTLAND&&Vars[9]==-1&&i<3){
					lweapon sword = Screen->LoadLWeapon(1);
					if(Distance(CenterLinkX(), CenterLinkY(), X, Y)<Radius[i]){
						Game->PlaySound(SFX_LTTP_BUMPER);
						DamageLinkPierce(ghost->WeaponDamage);
						Link->HitDir = 8;
						BounceFrames[i] = 32;
						BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
						Vars[9] = i;
					}
					else if(sword->isValid()){
						if(sword->ID==LW_SWORD&&Distance(CenterX(sword), CenterY(sword), X, Y)<Radius[i]+8){
							Game->PlaySound(SFX_LTTP_BUMPER);
							BounceFrames[i] = 32;
							BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
							Vars[9] = i;
						}
					}
				}
			}
		}
		if(Vars[9]>-1){
			if(BounceFrames[Vars[9]]==0)
				Vars[9] = -1;
		}
		HandlePushArray(PushArray, 0);
		if(!Ghost_Waitframe(this, ghost, false, false)||Ghost_HP<=1){
			Moldorm_DeathAnimation(this, ghost, tail, Vars);
			Quit();
		}
	}
	void Moldorm_DeathAnimation(ffc this, npc ghost, npc tail, int Vars){
		__DeathAnimStart(this, ghost);
		__DeathAnimSFX(ghost->ID, ghost->X);
		lweapon explosion;
		int i; int j; int k; int m;
		//Vars[0] = Flash frames
		//Vars[1] = Angle
		int Combo = ghost->Attributes[10];
		int TrackX = Vars[2];
		int TrackY = Vars[3];
		int Spacing = Vars[4];
		int BounceFrames = Vars[5];
		int BounceAngle = Vars[6];
		int PushArray = Vars[7];
		int Radius = Vars[8];
		//Vars[9] = Currently Bouncing
		if(tail->isValid()){
			tail->Y = -32;
			tail->HP = -1000;
		}
		int X; int Y; int Angle; int Dist;
		int CSet = Ghost_CSet;
		for(m=5; m>=0; m--){
			for(k=0; k<4; k++){
				int Pos;
				if(m>0)
					Pos += Spacing[1];
				if(m>1)
					Pos += Spacing[2];
				if(m>2)
					Pos += Spacing[3];
				if(m>3)
					Pos += Spacing[4];
				if(m>4)
					Pos += Spacing[5];
				Angle = Rand(360);
				Dist = Rand(0, Radius[m]);
				X = TrackX[Pos]-8+VectorX(Dist, Angle);
				Y = TrackY[Pos]-8+VectorY(Dist, Angle);
				explosion = CreateLWeaponAt(LW_BOMBBLAST, X, Y);
				explosion->CollDetection = false;
				for(j=0; j<16; j++){
					Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5];
					for(i=5; i>=0; i--){
						if(i<5)
								Pos -= Spacing[i+1];
						if(i<=m){
							X = TrackX[Pos];
							Y = TrackY[Pos];
							if(i<4){
								if (i > 0)DrawComboMoldorm(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								if(i==0){
									Angle = WrapDegrees(Vars[1]-45);
									Screen->FastCombo(2, X-8+VectorX(15, Angle), Y-8+VectorY(15, Angle), Combo+14, CSet, 128);
									Angle = WrapDegrees(Vars[1]+45);
									Screen->FastCombo(2, X-8+VectorX(15, Angle), Y-8+VectorY(15, Angle), Combo+15, CSet, 128);
								}
							}
							else{
								Screen->FastCombo(2, X-8, Y-8, Combo+5, CSet, 128);
							}
						}
					}
					Ghost_WaitframeLight(this, ghost);
				}
			}
		}
		__DeathAnimEnd(this, ghost);
	}
	
}





ffc script Gigadorm{
	void run(int enemyid){
		int i; int j; int k;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int TailID = ghost->Attributes[0];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, -1, 3, 3);
		Ghost_SetHitOffsets(ghost, 12, 12, 12, 12);
		ghost->CollDetection = true;
		npc tail = CreateNPCAt(TailID, Ghost_X+8, Ghost_Y+8);
		tail->HP = 1000;
		int TrackX[200];
		int TrackY[200];
		for(i=0; i<200; i++){
			TrackX[i] = Ghost_X+16;
			TrackY[i] = Ghost_Y+16;
		}
		int Spacing[8] = {0, 32, 28, 24, 22, 18, 16, 12};
		int Radius[8] = {25, 19, 14, 14, 10, 10, 5, 0};
		int BounceFrames[8];
		int BounceAngle[8];
		int PushArray[2];
		int Vars[16] = {0, 0, TrackX, TrackY, Spacing, BounceFrames, BounceAngle, PushArray, Radius, -1, 0, 0};
		k = 0;
		Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
		ghost->CollDetection = false;
		//int Step = 100;
		int lastk = 0;
		while(true){
			int Duration = 120;
			int Multiplier = 1;
			if(Vars[10]>0)
				Multiplier = 1.5;
			Duration = 120*Multiplier;
			for(i=0; i<Duration; i++){
				Multiplier = 1;
				if(Vars[10]>0)
					Multiplier = 1.5;
				int Speed = 2;
				if (ghost->Step > 0) Speed = (ghost->Step / 100);
				int VX = VectorX(2, Vars[1]);
				int VY = VectorY(2, Vars[1]);
				if((VX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0))||(VX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0)))
					VX = -VX;
				if((VY<0&&!Ghost_CanMove(DIR_UP, 1, 0))||(VY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0)))
					VY = -VY;
				Vars[1] = Angle(0, 0, VX, VY);
				Ghost_MoveAtAngle(Vars[1], Speed*Multiplier, 0);
				Vars[1] = WrapDegrees(Vars[1]+(2*k)*Multiplier);
				Moldorm_Waitframe(this, ghost, tail, Vars);
			}
			if(Vars[10]>0)
				k = Rand(-1, 1);
			else
				k = Rand(-2, 2);
			if(lastk==0&&k==0)
				k = Choose(-1, 1);
			lastk = k;
		}
	}
	void Moldorm_Waitframe(ffc this, npc ghost, npc tail, int Vars){
		int i; int j; int k;
		//Vars[0] = Flash frames
		//Vars[1] = Angle
		int Combo = ghost->Attributes[10];
		int TrackX = Vars[2];
		int TrackY = Vars[3];
		int Spacing = Vars[4];
		int BounceFrames = Vars[5];
		int BounceAngle = Vars[6];
		int PushArray = Vars[7];
		int Radius = Vars[8];
		//Vars[9] = Currently Bouncing
		//Vars[10] = Speedup counter
		//Vars[11] = SFX counter;
		Vars[11] = (Vars[11]+1)%360;
		if(Vars[10]>0){
			if(Vars[11]%8==0){
				Game->PlaySound(SFX_MOLDORM_SKITTER);
			}
			Vars[10]--;
		}
		else if(Vars[11]%12==0){
			Game->PlaySound(SFX_MOLDORM_SKITTER);
		}
		DEATHWORM(Ghost_X+16, Ghost_Y+16, TrackX, TrackY);
		int Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5]+Spacing[6]+Spacing[7];
		int X; int Y; int Angle;
		int CSet = Ghost_CSet;
		if(Vars[0]>0){
			CSet = 9-(Vars[0]>>1);
			Vars[0]--;
		}
		Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5]+Spacing[6]+Spacing[7];
		X = TrackX[Pos];
		Y = TrackY[Pos];
		Screen->FastCombo(2, X-8, Y-8, Combo+6, CSet, 128);
		if(tail->isValid()){
			tail->DrawYOffset = -1000;
			if(tail->HP<1000){
				Ghost_HP = Max(1, Ghost_HP+(tail->HP-1000));
				Vars[0] = 32;
				Vars[10] = 300;
			}
			tail->X = X-8;
			tail->Y = Y-8;
			tail->HP = 1000;
			tail->Stun = 4;
		}
		for(int i=6; i>=0; i--){
			Pos -= Spacing[i+1];
			X = TrackX[Pos];
			Y = TrackY[Pos];
			if(BounceFrames[i]>0){
				if (i > 2) DrawComboMoldorm(2, X, Y, Combo+i-1, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else if (i > 1) DrawComboMoldorm(2, X, Y, Combo+i, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, 48+4*Sin(BounceFrames[i]*5.625*8), 48+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(18+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(18+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+7+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(18+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(18+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+7+AngleDir8(Angle), CSet, 128);
				}
				if(BounceFrames[i]>16){
					PushArray[0] += VectorX(3, BounceAngle[i]);
					PushArray[1] += VectorY(3, BounceAngle[i]);
				}
				BounceFrames[i]--;
				Link->HitDir = 8;
			}
			else{
				if (i > 2) DrawComboMoldorm(2, X, Y, Combo+i-1, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else if (i > 1) DrawComboMoldorm(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(18, Angle), Y-8+VectorY(18, Angle), Combo+7+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(18, Angle), Y-8+VectorY(18, Angle), Combo+7+AngleDir8(Angle), CSet, 128);
				}
				if(Link->Action!=LA_GOTHURTLAND&&Vars[9]==-1&&i<6){
					lweapon sword = Screen->LoadLWeapon(1);
					if(Distance(CenterLinkX(), CenterLinkY(), X, Y)<Radius[i]){
						Game->PlaySound(SFX_LTTP_BUMPER);
						DamageLinkPierce(ghost->WeaponDamage);
						Link->HitDir = 8;
						BounceFrames[i] = 32;
						BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
						Vars[9] = i;
					}
					else if(sword->isValid()){
						if(sword->ID==LW_SWORD&&Distance(CenterX(sword), CenterY(sword), X, Y)<Radius[i]+8){
							Game->PlaySound(SFX_LTTP_BUMPER);
							BounceFrames[i] = 32;
							BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
							Vars[9] = i;
						}
					}
				}
			}
		}
		if(Vars[9]>-1){
			if(BounceFrames[Vars[9]]==0)
				Vars[9] = -1;
		}
		HandlePushArray(PushArray, 0);
		if(!Ghost_Waitframe(this, ghost, false, false)||Ghost_HP<=1){
			Moldorm_DeathAnimation(this, ghost, tail, Vars);
			Quit();
		}
	}
	void Moldorm_DeathAnimation(ffc this, npc ghost, npc tail, int Vars){
		__DeathAnimStart(this, ghost);
		__DeathAnimSFX(ghost->ID, ghost->X);
		lweapon explosion;
		int i; int j; int k; int m;
		//Vars[0] = Flash frames
		//Vars[1] = Angle
		int Combo = ghost->Attributes[10];
		int TrackX = Vars[2];
		int TrackY = Vars[3];
		int Spacing = Vars[4];
		int BounceFrames = Vars[5];
		int BounceAngle = Vars[6];
		int PushArray = Vars[7];
		int Radius = Vars[8];
		//Vars[9] = Currently Bouncing
		if(tail->isValid()){
			tail->Y = -32;
			tail->HP = -1000;
		}
		int X; int Y; int Angle; int Dist;
		int CSet = Ghost_CSet;
		for(m=5; m>=0; m--){
			for(k=0; k<4; k++){
				int Pos;
				if(m>0)
					Pos += Spacing[1];
				if(m>1)
					Pos += Spacing[2];
				if(m>2)
					Pos += Spacing[3];
				if(m>3)
					Pos += Spacing[4];
				if(m>4)
					Pos += Spacing[5];
				if(m>5)
					Pos += Spacing[6];
				if(m>6)
					Pos += Spacing[7];
				Angle = Rand(360);
				Dist = Rand(0, Radius[m]);
				X = TrackX[Pos]-8+VectorX(Dist, Angle);
				Y = TrackY[Pos]-8+VectorY(Dist, Angle);
				explosion = CreateLWeaponAt(LW_BOMBBLAST, X, Y);
				explosion->CollDetection = false;
				for(j=0; j<16; j++){
					Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5]+Spacing[6]+Spacing[7];
					for(i=7; i>=0; i--){
						if(i<7)
								Pos -= Spacing[i+1];
						if(i<=m){
							X = TrackX[Pos];
							Y = TrackY[Pos];
							if(i<6){
								if (i > 2)DrawComboMoldorm(2, X, Y, Combo+i - 1, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else if (i > 1)DrawComboMoldorm(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								if(i==0){
									Angle = WrapDegrees(Vars[1]-45);
									Screen->FastCombo(2, X-8+VectorX(18, Angle), Y-8+VectorY(18, Angle), Combo+15, CSet, 128);
									Angle = WrapDegrees(Vars[1]+45);
									Screen->FastCombo(2, X-8+VectorX(18, Angle), Y-8+VectorY(18, Angle), Combo+16, CSet, 128);
								}
							}
							else{
								Screen->FastCombo(2, X-8, Y-8, Combo+6, CSet, 128);
							}
						}
					}
					Ghost_WaitframeLight(this, ghost);
				}
			}
		}
		__DeathAnimEnd(this, ghost);
	}
	
}

ffc script Omegadorm{
	void run(int enemyid){
		int i; int j; int k;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int TailID = ghost->Attributes[0];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, -1, 4, 4);
		Ghost_SetHitOffsets(ghost, 12, 12, 12, 12);
		ghost->CollDetection = true;
		npc tail = CreateNPCAt(TailID, Ghost_X+8, Ghost_Y+8);
		tail->HP = 1000;
		int TrackX[400];
		int TrackY[400];
		for(i=0; i<400; i++){
			TrackX[i] = Ghost_X+16;
			TrackY[i] = Ghost_Y+16;
		}
		int Spacing[11] = {0, 42, 38, 34, 32, 28, 24, 22, 18, 16, 12};
		int Radius[11] = {30, 25, 25, 19, 19, 14, 14, 10, 10, 5, 0};
		int BounceFrames[11];
		int BounceAngle[11];
		int PushArray[2];
		int Vars[16] = {0, 0, TrackX, TrackY, Spacing, BounceFrames, BounceAngle, PushArray, Radius, -1, 0, 0};
		k = 0;
		Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
		ghost->CollDetection = false;
		//int Step = 100;
		int lastk = 0;
		while(true){
			int Duration = 120;
			int Multiplier = 1;
			if(Vars[10]>0)
				Multiplier = 1.5;
			Duration = 120*Multiplier;
			for(i=0; i<Duration; i++){
				Multiplier = 1;
				if(Vars[10]>0)
					Multiplier = 1.5;
				int Speed = 2;
				if (ghost->Step > 0) Speed = (ghost->Step / 100);
				int VX = VectorX(2, Vars[1]);
				int VY = VectorY(2, Vars[1]);
				if((VX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0))||(VX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0)))
					VX = -VX;
				if((VY<0&&!Ghost_CanMove(DIR_UP, 1, 0))||(VY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0)))
					VY = -VY;
				Vars[1] = Angle(0, 0, VX, VY);
				Ghost_MoveAtAngle(Vars[1], Speed*Multiplier, 0);
				Vars[1] = WrapDegrees(Vars[1]+(2*k)*Multiplier);
				Moldorm_Waitframe(this, ghost, tail, Vars);
			}
			if(Vars[10]>0)
				k = Rand(-1, 1);
			else
				k = Rand(-2, 2);
			if(lastk==0&&k==0)
				k = Choose(-1, 1);
			lastk = k;
		}
	}
	void Moldorm_Waitframe(ffc this, npc ghost, npc tail, int Vars){
		int i; int j; int k;
		//Vars[0] = Flash frames
		//Vars[1] = Angle
		int Combo = ghost->Attributes[10];
		int TrackX = Vars[2];
		int TrackY = Vars[3];
		int Spacing = Vars[4];
		int BounceFrames = Vars[5];
		int BounceAngle = Vars[6];
		int PushArray = Vars[7];
		int Radius = Vars[8];
		//Vars[9] = Currently Bouncing
		//Vars[10] = Speedup counter
		//Vars[11] = SFX counter;
		Vars[11] = (Vars[11]+1)%360;
		if(Vars[10]>0){
			if(Vars[11]%8==0){
				Game->PlaySound(SFX_MOLDORM_SKITTER);
			}
			Vars[10]--;
		}
		else if(Vars[11]%12==0){
			Game->PlaySound(SFX_MOLDORM_SKITTER);
		}
		DEATHWORM(Ghost_X+16, Ghost_Y+16, TrackX, TrackY);
		int Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5]+Spacing[6]+Spacing[7]+Spacing[8]+Spacing[9]+Spacing[10];
		int X; int Y; int Angle;
		int CSet = Ghost_CSet;
		if(Vars[0]>0){
			CSet = 9-(Vars[0]>>1);
			Vars[0]--;
		}
		Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5]+Spacing[6]+Spacing[7]+Spacing[8]+Spacing[9]+Spacing[10];
		X = TrackX[Pos];
		Y = TrackY[Pos];
		Screen->FastCombo(2, X-8, Y-8, Combo+7, CSet, 128);
		if(tail->isValid()){
			tail->DrawYOffset = -1000;
			if(tail->HP<1000){
				Ghost_HP = Max(1, Ghost_HP+(tail->HP-1000));
				Vars[0] = 32;
				Vars[10] = 300;
			}
			tail->X = X-8;
			tail->Y = Y-8;
			tail->HP = 1000;
			tail->Stun = 4;
		}
		for(int i=8; i>=0; i--){
			Pos -= Spacing[i+1];
			X = TrackX[Pos];
			Y = TrackY[Pos];
			if(BounceFrames[i]>0){
				if (i > 5) DrawComboMoldorm(2, X, Y, Combo+i-3, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else if (i > 4)DrawComboMoldorm(2, X, Y, Combo+i-2, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else if (i > 3) DrawComboMoldorm(2, X, Y, Combo+i-2, 3, 3, CSet, 48+4*Sin(BounceFrames[i]*5.625*8), 48+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else if (i > 1) DrawComboMoldorm(2, X, Y, Combo+i-1, 3, 3, CSet, 48+4*Sin(BounceFrames[i]*5.625*8), 48+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else if (i > 0) DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, 48+4*Sin(BounceFrames[i]*5.625*8), 48+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				else DrawComboMoldorm(2, X, Y, Combo+i, 4, 4, CSet, 64+4*Sin(BounceFrames[i]*5.625*8), 64+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(18+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(18+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+8+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(21+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(21+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+8+AngleDir8(Angle), CSet, 128);
				}
				if(BounceFrames[i]>16){
					PushArray[0] += VectorX(3, BounceAngle[i]);
					PushArray[1] += VectorY(3, BounceAngle[i]);
				}
				BounceFrames[i]--;
				Link->HitDir = 8;
			}
			else{
				if (i > 5) DrawComboMoldorm(2, X, Y, Combo+i-3, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else if (i > 4) DrawComboMoldorm(2, X, Y, Combo+i-2, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else if (i > 3) DrawComboMoldorm(2, X, Y, Combo+i-2, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else if (i > 1) DrawComboMoldorm(2, X, Y, Combo+i-1, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else if (i > 0) DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				else DrawComboMoldorm(2, X, Y, Combo+i, 4, 4, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(21, Angle), Y-8+VectorY(21, Angle), Combo+8+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(21, Angle), Y-8+VectorY(21, Angle), Combo+8+AngleDir8(Angle), CSet, 128);
				}
				if(Link->Action!=LA_GOTHURTLAND&&Vars[9]==-1&&i<9){
					lweapon sword = Screen->LoadLWeapon(1);
					if(Distance(CenterLinkX(), CenterLinkY(), X, Y)<Radius[i]){
						Game->PlaySound(SFX_LTTP_BUMPER);
						DamageLinkPierce(ghost->WeaponDamage);
						Link->HitDir = 8;
						BounceFrames[i] = 32;
						BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
						Vars[9] = i;
					}
					else if(sword->isValid()){
						if(sword->ID==LW_SWORD&&Distance(CenterX(sword), CenterY(sword), X, Y)<Radius[i]+8){
							Game->PlaySound(SFX_LTTP_BUMPER);
							BounceFrames[i] = 32;
							BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
							Vars[9] = i;
						}
					}
				}
			}
		}
		if(Vars[9]>-1){
			if(BounceFrames[Vars[9]]==0)
				Vars[9] = -1;
		}
		HandlePushArray(PushArray, 0);
		if(!Ghost_Waitframe(this, ghost, false, false)||Ghost_HP<=1){
			Moldorm_DeathAnimation(this, ghost, tail, Vars);
			Quit();
		}
	}
	void Moldorm_DeathAnimation(ffc this, npc ghost, npc tail, int Vars){
		__DeathAnimStart(this, ghost);
		__DeathAnimSFX(ghost->ID, ghost->X);
		lweapon explosion;
		int i; int j; int k; int m;
		//Vars[0] = Flash frames
		//Vars[1] = Angle
		int Combo = ghost->Attributes[10];
		int TrackX = Vars[2];
		int TrackY = Vars[3];
		int Spacing = Vars[4];
		int BounceFrames = Vars[5];
		int BounceAngle = Vars[6];
		int PushArray = Vars[7];
		int Radius = Vars[8];
		//Vars[9] = Currently Bouncing
		if(tail->isValid()){
			tail->Y = -32;
			tail->HP = -1000;
		}
		int X; int Y; int Angle; int Dist;
		int CSet = Ghost_CSet;
		for(m=8; m>=0; m--){
			for(k=0; k<4; k++){
				int Pos;
				if(m>0)
					Pos += Spacing[1];
				if(m>1)
					Pos += Spacing[2];
				if(m>2)
					Pos += Spacing[3];
				if(m>3)
					Pos += Spacing[4];
				if(m>4)
					Pos += Spacing[5];
				if(m>5)
					Pos += Spacing[6];
				if(m>6)
					Pos += Spacing[7];
				if(m>7)
					Pos += Spacing[8];
				if(m>8)
					Pos += Spacing[9];
				if(m>9)
					Pos += Spacing[10];
				Angle = Rand(360);
				Dist = Rand(0, Radius[m]);
				X = TrackX[Pos]-8+VectorX(Dist, Angle);
				Y = TrackY[Pos]-8+VectorY(Dist, Angle);
				explosion = CreateLWeaponAt(LW_BOMBBLAST, X, Y);
				explosion->CollDetection = false;
				for(j=0; j<16; j++){
					Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4]+Spacing[5]+Spacing[6]+Spacing[7]+Spacing[8]+Spacing[9]+Spacing[10];
					for(i=10; i>=0; i--){
						if(i<10)
								Pos -= Spacing[i+1];
						if(i<=m){
							X = TrackX[Pos];
							Y = TrackY[Pos];
							if(i<9){
								if (i > 5) DrawComboMoldorm(2, X, Y, Combo+i-3, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else if (i > 4) DrawComboMoldorm(2, X, Y, Combo+i-2, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else if (i > 3) DrawComboMoldorm(2, X, Y, Combo+i-2, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else if (i > 1) DrawComboMoldorm(2, X, Y, Combo+i-1, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else if (i > 0) DrawComboMoldorm(2, X, Y, Combo+i, 3, 3, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								else DrawComboMoldorm(2, X, Y, Combo+i, 4, 4, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								if(i==0){
									Angle = WrapDegrees(Vars[1]-45);
									Screen->FastCombo(2, X-8+VectorX(12, Angle), Y-8+VectorY(12, Angle), Combo+16, CSet, 128);
									Angle = WrapDegrees(Vars[1]+45);
									Screen->FastCombo(2, X-8+VectorX(12, Angle), Y-8+VectorY(12, Angle), Combo+17, CSet, 128);
								}
							}
							else{
								Screen->FastCombo(2, X-8, Y-8, Combo+7, CSet, 128);
							}
						}
					}
					Ghost_WaitframeLight(this, ghost);
				}
			}
		}
		__DeathAnimEnd(this, ghost);
	}
	
}
