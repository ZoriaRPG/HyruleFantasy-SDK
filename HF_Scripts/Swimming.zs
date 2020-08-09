//const int SWIM_DATA = 112;
//first 4 combos are floating
//second 4 combos are diving
//third 4 combos are swimming
//fourth 4 combos are one hand item holding in water
//fifth 4 combos are two hand item holding in water

int WaterArray[1000];

//Example global script with Ghost, Linkmovement, Scrollingdraws, Mooshpits and the custom swimming/truedrowning
//Of these, the only one I'm not sure is required is ghost, but better safe than sorry.

global script ExampleSwim
{
	void run()
	{
		StartGhostZH();
		ScrollingDraws_Init();
		MooshPit_Init();
		LinkMovement_Init();
		while(true)
		{
			ScrollingDraws_Update();
			RunInvisible();
			TrueDrown();
			LinkMovement_Update1();
			MooshPit_Update();
			UpdateGhostZH1();
			CustomSwimming();
			Waitdraw();
			TrueDrown();
			LinkMovement_Update2();
			UpdateGhostZH2();
			Waitframe();
		}
	}
}

void TrueDrown()
{
	if (Link->Action == LA_DROWNING)
	{
		WaterArray[4] = 3;
	}
	else if (WaterArray[4] == 3)
	{
		Link->X = MooshPit[MP_LASTX];
		Link->Y = MooshPit[MP_LASTY];
		//If the failsafe position was on a different screen, warp there
		if(Game->GetCurDMap()!=MooshPit[MP_LASTDMAP]||Game->GetCurDMapScreen()!=MooshPit[MP_LASTSCREEN]){
			Link->PitWarp(MooshPit[MP_LASTDMAP], MooshPit[MP_LASTSCREEN]);
		}
		WaterArray[4]--;
	}
	else if (WaterArray[4] > 0) WaterArray[4]--;
}

bool WaterCheck(int type)
{
	if (Screen->ComboT[ComboAt(Link->X + 6, Link->Y + 10)] == type && Screen->ComboT[ComboAt(Link->X + 9, Link->Y + 10)] == type
	&& Screen->ComboT[ComboAt(Link->X + 6, Link->Y + 13)] == type && Screen->ComboT[ComboAt(Link->X + 9, Link->Y + 13)] == type) return true;
	else return false;
}

bool WaterCheck2(int type)
{
	if (Screen->ComboT[ComboAt(Link->X + 1, Link->Y + 9)] == type || Screen->ComboT[ComboAt(Link->X + 14, Link->Y + 14)] == type
	|| Screen->ComboT[ComboAt(Link->X + 1, Link->Y + 14)] == type || Screen->ComboT[ComboAt(Link->X + 14, Link->Y + 14)] == type) return true;
	else return false;
}

bool isWater(int x, int y)
{
	if (Screen->ComboT[ComboAt(x, y)] == CT_WATER || Screen->ComboT[ComboAt(x, y)] == CT_DIVEWARP || Screen->ComboT[ComboAt(x, y)] == CT_DIVEWARPB
	|| Screen->ComboT[ComboAt(x, y)] == CT_DIVEWARPC || Screen->ComboT[ComboAt(x, y)] == CT_DIVEWARPD || Screen->ComboT[ComboAt(x, y)] == CT_SWIMWARP
	|| Screen->ComboT[ComboAt(x, y)] == CT_SWIMWARPB || Screen->ComboT[ComboAt(x, y)] == CT_SWIMWARPC || Screen->ComboT[ComboAt(x, y)] == CT_SWIMWARPD) return true;
	else return false;
}

void CustomSwimming()
{
	bool inwater = false;
	if (Link->Z == 0 && !MooshPit_OnFFC(Link->X, Link->Y) && Link->Action != LA_DROWNING && Link->Action != LA_RAFTING &&
	(isWater(Link->X + 6, Link->Y + 10) && isWater(Link->X + 9, Link->Y + 10) &&
	isWater(Link->X + 6, Link->Y + 13) && isWater(Link->X + 9, Link->Y + 13))) inwater = true;
	
	if (inwater && WaterArray[34] == 0)
	{
		if (Link->Item[145] && WaterArray[11] <= 0)
		{
			WaterArray[34] = 1;
		}
		else Link->Action = LA_DROWNING;
	}
	else if (!inwater)
	{
		if (WaterArray[34] == 1 || WaterArray[34] == 2 || WaterArray[34] == 3)
		{
			WaterArray[34] = 0;
		}
	}
	
	if (Link->Action == LA_DROWNING) FastCombo(2, ScrollingLinkX(), ScrollingLinkY(), NEWLINK_DATA + 36 + (GetShield() *104) + 4 + Link->Dir, 6, OP_OPAQUE);
	
	if (Link->Item[26])
	{
		WaterArray[21] = 1;
	}
	if (WaterArray[21] > 0)
	{
		if (Link->Item[26] && WaterArray[34] > 0) Link->Item[26] = false;
		else if (!Link->Item[26] && WaterArray[34] <= 0) Link->Item[26] = true;
	}
	
	if (WaterArray[34] > 0)
	{
		LinkMovement_AddLinkSpeedBoost(-0.5);
		Vanish();
		GenInt[200] = 4;
		if (Link->Action == LA_HOLD1LAND || Link->Action == LA_HOLD1WATER) 
		{
			if (WaterArray[36] == 0 && WaterArray[37] == 0)
			{
				item armositem = Screen->CreateItem(Link->HeldItem);
				armositem->X = 0;
				armositem->Y = 0;
				armositem->DrawXOffset = -100;
				armositem->DrawYOffset = -100;
				armositem->HitXOffset = -100;
				armositem->HitYOffset = -100;
				WaterArray[36] = armositem->Tile;
				WaterArray[37] = armositem->CSet;
				Remove(armositem);
			}
			GenInt[201] = 3;
			FastCombo(2, ScrollingLinkX(), ScrollingLinkY(), NEWLINK_DATA + 36 + (GetShield() *104) + 12 + Link->Dir, 6, OP_OPAQUE);
			FastTile(2, ScrollingLinkX(), ScrollingLinkY() - 12, WaterArray[36], WaterArray[37], OP_OPAQUE);
		}
		else if (Link->Action == LA_HOLD2LAND || Link->Action == LA_HOLD2WATER) 
		{
			if (WaterArray[36] == 0 && WaterArray[37] == 0)
			{
				item armositem = Screen->CreateItem(Link->HeldItem);
				armositem->X = 0;
				armositem->Y = 0;
				armositem->DrawXOffset = -100;
				armositem->DrawYOffset = -100;
				armositem->HitXOffset = -100;
				armositem->HitYOffset = -100;
				WaterArray[36] = armositem->Tile;
				WaterArray[37] = armositem->CSet;
				Remove(armositem);
			}
			GenInt[201] = 4;
			FastCombo(2, ScrollingLinkX(), ScrollingLinkY(), NEWLINK_DATA + 36 + (GetShield() *104) + 16 + Link->Dir, 6, OP_OPAQUE);
			FastTile(2, ScrollingLinkX(), ScrollingLinkY() - 12, WaterArray[36], WaterArray[37], OP_OPAQUE);
		}
		else 
		{
			GenInt[201] = WaterArray[34];
			FastCombo(2, ScrollingLinkX(), ScrollingLinkY(), NEWLINK_DATA + 36 + (GetShield() *104) - 4 + Link->Dir + (WaterArray[34] * 4), 6, OP_OPAQUE);
			WaterArray[36] = 0;
			WaterArray[37] = 0;
		}
		if (WaterCheck(CT_SWIMWARP))
		{
			ffc InstaWarp = Screen->LoadFFC(32);
			InstaWarp->X = Link->X;
			InstaWarp->Y = Link->Y;
			InstaWarp->EffectHeight = 16;
			InstaWarp->EffectWidth = 16;
			InstaWarp->Data = 132;
		}
		else if (WaterCheck(CT_SWIMWARPB))
		{
			ffc InstaWarp = Screen->LoadFFC(32);
			InstaWarp->X = Link->X;
			InstaWarp->Y = Link->Y;
			InstaWarp->EffectHeight = 16;
			InstaWarp->EffectWidth = 16;
			InstaWarp->Data = 133;
		}
		else if (WaterCheck(CT_SWIMWARPC))
		{
			ffc InstaWarp = Screen->LoadFFC(32);
			InstaWarp->X = Link->X;
			InstaWarp->Y = Link->Y;
			InstaWarp->EffectHeight = 16;
			InstaWarp->EffectWidth = 16;
			InstaWarp->Data = 134;
		}
		else if (WaterCheck(CT_SWIMWARPD))
		{
			ffc InstaWarp = Screen->LoadFFC(32);
			InstaWarp->X = Link->X;
			InstaWarp->Y = Link->Y;
			InstaWarp->EffectHeight = 16;
			InstaWarp->EffectWidth = 16;
			InstaWarp->Data = 135;
		}
		if (Link->Action != LA_HOLD1LAND && Link->Action != LA_HOLD2LAND && Link->Action != LA_HOLD1WATER && Link->Action != LA_HOLD2WATER)
		{
			if (Link->InputA && WaterArray[35] < 50 && WaterArray[35] >= 0) WaterArray[35]++;
			else
			{
				if (WaterArray[35] > 0) WaterArray[35] *= -1;
				else if (WaterArray[35] < 0) WaterArray[35]++;
			}
			if (WaterArray[35] <= 0 && WaterArray[34] == 2) WaterArray[34] = 1;
			else if (WaterArray[35] > 0) WaterArray[34] = 2;
			
			if (WaterArray[34] != 2 && (LinkMovement_StickX() != 0 || LinkMovement_StickY() != 0)) WaterArray[34] = 3;
			else if (WaterArray[34] != 2) WaterArray[34] = 1;
		}
		if (WaterArray[34] == 2) 
		{		
			if (WaterCheck(CT_DIVEWARP))
			{
				ffc InstaWarp = Screen->LoadFFC(32);
				InstaWarp->X = Link->X;
				InstaWarp->Y = Link->Y;
				InstaWarp->EffectHeight = 16;
				InstaWarp->EffectWidth = 16;
				InstaWarp->Data = 132;
			}
			else if (WaterCheck(CT_DIVEWARPB))
			{
				ffc InstaWarp = Screen->LoadFFC(32);
				InstaWarp->X = Link->X;
				InstaWarp->Y = Link->Y;
				InstaWarp->EffectHeight = 16;
				InstaWarp->EffectWidth = 16;
				InstaWarp->Data = 133;
			}
			else if (WaterCheck(CT_DIVEWARPC))
			{
				ffc InstaWarp = Screen->LoadFFC(32);
				InstaWarp->X = Link->X;
				InstaWarp->Y = Link->Y;
				InstaWarp->EffectHeight = 16;
				InstaWarp->EffectWidth = 16;
				InstaWarp->Data = 134;
			}
			else if (WaterCheck(CT_DIVEWARPD))
			{
				ffc InstaWarp = Screen->LoadFFC(32);
				InstaWarp->X = Link->X;
				InstaWarp->Y = Link->Y;
				InstaWarp->EffectHeight = 16;
				InstaWarp->EffectWidth = 16;
				InstaWarp->Data = 135;
			}
			else if (((Screen->ComboF[ComboAt(Link->X + 6, Link->Y + 10)] == 13 && Screen->ComboF[ComboAt(Link->X + 9, Link->Y + 10)] == 13
			&& Screen->ComboF[ComboAt(Link->X + 6, Link->Y + 13)] == 13 && Screen->ComboF[ComboAt(Link->X + 9, Link->Y + 13)] == 13)
			|| (Screen->ComboI[ComboAt(Link->X + 6, Link->Y + 10)] == 13 && Screen->ComboI[ComboAt(Link->X + 9, Link->Y + 10)] == 13
			&& Screen->ComboI[ComboAt(Link->X + 6, Link->Y + 13)] == 13 && Screen->ComboI[ComboAt(Link->X + 9, Link->Y + 13)] == 13)) 
			&& Screen->RoomType == RT_SPECIALITEM && Screen->State[ST_SPECIALITEM] != true)
			{
				item armositem = Screen->CreateItem(Screen->RoomData);
				armositem->Pickup |= IP_ST_SPECIALITEM;
				armositem->Pickup |= IP_HOLDUP;
				armositem->X = Link->X;
				armositem->Y = Link->Y;
				WaterArray[36] = armositem->Tile;
				WaterArray[37] = armositem->CSet;
			}
			else Etherize();
		}
		Link->InputA = false;
		Link->PressA = false;
		Link->InputB = false;
		Link->PressB = false;
	}
}