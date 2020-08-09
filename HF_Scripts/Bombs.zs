// script for GB style bombs

//! This needs to become a constant item script and an lweapon script. 

// global
int bomb_num;
int holding_bomb;
int throwing_bomb;
int bomb_dir;
bool zero_bombs;
int bomb_damage;

int prev_bombs;

const int BOMB_SPEED = 3;
//const int BOMB_DIST = 16;

const int BOMB_TILE = 15119;
const int BOMB_ITEM = 3;

bool bomb_on_screen;
bool isChangingBomb;

// item script
item script Bombs
{
	void run()
	{
		if (powerBracelet[HOLDING_BLOCK]) Quit();
		lweapon bomb;
		lweapon w;
		for(int nw = Screen->NumLWeapons();nw > 0; --nw)
		{
			w = Screen->LoadLWeapon(nw);
			if(w->ID == LW_BOMB) 
			{
				bomb = w;
				bomb_num = nw;
			}
		}
		if(bomb_on_screen)
		{
			if(LinkCollision(bomb)) PickUpBomb();
		}
		else PlaceBomb(bomb);
		isChangingBomb = true;
	}
}

// functions
void PlaceBomb(lweapon bomb)
{
	bomb->X = Link->X + InFrontX(Link->Dir,8);
	bomb->Y = Link->Y + InFrontY(Link->Dir,8);
	bomb_on_screen = true;
}


void PickUpBomb()
{
	Game->PlaySound(SFX_PICKUP_BLOCK);
	++holding_bomb;
}


// global function
void Bombs()
{
	lweapon bomb;
	lweapon w;
	int num_bombs = 0;
	for(int nw = Screen->NumLWeapons();nw > 0; --nw)
	{
		w = Screen->LoadLWeapon(nw);
		if(w->ID == LW_BOMB) 
		{
			bomb = w;
			bomb_num = nw;
			++num_bombs;
		}
	}
	unless(num_bombs) bomb_on_screen = false;
	//
	if(holding_bomb>0)
	{
		if (num_bombs > 0) Remove(bomb);
		Screen->FastTile(3, Link->X, Link->Y - 14, BOMB_TILE, 7, OP_OPAQUE);
		++holding_bomb;
		if(holding_bomb>20 && (Link->InputA || Link->InputB || Link->InputEx2)) ThrowBomb();
		unless(Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = true;
		if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
		if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
	}
	else 
	{
		if (powerBracelet[HOLDING_BLOCK] <= 0 && powerBracelet[LINK_CATCHING] <= 0)
		{
			if(Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = false;
			if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
			if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
		}
		if (num_bombs > 0) 
		{
			if (bomb->ID == LW_BOMB && bomb->isValid())
			{
				if(bomb->Z > 0)
				{
					bomb->Z += (4-throwing_bomb/2);
					++throwing_bomb;
					if(Screen->ComboS[ComboAt(bomb->X+8,bomb->Y+12)]!=15)
					{
						bomb->X += BOMB_SPEED*(Floor(bomb_dir/2) * (2*bomb_dir-5));
						bomb->Y += BOMB_SPEED*(Floor((-bomb_dir+3)/2) * (2*bomb_dir-1));
					}
				}
				else
				{
					throwing_bomb = 0;
				}
			}
		}
	}
}

void ThrowBomb()
{
	Game->PlaySound(SFX_THROW_BLOCK);
	throwing_bomb = 1;
	holding_bomb = 0;
	bomb_dir = Link->Dir;
	lweapon bomb = Screen->CreateLWeapon(LW_BOMB);
	bomb->Damage = bomb_damage;
	bomb->X = Link->X;
	bomb->Y = Link->Y;
	bomb->Z = 16;
}