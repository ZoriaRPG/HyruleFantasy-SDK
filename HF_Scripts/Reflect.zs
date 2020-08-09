ffc script ReflectWater
{
	void run()
	{
		while(true)
		{
			for (int i = Screen->NumLWeapons(); i > 0; i--)
			{
				lweapon l = Screen->LoadLWeapon(i);
				if (l->ID != LW_SWORD && l->ID != LW_SCRIPT3 && l->ID != LW_BOMB && (l->Dir == DIR_UP || l->Dir == DIR_DOWN)) Screen->DrawTile (0, l->X + l->DrawXOffset, l->Y + l->DrawYOffset + 16, l->Tile, l->TileWidth, l->TileHeight, l->CSet, -1, -1, 0, 0, 0, l->Flip, true, OP_TRANS);
				else if (l->ID == LW_SCRIPT9) Screen->DrawTile (0, l->X, l->Y + 16, l->Tile, l->TileWidth, l->TileHeight, l->CSet, -1, -1, 0, 0, 0, (l->Flip + 2) % 4, true, OP_TRANS);
				else if (l->ID != LW_SWORD && l->ID != LW_SCRIPT3) Screen->DrawTile (0, l->X + l->DrawXOffset, l->Y + l->DrawYOffset + 16, l->Tile, l->TileWidth, l->TileHeight, l->CSet, -1, -1, 0, 0, 0, (l->Flip + 2) % 4, true, OP_TRANS);
				else Screen->DrawTile (0, l->X + l->DrawXOffset, Link->Y + 16 + (Link->Y - (l->Y + l->DrawYOffset)), l->Tile, l->TileWidth, l->TileHeight, l->CSet, -1, -1, 0, 0, 0, (l->Flip + 2) % 4, true, OP_TRANS);
			}
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon e = Screen->LoadEWeapon(i);
				if (e->Dir == DIR_UP || e->Dir == DIR_DOWN) Screen->DrawTile (0, e->X + e->DrawXOffset, e->Y + e->DrawYOffset + 16, e->Tile, e->TileWidth, e->TileHeight, e->CSet, -1, -1, 0, 0, 0, e->Flip, true, OP_TRANS);
				else Screen->DrawTile (0, e->X + e->DrawXOffset, e->Y + e->DrawYOffset + 16, e->Tile, e->TileWidth, e->TileHeight, e->CSet, -1, -1, 0, 0, 0, (e->Flip + 2) % 4, true, OP_TRANS);
			}
			for (int i = Screen->NumItems(); i > 0; i--)
			{
				item m = Screen->LoadItem(i);
				Screen->DrawTile (0, m->X + m->DrawXOffset, m->Y + m->DrawYOffset + 16, m->Tile, m->TileWidth, m->TileHeight, m->CSet, -1, -1, 0, 0, 0, m->Flip + 2, true, OP_TRANS);
			}
			Screen->DrawTile (0, Link->X, Link->Y + 16, Link->Tile, 1, 1, 6, -1, -1, 0, 0, 0, Link->Flip + 2, true, OP_TRANS);
			Waitframe();
		}
	}
}

void DiagonAlley()
{
	int dir = -1;
	int topleft[] = {4290, 4294, 4298, 4280, 2948, 2628, 5132, 5126, 5130, 5200, 5484, 7584, 15782, 15394, 15625};
	int topright[] = {4291, 4295, 4299, 4281, 2949, 2629, 5133, 5127, 5131, 5201, 5485, 15783, 15400, 15626};
	int bottomleft[] = {4302, 4306, 4310, 4284, 2942, 2622, 5136, 5134, 5138, 5194, 15786, 15398, 15629};
	int bottomright[] = {4303, 4307, 4311, 4285, 2943, 2623, 5137, 5135, 5139, 5194, 15787, 15404, 15630};
	for (int i = 0; i < 176; i++)
	{
		if (Distance(Link->X, Link->Y, ComboX(i), ComboY(i)) < 16)
		{
			int comp[3]; 
			for (int m = 0; m < 3; m++) if ( Screen->LayerMap(m) != -1 && Screen->LayerScreen(m) != -1 ) comp[m] = GetLayerComboD(m, i);
			if (CompareArray(comp, topleft)) dir = 1;
			else if (CompareArray(comp, topright)) dir = 2;
			else if (CompareArray(comp, bottomleft)) dir = 3;
			else if (CompareArray(comp, bottomright)) dir = 4;
			if (dir > 0)
			{
				if (dir == 1)
				{
					while (lineBoxCollision(ComboX(i) + 15, ComboY(i), ComboX(i), ComboY(i) + 15, Link->X, Link->Y + 7, Link->X + 15, Link->Y + 15, 1))
					{
						if (!CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false) && !CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)) break;
						if (CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)) Link->Y++;
						if (CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)) Link->X++;
						NoPush = true;
					}
				}
				else if (dir == 2)
				{
					while (lineBoxCollision(ComboX(i), ComboY(i), ComboX(i) + 15, ComboY(i) + 15, Link->X, Link->Y + 7, Link->X + 15, Link->Y + 15, 1))
					{
						if (!CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false) && !CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)) break;
						if (CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)) Link->Y++;
						if (CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)) Link->X--;
						NoPush = true;
					}
				}
				else if (dir == 3)
				{
					while (lineBoxCollision(ComboX(i), ComboY(i), ComboX(i) + 15, ComboY(i) + 15, Link->X, Link->Y + 7, Link->X + 15, Link->Y + 15, 1))
					{
						if (!CanWalk(Link->X, Link->Y, DIR_UP, 1, false) && !CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)) break;
						if (CanWalk(Link->X, Link->Y, DIR_UP, 1, false)) Link->Y--;
						if (CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)) Link->X++;
						NoPush = true;
					}
				}
				else if (dir == 4)
				{
					while (lineBoxCollision(ComboX(i) + 15, ComboY(i), ComboX(i), ComboY(i) + 15, Link->X, Link->Y + 7, Link->X + 15, Link->Y + 15, 1))
					{
						if (!CanWalk(Link->X, Link->Y, DIR_UP, 1, false) && !CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)) break;
						if (CanWalk(Link->X, Link->Y, DIR_UP, 1, false)) Link->Y--;
						if (CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)) Link->X--;
						NoPush = true;
					}
				}
			}
			dir = 0;
		}
	}
}

bool CompareArray(int comp, int array)
{
	for (int i = SizeOfArray(array) - 1; i >= 0; i--)
	{
		for (int l = SizeOfArray(comp) - 1; l >= 0; l--)
		{
			if (array[i] == comp[l]) return true;
		}
	}
	return false;
}

bool IsPositive (int ispos)
{
	if (ispos <= 0) return false;
	else return true;
}