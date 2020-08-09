const int SPIN_WASSPIN = 500;
const int SPIN_CHARGECOUNTER = 500;

void SpinAttack()
{
	if (Link->Action == LA_SPINNING)
	{
		if (GenBool[SPIN_WASSPIN] == false)
		{
			GenBool[SPIN_WASSPIN] = true;
			int buffer[] = "SpinAttackByrna";
			int scr = Game->GetFFCScript(buffer);
			RunFFCScript(scr, 0);
		}
	}
	else GenBool[SPIN_WASSPIN] = false;
	if (Link->Action == LA_CHARGING)
	{
		if (GenInt[SPIN_CHARGECOUNTER] < 200000) GenInt[SPIN_CHARGECOUNTER]++;
		else GenInt[SPIN_CHARGECOUNTER]-=12;
		if ((Link->Item[102] && GenInt[SPIN_CHARGECOUNTER] >= 1) ||
		(Link->Item[101] && GenInt[SPIN_CHARGECOUNTER] >= 45) ||
		(GenInt[SPIN_CHARGECOUNTER] >= 70))
		{
			if (GenInt[SPIN_CHARGECOUNTER] % 6 == 0)
			{
				lweapon ChargedWeapon = Screen->LoadLWeapon(1);
				if (ChargedWeapon->isValid())
				{
					lweapon Sparkle = Screen->CreateLWeapon(LW_SPARKLE);
					Sparkle->UseSprite(132);
					if (Link->Dir == DIR_UP || ChargedWeapon->ID == LW_HAMMER)
					{
						Sparkle->X = ChargedWeapon->X + ChargedWeapon->DrawXOffset - 2 + Rand(-2, 2);
						Sparkle->Y = ChargedWeapon->Y + ChargedWeapon->DrawYOffset - 8 + Rand(-2, 2);
					}
					else if (Link->Dir == DIR_LEFT)
					{
						Sparkle->X = ChargedWeapon->X + ChargedWeapon->DrawXOffset - 8 + Rand(-2, 2);
						Sparkle->Y = ChargedWeapon->Y + ChargedWeapon->DrawYOffset + 4 + Rand(-2, 2);
					}
					else if (Link->Dir == DIR_RIGHT)
					{
						Sparkle->X = ChargedWeapon->X + ChargedWeapon->DrawXOffset + 8 + Rand(-2, 2);
						Sparkle->Y = ChargedWeapon->Y + ChargedWeapon->DrawYOffset + 4 + Rand(-2, 2);
					}
					else if (Link->Dir == DIR_DOWN)
					{
						Sparkle->X = ChargedWeapon->X + ChargedWeapon->DrawXOffset + 2 + Rand(-2, 2);
						Sparkle->Y = ChargedWeapon->Y + ChargedWeapon->DrawYOffset + 8 + Rand(-2, 2);
					}
				}
			}
		}
	}
	else GenInt[SPIN_CHARGECOUNTER] = 0;
}

ffc script SpinAttackByrna
{
	void run()
	{
		int OrbitAngle = RadtoDeg(dirToRad(Link->Dir)) + 15;
		lweapon SpinAttackOrbit = Screen->CreateLWeapon(LW_BEAM);
		this->X = 0;
		this->Y = 0;
		SpinAttackOrbit->X = Link->X;
		SpinAttackOrbit->Y = Link->Y;
		SpinAttackOrbit->UseSprite(87);
		SpinAttackOrbit->Dir = Link->Dir; 
		if (Link->Item[36]) SpinAttackOrbit->Damage = 8;
		else if (Link->Item[7]) SpinAttackOrbit->Damage = 4;
		else if (Link->Item[6] || Link->Item[166]) SpinAttackOrbit->Damage = 2;
		else SpinAttackOrbit->Damage = 1;
		do
		{
			for(int i = 0; i < 24 && Link->Action != LA_GOTHURTLAND; i++)
			{
				lweapon Sparkle = Screen->CreateLWeapon(LW_SPARKLE);
				if (!Link->Item[170])
				{
					SpinAttackOrbit->DrawXOffset = VectorX(24, OrbitAngle);
					SpinAttackOrbit->HitXOffset = VectorX(24, OrbitAngle);
					SpinAttackOrbit->DrawYOffset = VectorY(24, OrbitAngle);
					SpinAttackOrbit->HitYOffset = VectorY(24, OrbitAngle);
				}
				else
				{
					SpinAttackOrbit->DrawXOffset = VectorX(32, OrbitAngle);
					SpinAttackOrbit->HitXOffset = VectorX(32, OrbitAngle);
					SpinAttackOrbit->DrawYOffset = VectorY(32, OrbitAngle);
					SpinAttackOrbit->HitYOffset = VectorY(32, OrbitAngle);
				}
				Sparkle->X = SpinAttackOrbit->X + SpinAttackOrbit->DrawXOffset;
				Sparkle->Y = SpinAttackOrbit->Y + SpinAttackOrbit->DrawYOffset;
				Sparkle->UseSprite(132);
				SpinAttackOrbit->Dir = Link->Dir; 
				SpinAttackOrbit->DeadState = -1; 
				SpinAttackOrbit->X = Link->X;
				SpinAttackOrbit->Y = Link->Y;
				OrbitAngle-=15;
				OrbitAngle%=360;
				Waitframe();
			}
		}while (Link->Action == LA_SPINNING)
		Remove(SpinAttackOrbit);
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
}