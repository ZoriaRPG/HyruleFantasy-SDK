ffc script Big_Beamos
{
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		int Main = Ghost_Data;
		int Clockwise = Ghost_Data;
		int CounterClockwise = Ghost_Data + 8;
		Ghost_SetSize(this, ghost, 2, 2);
		Ghost_X = 208;
		Ghost_Y = 32;
		Ghost_CSet = 8;
		int TurnCounter = 3;
		bool MovingDown = true;
		
		int Angle[20];
		int LStartX[20] = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
		int LStartY[20] = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
		int LEndX[20] = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
		int LEndY[20] = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
		int LaserLength[20];
		bool LaserEnded[20];
		int LaserBounce[20];
		int AttackCounter = Rand(300, 420);
		int FireballCounter = Rand(120, 240);
		int MaxHP = Ghost_HP;
		
		while (true)
		{
			if (((Link->Y > Ghost_Y + 32 || Ghost_Y <= 32) || (Link->Y >= Ghost_Y + 8 && TurnCounter == 1)) && !MovingDown)
			{
				if (Ghost_HP <= (MaxHP / 2))
				{
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(180), 200, ghost->WeaponDamage, -1, -1, 0);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(210), 200, ghost->WeaponDamage, -1, -1, 0);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(150), 200, ghost->WeaponDamage, -1, -1, 0);
				}
				for (int i = 0; i < 32; i++)
				{
					Ghost_Data = Clockwise + Floor(i / 4);
					if (AttackCounter > 0) AttackCounter--;
					if (FireballCounter > 0) FireballCounter--;
					BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
				}
				MovingDown = true;
				Ghost_Data = Main;
				TurnCounter--;
			}
			else if (((Link->Y < Ghost_Y - 16 || Ghost_Y >= 128) || (Link->Y <= Ghost_Y + 8 && TurnCounter == 1)) && MovingDown)
			{
				if (Ghost_HP <= (MaxHP / 2))
				{
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(180), 200, ghost->WeaponDamage, -1, -1, 0);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(210), 200, ghost->WeaponDamage, -1, -1, 0);
					FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(150), 200, ghost->WeaponDamage, -1, -1, 0);
				}
				for (int i = 0; i < 32; i++)
				{
					Ghost_Data = CounterClockwise + Floor(i / 4);
					if (AttackCounter > 0) AttackCounter--;
					if (FireballCounter > 0) FireballCounter--;
					BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
				}
				Ghost_Data = Main;
				MovingDown = false;
				TurnCounter--;
			}
			if (AttackCounter > 0) AttackCounter--;
			if (FireballCounter > 0) FireballCounter--;
			if (TurnCounter <= 0)
			{
				Game->PlaySound(74);
				for (int i = 0; i < 16; i+=0.5)
				{
					DrawLaser(3, Ghost_X + 8, Ghost_Y + 16, i, 180, 1);
					BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					Screen->Quake = 4;
				}
				if (Ghost_HP <= (MaxHP / 3))
				{
					int NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
					Trace(NewLaser);
					LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LStartY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LEndY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					Angle[NewLaser] = 225;
					LaserBounce[NewLaser] = 3;
					NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
					Trace(NewLaser);
					LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LStartY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LEndY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					Angle[NewLaser] = 135;
					LaserBounce[NewLaser] = 3;
				}
				for (int i = 0; i < 16; i+=0.5)
				{
					Laser(3, Ghost_X + 8, Ghost_Y + 16, 16, 180, ghost->WeaponDamage * 1.5, 1);
					BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					Screen->Quake = 4;
				}
				Game->PlaySound(SFX_FALL);
				npc Fall1 = Screen->CreateNPC(310);
				int Combo = FindSpawnPoint(-1, 38);
				Fall1->X = ComboX(Combo);
				Fall1->Y = ComboY(Combo);
				Fall1->Z = Rand(80, 120);
				npc Fall2 = Screen->CreateNPC(310);
				Combo = FindSpawnPoint(-1, 38);
				Fall2->X = ComboX(Combo);
				Fall2->Y = ComboY(Combo);
				Fall2->Z = Rand(80, 120);
				TurnCounter = 3;
				if (Link->Y > Ghost_Y + 16) MovingDown = true;
				else MovingDown = false;
			}
			else if (AttackCounter <= 0)
			{
				if (MovingDown)
				{
					for (int i = 0; i < 32; i++)
					{
						Ghost_Data = CounterClockwise + Floor(i / 4);
						BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					}
					int NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
					Trace(NewLaser);
					LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LStartY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LEndY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					Angle[NewLaser] = 225;
					LaserBounce[NewLaser] = 3;
					for (int i = 0; i < 32; i++)
					{
						Ghost_Data = Clockwise + Floor(i / 4);
						BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					}
					NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
					Trace(NewLaser);
					LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LStartY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LEndY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					Angle[NewLaser] = 135;
					LaserBounce[NewLaser] = 3;
					if (Ghost_HP <= (MaxHP / 2))
					{
						for (int i = 0; i < 32; i++)
						{
							Ghost_Data = CounterClockwise + Floor(i / 4);
							BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
						}
						NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
						Trace(NewLaser);
						LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LStartY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LEndY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						Angle[NewLaser] = 200;
						LaserBounce[NewLaser] = 3;
						for (int i = 0; i < 32; i++)
						{
							Ghost_Data = Clockwise + Floor(i / 4);
							BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
						}
						NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
						Trace(NewLaser);
						LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LStartY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LEndY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						Angle[NewLaser] = 160;
						LaserBounce[NewLaser] = 3;
					}
					for (int i = 0; i < 32; i++)
					{
						Ghost_Data = Clockwise + Floor(i / 4);
						BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					}
					Ghost_Data = Main;
				}
				else
				{
					for (int i = 0; i < 32; i++)
					{
						Ghost_Data = Clockwise + Floor(i / 4);
						BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					}
					int NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
					Trace(NewLaser);
					LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LStartY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LEndY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					Angle[NewLaser] = 135;
					LaserBounce[NewLaser] = 3;
					for (int i = 0; i < 32; i++)
					{
						Ghost_Data = CounterClockwise + Floor(i / 4);
						BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					}
					NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
					Trace(NewLaser);
					LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LStartY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
					LEndY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
					Angle[NewLaser] = 225;
					LaserBounce[NewLaser] = 3;
					if (Ghost_HP <= (MaxHP / 2))
					{
						for (int i = 0; i < 32; i++)
						{
							Ghost_Data = Clockwise + Floor(i / 4);
							BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
						}
						NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
						Trace(NewLaser);
						LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LStartY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LEndY[NewLaser] = Clamp(Ghost_Y + 24, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						Angle[NewLaser] = 135;
						LaserBounce[NewLaser] = 3;
						for (int i = 0; i < 32; i++)
						{
							Ghost_Data = CounterClockwise + Floor(i / 4);
							BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
						}
						NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
						Trace(NewLaser);
						LStartX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LStartY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						LEndX[NewLaser] = Clamp(Ghost_X + 8, 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
						LEndY[NewLaser] = Clamp(Ghost_Y + 8, 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
						Angle[NewLaser] = 225;
						LaserBounce[NewLaser] = 3;
					}
					for (int i = 0; i < 32; i++)
					{
						Ghost_Data = CounterClockwise + Floor(i / 4);
						BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
					}
					Ghost_Data = Main;
				}
				AttackCounter = Rand(300, 420);
			}
			else if (FireballCounter <= 0)
			{
				for (int i = 0; i < 32; i++)
				{
					Ghost_Data = Clockwise + Floor(i / 4);
					BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
				}
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(180), 200, ghost->WeaponDamage, -1, -1, 0);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(210), 200, ghost->WeaponDamage, -1, -1, 0);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(150), 200, ghost->WeaponDamage, -1, -1, 0);
				for (int i = 0; i < 32; i++)
				{
					Ghost_Data = CounterClockwise + Floor(i / 4);
					BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
				}
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(195), 300, ghost->WeaponDamage, -1, -1, 0);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(225), 300, ghost->WeaponDamage, -1, -1, 0);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(165), 300, ghost->WeaponDamage, -1, -1, 0);
				FireEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y +8, DegtoRad(135), 300, ghost->WeaponDamage, -1, -1, 0);
				FireballCounter = Rand(120, 240);
				Ghost_Data = Main;
			}
			if (Ghost_HP <= (MaxHP / 3))
			{
				if (MovingDown) Ghost_Y+=2;
				else if (!MovingDown) Ghost_Y-=2;
			}
			else
			{
				if (MovingDown) Ghost_Y++;
				else if (!MovingDown) Ghost_Y--;
			}
			BeamosWaitframe(this, ghost, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
		}
	}
	void BeamosWaitframe(ffc this, npc ghost, int Angle, int LStartX, int LStartY, int LEndX, int LEndY, int LaserLength, bool LaserEnded, int LaserBounce)
	{
		HandleLasers(ghost, this, Angle, LStartX, LStartY, LEndX, LEndY, LaserLength, LaserEnded, LaserBounce);
		if (!Ghost_Waitframe(this, ghost, false, false))
		{
			for (int i = Screen->NumNPCs(); i > 1; i--)
			{
				npc Kill = Screen->LoadNPC(i);
				Kill->HP = 0;
			}
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon Kill = Screen->LoadEWeapon(i);
				Kill->DeadState = 0;
			}
			Ghost_DeathAnimation(this, ghost, GHD_EXPLODE);
			Quit();
		}
	}
	void HandleLasers(npc ghost, ffc this, int Angle, int LStartX, int LStartY, int LEndX, int LEndY, int LaserLength, bool LaserEnded, int LaserBounce)
	{
		for (int k = 0; k < 20; k++)
		{
			if (IsValidLaser(LStartX, LStartY, LEndX, LEndY, k))
			{
				if (Distance(LStartX[k], LStartY[k], LEndX[k], LEndY[k])<BEAMOS_LASER_LENGTH&&!LaserEnded[k])
				{
					int LDist = Distance(LStartX[k], LStartY[k], LEndX[k], LEndY[k]);
					LEndX[k] += VectorX(BEAMOS_LASER_SPEED, Angle[k]);
					LEndY[k] += VectorY(BEAMOS_LASER_SPEED, Angle[k]);
					LaserLength[k] += BEAMOS_LASER_SPEED;
					if(((Screen->isSolid(LEndX[k] - BEAMOS_LASER_SPEED, LEndY[k]) || Screen->isSolid(LEndX[k] + BEAMOS_LASER_SPEED, LEndY[k]) || Screen->isSolid(LEndX[k], LEndY[k] - BEAMOS_LASER_SPEED) || Screen->isSolid(LEndX[k], LEndY[k] + BEAMOS_LASER_SPEED))&&Distance(LStartX[k], LStartY[k], LEndX[k], LEndY[k])>=BEAMOS_LASER_MINDIST)||(LEndX[k]<-16||LEndX[k]>272||LEndY[k]<-16||LEndY[k]>192))
					{
						LaserEnded[k] = true;
						if (LaserBounce[k] > 0)
						{
							int NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
							Trace(NewLaser);
							LStartX[NewLaser] = Clamp(LEndX[k], 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
							LStartY[NewLaser] = Clamp(LEndY[k], 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
							LEndX[NewLaser] = Clamp(LEndX[k], 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
							LEndY[NewLaser] = Clamp(LEndY[k], 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
							Angle[NewLaser] = BounceAngle(LEndX[k], LEndY[k], 0, 0, Angle[k]);
							LaserBounce[NewLaser] = LaserBounce[k] - 1;
						}
					}
					//Draw everything in order
					if(Link->HP>0){
						Screen->Rectangle(LAYER_BEAMOS2, LStartX[k], LStartY[k]-1, LStartX[k]+LDist, LStartY[k]+1, COLOR_BEAMOS_LASER2, 1, LStartX[k], LStartY[k], Angle[k], true, 128);
						Screen->Line(LAYER_BEAMOS2, LStartX[k], LStartY[k], LEndX[k], LEndY[k], COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
						Screen->FastCombo(LAYER_BEAMOS2, LStartX[k]-8, LStartY[k]-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
					}
					CheckBeamosLaser(ghost, LStartX[k], LStartY[k], LEndX[k], LEndY[k]);
					//Ghost_Waitframe(this, ghost, true, true);
				}
				else
				{
					if(!LaserEnded[k]){
						if(((!Screen->isSolid(LEndX[k] - BEAMOS_LASER_SPEED, LEndY[k]) && !Screen->isSolid(LEndX[k] + BEAMOS_LASER_SPEED, LEndY[k]) && !Screen->isSolid(LEndX[k], LEndY[k] - BEAMOS_LASER_SPEED) && !Screen->isSolid(LEndX[k], LEndY[k] + BEAMOS_LASER_SPEED))
						&&!(LEndX[k]<-16||LEndX[k]>272||LEndY[k]<-16||LEndY[k]>192))||Distance(LStartX[k], LStartY[k], LEndX[k], LEndY[k])<BEAMOS_LASER_MINDIST){
							int LDist = Distance(LStartX[k], LStartY[k], LEndX[k], LEndY[k]);
							LStartX[k] += VectorX(BEAMOS_LASER_SPEED, Angle[k]);
							LStartY[k] += VectorY(BEAMOS_LASER_SPEED, Angle[k]);
							LEndX[k] += VectorX(BEAMOS_LASER_SPEED, Angle[k]);
							LEndY[k] += VectorY(BEAMOS_LASER_SPEED, Angle[k]);
							if((Screen->isSolid(LEndX[k] - BEAMOS_LASER_SPEED, LEndY[k]) || Screen->isSolid(LEndX[k] + BEAMOS_LASER_SPEED, LEndY[k]) || Screen->isSolid(LEndX[k], LEndY[k] - BEAMOS_LASER_SPEED) || Screen->isSolid(LEndX[k], LEndY[k] + BEAMOS_LASER_SPEED))) 
							{
								LaserEnded[k] = true;
								if (LaserBounce[k] > 0)
								{
									int NewLaser = GetUnusedLaser(LStartX, LStartY, LEndX, LEndY);
									Trace(NewLaser);
									LStartX[NewLaser] = Clamp(LEndX[k], 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
									LStartY[NewLaser] = Clamp(LEndY[k], 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
									LEndX[NewLaser] = Clamp(LEndX[k], 16 + BEAMOS_LASER_SPEED, 240 - BEAMOS_LASER_SPEED);
									LEndY[NewLaser] = Clamp(LEndY[k], 30 + BEAMOS_LASER_SPEED, 160 - BEAMOS_LASER_SPEED);
									Angle[NewLaser] = BounceAngle(LEndX[k], LEndY[k], 0, 0, Angle[k]);
									LaserBounce[NewLaser] = LaserBounce[k] - 1;
								}
							}
							Screen->Rectangle(LAYER_BEAMOS2, LStartX[k], LStartY[k]-1, LStartX[k]+LDist, LStartY[k]+1, COLOR_BEAMOS_LASER2, 1, LStartX[k], LStartY[k], Angle[k], true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX[k], LStartY[k], LEndX[k], LEndY[k], COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							CheckBeamosLaser(ghost, LStartX[k], LStartY[k], LEndX[k], LEndY[k]);
							//Ghost_Waitframe(this, ghost, true, true);
						}
					}
					else if (Distance(LStartX[k], LStartY[k], LEndX[k], LEndY[k])>BEAMOS_LASER_SPEED){
						int LDist = Distance(LStartX[k], LStartY[k], LEndX[k], LEndY[k]);
						if(LaserLength[k]>BEAMOS_LASER_LENGTH){
							LStartX[k] += VectorX(BEAMOS_LASER_SPEED, Angle[k]);
							LStartY[k] += VectorY(BEAMOS_LASER_SPEED, Angle[k]);
						}
						if(LaserLength[k]<=BEAMOS_LASER_LENGTH)
							LaserLength[k] += BEAMOS_LASER_SPEED;
						//Draw everything in order
						if(Link->HP>0){
							Screen->Rectangle(LAYER_BEAMOS2, LStartX[k], LStartY[k]-1, LStartX[k]+LDist, LStartY[k]+1, COLOR_BEAMOS_LASER2, 1, LStartX[k], LStartY[k], Angle[k], true, 128);
							Screen->Line(LAYER_BEAMOS2, LStartX[k], LStartY[k], LEndX[k], LEndY[k], COLOR_BEAMOS_LASER1, 1, 0, 0, 0, 128);
							if(LaserLength[k]<=BEAMOS_LASER_LENGTH)
								Screen->FastCombo(LAYER_BEAMOS2, LStartX[k]-8, LStartY[k]-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
							Screen->FastCombo(LAYER_BEAMOS2, LEndX[k]-8, LEndY[k]-8, CMB_BEAMOS_LASER_ENDPOINT, CS_BEAMOS_LASER_ENDPOINT, 128);
						}
						CheckBeamosLaser(ghost, LStartX[k], LStartY[k], LEndX[k], LEndY[k]);
						//Ghost_Waitframe(this, ghost, true, true);
					}
					else
					{
						LStartX[k] = -1;
						LStartY[k] = -1;
						LEndX[k] = -1;
						LEndY[k] = -1;
						LaserLength[k] = 0;
						LaserEnded[k] = false;
						LaserBounce[k] = 0;
					}
				}
			}
		}
	}
	int GetUnusedLaser(int LStartX, int LStartY, int LEndX, int LEndY)
	{
		int counting = 0;
		for (int i = 0; i < 20; i++)
		{
			if (LStartX[i] <= -1) counting++;
			if (LStartY[i] <= -1) counting++;
			if (LEndX[i] <= -1) counting++;
			if (LEndY[i] <= -1) counting++;
			if (counting >= 3) return i;
			else counting = 0;
		}
	}
	bool IsValidLaser(int LStartX, int LStartY, int LEndX, int LEndY, int Index)
	{
		int counting = 0;
		if (LStartX[Index] <= -1) counting++;
		if (LStartY[Index] <= -1) counting++;
		if (LEndX[Index] <= -1) counting++;
		if (LEndY[Index] <= -1) counting++;
		if (counting >= 3) return false;
		else return true;
	}
	int BounceAngle(int X, int Y, int width, int height, int angle)
	{
		if (Screen->isSolid(X - BEAMOS_LASER_SPEED, Y + Round(height / 2)) || X - BEAMOS_LASER_SPEED <= 0)
		{
			return ((90 + (90 - angle)) % 360);
		}
		if (Screen->isSolid(X + width + BEAMOS_LASER_SPEED, Y + Round(height / 2)) || X + width + BEAMOS_LASER_SPEED >= 255)
		{
			return ((270 + (270 - angle)) % 360);
		}		
		// Change Y velocity when bouncing on horizontal surface.
		if (Screen->isSolid(X + Round(width / 2), Y - BEAMOS_LASER_SPEED) || Y - BEAMOS_LASER_SPEED <= 0)
		{
			return ((180 + (180 - angle)) % 360);
		}
		if (Screen->isSolid(X + Round(width / 2), Y + height + BEAMOS_LASER_SPEED) || Y + height + BEAMOS_LASER_SPEED >= 175)
		{
			return ((0 - angle) % 360);
		}
	}
	void CheckBeamosLaser(npc ghost, int StartX, int StartY, int EndX, int EndY){
		if(lineBoxCollision(StartX, StartY, EndX, EndY, Link->X, Link->Y, Link->X+Link->HitWidth, Link->Y+Link->HitHeight, 0)){
			eweapon e = FireEWeapon(EW_SCRIPT10, Link->X+InFrontX(Link->Dir, 10), Link->Y+InFrontY(Link->Dir, 10), 0, 0, ghost->WeaponDamage, -1, -1, EWF_UNBLOCKABLE);
			SetEWeaponLifespan(e, EWL_TIMER, 1);
			SetEWeaponDeathEffect(e, EWD_VANISH, 0);
			e->DrawYOffset = -1000;
		}
	}
}