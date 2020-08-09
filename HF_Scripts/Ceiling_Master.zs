const int SFX_WALLMASTER_SHADOW = 00;
const int SFX_WALLMASTER_DROP = 16;
const int SFX_WALLMASTER_LTTP_FALL = 38;
const int SFX_WALLMASTER_GRAB = 00;
const int SFX_WALLMASTER_AWAY = 00;
const int COMBO_AUTOWARP = 10034;
const int TILE_WALLMASTER = 20121;
const int COMBO_WALLMASTER = 10001;
const int COLOR_SHADOW = 0x0F;

ffc script OoTWallmaster
{
	void run(int enemyID)
	{
		bool OoT; // True if Miscellaneous Attribute 1 is not 0. Makes the Wallmaster behave more like OoT and give more warning than LttP style.
		int wait;
		int xradius;
		int yradius;
		
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_MOVE_OFFSCREEN);
		
		if (ghost->Attributes[0] > 0)
		{
			OoT = true;
		}
		
		while (true)
		{
			Ghost_X = -100;
			Ghost_Y = -100;
			ghost->DrawXOffset = -1000;
			ghost->DrawYOffset = -1000;
			//Ghost_Z = 0;
			ghost->CollDetection = false;
			Link->CollDetection = true;
			
			// Wallmaster waiting.
			wait = Rand(ghost->Attributes[1], ghost->Attributes[2]);
			for (int i = 0; i < wait; i++)
			{
				Ghost_Waitframe(this, ghost, true, true);
			}
			
			// Set tile to something not invisible.
			//Ghost_Data = COMBO_WALLMASTER;
			//Ghost_CSet = 10;
			ghost->OriginalTile = TILE_WALLMASTER;
			
			if (OoT)
			{
				Game->PlaySound(SFX_WALLMASTER_SHADOW);
			}
			
			// Wallmaster's shadow appears under Link.
			for (int i = 0; i < 150; i++)
			{
				Ghost_X = Link->X;
				Ghost_Y = Link->Y;
				//Ghost_Z = 256;
				if (OoT)
				{
					xradius = (Min(i + 50, 150) / 150) * 8;
					yradius = (Min(i + 50, 150) / 150) * 6;
					Screen->Ellipse(2, Ghost_X + 7, Ghost_Y + 12, xradius, yradius, COLOR_SHADOW, 1, 0, 0, 0, true, OP_OPAQUE);
				}
				Ghost_Waitframe(this, ghost, true, true);
			}
			
			// Wallmaster falls.
			//while (Ghost_Z > 0)
			//{
				//Ghost_Waitframe(this, ghost, true, true);
			//}
			if (!OoT)
			{
				Game->PlaySound(SFX_WALLMASTER_LTTP_FALL);
			}
			ghost->DrawXOffset = 0;
			for (int i = -256; i <= 0; i += 4)
			{
				ghost->DrawYOffset = i;
				if (!OoT)
				{
					xradius = (Clamp(256 + i, 50, 150) / 150) * 8;
					yradius = (Clamp(256 + i, 50, 150) / 150) * 6;
				}
				Screen->Ellipse(2, Ghost_X + 7, Ghost_Y + 12, xradius, yradius, COLOR_SHADOW, 1, 0, 0, 0, true, OP_OPAQUE);
				Ghost_Waitframe(this, ghost, true, true);
			}
			
			Game->PlaySound(SFX_WALLMASTER_DROP);
			ghost->CollDetection = true;
			
			// Wallmaster grabs Link if it touches him.
			for (int i = 0; i < 90; i++)
			{
				if (Abs(Link->X - Ghost_X) < 12 && Abs(Link->Y - Ghost_Y) < 12 && Link->Z < 4)
				{
					Game->PlaySound(SFX_WALLMASTER_GRAB);
					Link->DrawYOffset = 0;
					for (int j = 0; j < 256; j++)
					{
						Link->X = Ghost_X;
						Link->Y = Ghost_Y;
						NoAction();
						//Link->Action = LA_NONE;
						//Link->Z = j;
						//Ghost_Z = j;
						//Ghost_Data = GH_INVISIBLE_COMBO;
						
						ghost->DrawYOffset--;
						Link->DrawYOffset = ghost->DrawYOffset;
						if (j > 20 && ghost->CollDetection)
						{
							ghost->CollDetection = false;
						}
						if (j > 0 && Link->CollDetection)
						{
							Link->CollDetection = false;
						}
						xradius = (Clamp(256 - j, 50, 150) / 150) * 8;
						yradius = (Clamp(256 - j, 50, 150) / 150) * 6;
						Screen->Ellipse(2, Ghost_X + 7, Ghost_Y + 12, xradius, yradius, COLOR_SHADOW, 1, 0, 0, 0, true, OP_OPAQUE);
						Screen->FastTile(4, Ghost_X, Ghost_Y + ghost->DrawYOffset, TILE_WALLMASTER, Ghost_CSet, OP_OPAQUE);
						Ghost_Waitframe(this, ghost, true, true);
					}
					int dmap = Game->GetCurDMap();
					Screen->SetSideWarp(0, Game->LastEntranceScreen - Game->DMapOffset[dmap], Game->LastEntranceDMap, WT_IWARPOPENWIPE);
					this->Data = COMBO_AUTOWARP;
					Link->Z = 0;
					Link->DrawYOffset = 0;
					Link->CollDetection = true;
					Quit();
				}
				Screen->Ellipse(2, Ghost_X + 7, Ghost_Y + 12, xradius, yradius, COLOR_SHADOW, 1, 0, 0, 0, true, OP_OPAQUE);
Ghost_Waitframe(this, ghost, true, true);

			}
			
			Game->PlaySound(SFX_WALLMASTER_AWAY);
			
			// Wallmaster rises back to the ceiling if it fails to grab.
			ghost->CollDetection = false;
			for (int i = 0; i < 256; i += 2)
			{
				//Ghost_Z = i;
				ghost->DrawYOffset = -i;
				xradius = (Clamp(256 - i, 50, 150) / 150) * 8;
				yradius = (Clamp(256 - i, 50, 150) / 150) * 6;
				Screen->Ellipse(2, Ghost_X + 7, Ghost_Y + 12, xradius, yradius, COLOR_SHADOW, 1, 0, 0, 0, true, OP_OPAQUE);
Ghost_Waitframe(this, ghost, true, true);


			}
		}
	}
}