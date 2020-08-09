//0.1807
const int CRACKSCREEN = 15;
const int CEILSCREEN = 31;

ffc script Z3Auto
{
	
	void run(int screenheight)
	{
		int height = 0;
		int ScreenSave[176];
		for (int k = 0; k < 176; k++)
		{
			ScreenSave[k] = Screen->ComboD[k];
		}
		int maxdrawheight = (screenheight) * 176;
		int maxheight = (screenheight - 1) * 176;
		int screen = Floor(height / 176);
		int curheight = height % 176;
		int linkheight = height + Link->Y;
		int SaveHeight = height;
		int LinkFloat = 0;
		int lastscreen = screen;
		Screen->SetRenderTarget(RT_BITMAP0);
		Screen->Rectangle(2, 0, 0, 256, 176, 15, 1, 0, 0, 0, true, OP_OPAQUE);
		if (screen == 0) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, 0, 0);
		if (screen > 0) Screen->DrawScreen (2, 31, 27 + (16 * screen), 0, 0, 0);
		if (screen == 1) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, -176, 0);
		if (screen > 1) Screen->DrawScreen (2, 31, 27 + (16 * (screen - 1)), 0, -176, 0);
		if (height >= maxheight) Screen->DrawScreen (2, 31, CEILSCREEN, 0, 176, 0);
		else Screen->DrawScreen (2, 31, 27 + (16 * (screen + 1)), 0, 176, 0);
		Screen->SetRenderTarget(RT_SCREEN);
		bool Placed[4] = {false, false, false, false};
		for (int i = 240; i > 0; i--)
		{
			if (i % 6 == 0)
			{
				FireEWeapon(EW_BOMBBLAST, Rand(72, 168), Rand(144, 168), 0, 0, 0, -1, -1, EWF_NO_COLLISION);
				FireEWeapon(EW_BOMBBLAST, Rand(72, 168), Rand(144, 168), 0, 0, 0, -1, -1, EWF_NO_COLLISION);
				FireEWeapon(EW_BOMBBLAST, Rand(72, 168), Rand(144, 168), 0, 0, 0, -1, -1, EWF_NO_COLLISION);
				
				FireEWeapon(EW_BOMBBLAST, Choose(32, 208), Choose(112, 128), 0, 0, 0, -1, -1, EWF_NO_COLLISION);
			}
			Waitframe();
		}
		this->InitD[2] = 1;
		while (true)
		{
			linkheight = height + Link->Y;
			screen = Floor(height / 176);
			curheight = height % 176;
			Screen->SetRenderTarget(RT_BITMAP0);
			Screen->Rectangle(2, 0, 0, 256, 176, 15, 1, 0, 0, 0, true, OP_OPAQUE);
			if (screen == 0) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, 0, 0);
			if (screen < 0) Screen->DrawScreen (2, 31, CEILSCREEN, 0, 0, 0);
			if (screen > 0) Screen->DrawScreen (2, 31, 27 + (16 * screen), 0, 0, 0);
			if (screen == 1) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, -176, 0);
			if (screen > 1) Screen->DrawScreen (2, 31, 27 + (16 * (screen - 1)), 0, -176, 0);
			if (screen < 0) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, -176, 0);
			if (height >= maxheight) Screen->DrawScreen (2, 31, CEILSCREEN, 0, 176, 0);
			else Screen->DrawScreen (2, 31, 27 + (16 * (screen + 1)), 0, 176, 0);
			Screen->SetRenderTarget(RT_SCREEN);
			Screen->DrawBitmap (2, RT_BITMAP0, 0, curheight, 256, 176, 0, 0, 256, 176, 0, true);
			lastscreen = screen;
			
			if (this->InitD[1] == 1)
			{
				if (height < maxheight && Link->Y > 104) 
				{
					height+=1.5;
					LinkFloat += 1.5;
				}
				if (height >= 1.5 && Link->Y < 54) 
				{
					height-=1.5;
					LinkFloat -= 1.5;
				}
				while (LinkFloat >= 1)
				{
					if (CanWalk(Link->X, Link->Y, DIR_UP, 1, false)) Link->Y--;
					for (int i = Screen->NumItems(); i > 0; i--)
					{
						item Moving = Screen->LoadItem(i);
						Moving->Y--;
					}
					for (int i = Screen->NumLWeapons(); i > 0; i--)
					{
						lweapon Moving = Screen->LoadLWeapon(i);
						if (Moving->ID != LW_SWORD && Moving->ID != LW_SCRIPT3 && Moving->ID != LW_HOOKSHOT && Moving->ID != LW_HAMMER && Moving->ID != LW_WAND && Moving->ID != LW_CANEOFBYRNA) Moving->Y--;
					}
					for (int i = Screen->NumEWeapons(); i > 0; i--)
					{
						eweapon Moving = Screen->LoadEWeapon(i);
						Moving->Y--;
					}
					LinkFloat--;
				}
				while (LinkFloat <= -1)
				{
					if (CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)) Link->Y++;
					for (int i = Screen->NumItems(); i > 0; i--)
					{
						item Moving = Screen->LoadItem(i);
						Moving->Y++;
					}
					for (int i = Screen->NumLWeapons(); i > 0; i--)
					{
						lweapon Moving = Screen->LoadLWeapon(i);
						if (Moving->ID != LW_SWORD && Moving->ID != LW_SCRIPT3 && Moving->ID != LW_HOOKSHOT && Moving->ID != LW_HAMMER && Moving->ID != LW_WAND && Moving->ID != LW_CANEOFBYRNA) Moving->Y++;
					}
					for (int i = Screen->NumEWeapons(); i > 0; i--)
					{
						eweapon Moving = Screen->LoadEWeapon(i);
						Moving->Y++;
					}
					LinkFloat++;
				}
				Screen->FastCombo(2, 120, 80 - height, 3368, 2, OP_OPAQUE);
				if (Link->X > 116 && Link->X < 124 && Link->Y > 76 - height && Link->Y < 84 - height) 
				{
					while(height > 0)
					{
						NoAction();
						linkheight = height + Link->Y;
						screen = Floor(height / 176);
						curheight = height % 176;
						Screen->SetRenderTarget(RT_BITMAP0);
						Screen->Rectangle(2, 0, 0, 256, 176, 15, 1, 0, 0, 0, true, OP_OPAQUE);
						if (screen == 0) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, 0, 0);
						if (screen < 0) Screen->DrawScreen (2, 31, CEILSCREEN, 0, 0, 0);
						if (screen > 0) Screen->DrawScreen (2, 31, 27 + (16 * screen), 0, 0, 0);
						if (screen == 1) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, -176, 0);
						if (screen > 1) Screen->DrawScreen (2, 31, 27 + (16 * (screen - 1)), 0, -176, 0);
						if (screen < 0) Screen->DrawScreen (2, 31, CRACKSCREEN, 0, -176, 0);
						if (height >= maxheight) Screen->DrawScreen (2, 31, CEILSCREEN, 0, 176, 0);
						else Screen->DrawScreen (2, 31, 27 + (16 * (screen + 1)), 0, 176, 0);
						Screen->SetRenderTarget(RT_SCREEN);
						Screen->DrawBitmap (2, RT_BITMAP0, 0, curheight, 256, 176, 0, 0, 256, 176, 0, true);
						lastscreen = screen;
						if (height < 1)
						{
							LinkFloat-=height;
							height = 0;
						}
						else
						{
							height--;
							LinkFloat--;
						}
						while (LinkFloat >= 1)
						{
							if (CanWalk(Link->X, Link->Y, DIR_UP, 1, false)) Link->Y--;
							for (int i = Screen->NumItems(); i > 0; i--)
							{
								item Moving = Screen->LoadItem(i);
								Moving->Y--;
							}
							for (int i = Screen->NumLWeapons(); i > 0; i--)
							{
								lweapon Moving = Screen->LoadLWeapon(i);
								if (Moving->ID != LW_SWORD && Moving->ID != LW_SCRIPT3 && Moving->ID != LW_HOOKSHOT && Moving->ID != LW_HAMMER && Moving->ID != LW_WAND && Moving->ID != LW_CANEOFBYRNA) Moving->Y--;
							}
							for (int i = Screen->NumEWeapons(); i > 0; i--)
							{
								eweapon Moving = Screen->LoadEWeapon(i);
								Moving->Y--;
							}
							LinkFloat--;
						}
						while (LinkFloat <= -1)
						{
							if (CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)) Link->Y++;
							for (int i = Screen->NumItems(); i > 0; i--)
							{
								item Moving = Screen->LoadItem(i);
								Moving->Y++;
							}
							for (int i = Screen->NumLWeapons(); i > 0; i--)
							{
								lweapon Moving = Screen->LoadLWeapon(i);
								if (Moving->ID != LW_SWORD && Moving->ID != LW_SCRIPT3 && Moving->ID != LW_HOOKSHOT && Moving->ID != LW_HAMMER && Moving->ID != LW_WAND && Moving->ID != LW_CANEOFBYRNA) Moving->Y++;
							}
							for (int i = Screen->NumEWeapons(); i > 0; i--)
							{
								eweapon Moving = Screen->LoadEWeapon(i);
								Moving->Y++;
							}
							LinkFloat++;
						}
						Waitframe();
					}
					for (int k = 0; k < 176; k++)
					{
						Screen->ComboD[k] = ScreenSave[k];
					}
					for (int i = 0; i < 45; i++)
					{
						Waitframe();
						NoAction();
					}
					this->Data = CMB_AUTOWARP + 1;
				}
			}
			else if (this->InitD[1] != 2)
			{
				if (height < maxdrawheight)
				{
					LinkFloat += 0.1807;
					if (LinkFloat >= 1)
					{
						if (CanWalk(Link->X, Link->Y, DIR_UP, 1, false)) Link->Y--;
						for (int i = Screen->NumItems(); i > 0; i--)
						{
							item Moving = Screen->LoadItem(i);
							Moving->Y--;
						}
						for (int i = Screen->NumLWeapons(); i > 0; i--)
						{
							lweapon Moving = Screen->LoadLWeapon(i);
							if (Moving->ID != LW_SWORD && Moving->ID != LW_SCRIPT3 && Moving->ID != LW_HOOKSHOT && Moving->ID != LW_HAMMER && Moving->ID != LW_WAND && Moving->ID != LW_CANEOFBYRNA) Moving->Y--;
						}
						for (int i = Screen->NumEWeapons(); i > 0; i--)
						{
							eweapon Moving = Screen->LoadEWeapon(i);
							Moving->Y--;
						}
						LinkFloat--;
					}
					height += 0.1807;
				}
				if (height > (maxheight / 5) && Placed[0] == false)
				{
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					Placed[0] = true;
				}
				if (height > ((maxheight / 5) * 2) && Placed[1] == false)
				{
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					Placed[1] = true;
				}
				if (height > ((maxheight / 5) * 3) && Placed[2] == false)
				{
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					Placed[2] = true;
				}
				if (height > ((maxheight / 5) * 4) && Placed[3] == false)
				{
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					CreateNPCAt(Choose(289, 289, 289, 303, 303), Rand(80, 160), Rand(168, 172));
					Placed[3] = true;
				}
			}
			if (height >= 128 && Link->X < 80) Link->X +=2;
			if (height >= 128 && Link->X > 160) Link->X -=2;
			if (height >= 140)
			{
				Screen->ComboD[131] = 2972;
				Screen->ComboD[132] = 2972;
				Screen->ComboD[115] = 2972;
				Screen->ComboD[116] = 2972;
				Screen->ComboD[99] = 2972;
				Screen->ComboD[100] = 2972;
				Screen->ComboD[83] = 2972;
				Screen->ComboD[84] = 2972;
				Screen->ComboD[67] = 2972;
				Screen->ComboD[68] = 2972;
				Screen->ComboD[51] = 2972;
				Screen->ComboD[52] = 2972;
				Screen->ComboD[35] = 2972;
				Screen->ComboD[36] = 2972;
				
				Screen->ComboD[139] = 2972;
				Screen->ComboD[140] = 2972;
				Screen->ComboD[123] = 2972;
				Screen->ComboD[124] = 2972;
				Screen->ComboD[107] = 2972;
				Screen->ComboD[108] = 2972;
				Screen->ComboD[91] = 2972;
				Screen->ComboD[92] = 2972;
				Screen->ComboD[75] = 2972;
				Screen->ComboD[76] = 2972;
				Screen->ComboD[59] = 2972;
				Screen->ComboD[60] = 2972;
				Screen->ComboD[43] = 2972;
				Screen->ComboD[44] = 2972;
			}
			else
			{
				Screen->ComboD[131] = 2735;
				Screen->ComboD[132] = 2735;
				Screen->ComboD[115] = 2735;
				Screen->ComboD[116] = 2735;
				Screen->ComboD[99] = 2735;
				Screen->ComboD[100] = 2735;
				Screen->ComboD[83] = 2735;
				Screen->ComboD[84] = 2735;
				Screen->ComboD[67] = 2735;
				Screen->ComboD[68] = 2735;
				Screen->ComboD[51] = 2735;
				Screen->ComboD[52] = 2735;
				Screen->ComboD[35] = 2735;
				Screen->ComboD[36] = 2735;
				
				Screen->ComboD[139] = 2735;
				Screen->ComboD[140] = 2735;
				Screen->ComboD[123] = 2735;
				Screen->ComboD[124] = 2735;
				Screen->ComboD[107] = 2735;
				Screen->ComboD[108] = 2735;
				Screen->ComboD[91] = 2735;
				Screen->ComboD[92] = 2735;
				Screen->ComboD[75] = 2735;
				Screen->ComboD[76] = 2735;
				Screen->ComboD[59] = 2735;
				Screen->ComboD[60] = 2735;
				Screen->ComboD[43] = 2735;
				Screen->ComboD[44] = 2735;
			}
			if (height >=16)
			{
				for (int i = 3; i <= 12; i++)
				{
					Screen->ComboD[i] = 2735;
				}
				if (height >= 128)
				{
					Screen->ComboD[3] = 2972;
					Screen->ComboD[4] = 2972;
					Screen->ComboD[11] = 2972;
					Screen->ComboD[12] = 2972;
				}
			}
			if (height >=32)
			{
				for (int i = 19; i <= 28; i++)
				{
					Screen->ComboD[i] = 2735;
				}
				if (height >= 128)
				{
					Screen->ComboD[19] = 2972;
					Screen->ComboD[20] = 2972;
					Screen->ComboD[27] = 2972;
					Screen->ComboD[28] = 2972;
				}
			}
			for (int i = 149; i <= 154; i++)
			{
				Screen->ComboD[i] = 2735;
			}
			for (int i = 165; i <= 170; i++)
			{
				Screen->ComboD[i] = 2735;
			}
			if (Link->Y < (32 - height)) Link->Y +=2;
			if (Link->Y > (128 - height) && (Link->X < 80 || Link->X > 160))
			{			
				if ((Link->X < 78 || Link->X > 162) && CanWalk(Link->X, Link->Y, DIR_UP, 2, false)) Link->Y -=2;
				if (Link->X < 80 && Link->Y > (130 - height) && height < 128) Link->X+=2;
				if (Link->X > 160 && Link->Y > (130 - height) && height < 128) Link->X-=2;
			}
			if (Link->Y > (1146 - height))
			{
				Link->DrawXOffset += Cond(Link->DrawXOffset < 0, -1000, 1000);
				Link->HitXOffset += Cond(Link->HitXOffset < 0, -1000, 1000);
				Link->X = GridX(Link->X + 8);
				Link->Y = (height + Link->Y + 8) - ((height + Link->Y + 8) % 16);
				Game->PlaySound(SFX_LINK_FALL);
				lweapon dummy = CreateLWeaponAt(LW_SCRIPT10, Link->X, Link->Y);
				dummy->UseSprite(WPS_LINK_FALL);
				dummy->DeadState = dummy->NumFrames*dummy->ASpeed;
				dummy->DrawXOffset = 0;
				dummy->DrawYOffset = 0;
				PitsLava[HL_FALLING] = dummy->DeadState;
				NoAction();
				Link->Action = LA_NONE;
				for (int l = dummy->NumFrames*dummy->ASpeed; l > 0; l--)
				{
					Screen->DrawBitmap (2, RT_BITMAP0, 0, curheight, 256, 176, 0, 0, 256, 176, 0, true);
					WaitNoAction();
				}
				Screen->DrawBitmap (2, RT_BITMAP0, 0, curheight, 256, 176, 0, 0, 256, 176, 0, true);
				Link->DrawXOffset -= Cond(Link->DrawXOffset < 0, -1000, 1000);
				Link->HitXOffset -= Cond(Link->HitXOffset < 0, -1000, 1000);
				Link->HP = 0;
				Link->Action = LA_GOTHURTLAND;
				Link->HitDir = -1;
				Game->PlaySound(SFX_OUCH);
			}
			SaveHeight = Floor(height);
			Waitframe();
		}
	}
}