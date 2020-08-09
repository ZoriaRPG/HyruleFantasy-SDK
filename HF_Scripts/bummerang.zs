item script OneUppingZoriaSince2017
{
	void run()
	{
		if (NumLWeaponsOf(LW_BRANG) <= 0)
		{
			for (int i = 0; i < 360; i+=3)
			{
				lweapon boomerang = Screen->CreateLWeapon(LW_BRANG);
				boomerang->Angular = true;
				boomerang->Angle = DegtoRad(i);
				boomerang->X = Link->X + VectorX(16, i);
				boomerang->Y = Link->Y + VectorY(16, i);
			}
		}
	}
}