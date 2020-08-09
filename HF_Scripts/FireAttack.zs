ffc script HomingFire
{
	void run(int damage, int speed, int bouncemax, int startangle)
	{
		int bounce = 0;
		int angle = startangle;
		int anglelink = Angle(this->X, this->Y, Link->X, Link->Y);
		int counter = 0;
		eweapon FireSnek = FireEWeapon(EW_FIRE, this->X, this->Y, 0, 0, damage, -1, -1, EWF_UNBLOCKABLE);
		SetEWeaponLifespan(FireSnek, EWL_TIMER, 45);
		SetEWeaponDeathEffect(FireSnek, EWD_VANISH, 0);
		int bounced = 0;
		while(bounce < bouncemax || bouncemax == -1)
		{
			//int Hex = (Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
			counter++;
			if (counter == 6)
			{
				this->X += VectorX(speed, angle);
				this->Y += VectorY(speed, angle);
				if (bounced > 0) bounced--;
				if (!CanWalk(this->X, this->Y, VelocityToDir4(VectorX(speed, angle), 0), VectorX(speed, angle), false)) 
				{
					angle = Angle(0, 0, 0 - VectorX(speed, angle), 0 + VectorY(speed, angle));
					anglelink = Angle(this->X, this->Y, Link->X, Link->Y);
					if (bounced <= 0) bounced = 2;
				}
				if (!CanWalk(this->X, this->Y, VelocityToDir4(0, VectorY(speed, angle)), VectorY(speed, angle), true))
				{
					angle = Angle(0, 0, 0 + VectorX(speed, angle), 0 - VectorY(speed, angle));
					anglelink = Angle(this->X, this->Y, Link->X, Link->Y);
					if (bounced <= 0) bounced = 2;
				}
				if (bounced == 2) bounce++;
				eweapon FireSnek2 = FireEWeapon(EW_FIRE, this->X, this->Y, 0, 0, damage, -1, -1, EWF_UNBLOCKABLE);
				SetEWeaponLifespan(FireSnek2, EWL_TIMER, 45);
				SetEWeaponDeathEffect(FireSnek2, EWD_VANISH, 0);
			}
			counter%=6;
			if (Sign(angleDifference(DegtoRad(angle), DegtoRad(anglelink))) > 0)
			{
				angle++;
			}
			else if (Sign(angleDifference(DegtoRad(angle), DegtoRad(anglelink))) < 0)
			{
				angle--;
			}
			angle %= 360;
			Waitframe();
		}
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}

ffc script FireShock
{
	void run(int damage, int dir)
	{
		int angle = 0;
		if (dir == DIR_UP) angle = 270;
		else if (dir == DIR_DOWN) angle = 90;
		else if (dir == DIR_LEFT) angle = 180;
		int origangle = angle;
		bool increase;
		this->X -= 8;
		this->Y -= 8;
		for (int i = 25; i < 200; i+=4)
		{
			if (Abs(origangle - angle) > 45) increase = !increase;
			if (increase) angle += 2;
			else angle -= 2;
			
			eweapon FireSnek = Screen->CreateEWeapon(EW_FIRE);
			FireSnek->X = this->X;
			FireSnek->Y = this->Y;
			FireSnek->Damage = damage;
			FireSnek->Angular = true;
			FireSnek->Angle = DegtoRad(angle);
			FireSnek->Step = i;
			Waitframe();
		}
		for (int i = 0; i < 240; i++)
		{
			if (Abs(origangle - angle) > 45) increase = !increase;
			if (increase) angle += 2;
			else angle -= 2;
			
			eweapon FireSnek = Screen->CreateEWeapon(EW_FIRE);
			FireSnek->X = this->X;
			FireSnek->Y = this->Y;
			FireSnek->Damage = damage;
			FireSnek->Angular = true;
			FireSnek->Angle = DegtoRad(angle);
			FireSnek->Step = 200;
			
			if (i % 60 == 0)
			{
				eweapon FIREBALL = FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad((origangle + 90) % 360), 400, damage, -1, -1, EWF_UNBLOCKABLE);
				eweapon FIREBALL2 = FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad((origangle - 90) % 360), 400, damage, -1, -1, EWF_UNBLOCKABLE);
				eweapon FIREBALL3 = FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad((origangle + 90) % 360), 400, damage, -1, -1, EWF_UNBLOCKABLE);
				eweapon FIREBALL4 = FireEWeapon(EW_FIREBALL, this->X, this->Y, DegtoRad((origangle - 90) % 360), 400, damage, -1, -1, EWF_UNBLOCKABLE);
				if (dir == DIR_UP || dir == DIR_DOWN)
				{
					SetEWeaponMovement(FIREBALL, EWM_HOMING_REAIM, 1, 38);
					SetEWeaponMovement(FIREBALL2, EWM_HOMING_REAIM, 1, 38);
					SetEWeaponMovement(FIREBALL3, EWM_HOMING_REAIM, 1, 27);
					SetEWeaponMovement(FIREBALL4, EWM_HOMING_REAIM, 1, 27);
				}
				else
				{
					SetEWeaponMovement(FIREBALL, EWM_HOMING_REAIM, 1, 28);
					SetEWeaponMovement(FIREBALL2, EWM_HOMING_REAIM, 1, 28);
					SetEWeaponMovement(FIREBALL3, EWM_HOMING_REAIM, 1, 22);
					SetEWeaponMovement(FIREBALL4, EWM_HOMING_REAIM, 1, 22);
				}
			}
			Waitframe();
		}
		this->InitD[2] = 1;
		Waitframe();
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}

ffc script HandleFireDrawing
{
	void run()
	{
		while(true)
		{
			for (int i = Screen->NumEWeapons(); i > 0; i--)
			{
				eweapon wpn = Screen->LoadEWeapon(i);
				if (wpn->Misc[__EWI_LIFESPAN] == EWL_NEAR_LINK)
				{
					Screen->Circle(2, wpn->X + 8 + Rand(-1, 1), wpn->Y + 8 + Rand(-1, 1), wpn->Misc[__EWI_LIFESPAN_ARG], 12, 1, 0, 0, 0, true, OP_TRANS);
				}
				else if (wpn->ID == EW_SCRIPT5)
				{
					int angle = Angle(wpn->X + wpn->DrawXOffset, wpn->Y + wpn->DrawYOffset, wpn->X, wpn->Y);
					wpn->DrawXOffset += VectorX(5, angle);
					wpn->DrawYOffset += VectorY(5, angle);
					if(GH_SHADOW_TRANSLUCENT>0) Screen->DrawTile(1, wpn->X + wpn->DrawXOffset, wpn->Y, GH_SHADOW_TILE+__ghzhData[__GHI_SHADOW_FRAME], 1, 1, GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
					else Screen->DrawTile(1, wpn->X + wpn->DrawXOffset, wpn->Y, GH_SHADOW_TILE+__ghzhData[__GHI_SHADOW_FRAME], 1, 1, GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
					if(Distance(wpn->X, wpn->Y, wpn->X + wpn->DrawXOffset, wpn->Y + wpn->DrawYOffset) < 4){
						eweapon Explode = Screen->CreateEWeapon(EW_BOMBBLAST);
						Explode->X = wpn->X;
						Explode->Y = wpn->Y;
						Explode->Damage = 8;
						Screen->Quake = 100;
						FireEWeapon(EW_SCRIPT3, wpn->X, wpn->Y, DegtoRad(45), 200, 8, 83, SFX_ICE, 0);
						FireEWeapon(EW_SCRIPT3, wpn->X, wpn->Y, DegtoRad(135), 200, 8, 83, SFX_ICE, 0);
						FireEWeapon(EW_SCRIPT3, wpn->X, wpn->Y, DegtoRad(225), 200, 8, 83, SFX_ICE, 0);
						FireEWeapon(EW_SCRIPT3, wpn->X, wpn->Y, DegtoRad(315), 200, 8, 83, SFX_ICE, 0);
						Remove(wpn);
					}
				}
			}
			Waitframe();
		}
	}
}

ffc script FireExplode
{
	void run(int damage)
	{
		eweapon Boom = FireAimedEWeapon(EW_FIREBALL, this->X, this->Y, 0, 100, damage, -1, -1, EWF_UNBLOCKABLE);
		SetEWeaponLifespan(Boom, EWL_NEAR_LINK, 32); //EWD_RUN_SCRIPT
		int lightning[] = "FireRing";
		int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
		SetEWeaponDeathEffect(Boom, EWD_RUN_SCRIPT, script_num);
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}

ffc script FireRing
{
	void run()
	{
		eweapon Hey = GetAssociatedEWeapon(this->InitD[0]);
		int damage = Hey->Damage;
		for (int i = 0; i < 360; i += 22.5)
		{
			eweapon Flame = Screen->CreateEWeapon(EW_FIRE);
			Flame->X = Hey->X;
			Flame->Y = Hey->Y;
			Flame->Angular = true;
			Flame->Angle = DegtoRad(i);
			Flame->Step = 100;
			Flame->Damage = damage;
		}
		Remove(Hey);
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}

ffc script IceMeteor
{
	void run()
	{
		int targetx = Rand(32, 223);
		int targety = Rand(32, 143);
		int impactcombo = ComboAt(targetx, targety);
		int starty = ComboY(impactcombo) - 176;
		int startx = ComboX(impactcombo) + ComboY(impactcombo) / Tan(30);
		if(startx > 240){
			startx = 240;
			starty = ComboY(impactcombo) - ((startx -ComboX(impactcombo)) * Tan(30));
		}
		eweapon ember = FireEWeapon(EW_SCRIPT5, ComboX(impactcombo), ComboY(impactcombo), 0, 0, 0, 108, 0, 0);
		ember->CollDetection = false;
		ember->DrawXOffset = startx - ComboX(impactcombo);
		ember->DrawYOffset = starty - ComboY(impactcombo);
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}

ffc script MeteorSwarm
{
	void run()
	{
		for (int i = 0; i <= 300; i++)
		{
			if (i % 45 == 0)
			{
				int lightning[] = "IceMeteor";
				int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
				RunFFCScript(script_num, 0); 
			}
			Waitframe();
		}
	}
}

ffc script IceRing
{
	void run(int dir)
	{
		int startangle = 0;
		if (dir == DIR_UP) startangle = 90;
		if (dir == DIR_DOWN) startangle = 270;
		if (dir == DIR_RIGHT) startangle = 180;
		
		eweapon Ice[8];
		int angle = startangle;
		for (int i = 0; i < 360; i+=8)
		{
			angle-=8;
			angle%=360;
			if (i == 0) Ice[0] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle), 80 + VectorY(48, angle), 0, 0, 8, 83, SFX_ICE, 0);
			if (i == 48) Ice[1] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle + 45), 80 + VectorY(48, angle + 45), 0, 0, 8, 83, SFX_ICE, 0);
			if (i == 88) Ice[2] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle + 90), 80 + VectorY(48, angle + 90), 0, 0, 8, 83, SFX_ICE, 0);
			if (i == 136) Ice[3] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle + 135), 80 + VectorY(48, angle + 135), 0, 0, 8, 83, SFX_ICE, 0);
			if (i == 184) Ice[4] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle + 180), 80 + VectorY(48, angle + 180), 0, 0, 8, 83, SFX_ICE, 0);
			if (i == 224) Ice[5] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle + 225), 80 + VectorY(48, angle + 225), 0, 0, 8, 83, SFX_ICE, 0);
			if (i == 272) Ice[6] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle + 270), 80 + VectorY(48, angle + 270), 0, 0, 8, 83, SFX_ICE, 0);
			if (i == 320) Ice[7] = FireEWeapon(EW_SCRIPT3, 120 + VectorX(88, angle + 315), 80 + VectorY(48, angle + 315), 0, 0, 8, 83, SFX_ICE, 0);
			
			for (int j = 0; j < 8; j++)
			{
				if (Ice[j]->isValid())
				{
					Ice[j]->X = 120 + VectorX(88, angle + (j*45));
					Ice[j]->Y = 80 + VectorY(48, angle + (j*45));
					Ice[j]->DeadState = -1;
				}
			}
			Waitframe();
		}
		int angle2 = 0;
		for (int i = 0; i < 225; i++)
		{
			angle-=8;
			angle%=360;
			angle2+=2;
			angle2%=360;
			for (int j = 0; j < 8; j++)
			{
				if (Ice[j]->isValid())
				{
					Ice[j]->X = 120; 
					Ice[j]->Y = 80;
					Ice[j]->DrawXOffset = VectorX(i, angle2) + VectorX(88 + (i * 1.25), angle + (j*45));
					Ice[j]->DrawYOffset = VectorY(i, angle2) + VectorY(48 + (i * 1.25), angle + (j*45));
					Ice[j]->HitXOffset = VectorX(i, angle2) + VectorX(88 + (i * 1.25), angle + (j*45));
					Ice[j]->HitYOffset = VectorY(i, angle2) + VectorY(48 + (i * 1.25), angle + (j*45));
					Ice[j]->DeadState = -1;
				}
			}
			Waitframe();
		}
		for (int j = 0; j < 8; j++)
		{
			if (Ice[j]->isValid())
			{
				Ice[j]->DeadState = 0;
			}
		}
		this->InitD[2] = 1;
		Waitframe();
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}

bool IsFreezing = false;

ffc script FrostCircle
{
	void run(int radius, int duration)
	{
		for (int i = duration; i > 0 || duration == -1; i--)
		{
			//Game->Counter[CR_RUPEES] = (LS_Speed * 100);
			if (Distance(Link->X + 8, Link->Y + 8, this->X + 8, this->Y + 8) <= radius + 4)
			{
				//LS_LinkSpeed = 0.5;
				IsFreezing = true;
			}
			if (i % 3 == 0) Screen->Circle(3, this->X + 8 + Rand(-1, 1), this->Y + 8 + Rand(-1, 1), radius, 1, 1, 0, 0, 0, true, OP_TRANS);
			else Screen->Circle(3, this->X + 8 + Rand(-1, 1), this->Y + 8 + Rand(-1, 1), radius, 6, 1, 0, 0, 0, true, OP_TRANS);
			Waitframe();
		}
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}