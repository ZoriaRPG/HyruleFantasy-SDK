
int AngleDir16(float angle) {
	int angle2 = angle;
	if (angle2 != 0) return ((Round (angle2 / 22.5) + 16) % 16);
	else return 0;
}

void DEATHWORMSTUN(int X, int Y, int WormX, int WormY){
	int Length = SizeOfArray(WormX);
	int OldX = WormX[0];
	int OldY = WormY[0];
	int Step = Max(1, Round(Distance(X, Y, WormX[0], WormY[0])));
	//if(Step>=1){
		for(int i=Length-1; i>Step; i--){
			WormX[i] = WormX[i-Step];
			WormY[i] = WormY[i-Step];
		}
		for(int i=0; i<=Step; i++){
			WormX[i] = X+VectorX(i, Angle(X, Y, OldX, OldY));
			WormY[i] = Y+VectorY(i, Angle(X, Y, OldX, OldY));
		}
	//}
	// for(int i=0; i<Length; i++){
		// Screen->PutPixel(6, WormX[i], WormY[i], Cond(i%2==0, 0x01, 0x0F), 0, 0, 0, 128);
	// }
}

ffc script MiniMoldorm{
	void run(int enemyid){
		int i; int j; int k;
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		//Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		//Ghost_SetFlag(GHF_REDUCED_KNOCKBACK);
		int TailID = ghost->Attributes[0];
		int Combo = ghost->Attributes[10];
		Ghost_Transform(this, ghost, GH_INVISIBLE_COMBO, -1, 1, 1);
		Ghost_SetHitOffsets(ghost, 2, 2, 2, 2);
		ghost->CollDetection = true;
		npc tail = CreateNPCAt(TailID, Ghost_X+8, Ghost_Y+8);
		tail->HP = 1000;
		tail->HitXOffset = 4;
		tail->HitYOffset = 4;
		tail->HitWidth = 8;
		tail->HitHeight = 8;
		npc tail2 = CreateNPCAt(TailID, Ghost_X+8, Ghost_Y+8);
		tail2->HP = 1000;
		int TrackX[120];
		int TrackY[120];
		for(i=0; i<120; i++){
			TrackX[i] = Ghost_X+8;
			TrackY[i] = Ghost_Y+8;
		}
		int Spacing[3] = {0, 12, 10};
		int Radius[3] = {10, 5, 0};
		int Vars[19] = {0, 0, TrackX, TrackY, Spacing, 0, 0, 0, Radius, -1, 0, 0, 0, 0, 0};
		Vars[17] = Ghost_HP;
		k = 0;
		Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
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
				Ghost_MoveAtAngle(Vars[1], ghost->Step / 100, 0);
				if (Vars[16] <= 0) Vars[1] = WrapDegrees(Vars[1]+(2*k)*Multiplier);
				bool StunCount = 0;
				do
				{
				if (Vars[18] > 0) Vars[18]--;
				if (Vars[18] > 4)
				{
					int angled = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
					Ghost_MoveAtAngle(angled, 2, 0);
				}
				Moldorm_Waitframe(this, ghost, tail, Vars, tail2);
				}while (Vars[18] > 0)
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
	void Moldorm_Waitframe(ffc this, npc ghost, npc tail, int Vars, npc tail2){
		int i; int j; int k;
		//Vars[0] = Flash frames
		//Vars[1] = Angle
		int Combo = ghost->Attributes[10];
		int TrackX = Vars[2];
		int TrackY = Vars[3];
		int Spacing = Vars[4];
		int Radius = Vars[8];
		//Vars[9] = Currently Bouncing
		//Vars[10] = Speedup counter
		//Vars[11] = SFX counter;
		Vars[11] = (Vars[11]+1)%360;
		if (false) //Dummy this out...
		{
			if(Vars[10]>0){
				if(Vars[11]%8==0){
					Game->PlaySound(SFX_MOLDORM_SKITTER);
				}
				Vars[10]--;
			}
			else if(Vars[11]%12==0){
				Game->PlaySound(SFX_MOLDORM_SKITTER);
			}
		}
		if (Vars[18] <= 0)DEATHWORM(Ghost_X, Ghost_Y, TrackX, TrackY);
		else
		{
			DEATHWORMSTUN(Ghost_X, Ghost_Y, TrackX, TrackY);
			DEATHWORMSTUN(Ghost_X, Ghost_Y, TrackX, TrackY);
			DEATHWORMSTUN(Ghost_X, Ghost_Y, TrackX, TrackY);
			DEATHWORMSTUN(Ghost_X, Ghost_Y, TrackX, TrackY);
		}
		int Pos = Spacing[1]+Spacing[2];
		int X; int Y; int Angle;
		int CSet = Ghost_CSet;
		if(Vars[0]>0){
			CSet = 9-(Vars[0]>>1);
			Vars[0]--;
		}
		Pos = Spacing[1]+Spacing[2];
		X = TrackX[Pos];
		Y = TrackY[Pos];
		Screen->FastCombo(2, X, Y, Combo+2, CSet, 128);
		if(tail->isValid()){
			tail->DrawYOffset = -1000;
			if(tail->HP<1000 && Vars[0] <= 0){
				ghost->HP = Max(1, Ghost_HP+(tail->HP-1000));
				Vars[17] = Ghost_HP;
				//if (ghost->Attributes[8] <= 0) Vars[1] = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
				Vars[0] = 32;
				Vars[18] = 20;
			}
			tail->X = X-8;
			tail->Y = Y-8;
			tail->HP = 1000;
		}
		Pos = Spacing[1];
		X = TrackX[Pos];
		Y = TrackY[Pos];
		Screen->FastCombo(2, X, Y, Combo+1, CSet, 128);
		if(tail2->isValid()){
			tail2->DrawYOffset = -1000;
			if(tail2->HP<1000 && Vars[0] <= 0){
				ghost->HP = Max(1, Ghost_HP+(tail2->HP-1000));
				Vars[17] = Ghost_HP;
				//if (ghost->Attributes[8] <= 0) Vars[1] = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
				Vars[0] = 32;
				Vars[18] = 20;
			}
			tail2->X = X-8;
			tail2->Y = Y-8;
			tail2->HP = 1000;
		}
		Pos = Spacing[0];
		X = TrackX[Pos];
		Y = TrackY[Pos];
		
		//Screen->DrawInteger	(3, Ghost_X - 8, Ghost_Y - 18, 1, 1, 0, 32, 16, Ghost_HP, 1, OP_OPAQUE);
		Screen->DrawCombo(2, X, Y, Combo, 1, 1, CSet, -1, -1, X, Y, Vars[1], -1, 0, true, 128);
		if(Ghost_HP < Vars[17] && Vars[0] <= 0){
			Ghost_HP = Max(1, Ghost_HP);
			Vars[17] = Ghost_HP;
			//if (ghost->Attributes[8] <= 0) Vars[1] = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
			Vars[0] = 32;
			Vars[18] = 20;
		}
		else if (Ghost_HP < Vars[17]) Ghost_HP = Vars[17];
		
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
		if(!Ghost_Waitframe(this, ghost, false, false)||Ghost_HP<=1){
			tail->HP = 0;
			tail2->HP = 0;
			Ghost_HP = 0;
			Ghost_Waitframe(this, ghost, true, true);
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
	
}