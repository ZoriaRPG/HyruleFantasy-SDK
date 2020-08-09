bool pushing = false;

ffc script SomariaBlock
{
	void run()
	{
		int SomariaArray[32];
		int ArrayCount = 0;
		for (int i = 1; i <= 32; i++)
		{
			ffc Meh = Screen->LoadFFC(i);
			if (Meh != this && Meh->Script == this->Script)
			{
				SomariaArray[ArrayCount] = i;
				ArrayCount++;
			}
		}
		while(true)
		{
			ArrayCount = 0;
			for (int i = 1; i <= 32; i++)
			{
				ffc Meh = Screen->LoadFFC(i);
				if (Meh != this && Meh->Script == this->Script)
				{
					SomariaArray[ArrayCount] = i;
					ArrayCount++;
				}
			}
			if (Link->Dir == AngleDir4(Angle(Link->X + 7, Link->Y + 11, this->X + 7, this->Y + 7)) && pushing == true && Distance(this->X, this->Y, Link->X, Link->Y) <= 17)
			{
				if (Link->InputUp && Link->Dir == DIR_UP && CanWalk(this->X, this->Y, Link->Dir, 1, true) && 
				FFCArrayCollision(SomariaArray, this->X, this->Y - 1, 15, 15) == false) this->Y--;
				else if (Link->InputDown && Link->Dir == DIR_DOWN && CanWalk(this->X, this->Y, Link->Dir, 1, true) &&
				FFCArrayCollision(SomariaArray, this->X, this->Y + 1, 15, 15) == false) this->Y++;
				else if (Link->InputLeft && Link->Dir == DIR_LEFT && CanWalk(this->X, this->Y, Link->Dir, 1, true) &&
				FFCArrayCollision(SomariaArray, this->X - 1, this->Y, 15, 15) == false) this->X--;
				else if (Link->InputRight && Link->Dir == DIR_RIGHT && CanWalk(this->X, this->Y, Link->Dir, 1, true) &&
				FFCArrayCollision(SomariaArray, this->X + 1, this->Y, 15, 15) == false) this->X++;
			}
			Waitframe();
		}
	}
	bool FFCArrayCollision(int array, int x, int y, int width, int height)
	{
		for (int i = 0; i < SizeOfArray(array); i++)
		{
			if (array[i] > 0)
			{
				ffc madness = Screen->LoadFFC(array[i]);
				if (RectCollision(madness->X, madness->Y, madness->X + (16 * madness->TileWidth) - 1, madness->Y + (16 * madness->TileHeight) - 1, x, y, x + width, y + height))
				{
					return true;
				}
			}
		}
		return false;
	}
}

void SomariaBlockCollision()
{
	int SomariaScript[] = "SomariaBlock";
	int SomariaID = Game->GetFFCScript(SomariaScript);
	ffc Somaria = Screen->LoadFFC(FindFFCRunning(SomariaID));
	if (Somaria->Script == SomariaID)
	{
		if (RectCollision(Link->X + 1, Link->Y + 7, Link->X + 14, Link->Y + 15, Somaria->X, Somaria->Y, Somaria->X + 15, Somaria->Y + 15))
		{
			if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_UP)
			{
				Link->Y += (8 - Abs(Link->Y - Somaria->Y));
			}
			else if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_DOWN)
			{
				Link->Y -= (16 - Abs(Link->Y - Somaria->Y));
			}
			else if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_LEFT)
			{
				Link->X += (15 - Abs(Link->X - Somaria->X));
			}
			else if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_RIGHT)
			{
				Link->X -= (15 - Abs(Link->X - Somaria->X));
			}
			pushing = true;
		}
		else pushing = false;
	}
}