ffc script Lightning
{

	void run(int dir, int repeattimes, int NoOverhead) //D0 is direction to fire, D1 is how many times it fires after the first time (0 is a good number, -1 for infinite repeating), 
	{//D2 is whether the lightning will be drawn on layer 2 or layer 3 when the direction is up; 0 or lower will draw on layer 2 and anyhing higher than 0 will draw the lightning on layer 3 like the other directions.
		int Lightning1X[25];
		int Lightning1Y[25];
		int Lightning2X[25];
		int Lightning2Y[25];
		int Lightning3X[25];
		int Lightning3Y[25];
		int Lightning4X[25];
		int Lightning4Y[25];
		int HitCounter = 0;
		int LayerCounter = 0;
		for (int m = repeattimes; m!= 0;)
		{
			if (m > 0) m--;
			for (int i = 24; i >= 0; i--)
			{
				Lightning1X[i] = this->X;
				Lightning1Y[i] = this->Y;
				Lightning2X[i] = this->X;
				Lightning2Y[i] = this->Y;
				Lightning3X[i] = this->X;
				Lightning3Y[i] = this->Y;
				Lightning4X[i] = this->X;
				Lightning4Y[i] = this->Y;
			}
			Game->PlaySound(74);
			while(((Lightning1X[24] > 0 || Lightning2X[24] > 0 || Lightning3X[24] > 0 || Lightning4X[24] > 0) && dir == DIR_LEFT) ||
			((Lightning1X[24] < 256 || Lightning2X[24] < 256 || Lightning3X[24] < 256 || Lightning4X[24] < 256) && dir == DIR_RIGHT) ||
			((Lightning1Y[24] > 0 || Lightning2Y[24] > 0 || Lightning3Y[24] > 0 || Lightning4Y[24] > 0) && dir == DIR_UP) ||
			((Lightning1Y[24] < 176 || Lightning2Y[24] < 176 || Lightning3Y[24] < 176 || Lightning4Y[24] < 176) && dir == DIR_DOWN))
			{
				bool Struck = false;
				for (int l = 0; l <= 2; l++)
				{
					int Angle1 = Choose(210, 150, 225, 135);
					if (dir == DIR_UP) Angle1 += 90;
					else if (dir == DIR_DOWN) Angle1 -= 90;
					else if (dir == DIR_RIGHT) Angle1 += 180;
					ShiftArray(Lightning1X);
					ShiftArray(Lightning1Y);
					Lightning1X[0] += VectorX(10, Angle1);
					Lightning1Y[0] += VectorY(10, Angle1);
					int Angle2 = Choose(210, 150, 225, 135);
					if (dir == DIR_UP) Angle2 += 90;
					else if (dir == DIR_DOWN) Angle2 -= 90;
					else if (dir == DIR_RIGHT) Angle2 += 180;
					ShiftArray(Lightning2X);
					ShiftArray(Lightning2Y);
					Lightning2X[0] += VectorX(10, Angle2);
					Lightning2Y[0] += VectorY(10, Angle2);
					int Angle3 = Choose(210, 150, 225, 135);
					if (dir == DIR_UP) Angle3 += 90;
					else if (dir == DIR_DOWN) Angle3 -= 90;
					else if (dir == DIR_RIGHT) Angle3 += 180;
					ShiftArray(Lightning3X);
					ShiftArray(Lightning3Y);
					Lightning3X[0] += VectorX(10, Angle3);
					Lightning3Y[0] += VectorY(10, Angle3);
					int Angle4 = Choose(210, 150, 225, 135);
					if (dir == DIR_UP) Angle4 += 90;
					else if (dir == DIR_DOWN) Angle4 -= 90;
					else if (dir == DIR_RIGHT) Angle4 += 180;
					ShiftArray(Lightning4X);
					ShiftArray(Lightning4Y);
					Lightning4X[0] += VectorX(10, Angle4);
					Lightning4Y[0] += VectorY(10, Angle4);
					for (int i = 24; i > 0; i--)
					{
						if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
						{
							Screen->Line(2, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x0B, 1, 0, 0, 0, 128);
							Screen->Line(2, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x0B, 1, 0, 0, 0, 128);
							Screen->Line(2, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x0B, 1, 0, 0, 0, 128);
							Screen->Line(2, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						}
						else
						{
							Screen->Line(3, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x0B, 1, 0, 0, 0, 128);
							Screen->Line(3, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x0B, 1, 0, 0, 0, 128);
							Screen->Line(3, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x0B, 1, 0, 0, 0, 128);
							Screen->Line(3, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						}
						
						if (dir == DIR_LEFT || dir == DIR_RIGHT)
						{
							Screen->Line(3, Lightning1X[i], Lightning1Y[i] - 1, Lightning1X[i-1], Lightning1Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning2X[i], Lightning2Y[i] - 1, Lightning2X[i-1], Lightning2Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning3X[i], Lightning3Y[i] - 1, Lightning3X[i-1], Lightning3Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning4X[i], Lightning4Y[i] - 1, Lightning4X[i-1], Lightning4Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
						}
						else
						{
							if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
							{
								Screen->Line(2, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x0B, 2, 0, 0, 0, 64);
								Screen->Line(2, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x0B, 2, 0, 0, 0, 64);
								Screen->Line(2, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x0B, 2, 0, 0, 0, 64);
								Screen->Line(2, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x0B, 2, 0, 0, 0, 64);

							}
							else
							{
								Screen->Line(3, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x0B, 2, 0, 0, 0, 64);
								Screen->Line(3, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x0B, 2, 0, 0, 0, 64);
								Screen->Line(3, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x0B, 2, 0, 0, 0, 64);
								Screen->Line(3, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x0B, 2, 0, 0, 0, 64);
							}
						}
						if (!Struck)
						{
							if (lineBoxCollision(Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], Link->X, Link->Y, Link->X+Link->HitWidth, Link->Y+Link->HitHeight, 0))
							{
								Struck = true;
								if (HitCounter <= 0) HitCounter = 10;
								continue;
							}	
							if (lineBoxCollision(Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], Link->X, Link->Y, Link->X+Link->HitWidth, Link->Y+Link->HitHeight, 0))
							{
								Struck = true;
								if (HitCounter <= 0) HitCounter = 10;
								continue;
							}
							if (lineBoxCollision(Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], Link->X, Link->Y, Link->X+Link->HitWidth, Link->Y+Link->HitHeight, 0))
							{
								Struck = true;
								if (HitCounter <= 0) HitCounter = 10;
								continue;
							}
							if (lineBoxCollision(Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], Link->X, Link->Y, Link->X+Link->HitWidth, Link->Y+Link->HitHeight, 0))
							{
								Struck = true;
								if (HitCounter <= 0) HitCounter = 10;
								continue;
							}
						}
					}
				}
				if (Struck)
				{
					eweapon e = FireEWeapon(EW_SCRIPT10, Link->X+InFrontX(Link->Dir, 10), Link->Y+InFrontY(Link->Dir, 10), 0, 0, 8, -1, -1, EWF_UNBLOCKABLE);
					SetEWeaponLifespan(e, EWL_TIMER, 1);
					SetEWeaponDeathEffect(e, EWD_VANISH, 0);
					e->DrawYOffset = -1000;
				}
				if (HitCounter > 0)
				{
					if (Link->HP > 0)Screen->Rectangle(6, 0, 0, 256, 176, 1, 1, 0, 0, 0, true, OP_TRANS);
				}
				Waitframe();
				for (int i = 24; i > 0; i--)
				{
					if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
					{
						Screen->Line(2, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x0B, 1, 0, 0, 0, 128);
					}
					else
					{
						Screen->Line(3, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x0B, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x0B, 1, 0, 0, 0, 128);
					}
					if (dir == DIR_LEFT || dir == DIR_RIGHT)
					{
						Screen->Line(3, Lightning1X[i], Lightning1Y[i] - 1, Lightning1X[i-1], Lightning1Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning2X[i], Lightning2Y[i] - 1, Lightning2X[i-1], Lightning2Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning3X[i], Lightning3Y[i] - 1, Lightning3X[i-1], Lightning3Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning4X[i], Lightning4Y[i] - 1, Lightning4X[i-1], Lightning4Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
					}
					else
					{
						if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
						{
							Screen->Line(2, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x01, 2, 0, 0, 0, 64);
						}
						else
						{
							Screen->Line(3, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x01, 2, 0, 0, 0, 64);
						}
					}
				}
				if (HitCounter > 0)
				{
					if (Link->HP > 0)Screen->Rectangle(6, 0, 0, 256, 176, 1, 1, 0, 0, 0, true, OP_OPAQUE);
					HitCounter--;
				}
				Waitframe();
				for (int i = 24; i > 0; i--)
				{
					if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
					{
						Screen->Line(2, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x01, 1, 0, 0, 0, 128);
					}
					else
					{
						Screen->Line(3, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x01, 1, 0, 0, 0, 128);
					}
					if (dir == DIR_LEFT || dir == DIR_RIGHT)
					{
						Screen->Line(3, Lightning1X[i], Lightning1Y[i] - 1, Lightning1X[i-1], Lightning1Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning2X[i], Lightning2Y[i] - 1, Lightning2X[i-1], Lightning2Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning3X[i], Lightning3Y[i] - 1, Lightning3X[i-1], Lightning3Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning4X[i], Lightning4Y[i] - 1, Lightning4X[i-1], Lightning4Y[i-1] - 1, 0x0B, 2, 0, 0, 0, 64);
					}
					else
					{
						if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
						{
							Screen->Line(2, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x0B, 2, 0, 0, 0, 64);
						}
						else
						{
							Screen->Line(3, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x0B, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x0B, 2, 0, 0, 0, 64);
						}
					}
				}
				Waitframe();
				for (int i = 24; i > 0; i--)
				{
					if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
					{
						Screen->Line(2, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(2, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x01, 1, 0, 0, 0, 128);
					}
					else
					{
						Screen->Line(3, Lightning1X[i], Lightning1Y[i], Lightning1X[i-1], Lightning1Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning2X[i], Lightning2Y[i], Lightning2X[i-1], Lightning2Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning3X[i], Lightning3Y[i], Lightning3X[i-1], Lightning3Y[i-1], 0x01, 1, 0, 0, 0, 128);
						Screen->Line(3, Lightning4X[i], Lightning4Y[i], Lightning4X[i-1], Lightning4Y[i-1], 0x01, 1, 0, 0, 0, 128);
					}
					if (dir == DIR_LEFT || dir == DIR_RIGHT)
					{
						Screen->Line(3, Lightning1X[i], Lightning1Y[i] - 1, Lightning1X[i-1], Lightning1Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning2X[i], Lightning2Y[i] - 1, Lightning2X[i-1], Lightning2Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning3X[i], Lightning3Y[i] - 1, Lightning3X[i-1], Lightning3Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
						Screen->Line(3, Lightning4X[i], Lightning4Y[i] - 1, Lightning4X[i-1], Lightning4Y[i-1] - 1, 0x01, 2, 0, 0, 0, 64);
					}
					else
					{
						if (dir == DIR_UP && i >= (LayerCounter - 8) && i <= (LayerCounter + 16) && NoOverhead <= 0)
						{
							Screen->Line(2, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(2, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x01, 2, 0, 0, 0, 64);
						}
						else
						{
							Screen->Line(3, Lightning1X[i] - 1, Lightning1Y[i], Lightning1X[i-1] - 1, Lightning1Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning2X[i] - 1, Lightning2Y[i], Lightning2X[i-1] - 1, Lightning2Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning3X[i] - 1, Lightning3Y[i], Lightning3X[i-1] - 1, Lightning3Y[i-1], 0x01, 2, 0, 0, 0, 64);
							Screen->Line(3, Lightning4X[i] - 1, Lightning4Y[i], Lightning4X[i-1] - 1, Lightning4Y[i-1], 0x01, 2, 0, 0, 0, 64);
						}
					}
				}
				Waitframe();
				LayerCounter+=2;
			}
		}
		this->InitD[2] = 1;
		while(HitCounter > 0)
		{
			if (Link->HP > 0) Screen->Rectangle(6, 0, 0, 256, 176, 1, 1, 0, 0, 0, true, OP_OPAQUE);
			Waitframe();
			if (Link->HP > 0) Screen->Rectangle(6, 0, 0, 256, 176, 1, 1, 0, 0, 0, true, OP_OPAQUE);
			HitCounter--;
			Waitframe();
			Waitframe();
			Waitframe();
		}
		this->Data = 0;
		this->Script = 0;
	}
}

ffc script LightningBolt //D0 is how long it lasts, D1 is the combo the ffc changes to whenthe lightning reaches it. Lightning will always land on the center of the ffc.
{

	void run(int Duration, int ImpactCombo)
	{
		int LightningX[50];
		int LightningY[50];
		LightningX[0] = this->X + 8;
		LightningY[0] = this->Y + 8;
		for (int i = 0; i < 49; i++)
		{
			int Angle1 = Choose(210, 150, 225, 135);
			Angle1 += 90;
			Angle1%=360;
			ShiftArray(LightningX);
			ShiftArray(LightningY);
			LightningX[0] += VectorX(10, Angle1);
			LightningY[0] += VectorY(10, Angle1);
		}
		Game->PlaySound(74);
		for (int l = 0; l <= 48; l+=2)
		{
			for (int i = 0; i < l + 1; i++)
			{
				if ((LightningX[i] < 256 && LightningX[i] > 0 && LightningY[i] < 176 && LightningY[i] > 0) ||
				(LightningX[i+1] < 256 && LightningX[i+1] > 0 && LightningY[i+1] < 176 && LightningY[i+1] > 0))
				{
					Screen->Line(3, LightningX[i], LightningY[i], LightningX[i+1], LightningY[i+1], 0x01, 1, 0, 0, 0, 128);
					if (l % 4 == 0) Screen->Line(3, LightningX[i] - 1, LightningY[i], LightningX[i+1] - 1, LightningY[i+1], 0x01, 2, 0, 0, 0, 64);
					else Screen->Line(3, LightningX[i] + 1, LightningY[i], LightningX[i+1] + 1, LightningY[i+1], 0x01, 2, 0, 0, 0, 64);
				}
			}
			Waitframe();
		}
		this->Data = ImpactCombo;
		this->CSet = 7;
		Screen->FastCombo(3, this->X, this->Y, this->Data, this->CSet, OP_OPAQUE);
		for (int l = Duration; l > 0; l--)
		{
			if (LinkCollision(this))
			{
				eweapon e = FireEWeapon(EW_SCRIPT10, Link->X+InFrontX(Link->Dir, 10), Link->Y+InFrontY(Link->Dir, 10), 0, 0, 8, -1, -1, EWF_UNBLOCKABLE);
				SetEWeaponLifespan(e, EWL_TIMER, 1);
				SetEWeaponDeathEffect(e, EWD_VANISH, 0);
				e->DrawYOffset = -1000;
			}
			Screen->FastCombo(3, this->X, this->Y, this->Data, this->CSet, OP_OPAQUE);
			for (int i = 49; i > 0; i--)
			{
				if ((LightningX[i] < 256 && LightningX[i] > 0 && LightningY[i] < 176 && LightningY[i] > 0) ||
				(LightningX[i-1] < 256 && LightningX[i-1] > 0 && LightningY[i-1] < 176 && LightningY[i-1] > 0))
				{
					Screen->Line(3, LightningX[i], LightningY[i], LightningX[i-1], LightningY[i-1], 0x01, 1, 0, 0, 0, 128);
					if (l % 2 == 0) Screen->Line(3, LightningX[i] - 1, LightningY[i], LightningX[i-1] - 1, LightningY[i-1], 0x01, 2, 0, 0, 0, 64);
					else Screen->Line(3, LightningX[i] + 1, LightningY[i], LightningX[i-1] + 1, LightningY[i-1], 0x01, 2, 0, 0, 0, 64);
				}
			}
			Waitframe();
		}
		this->Data = 0;
		this->Script = 0;
	}
}	

ffc script LightningCaller //Originally this attack was a ball with no collision that lazy chased you around for a few attacks before summoning a bunch of lightning on the spot. 
{						   //"Heh" is used to get that eweapon to place the ffc on it. If you want the attack ask, otheriwse just remove that stuff 
						   //and have the "X" and "Y" variables be equal to the ffc X/Y and set ImpactCombo to whichever you want the impact combo for the summoned lightning to be.
	void run(int Heh)
	{
		int Args[8];
		eweapon GlowingOrb = GetAssociatedEWeapon(Heh);
		int X = GlowingOrb->X;
		int Y = GlowingOrb->Y;
		int ImpactCombo = GlowingOrb->Misc[0];
		Remove(GlowingOrb);
		int lightning[] = "LightningBolt";
		int script_num = Game->GetFFCScript(lightning);
		Args[0] = 90;
		Args[1] = ImpactCombo;
		ffc meh = Screen->LoadFFC(RunFFCScript(script_num, Args));
		meh->X = X;
		meh->Y = Y;
		int angle = Rand(0, 89);
		int length = 0;
		for (int m = 3; m > 0; m--)
		{
			for (int i = 60; i > 0; i--)
			{
				angle+=2;
				angle%=360;
				length += 0.4;
				Waitframe();
			}
			Round(length);
			ffc meh2 = Screen->LoadFFC(RunFFCScript(script_num, Args));
			ffc meh3 = Screen->LoadFFC(RunFFCScript(script_num, Args));
			ffc meh4 = Screen->LoadFFC(RunFFCScript(script_num, Args));
			ffc meh5 = Screen->LoadFFC(RunFFCScript(script_num, Args));
			meh2->X = X + VectorX(length, angle);
			meh2->Y = Y + VectorY(length, angle);
			meh3->X = X + VectorX(length, angle + 90);
			meh3->Y = Y + VectorY(length, angle + 90);
			meh4->X = X + VectorX(length, angle + 180);
			meh4->Y = Y + VectorY(length, angle + 180);
			meh5->X = X + VectorX(length, angle + 270);
			meh5->Y = Y + VectorY(length, angle + 270);
		}
	}
}
	
void ShiftArray(int Array)
{
	for (int i = SizeOfArray(Array)-1; i > 0; i--)
	{
		Array[i] = Array[i-1];
	}
}