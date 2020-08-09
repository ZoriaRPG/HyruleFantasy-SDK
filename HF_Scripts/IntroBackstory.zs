int DrawTangoMessage(int messageID, int style, int x, int y, int followup)
{
	int TextSlot = Tango_GetFreeSlot();
	Tango_ClearSlot(TextSlot);
	Tango_LoadMessage(TextSlot, messageID);
	if (followup > 0)
	{
		for (int i = 1; i <= followup; i++)
		{
			Tango_AppendMessage(TextSlot, messageID + i);
		}
	}
	if (followup == -1)
	{
		for (int i = 0; i <= 2; i++)
		{
			Tango_AppendMessage(TextSlot, 152 + i);
		}
	}
	Tango_SetSlotStyle(TextSlot, style);
	Tango_SetSlotPosition(TextSlot, x, y);
	Tango_ActivateSlot(TextSlot);
	return TextSlot;
}

void NoMove()
{
	Link->InputUp = false; Link->PressUp = false;
	Link->InputDown = false; Link->PressDown = false;
	Link->InputLeft = false; Link->PressLeft = false;
	Link->InputRight = false; Link->PressRight = false;
	Link->PressStart = false; Link->InputStart = false;
}

void DrawScene(int Scene)
{
	if (Scene == 1) Screen->DrawLayer (3, 31, 0x75, 3, 0, 0, 0, OP_OPAQUE);
	if (Scene == 2) Screen->DrawLayer (3, 31, 0x76, 3, 0, 0, 0, OP_OPAQUE);
	if (Scene == 3) Screen->DrawLayer (3, 31, 0x77, 3, 0, 0, 0, OP_OPAQUE);
	if (Scene == 4) Screen->DrawLayer (3, 31, 0x78, 3, 0, 0, 0, OP_OPAQUE);
	if (Scene == 5) Screen->DrawLayer (3, 31, 0x79, 3, 0, 0, 0, OP_OPAQUE);
	if (Scene == 6) Screen->DrawLayer (3, 31, 0x79, 3, 0, 0, 0, OP_TRANS);
	if (Scene == 7) 
	{
		Screen->DrawLayer (6, 31, 0x65, 3, 0, 0, 0, OP_TRANS);
		Screen->DrawLayer (6, 31, 0x65, 3, 0, -176, 0, OP_TRANS);
	}
	if (Scene == 8) 
	{
		Screen->DrawLayer (6, 31, 0x65, 3, 0, 0, 0, OP_OPAQUE);
		Screen->DrawLayer (6, 31, 0x65, 3, 0, -176, 0, OP_OPAQUE);
	}
}

ffc script IntroString
{
	void run(int messageID, int followup, int messageID2, int followup2)
	{
		Tango_SetStyleAttribute(1, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_CLEAR);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_FONT, TANGO_FONT_LTTP_OUTLINE);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_CSET, 0);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_COLOR, 1);
		Tango_SetStyleAttribute(1, TANGO_STYLE_MORE_COMBO, 1);
		Tango_SetStyleAttribute(1, TANGO_STYLE_FLAGS, TANGO_FLAG_ENABLE_SPEEDUP);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_WIDTH, 192);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_HEIGHT, 48);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_SPEED, 4);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_SFX, 18);
		int Scene = 1;
		for (int i = 0; i < 15; i++)
		{
			DrawScene(Scene);
			DrawScene(5);
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		for (int i = 0; i < 15; i++)
		{
			DrawScene(Scene);
			DrawScene(6);
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		int TextSlot = DrawTangoMessage(messageID, 1, 50, 76, followup);
		//int TextSlot = DrawTangoMessage(messageID, 1, 0, 0, followup);
		while(!Tango_SlotIsFinished(TextSlot) || Scene < 4)
		{
			while (!Link->Item[168] && !Tango_SlotIsFinished(TextSlot))
			{
				if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
				NoMove();
				DrawScene(Scene);
				Waitframe();
			}
			if (!Tango_SlotIsFinished(TextSlot))
			{
				Tango_SuspendSlot(TextSlot);
				if (true)
				{
					for (int i = 0; i < 15; i++)
					{
						DrawScene(Scene);
						DrawScene(6);
						if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
						WaitNoAction();
					}
					for (int i = 0; i < 15; i++)
					{
						DrawScene(Scene);
						DrawScene(5);
						if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
						WaitNoAction();
					}
					Scene++;
					for (int i = 0; i < 15; i++)
					{
						DrawScene(Scene);
						DrawScene(6);
						if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
						WaitNoAction();
					}
				}
				Tango_ResumeSlot(TextSlot);
				Link->Item[168]  = false;
			}
		}
		Tango_ClearSlot(TextSlot);
		TextSlot = DrawTangoMessage(155, 1, 50, 76, -1);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_SPEED, 0);
		if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
		NoMove();
		DrawScene(Scene);
		Waitframe();
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_SPEED, 4);
		while(!Link->Item[168])
		{
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			NoMove();
			DrawScene(Scene);
			Waitframe();
		}
		for (int i = 0; i < 15; i++)
		{
			DrawScene(Scene);
			DrawScene(6);
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		for (int i = 0; i < 15; i++)
		{
			DrawScene(Scene);
			DrawScene(5);
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		for (int i = 0; i < 30; i++)
		{
			DrawScene(7);
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		Tango_ClearSlot(TextSlot);
		for (int i = 0; i < 30; i++)
		{
			DrawScene(8);
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		DrawScene(8);
		WaitNoAction();
		this->Data = CMB_AUTOWARP;
	}
}

ffc script QuakeScreen
{
	void run (int intensity, int duration)
	{
		for (int i = duration; i != 0; i--)
		{
			Screen->Quake = intensity;
			Waitframe();
		}
	}
}

ffc script IntroString2
{
	void run(int messageID, int followup, int delay, bool fadein, bool fadeout, bool string)
	{
		Tango_SetStyleAttribute(1, TANGO_STYLE_BACKDROP_TYPE, TANGO_BACKDROP_COLOR_TRANS);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_FONT, TANGO_FONT_LTTP_OUTLINE);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_CSET, 0);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_COLOR, 15);
		Tango_SetStyleAttribute(1, TANGO_STYLE_MORE_COMBO, 1);
		Tango_SetStyleAttribute(1, TANGO_STYLE_FLAGS, TANGO_FLAG_ENABLE_SPEEDUP);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_WIDTH, 192);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_HEIGHT, 48);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_SPEED, 4);
		Tango_SetStyleAttribute(1, TANGO_STYLE_TEXT_SFX, 18);
		if (fadein)
		{
			for (int i = 0; i < 30; i++)
			{
				DrawScene(8);
				if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
				WaitNoAction();
			}
			for (int i = 0; i < 30; i++)
			{
				DrawScene(7);
				if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
				WaitNoAction();
			}
		}
		for (int i = 0; i < delay; i++)
		{
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		int TextSlot;
		if (string)
		{
			int TextSlot = DrawTangoMessage(messageID, 1, 50, 100, followup);
			while(!Tango_SlotIsFinished(TextSlot))
			{
				NoMove();
				if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
				Waitframe();
			}
		}
		if (fadeout)
		{
			for (int i = 0; i < 30; i++)
			{
				DrawScene(7);
				if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
				WaitNoAction();
			}
			if (string) Tango_ClearSlot(TextSlot);
			for (int i = 0; i < 30; i++)
			{
				DrawScene(8);
				if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
				WaitNoAction();
			}
			DrawScene(8);
			if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
			WaitNoAction();
		}
		if (string || fadeout) this->Data = CMB_AUTOWARP;
	}
}

ffc script DodgeCutscene
{
	void run()
	{
		while (true)
		{
			if (LinkCollision(this))
			{
				if (CanWalk(this->X, this->Y, DIR_RIGHT, 16, false) && CanWalk(Link->X, Link->Y, DIR_RIGHT, 1, false)) {Link->X++; Link->Dir = DIR_RIGHT; Link->Action = LA_WALKING;}
				else if (CanWalk(this->X, this->Y, DIR_UP, 16, false) && CanWalk(Link->X, Link->Y, DIR_UP, 1, false)) {Link->Y--; Link->Dir = DIR_UP; Link->Action = LA_WALKING;}
				else if (CanWalk(this->X, this->Y, DIR_LEFT, 16, false) && CanWalk(Link->X, Link->Y, DIR_LEFT, 1, false)) {Link->X--; Link->Dir = DIR_LEFT; Link->Action = LA_WALKING;}
				else if (CanWalk(this->X, this->Y, DIR_DOWN, 16, false) && CanWalk(Link->X, Link->Y, DIR_DOWN, 1, false)) {Link->Y++; Link->Dir = DIR_DOWN; Link->Action = LA_WALKING;}
			}
			Waitframe();
		}
	}
}

ffc script SetIntroSong
{
	void run(int songid)
	{
		int track0[] = "Cave (Lufia 2).spc";
		int track1[] = "Soldiers of Kakariko Village (LOZ-ALTTP).spc";
		if (songid == 0) {Game->SetDMapEnhancedMusic(Game->GetCurDMap(), track0, 0); Game->DMapMIDI[Game->GetCurDMap()] = 13;}		
		if (songid == 1) {Game->SetDMapEnhancedMusic(Game->GetCurDMap(), track1, 0); Game->DMapMIDI[Game->GetCurDMap()] = 57;}	
	}
}

ffc script PlaySFX
{
	void run(int sound, int delay)
	{
		Waitframes(delay);
		Game->PlaySound(sound);
	}
}