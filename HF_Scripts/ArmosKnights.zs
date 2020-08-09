// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// Time before coming to life
const int AK_INITIAL_WAIT_TIME 		= 180;
const int AK_RUMBLE_TIME 		= 60;

// First phase movement
const int AK_PART_1_WAIT_TIME 		= 150;
const int AK_PART_1_TOTAL_CIRCLE_TIME 	= 510;
const int AK_PART_1_REDUCE_RADIUS_TIME 	= 300;
const int AK_PART_1_EXPAND_RADIUS_TIME 	= 390;
const float AK_PART_1_STEP 		= 1.25;
const int AK_PART_1_ROTATE_SPEED 	= 1;

// Second phase movement
const int AK_PART_2_WAIT_TIME 		= 30;
const float AK_PART_2_STEP 		= 3.5;
const int AK_PART_2_RISE_DIVISOR 	= 2;
const int AK_PART_2_FALL_STEP 		= 6;

// ffc->Misc[] indices
const int AK_IDX_LAST_ONE 		= 0;
const int AK_IDX_PLAY_SOUND 		= 1;
const int AK_IDX_DYING 			= 2;

// npc->Attributes[] indices
const int AK_ATTR_NUM_KNIGHTS 		= 0;
const int AK_ATTR_SECOND_CSET 		= 1;
const int AK_ATTR_SFX_STOMP 		= 2;
const int AK_ATTR_SFX_JUMP 		= 3;
const int AK_ATTR_SFX_RUMBLE 		= 4;
const int AK_ATTR_EXPLODE 		= 5;

ffc script ArmosKnights
{
	void run(int enemyID, int knightID, int numKnights, int rowX, int rowY, int Attack)
	{
		// The placed enemy is a dummy that acts as a supervisor;
		// it'll set up the rest of the FFCs and give them nonzero knightIDs
		unless(knightID)
			SupervisorRun(this, enemyID);
		else
			KnightRun(this, enemyID, knightID-1, numKnights, rowX, rowY);
	}

	// Supervisor mode ------------------------

	void SupervisorRun(ffc this, int enemyID)
	{
		npc ghost;
		int combo;
		int cset;
		int numKnights;
		int numFFCs;
		int ffcID;
		int numAlive;
		ffc knightFFC[10];
		int startX[10]; // Starting positions
		int startY[10];
		int rowX[10]; // Initial positions when jumping downward in a row
		int rowY[10];
		bool alive[10]; // Whether each knight is still alive
		bool playSound;
		int i;

		ghost=Ghost_InitAutoGhost(this, enemyID);
		ghost->CollDetection=false;
		ghost->SFX=0;

		combo=Ghost_Data;
		cset=Ghost_CSet;
		this->Data=0;

		numKnights=Ghost_GetAttribute(ghost, AK_ATTR_NUM_KNIGHTS, 1, 1, 10);

		// Get FFCs for knights
		numFFCs=0;
		ffcID=0;

		while(numFFCs<numKnights)
		{
			ffcID=FindUnusedFFC(ffcID);

			unless(ffcID)
				break;

			knightFFC[numFFCs]=Screen->LoadFFC(ffcID);
			++numFFCs;
		}

		// Reduce the number of knights if too few FFCs were available
		numKnights=Min(numKnights, numFFCs);

		// Find where the knights go based on how many there are
		GetStartingPositions(numKnights, startX, startY);
		GetRowPositions(numKnights, rowX);
		GetColumnPositions(numKnights, rowY);

		// Set up the FFCs; no enemies or scripts yet
		for(i=0; i<numKnights; ++i)
		{
			knightFFC[i]->Data=combo;
			knightFFC[i]->CSet=cset;
			knightFFC[i]->TileWidth=1;
			knightFFC[i]->TileHeight=2;
			knightFFC[i]->X=startX[i];
			knightFFC[i]->Y=startY[i];
			knightFFC[i]->Flags[FFCF_OVERLAY]=true;
		}

		// Let the FFCs sit there a moment, then rumble

		Waitframes(AK_INITIAL_WAIT_TIME);

		Game->PlaySound(ghost->Attributes[AK_ATTR_SFX_RUMBLE]);
		for(i=0; i < AK_RUMBLE_TIME; ++i)
		{
			for(int j=0; j < numKnights; ++j)
				knightFFC[j]->X=startX[j]+Rand(3)-1; // Starting position +/- 1
			Waitframe();
		}

		// Set up the knights' scripts
		numAlive=numKnights;
		for(i=0; i < numKnights; ++i)
		{
			knightFFC[i]->Script=this->Script;
			knightFFC[i]->InitD[0]=enemyID;
			knightFFC[i]->InitD[1]=i+1;
			knightFFC[i]->InitD[2]=numKnights;
			knightFFC[i]->InitD[3]=rowX[i];
			knightFFC[i]->InitD[4]=rowY[i];
			alive[i]=true;
		}

		// The knights will move on their own; just watch to see when they die
		while( numAlive > 1 )
		{
			Waitframe();
			if (this->InitD[5] > 0)
			{
				int Attack = Rand(1, 5);
				for(i=0; i < numKnights; ++i)
				{
					knightFFC[i]->InitD[5] = Attack;
				}
				this->InitD[5] = 0;
			}
			for(i=0; i < numKnights; ++i)
			{
				unless(alive[i])
				continue;

				// If a knight is dying, don't count it as dead unless there's at least one other;
				// if they all died at once here, the second phase of the fight wouldn't happen
				if(knightFFC[i]->Misc[AK_IDX_DYING] && numAlive > 1)
				{
					alive[i]=false;
					--numAlive;
				}
				// Check if a landing sound should be played;
				// It's the supervisor that does this so the sound only plays once per jump
				else if(knightFFC[i]->Misc[AK_IDX_PLAY_SOUND]==1)
				playSound=true;
			}

			if(playSound)
			{
				Game->PlaySound(ghost->Attributes[AK_ATTR_SFX_STOMP]);
				playSound=false;
			}
		}

		// Only one is left; tell it to switch behavior
		for(i=0; i < numKnights; ++i)
		{
			if(alive[i])
			{
				knightFFC[i]->Misc[AK_IDX_LAST_ONE]=1;
				break;
			}
		}

		// Then just wait for it to die
		knightFFC[i]->Misc[AK_IDX_DYING]=0;
		while(knightFFC[i]->Misc[AK_IDX_DYING]==0)
		Waitframe();

		// And kill the supervisor
		ghost->X=1024;
		ghost->Y=1024;
		ghost->ItemSet=0;
		this->Data=0;
		Quit();
	}

	// Determine the initial position of each knight based on the total number
	void GetStartingPositions(int numKnights, int startX, int startY)
	{
		switch(numKnights)
		{
			case 1:
			{
				startX[0]=120;
				startY[0]=72;
				break;
			}
			case 2:
			{
				startX[0]=72;
				startY[0]=72;

				startX[1]=168;
				startY[1]=72;
				break;
			}
			case 3:
			{
				startX[0]=120;
				startY[0]=48;

				startX[1]=168;
				startY[1]=96;

				startX[2]=72;
				startY[2]=96;
				break;
			}
			case 4:
			{
				startX[0]=72;
				startY[0]=48;

				startX[1]=168;
				startY[1]=48;

				startX[2]=168;
				startY[2]=96;

				startX[3]=72;
				startY[3]=96;
				break;
			}
			case 5:
			{
				startX[0]=120;
				startY[0]=48;

				startX[1]=168;
				startY[1]=48;

				startX[2]=148;
				startY[2]=96;

				startX[3]=88;
				startY[3]=96;

				startX[4]=72;
				startY[4]=48;
				break;
			}
			case 6:
			{
				startX[0]=120;
				startY[0]=48;

				startX[1]=168;
				startY[1]=48;

				startX[2]=168;
				startY[2]=96;

				startX[3]=120;
				startY[3]=96;

				startX[4]=72;
				startY[4]=96;

				startX[5]=72;
				startY[5]=48;
				break;
			}
			default:
			{
				startX[0]=104;
				startY[0]=60;

				startX[1]=136;
				startY[1]=60;

				startX[2]=104;
				startY[2]=32;

				startX[3]=136;
				startY[3]=32;

				startX[4]=160;
				startY[4]=48;

				startX[5]=160;
				startY[5]=72;
				
				startX[6]=136;
				startY[6]=88;

				startX[7]=104;
				startY[7]=88;

				startX[8]=80;
				startY[8]=72;

				startX[9]=80;
				startY[9]=48;
				break;
			}
		}
	}

	// Determine each knight's X position when jumping in a row
	void GetRowPositions(int numKnights, int rowX)
	{
		// If there's only one, this won't be used, anyway
		switch(numKnights)
		{
			case 1: break;
			case 2:
			{
				rowX[0]=64;
				rowX[1]=160;
				break;
			}
			case 3:
			{
				rowX[0]=56;
				rowX[1]=112;
				rowX[2]=168;
				break;
			}
			case 4:
			{
				rowX[0]=40;
				rowX[1]=88;
				rowX[2]=136;
				rowX[3]=184;
				break;
			}
			case 5:
			{
				rowX[0]=32;
				rowX[1]=72;
				rowX[2]=112;
				rowX[3]=152;
				rowX[4]=192;
				break;
			}
			case 6:
			{
				rowX[0]=40;
				rowX[1]=72;
				rowX[2]=104;
				rowX[3]=136;
				rowX[4]=168;
				rowX[5]=200;
				break;
			}
			default:
			{
				for (int j = 0; j < numKnights; ++j) 
				{
					rowX[j]=48 + (j*16);
				}
				break;
			}
		}
	}
	
	void GetColumnPositions(int numKnights, int rowY)
	{
		for (int j = 0; j < numKnights; ++j) 
		{
			rowY[j]=32 + ((j%5)*22.4);
		}
	}

	// Knight mode ------------------------

	void KnightRun(ffc this, int enemyID, int position, int numKnights, int rowX, int rowY)
	{
		npc ghost;
		int maxHP;
		int cset2;
		float radius;
		float targetAngle;
		float angleStep;
		float targetX;
		float targetY;
		bool endPart1;
		int i;
		
		int followx[20];
		int followy[20];

		ghost=Ghost_InitCreate(this, enemyID);
		Ghost_SetFlag(GHF_FAKE_Z);
		Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		Ghost_SetFlag(GHF_REDUCED_KNOCKBACK);
		maxHP=Ghost_HP;
		Ghost_SetHitOffsets(ghost, 12, 0, 0, 0);

		cset2=ghost->Attributes[AK_ATTR_SECOND_CSET];

		// First stage - other knights still alive
		endPart1=false;
		angleStep=AK_PART_1_ROTATE_SPEED;
		radius=40;

		while(true)
		{
			// Move into position and hold it briefly
			targetAngle=270+(position/numKnights)*360;
			targetX=120+radius*Cos(targetAngle);
			targetY=72+radius*Sin(targetAngle);

			for(i=0; i<AK_PART_1_WAIT_TIME && !endPart1; i++)
			endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);

			if(endPart1)
			break;

			// Jump in a circle for a while
			for(i=0; (i < AK_PART_1_TOTAL_CIRCLE_TIME && !endPart1); ++i)
			{
				// Change radius at certain points
				if(i==AK_PART_1_REDUCE_RADIUS_TIME)
				radius=24;
				else if(i==AK_PART_1_EXPAND_RADIUS_TIME)
				radius=40;

				// Rotate until the radius has been decreased and restored
				if(i<=AK_PART_1_EXPAND_RADIUS_TIME)
				{
					targetAngle+=angleStep;
					targetX=120+radius*Cos(targetAngle);
					targetY=72+radius*Sin(targetAngle);
				}

				endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);
			}

			if(endPart1)
				break;
			for (int f = 1; f <= 32; ++f)
			{
				ffc MightKnight = Screen->LoadFFC(f);
				if (MightKnight->Script == this->Script && MightKnight->InitD[1] <= 0)
				{
					MightKnight->InitD[5] = 1;
					break;
				}
			}
			endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);
			if(endPart1)
				break;
			
			int Attack = this->InitD[5];
			if (Attack == 1)
			{
				// Line up and jump down the screen
				targetX=rowX;
				targetY=16;
				for(i=0; i<AK_PART_1_WAIT_TIME && !endPart1; i++)
				endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);

				if(endPart1)
				break;

				targetY=112;

				// Moving 112-16=96 pixels, so wait exactly long enough for that
				for(i=96/AK_PART_1_STEP; i>0 && !endPart1; i--) endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);
			}
			else if (Attack == 2)
			{
				// Line up and jump down the screen
				targetAngle=270+(position/numKnights)*360;
				targetX=rowX;
				targetY=72;
				for(i=0; (i < AK_PART_1_WAIT_TIME && !endPart1); ++i)
					endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);

				if(endPart1)
				break;

				int targetdist = Distance(Ghost_X, Ghost_Y, 120, 72);
				int targetdist2 = targetdist * 0.7;
				targetAngle = Angle(120, 72, Ghost_X, Ghost_Y);
				for(i=0; i<760 && !endPart1; i++)
				{
					targetAngle+=angleStep;
					targetX=120+targetdist*Cos(targetAngle);
					targetY=72+targetdist2*Sin(targetAngle);

					endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);
				}
			}
			if (Attack == 3)
			{
				// Line up and jump down the screen
				if (position < 5) targetX=48;
				else targetX=192;
				targetY=rowY;
				for(i=0; (i < AK_PART_1_WAIT_TIME && !endPart1); ++i)
					endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);

				if(endPart1)
					break;

				if (position < 5) targetX=192;
				else targetX=48;

				// Moving 192-48=144 pixels, so wait exactly long enough for that
				for(i=144/AK_PART_1_STEP; (i > 0 && !endPart1); --i)
					endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);
			}
			else if (Attack == 4)
			{
				int highestlower = position;
				ffc IsKnight;
				for (int i = 0; (i < 660 && !endPart1); ++i)
				{
					highestlower = position;
					for (int f = 1; f <= 32; ++f)
					{
						ffc MightKnight = Screen->LoadFFC(f);
						if (MightKnight->Script == this->Script && (MightKnight->InitD[1] - 1) < position && ((MightKnight->InitD[1] - 1) > highestlower || highestlower >= position) && MightKnight->InitD[1] > 0)
						{
							IsKnight = MightKnight;
							highestlower = (MightKnight->InitD[1] - 1);
						}
					}
					if (highestlower == position)
					{
						targetX = Link->X;
						targetY = Link->Y - 8;
					}
					else
					{
						for (int k = 19; k > 0; --k)
						{
							if (followx[k] <= 0)
							{
								followx[k] = IsKnight->X;
								followy[k] = IsKnight->Y + 12;
							}
							else
							{
								followx[k] = followx[k - 1];
								followy[k] = followy[k - 1];
							}
						}
						followx[0] = IsKnight->X;
						followy[0] = IsKnight->Y + 12;
						targetX = followx[19];
						targetY = followy[19];
					}
					endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);
				}
			}
			else if (Attack == 5)
			{
				int radiusx = 120 - 48;
				int radiusy = 40;
				
				// Line up and jump down the screen
				targetAngle=270+(position/numKnights)*360;
				targetX=120+radiusx*Cos(targetAngle);
				targetY=72+radiusy*Sin(targetAngle*2);
				for(i=0; (i < AK_PART_1_WAIT_TIME && !endPart1); ++i)
					endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);

				if(endPart1)
					break;
				for(i=0; (i < AK_PART_1_TOTAL_CIRCLE_TIME && !endPart1); ++i)
				{
					targetAngle+=angleStep;
					targetX=120+radiusx*Cos(targetAngle);
					targetY=72+radiusy*Sin((targetAngle*2) % 360);
					endPart1=AKPart1Waitframe(this, ghost, targetX, targetY);
				}
			}
			if(endPart1)
				break;

			// Rotate the opposite direction next time
			angleStep*=-1;
		}

		// Part 1's ended, so this is the last knight; change color, restore HP, change behavior
		Ghost_CSet=cset2;
		Ghost_HP=maxHP;

		// Finish falling...
		while(Ghost_Z>0)
			AKPart2Waitframe(this, ghost, Ghost_X, Ghost_Y);

		// Change Z handling...
		Ghost_SetFlag(GHF_NO_FALL);
		Ghost_UnsetFlag(GHF_FAKE_Z);

		while(true)
		{
			// Move to directly above Link
			targetX=Link->X;
			targetY=Link->Y-16;

			Game->PlaySound(ghost->Attributes[AK_ATTR_SFX_JUMP]);

			until((Ghost_X==targetX && Ghost_Y==targetY))
				AKPart2Waitframe(this, ghost, targetX, targetY);

			// Hold it for a moment
			for(i=0; i < AK_PART_2_WAIT_TIME; ++i)
				AKPart2Waitframe(this, ghost, targetX, targetY);

			// Fall
			while(Ghost_Z>0)
			{
				Ghost_Z-=AK_PART_2_FALL_STEP;
				AKPart2Waitframe(this, ghost, targetX, targetY);
			}

			Game->PlaySound(ghost->Attributes[AK_ATTR_SFX_STOMP]);

			// And wait for a moment before repeating
			for(i=0; i<AK_PART_2_WAIT_TIME; ++i)
				AKPart2Waitframe(this, ghost, targetX, targetY);
		}
	}

	// Waitframe used in the first phase of the fight. Returns true if this
	// is the last knight and it's time to start the next phase.
	bool AKPart1Waitframe(ffc this, npc ghost, float targetX, float targetY)
	{
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		// Move toward where the knight's supposed to be
		if(Distance(Ghost_X, Ghost_Y, targetX, targetY)<AK_PART_1_STEP)
		{
			Ghost_X=targetX;
			Ghost_Y=targetY;
		}
		else
		{
			float angle=ArcTan(targetX-Ghost_X, targetY-Ghost_Y)*57.2958;
			Ghost_X+=AK_PART_1_STEP*Cos(angle);
			Ghost_Y+=AK_PART_1_STEP*Sin(angle);
		}

		// If on the ground, jump and tell the supervisor to play the bounce sound
		unless(Ghost_Z)
		{
			Ghost_Jump=2;
			this->Misc[AK_IDX_PLAY_SOUND]=1;
		}
		else 
		{
			if(this->Misc[AK_IDX_PLAY_SOUND]==1)
				this->Misc[AK_IDX_PLAY_SOUND]=0;
		}

		// Don't automatically clear and quit on death; if the last two died
		// at the same time, the second phase of the battle wouldn't happen
		unless(Ghost_Waitframe(this, ghost, false, false))
		{
			// Wait a frame to let the supervisor check
			this->Misc[AK_IDX_DYING]=1;
			Ghost_HP=1;
			Ghost_Waitframe(this, ghost, true, true);

			// If this isn't the last knight, it can die now
			unless(this->Misc[AK_IDX_LAST_ONE])
			{
				Ghost_HP=0;
				Ghost_Waitframe(this, ghost, true, true);
			}
			else return true;
		}

		return this->Misc[AK_IDX_LAST_ONE]!=0;
	}

	// Waitframe used in the second phase of the fight.
	void AKPart2Waitframe(ffc this, npc ghost, float targetX, float targetY)
	{
		ghost->Stun = 0;
		ghost->Misc[1] = 0;
		if(Ghost_X != targetX || Ghost_Y != targetY)
		{
			float dist=Distance(Ghost_X, Ghost_Y, targetX, targetY);

			if(dist < AK_PART_2_STEP)
			{
				Ghost_X=targetX;
				Ghost_Y=targetY;
				Ghost_Z+=Sqrt(dist)/AK_PART_2_RISE_DIVISOR;
			}
			else
			{
				float angle=ArcTan(targetX-Ghost_X, targetY-Ghost_Y)*57.2958;
				Ghost_X+=AK_PART_2_STEP*Cos(angle);
				Ghost_Y+=AK_PART_2_STEP*Sin(angle);
				Ghost_Z+=Sqrt(dist)/AK_PART_2_RISE_DIVISOR;
			}
		}

		unless(Ghost_Waitframe(this, ghost, (ghost->Attributes[AK_ATTR_EXPLODE]),(ghost->Attributes[AK_ATTR_EXPLODE])))
		{
			this->Misc[AK_IDX_DYING]=1;
			Ghost_DeathAnimation(this, ghost, ghost->Attributes[AK_ATTR_EXPLODE]);
			Quit();
		}
	}
}