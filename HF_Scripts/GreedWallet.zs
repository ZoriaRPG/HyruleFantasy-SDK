void GreedWallet()
{
	if (Link->Item[178])
	{
		if (Game->Counter[CR_RUPEES] >= 10000)
		{
			if (Game->Counter[CR_SCRIPT1] < 50000) Game->Counter[CR_SCRIPT1]++;
			Game->Counter[CR_RUPEES]-=10000;
		}
		for (int i = 1; i <= Screen->NumItems(); i++)
		{
			item Greedy = Screen->LoadItem(i);
			if (Greedy->Misc[0] != 0)
			{
				Greedy->Misc[2] += Greedy->Misc[0];
				if (Abs(Greedy->Misc[2]) >= 1) 
				{
					Greedy->X += Greedy->Misc[2];
					Greedy->Misc[2] -= (Greedy->Misc[2] << 0);
				}
			}
			if (Greedy->Misc[1] != 0)
			{
				Greedy->Misc[3] += Greedy->Misc[1];
				if (Abs(Greedy->Misc[3]) >= 1) 
				{
					Greedy->Y += Greedy->Misc[3];
					Greedy->Misc[3] -= (Greedy->Misc[3] << 0);
				}
			}
			if (Greedy->ID >= 180 && Greedy->ID <= 182 && Greedy->Z <= 0)
			{
				Greedy->Misc[0] = 0;
				Greedy->Misc[1] = 0;
			}
			if (Greedy->ID == 0)
			{
				for (int l = Rand(3, 6); l > 0; l--)
				{
					item Rupee = Screen->CreateItem(180);
					Rupee->X = Greedy->X;
					Rupee->Y = Greedy->Y;
					Rupee->Jump = (Rand(1, 3) / 2);
					Rupee->Z = 4;
					//Rupee->Vx = Rand(-4, 4) / 4;
					//Rupee->Vy = Rand(-4, 4) / 4;
					Rupee->Misc[0] = Rand(-4, 4) / 4;
					Rupee->Misc[1] = Rand(-4, 4) / 4;
				}
				Remove(Greedy);
			}
			if (Greedy->ID == 1)
			{
				for (int l = Rand(11, 17); l > 0; l--)
				{
					item Rupee = Screen->CreateItem(180);
					Rupee->X = Greedy->X;
					Rupee->Y = Greedy->Y;
					Rupee->Jump = (Rand(1, 3) / 2);
					Rupee->Z = 4;
					//Rupee->Vx = Rand(-4, 4) / 4;
					//Rupee->Vy = Rand(-4, 4) / 4;
					Rupee->Misc[0] = Rand(-4, 4) / 4;
					Rupee->Misc[1] = Rand(-4, 4) / 4;
				}
				Remove(Greedy);
			}
			if (Greedy->ID == 86)
			{
				int lightning[] = "RupeeShower";
				int script_num = Game->GetFFCScript(lightning); //Lightning is a script.
				ffc Greedier = Screen->LoadFFC(RunFFCScript(script_num, 0)); 
				Greedier->X = Greedy->X;
				Greedier->Y = Greedy->Y;
				Remove(Greedy);
			}
		}
	}
}

ffc script RupeeShower
{
	void run()
	{
		for (int i = 0; i < 360; i++)
		{
			if (i % 12 == 0)
			{
				item Rupee = Screen->CreateItem(180 + Rand(3));
				Rupee->X = this->X;
				Rupee->Y = this->Y;
				Rupee->Jump = (Rand(1, 3) / 2);
				Rupee->Z = 4;
				//Rupee->Vx = Rand(-4, 4) / 4;
				//Rupee->Vy = Rand(-4, 4) / 4;
				Rupee->Misc[0] = Rand(-4, 4) / 4;
				Rupee->Misc[1] = Rand(-4, 4) / 4;
			}
			Waitframe();
		}
	}
}

bool GreaterLarge (int bignum, int smallnum)
{
	for (int i = SizeOfArray(bignum) - 1; i >= 0; i--)
	{
		if (bignum[i] > smallnum[i]) return true;
		else if (bignum[i] == smallnum[i]) continue;
		else if (bignum[i] < smallnum[i]) break;
	}
	return false;
}

bool GreaterEqualLarge (int bignum, int smallnum)
{
	for (int i = SizeOfArray(bignum) - 1; i >= 0; i--)
	{
		if (bignum[i] > smallnum[i]) return true;
		else if (bignum[i] == smallnum[i] && i!=0) continue;
		else if (bignum[i] == smallnum[i] && i==0) return true;
		else if (bignum[i] < smallnum[i]) break;
	}
	return false;
}

void SubtractLarge (int num1, int num2)
{
	for (int i = 0; i < SizeOfArray(num1); i++)
	{
		num1[i] -= num2[i];
		if (num1[i] < 0) 
		{
			if (i < SizeOfArray(num1) - 1) 
			{
				while (num1[i] < 0) 
				{
					num1[i]+=10000;
					num2[i+1]++;
				}
			}
			else
			{
				for (int l = 0; l < SizeOfArray(num1); l++)
				{
					num1[l] = 0;
				}
				break;
			}
		}
	}
}

ffc script GreedFill
{
	void run()
	{
		while(true)
		{
			if (LinkCollision(this))
			{
				Game->Counter[CR_SCRIPT1]++;
			}
			Waitframe();
		}
	}
}