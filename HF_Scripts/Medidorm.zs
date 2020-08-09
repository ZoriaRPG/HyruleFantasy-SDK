

ffc script Medidorm{
	void run(int enemyid){
		int i; int j; int k;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int TailID = ghost->Attributes[0];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, -1, 2, 2);
		Ghost_SetHitOffsets(ghost, 4, 4, 4, 4);
		ghost->CollDetection = true;
		npc tail = CreateNPCAt(TailID, Ghost_X+8, Ghost_Y+8);
		tail->HP = 1000;
		int TrackX[120];
		int TrackY[120];
		for(i=0; i<120; i++){
			TrackX[i] = Ghost_X+16;
			TrackY[i] = Ghost_Y+16;
		}
		int Spacing[5] = {0, 0, 0, 16, 12};
		int Radius[5] = {14, 10, 10, 5, 0};
		int BounceFrames[5];
		int BounceAngle[5];
		int PushArray[2];
		int Vars[17] = {0, 0, TrackX, TrackY, Spacing, BounceFrames, BounceAngle, PushArray, Radius, -1, 0, 0, 0};
		k = 0;
		if (ghost->Misc[0] == 1) Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Ghost_X+8, Ghost_Y);
		else if (ghost->Misc[0] == 2) Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Ghost_X, Ghost_Y+16);
		else if (ghost->Misc[0] == 3) Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Ghost_X + 16, Ghost_Y+16);
		else Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
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
				int VX = VectorX(2, Vars[1]);
				int VY = VectorY(2, Vars[1]);
				if((VX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0))||(VX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0)))
				{
					VX = -VX;
					if (Vars[16] > 0) Vars[16] = 0;
				}
				if((VY<0&&!Ghost_CanMove(DIR_UP, 1, 0))||(VY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0)))
				{
					VY = -VY;
					if (Vars[16] > 0) Vars[16] = 0;
				}
				Vars[1] = Angle(0, 0, VX, VY);
				Ghost_MoveAtAngle(Vars[1], 2*Multiplier, 0);
				if (Vars[16] <= 0) Vars[1] = WrapDegrees(Vars[1]+(2*k)*Multiplier);
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
		int Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4];
		int X; int Y; int Angle;
		int CSet = Ghost_CSet;
		if(Vars[0]>0){
			CSet = 9-(Vars[0]>>1);
			Vars[0]--;
		}
		Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4];
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
		for(int i=3; i>1; i--){
			Pos -= Spacing[i+1];
			X = TrackX[Pos];
			Y = TrackY[Pos];
			if(BounceFrames[i]>0){
				DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				if(i==2){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(8+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(12+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+8+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(8+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(12+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+8+AngleDir8(Angle), CSet, 128);
				}
				if(BounceFrames[i]>16){
					PushArray[0] += VectorX(3, BounceAngle[i]);
					PushArray[1] += VectorY(3, BounceAngle[i]);
				}
				BounceFrames[i]--;
				Link->HitDir = 8;
			}
			else{
				DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				if(i==2){
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(8, Angle), Y-8+VectorY(12, Angle), Combo+8+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(8, Angle), Y-8+VectorY(12, Angle), Combo+8+AngleDir8(Angle), CSet, 128);
				}
				if(Link->Action!=LA_GOTHURTLAND&&Vars[9]==-1&&i<3){
					if(Distance(CenterLinkX(), CenterLinkY(), X, Y)<Radius[i]){
						Game->PlaySound(SFX_LTTP_BUMPER);
						DamageLinkPierce(ghost->WeaponDamage);
						Link->HitDir = 8;
						BounceFrames[i] = 24;
						BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
						Vars[9] = i;
					}
					else if (Screen->NumLWeapons() > 0)
					{
						lweapon sword = Screen->LoadLWeapon(1);
						if(sword->isValid()){
							if(sword->ID==LW_SWORD&&Distance(CenterX(sword), CenterY(sword), X, Y)<Radius[i]+8){
								Game->PlaySound(SFX_LTTP_BUMPER);
								BounceFrames[i] = 24;
								BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
								Vars[9] = i;
							}
						}
					}
				}
			}
		}
		if(Vars[9]>-1){
			if(BounceFrames[Vars[9]]==0)
				Vars[9] = -1;
		}
		for (int p = Screen->NumLWeapons(); p > 0; p--)
		{
			lweapon whistle = Screen->LoadLWeapon(p);
			if (whistle->ID == LW_WHISTLE)
			{
				Vars[1] = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
				Vars[16] = 1;
				break;
			}
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
		for(m=4; m>1; m--){
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
				Angle = Rand(360);
				Dist = Rand(0, Radius[m]);
				X = TrackX[Pos]-8+VectorX(Dist, Angle);
				Y = TrackY[Pos]-8+VectorY(Dist, Angle);
				explosion = CreateLWeaponAt(LW_BOMBBLAST, X, Y);
				explosion->CollDetection = false;
				for(j=0; j<16; j++){
					Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4];
					for(i=4; i>1; i--){
						if(i<4)
								Pos -= Spacing[i+1];
						if(i<=m){
							X = TrackX[Pos];
							Y = TrackY[Pos];
							if(i<4){
								DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								if(i==2){
									Angle = WrapDegrees(Vars[1]-45);
									Screen->FastCombo(2, X-8+VectorX(12, Angle), Y-8+VectorY(12, Angle), Combo+16, CSet, 128);
									Angle = WrapDegrees(Vars[1]+45);
									Screen->FastCombo(2, X-8+VectorX(12, Angle), Y-8+VectorY(12, Angle), Combo+17, CSet, 128);
								}
							}
							else{
								Screen->FastCombo(2, X-8, Y-8, Combo+4, CSet, 128);
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