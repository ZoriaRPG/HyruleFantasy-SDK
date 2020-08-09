//import "std.zh"
//import "string.zh"
//import "ghost.zh"

//const int CMB_BLANK = 1;
const int CMB_HOARDER = 10268;

ffc script Hoarder
{
	void run(int enemyID, int placeStyle, int rockCombo, int rockRandom, int placeData1, int placeData2, int detectRadius, int duplicates)
	{
		//Placestyle 0=Set(Remains in position.)
		//1=Random(Random, empty combo. )
		//2=Replace(Replace a random member of specific combo type defined by placeData1, undercombo is placeData2)
		int rockCSet = this->CSet;
		if(detectRadius <= 0) detectRadius = 32;
		if(enemyID == 0) enemyID = 186;
		if (rockCombo == 0) rockCombo = this->Data;
		int rnd = Rand(rockRandom);
		rockCombo = rockCombo + rnd;
		this->Data = this->Data + rnd;
		//Place the combo
		if(placeStyle == 1)
		{
			int startx = this->X;
			int starty = this->Y;
			for(int i = 0; i<=20; i++)
			{
				startx = 16*Rand(3, 12); //15-a
				starty = 16*Rand(3, 7); //10-a
				if (GetLayerComboS(0, startx/16 + starty) == 0000b && GetLayerComboS(1, startx/16 + starty) == 0000b && GetLayerComboS(2, startx/16 + starty) == 0000b)
				{
					this->X = startx;
					this->Y = starty;
					break;
				}
			}
		}
		else if(placeStyle == 2)
		{
			int numcombos = 0;
			int validcombos[176];
			for(int i = 0; i<176; i++)
			{
				if(Screen->ComboD[i] == placeData1)
				{
					validcombos[numcombos] = i;
					numcombos++;
				}
			}
			int targetcombo = validcombos[Rand(numcombos)];
			if (placeData2>0) Screen->ComboD[targetcombo] = placeData2;
			this->X = ComboX(targetcombo);
			this->Y = ComboY(targetcombo);
			
		}
		do{
			Waitframe();
		}while(Distance(Link->X, Link->Y, this->X, this->Y)>detectRadius)
		if ((duplicates - Floor(duplicates)) > 0) 
		{
			this->Data = rockCombo + 1;
		}
		else 
		{
			this->Data = CMB_HOARDER;
			this->CSet = 0;
		}
		for(int i = 0; i<(16 * Max(1, duplicates + 1)); i++)
		{
			for(int l = 0; l <= duplicates; l++)
			{
				if (i >= 16 * l) Screen->FastCombo(3, this->X, this->Y - (Min((Floor(i/2) - (l * 8)), 8)) - (8 * l), rockCombo, rockCSet, 128);
			}
			Waitframe();
		}
		npc ghost = Ghost_InitCreate(this, enemyID);
		if ((duplicates - Floor(duplicates)) > 0) Ghost_Data = ghost->Attributes[10];
		else Ghost_Data = CMB_HOARDER;
		if ((enemyID - Floor(enemyID)) <= 0) Ghost_SetFlag(GHF_KNOCKBACK);
		//Ghost_SetFlag(GHF_STUN);
		if ((enemyID - Floor(enemyID)) <= 0) Ghost_SetFlag(GHF_FULL_TILE_MOVEMENT);
		int counterhoard = 0;
		int GhostCombo = Ghost_Data;
		if (((enemyID - Floor(enemyID)) * 10000) >= 2) Ghost_Data = GH_INVISIBLE_COMBO;
		//Ghost_CSet = 0;
		if ((enemyID - Floor(enemyID)) <= 0) do
		{
			counterhoard = Ghost_ConstantWalk4(counterhoard, 100, 4, 8, 2);
			for(int l = 0; l <= duplicates; l++)
			{
				if (l == 0) Screen->FastCombo(3, Ghost_X, Ghost_Y - 8 - (8 * l), rockCombo, rockCSet, 128);
				else Screen->FastCombo(4, Ghost_X, Ghost_Y - 8 - (8 * l), rockCombo, rockCSet, 128);
			}
		}while(Ghost_Waitframe(this, ghost, true, true))
		else do
		{
			//counterhoard = Ghost_ConstantWalk4(counterhoard, 100, 4, 8, 2);
			if (((enemyID - Floor(enemyID)) * 10000) >= 2) Screen->FastCombo(3, Ghost_X + ghost->DrawXOffset, Ghost_Y + ghost->DrawYOffset, GhostCombo, this->CSet, 128);
			for(int l = 0; l <= duplicates; l++)
			{
				if (l == 0) Screen->FastCombo(3, Ghost_X, Ghost_Y - 8 - (8 * l), rockCombo, rockCSet, 128);
				else Screen->FastCombo(4, Ghost_X, Ghost_Y - 8 - (8 * l), rockCombo, rockCSet, 128);
			}
		}while(Ghost_Waitframe2(this, ghost, true, true))
		
	}
}


//Just import the regular ghost.zh global script, this one only does some extra graphics for the bombs
global script SA
{
	void run()
	{
		StartGhostZH();
		Game->Cheat = 4;
		while(true)
		{
			UpdateGhostZH1();
			for (int i = 1; i <= Screen->NumLWeapons(); i++)
			{
				lweapon wpn = Screen->LoadLWeapon(i);
				if (wpn->ID == LW_BOMBBLAST)
				{
					if (wpn->Misc[3] == 0)
					{
						lweapon wpen = CreateLWeaponAt(LW_SPARKLE, 0, 0);
						wpen->DrawXOffset = wpn->X - 16;
						wpen->DrawYOffset = wpn->Y - 16;
						wpen->UseSprite(90);
						wpen->DeadState = -10;
						wpen->Extend = 3;
						wpen->TileWidth = 3;
						wpen->TileHeight = 3;
						Screen->Quake = 5;
						wpn->Misc[3] = 1;
					}
				}
				if (wpn->ID == LW_SBOMBBLAST)
				{
					if (wpn->Misc[3] == 0)
					{
						lweapon wpen = CreateLWeaponAt(LW_SPARKLE, 0, 0);
						wpen->DrawXOffset = wpn->X - 32;
						wpen->DrawYOffset = wpn->Y - 32;
						wpen->UseSprite(89);
						wpen->DeadState = -10;
						wpen->Extend = 5;
						wpen->TileWidth = 5;
						wpen->TileHeight = 5;
						Screen->Quake = 30;
						wpn->Misc[3] = 1;
					}
				}
			}
			for (int i = 1; i <= Screen->NumEWeapons(); i++)
			{
				eweapon wpn = Screen->LoadEWeapon(i);
				if (wpn->ID == EW_BOMBBLAST)
				{
					if (wpn->Misc[3] == 0)
					{
						lweapon wpen = CreateLWeaponAt(LW_SPARKLE, 0, 0);
						wpen->DrawXOffset = wpn->X - 16;
						wpen->DrawYOffset = wpn->Y - 16;
						wpen->UseSprite(90);
						wpen->DeadState = -10;
						wpen->Extend = 3;
						wpen->TileWidth = 3;
						wpen->TileHeight = 3;
						wpn->Misc[3] = 1;
					}
				}
				if (wpn->ID == EW_SBOMBBLAST)
				{
					if (wpn->Misc[3] == 0)
					{
						lweapon wpen = CreateLWeaponAt(LW_SPARKLE, 0, 0);
						wpen->DrawXOffset = wpn->X - 32;
						wpen->DrawYOffset = wpn->Y - 32;
						wpen->UseSprite(89);
						wpen->DeadState = -10;
						wpen->Extend = 5;
						wpen->TileWidth = 5;
						wpen->TileHeight = 5;
						wpn->Misc[3] = 1;
					}
				}
			}
			Waitdraw();
			UpdateGhostZH2();
			Waitframe();
		}
	}
}




void FireNEWeapons(int weaponID, int x, int y, float initangle, int step, int damage, int sprite, int sound, int flags, int n, float offsetangle)
{
	float angle = initangle;
	for(int i = 0; i < n; i++)
	{
		FireEWeapon(weaponID, x, y, angle, step, damage, sprite, sound, flags);
		angle += offsetangle;
		
	}
}
