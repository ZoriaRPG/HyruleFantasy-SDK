void DEATHWORM(int X, int Y, int WormX, int WormY){
	int Length = SizeOfArray(WormX);
	int OldX = WormX[0];
	int OldY = WormY[0];
	int Step = Round(Distance(X, Y, WormX[0], WormY[0]));
	if(Step>=1){
		for(int i=Length-1; i>Step; i--){
			WormX[i] = WormX[Max(0, i-Step)];
			WormY[i] = WormY[Max(0, i-Step)];
		}
		for(int i=0; i<=Step; i++){
			WormX[i] = X+VectorX(i, Angle(X, Y, OldX, OldY));
			WormY[i] = Y+VectorY(i, Angle(X, Y, OldX, OldY));
		}
	}
	// for(int i=0; i<Length; i++){
		// Screen->PutPixel(6, WormX[i], WormY[i], Cond(i%2==0, 0x01, 0x0F), 0, 0, 0, 128);
	// }
}

void DrawComboOof(int layer, int cx, int cy, int tile, int blockw, int blockh, int cset, int xscale, int yscale, int rx, int ry, int rangle, int frame, int flip, bool transparency, int opacity){
	int w = xscale;
	if(xscale==-1)
		w = blockw*16;
	int h = yscale;
	if(yscale==-1)
		h = blockh*16;
	Screen->DrawCombo(layer, cx-w/2, cy-h/2, tile, blockw, blockh, cset, xscale, yscale, rx-w/2, ry-h/2, rangle, frame, flip, transparency, opacity);
}

void DamageLinkPierce(int Damage){
	Damage*=4;
	if(Link->Item[I_RING3])
		Damage = Damage/8;
	else if(Link->Item[I_RING2])
		Damage = Damage/4;
	else if(Link->Item[I_RING1])
		Damage = Damage/2;
	Link->Action = LA_GOTHURTLAND;
	Link->HP -= Damage;
	Game->PlaySound(SFX_OUCH);
	// eweapon e = FireEWeapon(EW_SCRIPT10, Clamp(Link->X+InFrontX(Link->Dir, 12), 2, 238), Clamp(Link->Y+InFrontY(Link->Dir, 12), 2, 158), 0, 0, Damage, -1, -1, EWF_UNBLOCKABLE);
	// e->Dir = Link->Dir;
	// e->DrawYOffset = -1000;
	// SetEWeaponLifespan(e, EWL_TIMER, 1);
	// SetEWeaponDeathEffect(e, EWD_VANISH, 0);
}

const int MAX_PUSHY = 4;

void HandlePushArray(int PushArray, int Imprecision){
	for(int i=0; i<MAX_PUSHY&&PushArray[0]<=-1; i++){
		if(CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)){
			Link->X--;
			PushArray[0]++;
		}
		else if(Imprecision>0&&Abs(GridY(Link->Y+8)-Link->Y)<Imprecision&&CanWalk(Link->X, GridY(Link->Y+8), DIR_LEFT, 1, false)){
			Link->Y = GridY(Link->Y+8);
			Link->X--;
			PushArray[0]++;
		}
		else{
			PushArray[0] = 0;
		}
	}
	for(int i=0; i<MAX_PUSHY&&PushArray[0]>=1; i++){
		if(CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)){
			Link->X++;
			PushArray[0]--;
		}
		else if(Imprecision>0&&Abs(GridY(Link->Y+8)-Link->Y)<Imprecision&&CanWalk(Link->X, GridY(Link->Y+8), DIR_RIGHT, 1, false)){
			Link->Y = GridY(Link->Y+8);
			Link->X++;
			PushArray[0]++;
		}
		else{
			PushArray[0] = 0;
		}
	}
	for(int i=0; i<MAX_PUSHY&&PushArray[1]<=-1; i++){
		if(CanWalk(Link->X, Link->Y, DIR_UP, 1, false)){
			Link->Y--;
			PushArray[1]++;
		}
		else if(Imprecision>0&&Abs(GridX(Link->X+8)-Link->X)<Imprecision&&CanWalk(GridX(Link->X+8), Link->Y, DIR_UP, 1, false)){
			Link->X = GridX(Link->X+8);
			Link->Y--;
			PushArray[0]++;
		}
		else{
			PushArray[1] = 0;
		}
	}
	for(int i=0; i<MAX_PUSHY&&PushArray[1]>=1; i++){
		if(CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)){
			Link->Y++;
			PushArray[1]--;
		}
		else if(Imprecision>0&&Abs(GridX(Link->X+8)-Link->X)<Imprecision&&CanWalk(GridX(Link->X+8), Link->Y, DIR_DOWN, 1, false)){
			Link->X = GridX(Link->X+8);
			Link->Y++;
			PushArray[0]++;
		}
		else{
			PushArray[1] = 0;
		}
	}
}

const int SFX_MOLDORM_SKITTER = 79;
const int TIL_LINK_HAMMER = 16202;
const int SFX_HELMASAUR_BLOCK = 58;
const int SFX_HELMASAUR_HURT = 15;
const int SPR_HELMASAUR_MASK_CHUNK = 102;
const int SFX_HELMASAUR_MASK_CHUNK = 81;
const int FFCS_HELMASAUR_FIREBALL = 48;
const int SFX_HELMASAUR_MOUTH = 82;


ffc script Moldorm{
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
		int Spacing[5] = {0, 22, 18, 16, 12};
		int Radius[5] = {14, 10, 10, 5, 0};
		int BounceFrames[5];
		int BounceAngle[5];
		int PushArray[2];
		int Vars[24] = {0, 0, TrackX, TrackY, Spacing, BounceFrames, BounceAngle, PushArray, Radius, -1, 0, 0, 0, 0, 0, 0, 0, 0, 15, 0, Rand(150, 210), 0, 0, 0};
		//MaskState = 16
		//PushCounterMask = 17
		//MaskHP = 18
		//Invulnerability = 19
		//FireCounter = 20
		k = 0;
		Vars[1] = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
		int AfterImageX1[5] = {0, 0, 0, 0, 0};
		int AfterImageY1[5] = {0, 0, 0, 0, 0};
		int AfterImageX2[5] = {0, 0, 0, 0, 0};
		int AfterImageY2[5] = {0, 0, 0, 0, 0};
		int AfterImageX3[5] = {0, 0, 0, 0, 0};
		int AfterImageY3[5] = {0, 0, 0, 0, 0};
		int AfterImageX4[5] = {0, 0, 0, 0, 0};
		int AfterImageY4[5] = {0, 0, 0, 0, 0};
		int AfterImageX5[5] = {0, 0, 0, 0, 0};
		int AfterImageY5[5] = {0, 0, 0, 0, 0};
		int AfterImageX[5] = {AfterImageX1, AfterImageX2, AfterImageX3, AfterImageX4, AfterImageX5}; 
		int AfterImageY[5] = {AfterImageY1, AfterImageY2, AfterImageY3, AfterImageY4, AfterImageY5}; 
		bool SpeedUp = false;
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
					if (Vars[23] > 0) Vars[23] = 0;
				}
				if((VY<0&&!Ghost_CanMove(DIR_UP, 1, 0))||(VY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0)))
				{
					VY = -VY;
					if (Vars[23] > 0) Vars[23] = 0;
				}
				Vars[1] = Angle(0, 0, VX, VY);
				Ghost_MoveAtAngle(Vars[1], 2*Multiplier, 0);
				if (Vars[23] <= 0) Vars[1] = WrapDegrees(Vars[1]+(2*k)*Multiplier);
				do
				{
					if (ghost->Stun > 0) ghost->Stun--;
					Moldorm_Waitframe(this, ghost, tail, Vars, AfterImageX, AfterImageY);
				}while (ghost->Stun > 0 || Vars[20] < 0)
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
	void Moldorm_Waitframe(ffc this, npc ghost, npc tail, int Vars, int AfterImageX, int AfterImageY){
		int i; int j; int k;
		//Trace(1);
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
		Vars[21]++;
		Vars[21]%=4;
		//Trace(2);
		if(Vars[10]>0 && ghost->Stun <= 0 && Vars[20] >= 0){
			if(Vars[11]%8==0){
				Game->PlaySound(SFX_MOLDORM_SKITTER);
			}
			Vars[10]--;
		}
		else if(Vars[11]%12==0 && ghost->Stun <= 0 && Vars[20] >= 0){
			Game->PlaySound(SFX_MOLDORM_SKITTER);
		}
		if(Vars[17]>0){
			if(CanWalk(Link->X, Link->Y, AngleDir4(Angle(Ghost_X + 16, Ghost_Y + 16, Link->X + 8, Link->Y + 8)), VectorX(2, Angle(Ghost_X + 16, Ghost_Y + 16, Link->X + 8, Link->Y + 8)), false)){
				Link->X += VectorX(1.5, Angle(Ghost_X + 16, Ghost_Y + 16, Link->X + 8, Link->Y + 8));
			}
			if(CanWalk(Link->X, Link->Y, AngleDir4(Angle(Ghost_X + 16, Ghost_Y + 16, Link->X + 8, Link->Y + 8)), VectorY(2, Angle(Ghost_X + 16, Ghost_Y + 16, Link->X + 8, Link->Y + 8)), false)){
				Link->Y += VectorY(1.5, Angle(Ghost_X + 16, Ghost_Y + 16, Link->X + 8, Link->Y + 8));
			}
			if (PushArray[0] <= -1) PushArray[0]+=0.5;
			else if (PushArray[0] >= 1) PushArray[0]-=0.5;
			if (PushArray[1] <= -1) PushArray[1]+=0.5;
			else if (PushArray[1] >= 1) PushArray[1]-=0.5;
			if (PushArray[0] > -0.75 && PushArray[0] < 0.75) PushArray[0] = 0;
			if (PushArray[1] > -0.75 && PushArray[1] < 0.75) PushArray[1] = 0;
			Vars[17]--;
		}
		//Trace(3);
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
		//Trace(4);
		for (int i = 4 - Vars[22]; i > 0; i--)
		{
			int XA = AfterImageX[4];
			int YA = AfterImageY[4];
			
			if (Vars[21] == 3)
			{
				XA[Max(0,i)] = XA[Max(0,i-1)];
				YA[Max(0,i)] = YA[Max(0,i-1)];
			}
			if (XA[i] != 0 || YA[i] != 0)
			{
				if (Vars[10] < 5) DrawCombo(2, XA[Max(0,i)], YA[Max(0,i)], Combo-4, 1, 1, 10, -1, -1, 0, 0, 0, -1, 0, true, 64);
				else DrawCombo(2, XA[Max(0,i)], YA[Max(0,i)], Combo+4, 1, 1, 10, -1, -1, 0, 0, 0, -1, 0, true, 64);
			}
		}
		//Trace(5);
		for (int i = 4 - Vars[22] + 1; i < 5; i++)
		{
			int XA = AfterImageX[4];
			int YA = AfterImageY[4];
			
			XA[Max(0,i)] = 0;
			YA[Max(0,i)] = 0;
		}
		//Trace(6);
		if (Vars[16] < 3)
		{
			if (Vars[21] == 3 && (Vars[22] < 5 || Vars[10] > 0))
			{
				int XA = AfterImageX[4];
				int YA = AfterImageY[4];
				
				XA[0] = X;
				YA[0] = Y;
			}
			if (Vars[10] > 0) Vars[22] = 0;
			else if (Vars[10] <= 0 && Vars[21] == 3) Vars[22]++;
		}
		else
		{
			if (Vars[21] == 3)
			{
				if (Vars[22] < 5) Vars[22]++;
			}
		}
		//Trace(7);
		for(int i=3; i>=0; i--){
			Pos -= Spacing[i+1];
			X = TrackX[Pos];
			Y = TrackY[Pos];
			for (int l = 4 - Vars[22]; l > 0; l--)
			{
				int XA = AfterImageX[i];
				int YA = AfterImageY[i];
				
				if (Vars[21] == 3)
				{
					XA[Max(0,l)] = XA[Max(0,l-1)];
					YA[Max(0,l)] = YA[Max(0,l-1)];
					//Trace(XA[Max(0,l)]);
				}
				if (XA[l] != 0 || YA[l] != 0)
				{
					if (Vars[10] < 5) DrawCombo(2, XA[Max(0,l)], YA[Max(0,l)], Combo+i, 2, 2, 10, -1, -1, 0, 0, 0, -1, 0, true, 64);
					else DrawCombo(2, XA[Max(0,l)], YA[Max(0,l)], Combo+i, 2, 2, 10, -1, -1, 0, 0, 0, -1, 0, true, 64);
				}
			}
			for (int l = 4 - Vars[22] + 1; l < 5; l++)
			{
				int XA = AfterImageX[i];
				int YA = AfterImageY[i];
				
				XA[Max(0,l)] = 0;
				YA[Max(0,l)] = 0;
			}
			if (Vars[16] < 3)
			{
				if (Vars[21] == 3 && (Vars[22] < 5 || Vars[10] > 0))
				{
					int XA = AfterImageX[i];
					int YA = AfterImageY[i];
					
					XA[0] = X;
					YA[0] = Y;
				}
			}
		}
		//Trace(8);
		Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4];
		X = TrackX[Pos];
		Y = TrackY[Pos];
		if (Vars[16] < 3)
		{
			if (Vars[10] <= 0) DrawCombo(2, X, Y, Combo-3, 1, 1, CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
			else if (Vars[10] < 5) DrawCombo(2, X, Y, Combo-4, 1, 1, CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
			else DrawCombo(2, X, Y, Combo+4, 1, 1, CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
		}
		else
		{
			if (Vars[10] <= 0) DrawCombo(2, X, Y, Combo-3, 1, 1, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
			else if (Vars[10] < 5) DrawCombo(2, X, Y, Combo-4, 1, 1, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
			else DrawCombo(2, X, Y, Combo+4, 1, 1, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
		}
		//Trace(9);
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
		//Trace(10);
		Pos = Spacing[1]+Spacing[2]+Spacing[3]+Spacing[4];
		for(int i=3; i>=0; i--){
			Pos -= Spacing[i+1];
			X = TrackX[Pos];
			Y = TrackY[Pos];
			if(BounceFrames[i]>0){
				if (Vars[16] < 3) DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 64);
				else DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, 32+4*Sin(BounceFrames[i]*5.625*8), 32+4*Sin(BounceFrames[i]*5.625*8), 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					DrawCombo(2, X, Y, Combo+6, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					if ((Vars[20] < 0 && Vars[20] > -5) || (Vars[20] <= -145 && Vars[20] > -150)) 
					{
						if (Vars[16] < 3) DrawCombo(2, X, Y, Combo-2, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
						else DrawCombo(2, X, Y, Combo+20, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
					}
					else if (Vars[20] <= -5 && Vars[20] > -150) 
					{
						if (Vars[16] < 3) DrawCombo(2, X, Y, Combo-1, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
						else DrawCombo(2, X, Y, Combo+21, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
					}
					if (Vars[16] == 0) DrawCombo(2, X, Y, Combo+5, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					else if (Vars[16] == 1) DrawCombo(2, X, Y, Combo+18, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					else if (Vars[16] == 2) DrawCombo(2, X, Y, Combo+19, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(12+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(12+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+8+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(12+4*Sin(BounceFrames[i]*5.625*8), Angle), Y-8+VectorY(12+4*Sin(BounceFrames[i]*5.625*8), Angle), Combo+8+AngleDir8(Angle), CSet, 128);
				}
				if(BounceFrames[i]>16){
					PushArray[0] += VectorX(3, BounceAngle[i]);
					PushArray[1] += VectorY(3, BounceAngle[i]);
				}
				BounceFrames[i]--;
				Link->HitDir = 8;
			}
			else{
				if (Vars[16] < 3) DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 64);
				else DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
				if(i==0){
					DrawCombo(2, X, Y, Combo+6, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					if ((Vars[20] < 0 && Vars[20] > -5) || (Vars[20] <= -145 && Vars[20] > -150)) 
					{
						if (Vars[16] < 3) DrawCombo(2, X, Y, Combo-2, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
						else DrawCombo(2, X, Y, Combo+20, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
					}
					else if (Vars[20] <= -5 && Vars[20] > -150) 
					{
						if (Vars[16] < 3) DrawCombo(2, X, Y, Combo-1, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
						else DrawCombo(2, X, Y, Combo+21, 3, 3, CSet, 48, 48, X, Y, Vars[1], -1, 0, true, 128);
					}
					if (Vars[16] == 0) DrawCombo(2, X, Y, Combo+5, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					else if (Vars[16] == 1) DrawCombo(2, X, Y, Combo+18, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					else if (Vars[16] == 2) DrawCombo(2, X, Y, Combo+19, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
					Angle = WrapDegrees(Vars[1]-45);
					Screen->FastCombo(2, X-8+VectorX(12, Angle), Y-8+VectorY(12, Angle), Combo+8+AngleDir8(Angle), CSet, 128);
					Angle = WrapDegrees(Vars[1]+45);
					Screen->FastCombo(2, X-8+VectorX(12, Angle), Y-8+VectorY(12, Angle), Combo+8+AngleDir8(Angle), CSet, 128);
				}
				if(Link->Action!=LA_GOTHURTLAND&&Vars[9]==-1&&i<3&&Link->Z <= 8 && Vars[17]<=0){
					if(Distance(CenterLinkX(), CenterLinkY(), X, Y)<Radius[i]){
						Game->PlaySound(SFX_LTTP_BUMPER);
						DamageLinkPierce(ghost->WeaponDamage);
						Link->HitDir = 8;
						BounceFrames[i] = 28;
						BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
						Vars[9] = i;
					}
					else if (Screen->NumLWeapons() > 0)
					{
						lweapon sword = Screen->LoadLWeapon(1);
						if(sword->isValid() && (i > 1 || Vars[16] >= 3)){
							if((sword->ID==LW_SWORD ||sword->ID==LW_SCRIPT3)&&Distance(CenterX(sword), CenterY(sword), X, Y)<Radius[i]+8){
								Game->PlaySound(SFX_LTTP_BUMPER);
								BounceFrames[i] = 28;
								BounceAngle[i] = Angle(X, Y, CenterLinkX(), CenterLinkY());
								Vars[9] = i;
							}
						}
					}
				}
			}
			if (Vars[16] < 3 && Vars[10] <= 0)
			{
				if(Vars[11]%8==0 && i != 0)
				{
					eweapon Flame = FireEWeapon(EW_FIREBALL, X + Rand(0, 15) - 16, Y + Rand(0, 15) - 16, DegtoRad(0), 0, 0, 98, 0, EWF_NO_COLLISION);
					SetEWeaponLifespan(Flame, EWL_TIMER, 20);
					SetEWeaponDeathEffect(Flame, EWD_VANISH, 0);
				}
			}
		}
		//Trace(11);
		if(Vars[9]>-1){
			if(BounceFrames[Vars[9]]==0)
				Vars[9] = -1;
		}
		//Trace(12);
		if (Vars[20] > -270 && (Vars[10] <= 0 || Vars[20] < 0))
		{
			if (ghost->Stun <= 0 || Vars[20] == -50)
			{
				Vars[20]--;
			}
			else if (ghost->Stun > 0 && Vars[20] < -50) Vars[20] = -260;
			if (Vars[20] == -50)
			{
				//int Args[8] = {Ghost_X+8+VectorX(12, Vars[1]), Ghost_Y+8+VectorY(12, Vars[1]), ghost->WeaponDamage, Vars[1], 0, 0, 0, 0};
				int Dummy1 = Ghost_X + 8 + VectorX(12, Vars[1]);
				int Dummy2 = Ghost_Y + 8 + VectorY(12, Vars[1]);
				//int Dummy3 = Vars[1];
				int Dummy3 = Angle(Ghost_X + 8 + VectorX(12, Vars[1]), Ghost_Y + 8 + VectorY(12, Vars[1]), Link->X, Link->Y);
				RunFFCScript(48, Dummy1, Dummy2, ghost->WeaponDamage, Dummy3, 0, 0, 0, 0);
			}
		}
		else Vars[20] = Rand(280, 340);
		//Trace(13);
		if (ghost->Stun <= 0 && Vars[23] > 1)
		{
			Vars[1] = Angle(Link->X, Link->Y, Ghost_X+8, Ghost_Y+8);
			Vars[23] = 1;
		}
		//Trace(14);
		for (int p = Screen->NumLWeapons(); p > 0; p--)
		{
			lweapon whistle = Screen->LoadLWeapon(Max(1,p));
			if (whistle->ID == LW_WHISTLE)
			{
				if (Vars[10] <= 0)
				{
					if (Vars[16] >= 3) Ghost_HP = 1;
					else
					{	
						ghost->Stun = 180;
						Vars[10] += 180;
						Vars[23] = 2;
					}
				}
				else 
				{
					Vars[1] = Angle(Ghost_X+8, Ghost_Y+8, Link->X, Link->Y);
					Vars[23] = 1;
					if (Vars[10] <= 0) Vars[10] += 60;
				}
				break;
			}
		}
		//Trace(15);
		HandlePushArray(PushArray, 0);
		MaskCollision(this, ghost, Vars);
		if(!Ghost_Waitframe(this, ghost, false, false)||Ghost_HP<=1){
			Moldorm_DeathAnimation(this, ghost, tail, Vars);
			Quit();
		}
		//Trace(16);
	}
	void Moldorm_DeathAnimation(ffc this, npc ghost, npc tail, int Vars){
		ghost->HP = 1;
		Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
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
		for(m=4; m>=0; m--){
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
					for(i=4; i>=0; i--){
						if(i<4)
								Pos -= Spacing[i+1];
						if(i<=m){
							X = TrackX[Pos];
							Y = TrackY[Pos];
							if(i<4){
								DrawCombo(2, X, Y, Combo+i, 2, 2, CSet, -1, -1, 0, 0, 0, -1, 0, true, 128);
								if(i==0){
									DrawCombo(2, X, Y, Combo+6, 2, 2, CSet, 32, 32, X, Y, Vars[1], -1, 0, true, 128);
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
			if (m == 0)
			{
				npc Moldrum1 = CreateNPCAt(314, Ghost_X, Ghost_Y - 8);
				npc Moldrum2 = CreateNPCAt(314, Ghost_X - 8, Ghost_Y + 8);
				npc Moldrum3 = CreateNPCAt(314, Ghost_X + 8, Ghost_Y + 8);
				Moldrum1->Misc[0] = 1;
				Moldrum2->Misc[0] = 2;
				Moldrum3->Misc[0] = 3;
			}
		}
		Ghost_WaitframeLight(this, ghost);
		__DeathAnimEnd(this, ghost);
	}
	
	void MaskCollision(ffc this, npc ghost, int Vars)
	{
		if (Vars[19] > 0) Vars[19]--;
		if (Vars[16] < 3)
		{
			int ShieldOffset = 0;
			if (Link->Item[37] == true) ShieldOffset = 780;
			else if (Link->Item[8] == true) ShieldOffset = 520;
			else if (Link->Item[93] == true) ShieldOffset = 260;
			for(int i=1; i<=Screen->NumLWeapons(); i++)
			{
				lweapon l = Screen->LoadLWeapon(Max(1,i));
				if((l->ID==LW_HAMMER||l->ID==LW_SWORD||l->ID==LW_SCRIPT3||l->ID==LW_WAND) && RectCollision(l->X + 1, l->Y + 1, l->X + 14, l->Y + 14, Ghost_X + 2, Ghost_Y + 2, Ghost_X + 29, Ghost_Y + 29) && Link->Tile == (TIL_LINK_HAMMER + ShieldOffset + (Link->Dir * 3)) && Vars[19] <= 0)
				{
					Game->PlaySound(SFX_HELMASAUR_BLOCK);
					if(l->ID==LW_HAMMER){
						Vars[18]--;
						Vars[19] = 20;
						Vars[17] = 15;
						Vars[10] += 150;
						Game->PlaySound(SFX_HELMASAUR_HURT);
					}
					else if (Vars[20] >= 0 && ghost->Stun <= 0)
					{
						Vars[1] += 180;
						Vars[1] %= 360;
						Vars[19] = 10;
						Vars[17] = 10;
					}
				}
				else if((l->ID==LW_BOMBBLAST||l->ID==LW_SBOMBBLAST)&&RectCollision(l->X+2, l->Y+2, l->X+14, l->Y+14, Ghost_X + 2, Ghost_Y + 2, Ghost_X + 29, Ghost_Y + 29)&&Vars[19]<=0){
					Vars[19] = 40;
					Vars[18] -= 4;
					Vars[10] += 300;
					Game->PlaySound(SFX_HELMASAUR_BLOCK);
					Game->PlaySound(SFX_HELMASAUR_HURT);
				}
			}
			if(Vars[18] < 14 && Vars[16] == 0){
				Vars[16] = 1;
				eweapon e = FireEWeapon(EW_SCRIPT10, Ghost_X+10, Ghost_Y+8, DegtoRad(180+Rand(-20, 20)), 150, 0, SPR_HELMASAUR_MASK_CHUNK, SFX_HELMASAUR_MASK_CHUNK, 0);
				e->CollDetection = false;
				SetEWeaponMovement(e, EWM_THROW, 3, EWMF_DIE);
				SetEWeaponDeathEffect(e, EWD_VANISH, 0);
			}
			else if(Vars[18] < 8 && Vars[16] == 1){
				Vars[16] = 2;
				eweapon e = FireEWeapon(EW_SCRIPT10, Ghost_X+19, Ghost_Y+8, DegtoRad(Rand(-20, 20)), 150, 0, SPR_HELMASAUR_MASK_CHUNK, SFX_HELMASAUR_MASK_CHUNK, 0);
				e->CollDetection = false;
				SetEWeaponMovement(e, EWM_THROW, 3, EWMF_DIE);
				SetEWeaponDeathEffect(e, EWD_VANISH, 0);
			}
			else if(Vars[18] < 1 && Vars[16] == 2){
				Vars[16] = 3;
				int ShardX[8] = {0, 8, 16, 0, 8, 16, 4, 12};
				int ShardY[8] = {0, 0, 0, 8, 8, 8, 16, 16};
				int ShardA[8] = {-135+Rand(-20, 20), -90+Rand(-20, 20), -45+Rand(-20, 20), 180+Rand(-20, 20), -90+Rand(-20, 20), Rand(-20, 20), 160+Rand(-20, 20), 30+Rand(-20, 20)};
				int ShardS[8] = {150, 150, 150, 150, 50, 150, 150, 150};
				for(int i=0; i<8; i++){
					eweapon e = FireEWeapon(EW_SCRIPT10, Ghost_X+ShardX[i], Ghost_Y+ShardY[i], DegtoRad(ShardA[i]), ShardS[i], 0, SPR_HELMASAUR_MASK_CHUNK, SFX_HELMASAUR_MASK_CHUNK, 0);
					e->CollDetection = false;
					SetEWeaponMovement(e, EWM_THROW, 3, EWMF_DIE);
					SetEWeaponDeathEffect(e, EWD_VANISH, 0);
				}
			}
		}
	}	
}

ffc script Helmasaur_Fireballs{
	void run(int X, int Y, int Damage, int Angle){
		eweapon Main = FireEWeapon(EW_SCRIPT10, X, Y, DegtoRad(Angle), 0, Damage, 17, SFX_FIREBALL, EWF_UNBLOCKABLE);
		for(int i=0; i<30; i++){
			Main->DeadState = -1;
			Waitframe();
		}
		if(Main->isValid())
			Main->Step = 200;
		Waitframes(16);
		if(Main->isValid())
			Main->Step = 0;
		Waitframes(10);
		if(Main->isValid()){
			eweapon Split[3];
			int Offset = Choose(Angle-90, Angle+30, Angle+150);
			for(int i=0; i<3; i++){
				Split[i] = FireEWeapon(EW_SCRIPT10, Main->X, Main->Y, DegtoRad(Offset+120*i), 200, Damage, 17, SFX_FIREBALL, EWF_UNBLOCKABLE);
			}
			Main->DeadState = 0;
			Waitframes(24);
			for(int i=0; i<3; i++){
				if(Split[i]->isValid()){
					Split[i]->Step = 0;
					SetEWeaponDeathEffect(Split[i], EWD_4_FIREBALLS_RANDOM, SP_FIREBALL);
				}
			}
			Waitframes(60);
			for(int i=0; i<3; i++){
				if(Split[i]->isValid()){
					SetEWeaponLifespan(Split[i], EWL_TIMER, 1);
					Waitframes(40);
				}
			}
		}
	}
}

int RunFFCScript(int scriptNum, int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7)
{
    // Invalid script
    if(scriptNum<0 || scriptNum>511)
        return 0;
    
    ffc theFFC;
    
    // Find an FFC not already in use
    for(int i=FFCS_MIN_FFC; i<=FFCS_MAX_FFC; i++)
    {
        theFFC=Screen->LoadFFC(i);
        
        if(theFFC->Script!=0 ||
         (theFFC->Data!=0 && theFFC->Data!=FFCS_INVISIBLE_COMBO) ||
         theFFC->Flags[FFCF_CHANGER])
            continue;
        
        // Found an unused one; set it up
        theFFC->Data=FFCS_INVISIBLE_COMBO;
        theFFC->Script=scriptNum;
        
        if(arg0!=NULL)
        {
            theFFC->InitD[0]=arg0;
        }
		if(arg1!=NULL)
        {
            theFFC->InitD[1]=arg1;
        }
		if(arg2!=NULL)
        {
            theFFC->InitD[2]=arg2;
        }
		if(arg3!=NULL)
        {
            theFFC->InitD[3]=arg3;
        }
		if(arg4!=NULL)
        {
            theFFC->InitD[4]=arg4;
        }
		if(arg5!=NULL)
        {
            theFFC->InitD[5]=arg5;
        }
		if(arg6!=NULL)
        {
            theFFC->InitD[6]=arg6;
        }
		if(arg7!=NULL)
        {
            theFFC->InitD[7]=arg7;
        }
        
        return i;
    }
    
    // No FFCs available
    return 0;
}