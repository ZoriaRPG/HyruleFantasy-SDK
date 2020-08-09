ffc script AntiFairy
{
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		int Num = ghost->Attributes[0];
		unless (Num) Num = -1;
		if (ghost->Attributes[1] > 0)
		{
			int dir = AngleDir8(Angle(Link->X, Link->Y, Ghost_X, Ghost_Y));
			switch(dir)
			{
				case DIR_UP: 
					Ghost_Vy = -1 * ghost->Step * 0.01;
					Ghost_Vy *= 4;
					break;
				
				case DIR_LEFT:
					Ghost_Vx *= 4;
					Ghost_Vx = -1 * ghost->Step * 0.01;
					break;
				
				case DIR_RIGHT:
					Ghost_Vx *= 4;
					Ghost_Vx = ghost->Step * 0.01;
					break;
				
				case DIR_DOWN:
					Ghost_Vy = ghost->Step * 0.01;
					Ghost_Vy *= 4;
					break;
				
				case DIR_RIGHTUP:
					Ghost_Vy = -1 * ghost->Step * 0.01;
					Ghost_Vx = ghost->Step * 0.01;
					break;
				
				case DIR_LEFTUP:
					Ghost_Vy = -1 * ghost->Step * 0.01;
					Ghost_Vx = -1 * ghost->Step * 0.01;
					break;
				
				case DIR_RIGHTDOWN:
					Ghost_Vy = ghost->Step * 0.01;
					Ghost_Vx = ghost->Step * 0.01;
					break;
				
				case DIR_LEFTDOWN:
					Ghost_Vy = ghost->Step * 0.01;
					Ghost_Vx = -1 * ghost->Step * 0.01;
					break;
				
			}
		}
		else
		{
			unless (Rand(2))
			{
				Ghost_Vx = ghost->Step * 0.01;
			}
			else
			{
				Ghost_Vx = -ghost->Step * 0.01;
			}
			
			unless (Rand(2)) //both dirs have separately randomised accel
			{
				
			}
			else
			{
				Ghost_Vy = -ghost->Step * 0.01;
			}
		}
		
		while (true)
		{
			unless ( Ghost_CanMove(DIR_LEFT, ghost->Step * 0.01, 4) )
			{
				if(Ghost_Vx < 0)
				{
					Ghost_Vx = -Ghost_Vx;
					if (Num > 0 && Num != -1) --Num;
				}
				else if (Ghost_Vx > 0)
				{
					Ghost_Vx = -Ghost_Vx;
					if (Num > 0 && Num != -1) --Num;
				}
			}
			
			// Change Y velocity when bouncing on horizontal surface.
			unless (Ghost_CanMove(DIR_UP, ghost->Step * 0.01, 4) ) 
			{
				if (Ghost_Vy < 0)
				{
					Ghost_Vy = -Ghost_Vy;
					if (Num > 0 && Num != -1) --Num;
				}
				else if (Ghost_Vy > 0)
				{
					Ghost_Vy = -Ghost_Vy;
					if (Num > 0 && Num != -1) --Num;
				}
			}
			
			unless (Num) 
			{
				lweapon Death = Screen->CreateLWeapon(LW_SPARKLE);
				Death->UseSprite(109);
				Death->X = Ghost_X;
				Death->Y = Ghost_Y;
				Ghost_X = -32;
				Ghost_Y = -32;
				Ghost_HP = 0;
			}
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}