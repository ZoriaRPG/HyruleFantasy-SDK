const int NEWLINK_DATA = 11008;

int GetShield()
{
	if (Link->Item[37]) return 3;
	else if (Link->Item[8]) return 2;
	else if (Link->Item[93]) return 1;
	else return 0;
}

void NewLinkActions1()
{
	Vanish();
	GenInt[200] = 0;
}

void NewLinkActions2()
{
	if (GenInt[200] == 0)
	{
		if (Link->Action == LA_WALKING) GenInt[200] == 1;
	}
	else if (GenInt[200] > 1)
	{
		GenInt[202] = 0;
	}
	if (GenInt[200] == 1) GenInt[202]++;
	GenInt[202]%=14;
	
	if (GenInt[200] <= 1)
	{
		if (GenInt[202] < 7) Screen->FastCombo(3, Link->X, Link->Y, NEWLINK_DATA + Link->Dir + (GetShield() *104), 6, OP_OPAQUE);
		else Screen->FastCombo(3, Link->X, Link->Y, NEWLINK_DATA + Link->Dir + (GetShield() *104), 6, OP_OPAQUE);
	}
}