void Z3SwordBush()
{
	for (int i = Screen->NumLWeapons(); i > 0; i--)
	{
		lweapon Meh = Screen->LoadLWeapon(i);
		if ((Meh->ID == LW_SCRIPT3 || Meh->ID == LW_BRANG) && Meh->isValid())
		{
			bool FoundBush = false;
			int mx = Meh->X + Meh->HitXOffset + 6;
			int my = Meh->Y + Meh->HitYOffset + 6;
			for(int k = 0; k < 4; k++)
			{
				if (isBush(mx, my))
				{
					CreateGrassClipping(ComboX(ComboAt(mx, my)), ComboY(ComboAt(mx, my)), 21276, 7, 0);
					npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(ComboAt(mx, my)), ComboY(ComboAt(mx, my)));
					n->HP = -1000;
					n->DrawYOffset = -1000;
					FoundBush = true;
				}
				if (isGrass(mx, my))
				{
					CreateGrassClipping(ComboX(ComboAt(mx, my)), ComboY(ComboAt(mx, my)), 21296, 7, 1);
					npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(ComboAt(mx, my)), ComboY(ComboAt(mx, my)));
					n->HP = -1000;
					n->DrawYOffset = -1000;
					FoundBush = true;
				}
				if (isFlower(mx, my))
				{
					CreateGrassClipping(ComboX(ComboAt(mx, my)), ComboY(ComboAt(mx, my)), 21256, 7, 0);
					npc n = CreateNPCAt(NPC_BUSHDROPSET, ComboX(ComboAt(mx, my)), ComboY(ComboAt(mx, my)));
					n->HP = -1000;
					n->DrawYOffset = -1000;
					FoundBush = true;
				}
				if (FoundBush)
				{
					Game->PlaySound(41);
					if ((Screen->ComboF[ComboAt(mx, my)] != 79 && Screen->ComboI[ComboAt(mx, my)] != 79) ||
					(Screen->ComboF[ComboAt(mx, my)] == 94 || Screen->ComboI[ComboAt(mx, my)] == 94 ||
					Screen->ComboF[ComboAt(mx, my)] == 95 || Screen->ComboI[ComboAt(mx, my)] == 95))
					{
						if (isNext(mx, my))
						{
							Screen->ComboD[ComboAt(mx, my)]++;
						}
						else Screen->ComboD[ComboAt(mx, my)] = Screen->UnderCombo;
					}
					else 
					{
						Screen->TriggerSecrets();
						if ((Screen->Flags[SF_SECRETS] & 0010b) == 0) Screen->State[ST_SECRET] = true;
					}
				}
				else if ((Screen->ComboF[ComboAt(mx, my)] == 79 || Screen->ComboI[ComboAt(mx, my)] == 79) &&
				(Screen->ComboF[ComboAt(mx, my)] != 94 && Screen->ComboI[ComboAt(mx, my)] != 94 &&
				Screen->ComboF[ComboAt(mx, my)] != 95 && Screen->ComboI[ComboAt(mx, my)] != 95) && Meh->ID == LW_SCRIPT3)
				{
					Screen->TriggerSecrets();
					if ((Screen->Flags[SF_SECRETS] & 0010b) == 0) Screen->State[ST_SECRET] = true;
				}
				FoundBush = false;
				if (k == 0)
				{
					mx = Meh->X + Meh->HitXOffset + 9;
					my = Meh->Y + Meh->HitYOffset + 6;
				}
				else if (k == 1)
				{
					mx = Meh->X + Meh->HitXOffset + 6;
					my = Meh->Y + Meh->HitYOffset + 9;
				}
				else if (k == 2)
				{
					mx = Meh->X + Meh->HitXOffset + 9;
					my = Meh->Y + Meh->HitYOffset + 9;
				}
			}
		}
	}
}

bool isBush(int x, int y)
{
	if (Screen->ComboT[ComboAt(x,y)] == CT_BUSH || Screen->ComboT[ComboAt(x,y)] == CT_BUSHC ||
	Screen->ComboT[ComboAt(x,y)] == CT_BUSHNEXT || Screen->ComboT[ComboAt(x,y)] == CT_BUSHNEXTC) return true;
	else return false;
}

bool isGrass(int x, int y)
{
	if (Screen->ComboT[ComboAt(x,y)] == CT_TALLGRASS || Screen->ComboT[ComboAt(x,y)] == CT_TALLGRASSC ||
	Screen->ComboT[ComboAt(x,y)] == CT_TALLGRASSNEXT) return true;
	else return false;
}

bool isFlower(int x, int y)
{
	if (Screen->ComboT[ComboAt(x,y)] == CT_FLOWERS || Screen->ComboT[ComboAt(x,y)] == CT_FLOWERSC) return true;
	else return false;
}

bool isNext(int x, int y)
{
	if (Screen->ComboT[ComboAt(x,y)] == CT_TALLGRASSNEXT || Screen->ComboT[ComboAt(x,y)] == CT_BUSHNEXTC ||
	Screen->ComboT[ComboAt(x,y)] == CT_BUSHNEXT) return true;
	else return false;
}

int GrassClippings[1792]; //Slots * 7

void CreateGrassClipping(int x, int y, int gfx, int cset, int type)
{
	int m;
	for (; m < 256; m++)
	{
		if (GrassClippings[m*7] < 0) break;
	}
	m*=7;
	GrassClippings[m] = x;
	GrassClippings[m+1] = y;
	GrassClippings[m+2] = 0;
	GrassClippings[m+3] = 0;
	GrassClippings[m+4] = gfx;
	GrassClippings[m+5] = cset;
	GrassClippings[m+6] = type;
}

void InitGrassClippings()
{
	for (int i = 0; i < 1792; i++) 
	{
		if (GrassClippings[i] == -1) break;
		GrassClippings[i] = -1;
	}
}

void UpdateGrassClippings()
{
	int n;
	for (int i = 0; i < 256;)
	{
		n = i * 7;
		if (GrassClippings[n] >= 0)
		{
			TileAnim_BushAnim(GrassClippings[n] - 8, GrassClippings[n+1], GrassClippings[n+4], GrassClippings[n+5], GrassClippings[n+3], GrassClippings[6]);
			GrassClippings[n+2]++;
			if (GrassClippings[n+2] >= 3)
			{
				GrassClippings[n+2] = 0;
				GrassClippings[n+3]++;
			}
			if (GrassClippings[n+3] >= 8)
			{
				int m;
				for (; m < 256; m++)
				{
					if (GrassClippings[m*7] < 0) break;
				}
				m--;
				m*=7;
				GrassClippings[n] = GrassClippings[m];
				GrassClippings[n+1] = GrassClippings[m+1];
				GrassClippings[n+2] = GrassClippings[m+2];
				GrassClippings[n+3] = GrassClippings[m+3];
				GrassClippings[n+4] = GrassClippings[m+4];
				GrassClippings[n+5] = GrassClippings[m+5];
				GrassClippings[n+6] = GrassClippings[m+6];
				GrassClippings[m] = -1;
				GrassClippings[m+1] = -1;
				GrassClippings[m+2] = -1;
				GrassClippings[m+3] = -1;
				GrassClippings[m+4] = -1;
				GrassClippings[m+5] = -1;
				GrassClippings[m+6] = -1;
			}
			else i++;
		}
		else break;
	}
}

void TileAnim_BushAnim(int x, int y, int tile, int cset, int frame, int type){
	int posX[32] = {16, 6,  20, 14, //Frame 1
					16, 9,  17, 14, //Frame 2
					17, 10, 14, 12, //Frame 3
					17, 11, 15, 11, //Frame 4
					19, 8,  18, 10, //Frame 5
					20, 4,  19, 9,  //Frame 6
					21, 3,  22, 8,  //Frame 7
					14, 1,  16, 7}; //Frame 8
					
					
	int posY[32] = {11, 8,  7,   1, //Frame 1 
					14, 9,  8,  -1, //Frame 2
					16, 10, 10, -2, //Frame 3
					18, 10, 10, -3, //Frame 4
					20, 10, 14, -4, //Frame 5
					21, 10, 14, -6, //Frame 6
					23, 9,  14, -9, //Frame 7
					24, 7,  21, -11};//Frame 8
						
	int flip[32] = {0,  0,  1,  0,  //Frame 1
					0,  0,  1,  0,  //Frame 2
					1,  0,  1,  0,  //Frame 3
					0,  1,  0,  3,  //Frame 4
					0,  1,  0,  0,  //Frame 5
					0,  0,  0,  0,  //Frame 6
					0,  0,  1,  0,  //Frame 7
					1,  1,  0,  0}; //Frame 8
	
	if (type <= 0)
	{
		for(int i=0; i<4; i++){
			Screen->DrawTile(4, x+posX[frame*4+i]-4, y+posY[frame*4+i]-4, tile+i, 1, 1, cset, -1, -1, 0, 0, 0, flip[frame*4+i], true, 128);
		}
	}
	else
	{
		if (frame < 2)
		{
			for(int i=0; i<4; i++){
				Screen->DrawTile(4, x+posX[frame*4+i]-4, y+posY[frame*4+i]-4, tile+i, 1, 1, cset, -1, -1, 0, 0, 0, flip[frame*4+i], true, 128);
			}
		}
		else 
		{
			for(int i=0; i<4; i++){
				Screen->DrawTile(4, x+posX[frame*4+i]-4, y+posY[frame*4+i]-4, tile+i+20, 1, 1, cset, -1, -1, 0, 0, 0, flip[frame*4+i], true, 128);
			}
		}
	}
}

void Vanish()
{
	GenInt[600] = 1;
}

void RunInvisible()
{
	if (GenInt[600] > 0)
	{
		Link->Invisible = true;
		GenInt[600]--;
	}
	else Link->Invisible = false;
}

void Z3SwordGlobalA()
{
	if (Link->SwordJinx <= 0 && (Link->Item[171] || Link->Item[172] || Link->Item[173] || Link->Item[174]) && Link->PressA && (Link->Action == LA_NONE || Link->Action == LA_WALKING))
	{
		int Args[8];
		if (Link->Item[174])
		{
			Args[0] = 16;
			Args[1] = 24455;
			Args[2] = 97;
			Args[3] = 91;
		}
		else if (Link->Item[173])
		{
			Args[0] = 8;
			Args[1] = 24450;
			Args[2] = 96;
			Args[3] = 90;
		}
		else if (Link->Item[172])
		{
			Args[0] = 4;
			Args[1] = 24445;
			Args[2] = 95;
			Args[3] = 89;
		}
		else if (Link->Item[171])
		{
			Args[0] = 2;
			Args[1] = 24440;
			Args[2] = 30;
			Args[3] = 88;
		}
		int sword[] = "Z3Sword";
		int script_num = Game->GetFFCScript(sword);
		if (CountFFCsRunning(script_num) <= 0) RunFFCScript(script_num, Args);
	}
}

item script Z3SwordItem
{
	void run(int damage, int tile)
	{
		int Args[] = {damage, tile, 0, 0, 0, 0, 0, 0};
		int lightning[] = "Z3Sword";
		int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
		RunFFCScript(script_num, Args);
	}
}

ffc script Z3Sword
{
	void run(int damage, int tile, int sfx, int beamspr)
	{
		//Up:    (-4, 0), (-4, 8), (0, 2), (4, 6), (2, 0)
		//Down:  (4, 0), (6, -6), (0, -2), (-2, -6), (-2, 0)
		//Left:  (0, 2), (4, 4), (2, 0), (8, -4), (0, -2)
		//Right: (0, 2), (-4, 4), (-2, 0), (-8, -4), (0, -2)
		
		//Up:    (12, 0), (12, -8), (0, -14), (-12, -10), (-14, 0)
		//Down:  (-12, 0), (-10, 10), (0, 14), (14, 10), (14, 0)
		//Left:  (0, -14), (-12, -12), (-14, 0), (-8, 12), (0, 14)
		//Right: (0, -14), (12, -12), (14, 0), (8, 12), (0, 14)
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 0, 6, OP_OPAQUE);
		WaitNoAction();
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 0, 6, OP_OPAQUE);
		Link->HitDir = -1;
		WaitNoAction();
		lweapon ZSword = Screen->CreateLWeapon(LW_SCRIPT3);
		ZSword->OriginalTile = tile + (Link->Dir * 20);
		ZSword->Tile = tile + (Link->Dir * 20);
		ZSword->DeadState = -1;
		ZSword->Damage = damage;
		ZSword->Dir = Link->Dir;
		ZSword->Step = 0;
		Game->PlaySound(sfx);
		
		int SwordX[5];
		int SwordY[5];
		if (Link->Dir == DIR_UP)
		{	//Up:    (12, 0), (12, -8), (0, -14), (-12, -10), (-14, 0)
			SwordX[0] = 12; SwordX[1] = 12; SwordX[2] = 0; SwordX[3] = -12; SwordX[4] = -14;
			SwordY[0] = 0; SwordY[1] = -8; SwordY[2] = -14; SwordY[3] = -10; SwordY[4] = 0;
		}
		else if (Link->Dir == DIR_DOWN)
		{	//Down:  (-12, 0), (-10, 10), (0, 14), (14, 10), (14, 0)
			SwordX[0] = -12; SwordX[1] = -10; SwordX[2] = 0; SwordX[3] = 14; SwordX[4] = 14;
			SwordY[0] = 0; SwordY[1] = 10; SwordY[2] = 14; SwordY[3] = 10; SwordY[4] = 0;
		}
		else if (Link->Dir == DIR_LEFT)
		{	//Left:  (0, -14), (-12, -12), (-14, 0), (-8, 12), (0, 14)
			SwordX[0] = 0; SwordX[1] = -12; SwordX[2] = -14; SwordX[3] = -8; SwordX[4] = 0;
			SwordY[0] = -14; SwordY[1] = -12; SwordY[2] = 0; SwordY[3] = 12; SwordY[4] = 14;
		}
		else if (Link->Dir == DIR_RIGHT)
		{	//Right: (0, -14), (12, -12), (14, 0), (8, 12), (0, 14)
			SwordX[0] = 0; SwordX[1] = 12; SwordX[2] = 14; SwordX[3] = 8; SwordX[4] = 0;
			SwordY[0] = -14; SwordY[1] = -12; SwordY[2] = 0; SwordY[3] = 12; SwordY[4] = 14;
		}
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[0]; ZSword->DrawXOffset = SwordX[0];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[0]; ZSword->DrawYOffset = SwordY[0];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 0, 6, OP_OPAQUE);
		WaitNoAction();
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[0]; ZSword->DrawXOffset = SwordX[0];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[0]; ZSword->DrawYOffset = SwordY[0];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 0, 6, OP_OPAQUE);
		WaitNoAction();
		
		ZSword->Tile++;
		ZSword->OriginalTile++;
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[1]; ZSword->DrawXOffset = SwordX[1];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[1]; ZSword->DrawYOffset = SwordY[1];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 0, 6, OP_OPAQUE);
		WaitNoAction();
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[1]; ZSword->DrawXOffset = SwordX[1];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[1]; ZSword->DrawYOffset = SwordY[1];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 0, 6, OP_OPAQUE);
		WaitNoAction();
		
		int oofx = 0; int oofy = 0;
		
		if (Link->Dir == DIR_UP) {Link->Y-=2; oofy = 2;}
		if (Link->Dir == DIR_DOWN) {Link->Y+=2; oofy = -2;}
		if (Link->Dir == DIR_LEFT) {Link->X-=2; oofx = 2;}
		if (Link->Dir == DIR_RIGHT) {Link->X+=2; oofx = -2;}
		
		ZSword->Tile++;
		ZSword->OriginalTile++;
		ZSword->X = Link->X + oofx; ZSword->HitXOffset = SwordX[2]; ZSword->DrawXOffset = SwordX[2];
		ZSword->Y = Link->Y + oofy; ZSword->HitYOffset = SwordY[2]; ZSword->DrawYOffset = SwordY[2];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 4, 6, OP_OPAQUE);
		WaitNoAction();
		ZSword->X = Link->X + oofx; ZSword->HitXOffset = SwordX[2]; ZSword->DrawXOffset = SwordX[2];
		ZSword->Y = Link->Y + oofy; ZSword->HitYOffset = SwordY[2]; ZSword->DrawYOffset = SwordY[2];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 4, 6, OP_OPAQUE);
		WaitNoAction();
		ZSword->X = Link->X + oofx; ZSword->HitXOffset = SwordX[2]; ZSword->DrawXOffset = SwordX[2];
		ZSword->Y = Link->Y + oofy; ZSword->HitYOffset = SwordY[2]; ZSword->DrawYOffset = SwordY[2];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 4, 6, OP_OPAQUE);
		WaitNoAction();
		ZSword->X = Link->X + oofx; ZSword->HitXOffset = SwordX[2]; ZSword->DrawXOffset = SwordX[2];
		ZSword->Y = Link->Y + oofy; ZSword->HitYOffset = SwordY[2]; ZSword->DrawYOffset = SwordY[2];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 4, 6, OP_OPAQUE);
		WaitNoAction();
		
		if (Link->Dir == DIR_UP) Link->Y+=2;
		if (Link->Dir == DIR_DOWN) Link->Y-=2;
		if (Link->Dir == DIR_LEFT) Link->X+=2;
		if (Link->Dir == DIR_RIGHT) Link->X-=2;
		
		if (Link->HP >= (Link->MaxHP - 0) && NumLWeaponsOf(LW_BEAM) <= 0)
		{
			lweapon SwBeam = Screen->CreateLWeapon(LW_BEAM);
			SwBeam->Step = 300;
			SwBeam->Dir = Link->Dir;
			SwBeam->X = ZSword->X + ZSword->DrawXOffset;
			SwBeam->Y = ZSword->Y + ZSword->DrawYOffset;
			SwBeam->Damage = Max (2, (damage / 2));
			SwBeam->UseSprite(beamspr);
			Game->PlaySound(2);
		}
		
		ZSword->Tile++;
		ZSword->OriginalTile++;
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[3]; ZSword->DrawXOffset = SwordX[3];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[3]; ZSword->DrawYOffset = SwordY[3]; 
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 8, 6, OP_OPAQUE);
		WaitNoAction();
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[3]; ZSword->DrawXOffset = SwordX[3];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[3]; ZSword->DrawYOffset = SwordY[3];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 8, 6, OP_OPAQUE);
		WaitNoAction();
		
		ZSword->Tile++;
		ZSword->OriginalTile++;
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[4]; ZSword->DrawXOffset = SwordX[4];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[4]; ZSword->DrawYOffset = SwordY[4];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 8, 6, OP_OPAQUE);
		WaitNoAction();
		ZSword->X = Link->X; ZSword->HitXOffset = SwordX[4]; ZSword->DrawXOffset = SwordX[4];
		ZSword->Y = Link->Y; ZSword->HitYOffset = SwordY[4]; ZSword->DrawYOffset = SwordY[4];
		ZSword->DeadState = -1;
		Link->HitDir = -1;
		Vanish();
		Screen->FastCombo(2, Link->X, Link->Y, 10752 + Link->Dir + 8, 6, OP_OPAQUE);
		WaitNoAction();
		
		Remove(ZSword);
		this->Script = 0;
		this->Data = 0;
		Quit();
	}
}