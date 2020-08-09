//import "std.zh"

//To have more weapons emit light, look in std_constants and add individual ors ('||') to them
//Like so: (...) || GLG->ID == EW_FIRETRAIL)

const int LIGHT_FLAG = 9;
const int BLACK_COLOR = 15;
const int DARK_ROOM_SLOT = 1;
const int LINK_SIZE_DEFAULT = 8;
bool ActiveLastFrame = false;

bool DarkRoomGlobal(bool HelloDarknessMyOldFriend)
{
	bool OkayFoundOne = false;
	if (HelloDarknessMyOldFriend == true)
	{
		if (Link->Action == LA_SCROLLING) 
		{
			Screen->Rectangle(6, 0, 0, 256, 176, BLACK_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
		}
		else HelloDarknessMyOldFriend = false;
	}
	for (int h = 1; h <= 32; h++)
	{
		ffc DarkMaybe = Screen->LoadFFC(h);
		if (DarkMaybe->Script == DARK_ROOM_SLOT)
		{
			if (Link->Action == LA_SCROLLING) 
			{
				Screen->Rectangle(6, 0, 0, 256, 176, BLACK_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
			}
			OkayFoundOne = true;
		}
	}
	if (OkayFoundOne == false && ActiveLastFrame == true) 
	{
		HelloDarknessMyOldFriend = true;
	}
	ActiveLastFrame = false;
}
 
ffc script DarkRoom
{
	void run(int LinkSize, int FlagSize, int LinkWeaponSize, int EnemyWeaponSize, int Expand, int Expanding, int CandleID, int DarkMap)
	{
		int Expander = 0;
		int Expandest = 0;
		bool Expandirect = true;
		if (LinkSize == 0) LinkSize = 48;
		if (FlagSize == 0) FlagSize = 48;
		if (LinkWeaponSize == 0) LinkWeaponSize = 48;
		if (EnemyWeaponSize == 0) EnemyWeaponSize = 48;
		Screen->SetRenderTarget(RT_BITMAP2);
		Screen->Rectangle(6, 0, 0, 256, 176, BLACK_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->SetRenderTarget(RT_BITMAP0);
		//Screen->Rectangle(6, 0, 0, 256, 176, 15, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->DrawScreen (6, DarkMap, Game->GetCurScreen(), 0, 0, 0);
		while(true)
		{
			Screen->SetRenderTarget(RT_SCREEN);
			Screen->DrawBitmap(7, RT_BITMAP2, 0, 0, 256, 176, 0, 0, 256, 176, 0, true);
			Screen->DrawBitmap(7, RT_BITMAP1, 0, 0, 256, 176, 0, 0, 256, 176, 0, true);
			
			Screen->DrawBitmap(7, RT_BITMAP3, 0, 0, 256, 176, 0, 0, 256, 176, 0, true);
			
			Screen->DrawBitmap(7, RT_BITMAP2, 0, 0, 256, 176, 0, 0, 256, 176, 0, true);
			Screen->DrawBitmap(7, RT_BITMAP0, 0, 0, 256, 176, 0, 0, 256, 176, 0, true);
			for (int k = 1; k <= 32; k++)
			{
				ffc darktrap = Screen->LoadFFC(k);
				if (darktrap->Data == 10296)
				{
					Screen->DrawCombo(7, darktrap->X + darktrap->Vx, darktrap->Y + darktrap->Vy, 10303, 2, 2, darktrap->CSet, -1, -1, 0, 0, 0, -1, 0, true, OP_TRANS);
				}
			}
			ActiveLastFrame = true;
			if (Expand > 0)
			{
				if (Expanding > 0) Expander+=Expanding;
				else Expander+=2;
				if (Expander >= 20)
				{
					Expander = 0;
					if (Expandirect) Expandest++;
					else Expandest--;
					if (Expandest >= Expand) Expandirect = false;
					else if (Expandest <= 0) Expandirect = true;
				}
			}
		
			
			Screen->SetRenderTarget(RT_BITMAP0);
			//Screen->Rectangle(6, 0, 0, 256, 176, BLACK_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (6, DarkMap, Game->GetCurScreen(), 0, 0, 0);
			if (CandleID != 0)
			{
				itemdata Candled = Game->LoadItemData(Abs(CandleID));
				itemdata CandledA = Game->LoadItemData(GetEquipmentA());
				itemdata CandledB = Game->LoadItemData(GetEquipmentB());
				if (LinkSize >= 0 && (CandleID == 0 || 
				(CandleID < 0 && Link->Item[Abs(CandleID)]) || 
				(CandleID > 0 && ((CandledA->Family == Candled->Family && CandledA->Level >= Candled->Level) || 
				(CandledB->Family == Candled->Family && CandledB->Level >= Candled->Level))))) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + 2 + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, Expandest + 2 + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			}
			else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + 2 + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			if (FlagSize >= 0) 
			{
				for(int i = 0; i < 176; i++)
				{
					if (Screen->ComboF[i] == LIGHT_FLAG || Screen->ComboI[i] == LIGHT_FLAG)
					{
						Screen->Circle(6, ComboX(i) + 8, ComboY(i) + 8, FlagSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (LinkWeaponSize >= 0)
			{
				for(int l = Screen->NumLWeapons(); l > 0; l--)
				{
					lweapon MLG = Screen->LoadLWeapon(l);
					if (MLG->ID == LW_FIRE || MLG->ID == LW_REFFIREBALL || MLG->ID == LW_FIRESPARKLE)
					{
						Screen->Circle(6, MLG->X + 8, MLG->Y + 8, LinkWeaponSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (EnemyWeaponSize >= 0)
			{
				for(int j = Screen->NumEWeapons(); j > 0; j--)
				{
					eweapon GLG = Screen->LoadEWeapon(j);
					if (GLG->ID == EW_FIRE || GLG->ID == EW_FIREBALL || GLG->ID == EW_FIREBALL2 || GLG->ID == EW_FIRE2 || GLG->ID == EW_FIRETRAIL || GLG->ID == EW_BOMBBLAST)
					{
						Screen->Circle(6, GLG->X + 8, GLG->Y + 8, EnemyWeaponSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			Screen->SetRenderTarget(RT_BITMAP1);
			//Screen->Rectangle(6, 0, 0, 256, 176, BLACK_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (6, DarkMap, Game->GetCurScreen() - 8, 0, 0, 0);
			if (CandleID != 0)
			{
				itemdata Candled = Game->LoadItemData(Abs(CandleID));
				itemdata CandledA = Game->LoadItemData(GetEquipmentA());
				itemdata CandledB = Game->LoadItemData(GetEquipmentB());
				if (LinkSize >= 0 && (CandleID == 0 || 
				(CandleID < 0 && Link->Item[Abs(CandleID)]) || 
				(CandleID > 0 && ((CandledA->Family == Candled->Family && CandledA->Level >= Candled->Level) || 
				(CandledB->Family == Candled->Family && CandledB->Level >= Candled->Level))))) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, Expandest + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			}
			else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			if (FlagSize >= 0) 
			{
				for(int i = 0; i < 176; i++)
				{
					if (Screen->ComboF[i] == LIGHT_FLAG || Screen->ComboI[i] == LIGHT_FLAG)
					{
						Screen->Circle(6, ComboX(i) + 8, ComboY(i) + 8, FlagSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (LinkWeaponSize >= 0)
			{
				for(int l = Screen->NumLWeapons(); l > 0; l--)
				{
					lweapon MLG = Screen->LoadLWeapon(l);
					if (MLG->ID == LW_FIRE || MLG->ID == LW_REFFIREBALL || MLG->ID == LW_FIRESPARKLE)
					{
						Screen->Circle(6, MLG->X + 8, MLG->Y + 8, LinkWeaponSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (EnemyWeaponSize >= 0)
			{
				for(int j = Screen->NumEWeapons(); j > 0; j--)
				{
					eweapon GLG = Screen->LoadEWeapon(j);
					if (GLG->ID == EW_FIRE || GLG->ID == EW_FIREBALL || GLG->ID == EW_FIREBALL2 || GLG->ID == EW_FIRE2 || GLG->ID == EW_FIRETRAIL || GLG->ID == EW_BOMBBLAST)
					{
						Screen->Circle(6, GLG->X + 8, GLG->Y + 8, EnemyWeaponSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			Screen->SetRenderTarget(RT_BITMAP2);
			Screen->Rectangle(6, 0, 0, 256, 176, BLACK_COLOR, 1, 0, 0, 0, true, OP_OPAQUE);
			//Screen->DrawScreen (6, DarkMap, Game->GetCurScreen(), 0, 0, 0);
			if (CandleID != 0)
			{
				itemdata Candled = Game->LoadItemData(Abs(CandleID));
				itemdata CandledA = Game->LoadItemData(GetEquipmentA());
				itemdata CandledB = Game->LoadItemData(GetEquipmentB());
				if (LinkSize >= 0 && (CandleID == 0 || 
				(CandleID < 0 && Link->Item[Abs(CandleID)]) || 
				(CandleID > 0 && ((CandledA->Family == Candled->Family && CandledA->Level >= Candled->Level) || 
				(CandledB->Family == Candled->Family && CandledB->Level >= Candled->Level))))) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + 2 + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, Expandest + 2 + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			}
			else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + 2 + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			if (FlagSize >= 0) 
			{
				for(int i = 0; i < 176; i++)
				{
					if (Screen->ComboF[i] == LIGHT_FLAG || Screen->ComboI[i] == LIGHT_FLAG)
					{
						Screen->Circle(6, ComboX(i) + 8, ComboY(i) + 8, FlagSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (LinkWeaponSize >= 0)
			{
				for(int l = Screen->NumLWeapons(); l > 0; l--)
				{
					lweapon MLG = Screen->LoadLWeapon(l);
					if (MLG->ID == LW_FIRE || MLG->ID == LW_REFFIREBALL || MLG->ID == LW_FIRESPARKLE)
					{
						Screen->Circle(6, MLG->X + 8, MLG->Y + 8, LinkWeaponSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (EnemyWeaponSize >= 0)
			{
				for(int j = Screen->NumEWeapons(); j > 0; j--)
				{
					eweapon GLG = Screen->LoadEWeapon(j);
					if (GLG->ID == EW_FIRE || GLG->ID == EW_FIREBALL || GLG->ID == EW_FIREBALL2 || GLG->ID == EW_FIRE2 || GLG->ID == EW_FIRETRAIL || GLG->ID == EW_BOMBBLAST)
					{
						Screen->Circle(6, GLG->X + 8, GLG->Y + 8, EnemyWeaponSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			Screen->SetRenderTarget(RT_BITMAP3);
			Screen->Rectangle(6, 0, 0, 256, 176, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			for (int k = 1; k <= 32; k++)
			{
				ffc darktrap = Screen->LoadFFC(k);
				if (darktrap->Data == 10296)
				{
					Screen->DrawCombo(6, darktrap->X + darktrap->Vx, darktrap->Y + darktrap->Vy, 10302, 2, 2, darktrap->CSet, -1, -1, 0, 0, 0, -1, 0, true, OP_OPAQUE);
				}
			}
			if (CandleID != 0)
			{
				itemdata Candled = Game->LoadItemData(Abs(CandleID));
				itemdata CandledA = Game->LoadItemData(GetEquipmentA());
				itemdata CandledB = Game->LoadItemData(GetEquipmentB());
				if (LinkSize >= 0 && (CandleID == 0 || 
				(CandleID < 0 && Link->Item[Abs(CandleID)]) || 
				(CandleID > 0 && ((CandledA->Family == Candled->Family && CandledA->Level >= Candled->Level) || 
				(CandledB->Family == Candled->Family && CandledB->Level >= Candled->Level))))) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, Expandest + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			}
			else if (LinkSize >= 0) Screen->Circle(6, Link->X + 8, Link->Y + 8, LinkSize + Expandest + LINK_SIZE_DEFAULT, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			if (FlagSize >= 0) 
			{
				for(int i = 0; i < 176; i++)
				{
					if (Screen->ComboF[i] == LIGHT_FLAG || Screen->ComboI[i] == LIGHT_FLAG)
					{
						Screen->Circle(6, ComboX(i) + 8, ComboY(i) + 8, FlagSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (LinkWeaponSize >= 0)
			{
				for(int l = Screen->NumLWeapons(); l > 0; l--)
				{
					lweapon MLG = Screen->LoadLWeapon(l);
					if (MLG->ID == LW_FIRE || MLG->ID == LW_REFFIREBALL || MLG->ID == LW_FIRESPARKLE)
					{
						Screen->Circle(6, MLG->X + 8, MLG->Y + 8, LinkWeaponSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			if (EnemyWeaponSize >= 0)
			{
				for(int j = Screen->NumEWeapons(); j > 0; j--)
				{
					eweapon GLG = Screen->LoadEWeapon(j);
					if (GLG->ID == EW_FIRE || GLG->ID == EW_FIREBALL || GLG->ID == EW_FIREBALL2 || GLG->ID == EW_FIRE2 || GLG->ID == EW_FIRETRAIL || GLG->ID == EW_BOMBBLAST)
					{
						Screen->Circle(6, GLG->X + 8, GLG->Y + 8, EnemyWeaponSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
					}
				}
			}
			Waitframe();
		}
	}
}

ffc script LightSource
{
	
	void run(int LightSize, int Expand, int Expanding, int FFCSpinRadius, int FFCSpinSpeed, int FFCSpinOffset)
	{
		
		int Expander = 0;
		int Expandest = 0;
		bool Expandirect = true;
		
		int FFCX = 0;
		int FFCY = 0;
		if (FFCSpinRadius > 0 && FFCSpinSpeed > 0)
		{
			FFCX = this->X;
			FFCY = this->Y;
		}
		
		int Spinner = FFCSpinOffset % 360;
		while (true)
		{
			if (Expand > 0)
			{
				if (Expanding > 0) Expander+=Expanding;
				else Expander+=2;
				if (Expander >= 20)
				{
					Expander = 0;
					if (Expandirect) Expandest++;
					else Expandest--;
					if (Expandest >= Expand) Expandirect = false;
					else if (Expandest <= 0) Expandirect = true;
				}
			}
			if (FFCSpinRadius > 0 && FFCSpinSpeed > 0)
			{
				Spinner += FFCSpinSpeed;
				Spinner %= 360;
				this->X = FFCX + VectorX(FFCSpinRadius, Spinner);
				this->Y = FFCY + VectorY(FFCSpinRadius, Spinner);
			}
			Screen->SetRenderTarget(RT_BITMAP2);
			Screen->Circle(6, this->X + 8, this->Y + 8, LightSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->SetRenderTarget(RT_BITMAP0);
			Screen->Circle(6, this->X + 8, this->Y + 8, LightSize + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->SetRenderTarget(RT_BITMAP1);
			Screen->Circle(6, this->X + 8, this->Y + 8, LightSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->SetRenderTarget(RT_BITMAP3);
			Screen->Circle(6, this->X + 8, this->Y + 8, LightSize + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->SetRenderTarget(RT_SCREEN);
			Waitframe();
		}
	}
}

ffc script EnemyLight
{
	
	void run(int Expand, int Expanding, int E1, int S1, int E2, int S2, int E3, int S3)
	{
		
		int Expander = 0;
		int Expandest = 0;
		bool Expandirect = true;
		while(true)
		{
			Screen->SetRenderTarget(RT_BITMAP0);
			if (Expand > 0)
			{
				if (Expanding > 0) Expander+=Expanding;
				else Expander+=2;
				if (Expander >= 20)
				{
					Expander = 0;
					if (Expandirect) Expandest++;
					else Expandest--;
					if (Expandest >= Expand) Expandirect = false;
					else if (Expandest <= 0) Expandirect = true;
				}
			}
			for(int l = Screen->NumNPCs(); l > 0; l--)
			{
				npc MLG = Screen->LoadNPC(l);
				if (MLG->ID == E1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S1 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S2 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S3 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_BITMAP1);
			for(int l = Screen->NumNPCs(); l > 0; l--)
			{
				npc MLG = Screen->LoadNPC(l);
				if (MLG->ID == E1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S1 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S2 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S3 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_BITMAP3);
			for(int l = Screen->NumNPCs(); l > 0; l--)
			{
				npc MLG = Screen->LoadNPC(l);
				if (MLG->ID == E1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S1 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S2 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S3 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_BITMAP2);
			for(int l = Screen->NumNPCs(); l > 0; l--)
			{
				npc MLG = Screen->LoadNPC(l);
				if (MLG->ID == E1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S1 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S2 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == E3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, S3 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_SCREEN);
			Waitframe();
		}
	}
}

ffc script ItemLight
{
	
	void run(int Expand, int Expanding, int I1, int S1, int I2, int S2, int I3, int S3)
	{
		
		int Expander = 0;
		int Expandest = 0;
		bool Expandirect = true;
		while(true)
		{
			Screen->SetRenderTarget(RT_BITMAP0);
			if (Expand > 0)
			{
				if (Expanding > 0) Expander+=Expanding;
				else Expander+=2;
				if (Expander >= 20)
				{
					Expander = 0;
					if (Expandirect) Expandest++;
					else Expandest--;
					if (Expandest >= Expand) Expandirect = false;
					else if (Expandest <= 0) Expandirect = true;
				}
			}
			for(int l = Screen->NumItems(); l > 0; l--)
			{
				item MLG = Screen->LoadItem(l);
				if (MLG->ID == I1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I1 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I2 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I3 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_BITMAP1);
			for(int l = Screen->NumItems(); l > 0; l--)
			{
				item MLG = Screen->LoadItem(l);
				if (MLG->ID == I1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I1 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I2 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I3 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_BITMAP3);
			for(int l = Screen->NumItems(); l > 0; l--)
			{
				item MLG = Screen->LoadItem(l);
				if (MLG->ID == I1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I1 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I2 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I3 + Expandest, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_BITMAP2);
			for(int l = Screen->NumItems(); l > 0; l--)
			{
				item MLG = Screen->LoadItem(l);
				if (MLG->ID == I1)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I1 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I2)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I2 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				if (MLG->ID == I3)
				{
					Screen->Circle(6, MLG->X + 8, MLG->Y + 8, I3 + Expandest + 2, 0, 1, 0, 0, 0, true, OP_OPAQUE);
				}
			}
			Screen->SetRenderTarget(RT_SCREEN);
			Waitframe();
		}
	}
}