int DifficultyLevel = 1;

const int Casual = 0;
const int Standard = 1;
const int Challenging = 2;
const int Intense = 3;
const int Masochistic = 4;

const int SKYSCREEN = 0x01;
const int SKYSCREEN2 = 0x03;
const int SKYSCREEN3 = 0x30;
const int LINKCOMBO = 10120;

ffc script ScrollTitle
{
	
	void run(int screenheight)
	{
		int maxdrawheight = (screenheight) * 176;
		int height = maxdrawheight;
		int screen = Floor(height / 176);
		int curheight = height % 176;
		int LinkPos = 0;
		int othercounter = 0;
		Screen->SetRenderTarget(RT_BITMAP4);
		Screen->Rectangle(2, 0, 0, 511, 511, 15, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->DrawScreen (2, 6, SKYSCREEN3, 0, 0, 0);
		Screen->DrawScreen (2, 6, SKYSCREEN3 + 16, 0, 176, 0);
		Screen->SetRenderTarget(RT_BITMAP3);
		Screen->Rectangle(2, 0, 0, 511, 511, 0, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->DrawScreen (2, 6, SKYSCREEN2, 0, 0, 0);
		Screen->DrawScreen (2, 6, SKYSCREEN2 + 16, 0, 176, 0);
		Screen->SetRenderTarget(RT_BITMAP2);
		Screen->Rectangle(2, 0, 0, 511, 511, 0, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->DrawScreen (2, 6, SKYSCREEN, 0, 0, 0);
		Screen->DrawScreen (2, 6, SKYSCREEN + 16, 0, 176, 0);
		Screen->SetRenderTarget(RT_BITMAP0);
		Screen->Rectangle(2, 0, 0, 511, 511, 0, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->DrawScreen (2, 6, (16 * screen), 0, 0, 0);
		Screen->DrawScreen (2, 6, (16 * (screen - 1)), 0, -176, 0);
		Screen->DrawScreen (2, 6, (16 * (screen + 1)), 0, 176, 0);
		Screen->SetRenderTarget(RT_SCREEN);
		int Parallax = (maxdrawheight / 3) * 2;
		int Parallax2 = (maxdrawheight / 3) * 2;
		int Parallax3 = (maxdrawheight / 3) * 2;
		int pausecounter = 0;
		int DrawCounter = 0;
		for (int i = 168; i >= 80; i--)
		{
			Screen->FastCombo(2, 120, i, LINKCOMBO, 6, OP_OPAQUE);
			Waitframe();
		}
		while (true)
		{
			if (height > maxdrawheight)
			{
				height = maxdrawheight;
			}
			if ((height > 0 && pausecounter >= 60) || height > 64)
			{
				if (Parallax > 0)
				{
					if (height > 64) Parallax-=0.5;
					else if (height <= 64) Parallax-=3.7187;
				}
				if (Parallax2 > 0)
				{
					if (height > 64) Parallax2-=0.7;
					else if (height <= 64) Parallax2-=4.4235;
				}
				if (Parallax3 > 0)
				{
					if (height > 64) Parallax3-=0.9;
					else if (height <= 64) Parallax3-=2.7294;
				}
				else DrawCounter++;
				if (height > 64) height--;
				else if (height <= 64) height-=2.6666;
				
				Trace(DrawCounter);
			}
			if (height < 0) height = 0;
			if (Parallax < 0) Parallax = 0;
			if (pausecounter < 60 && height <= 64) pausecounter++;
			screen = Floor(height / 176);
			curheight = height % 176;
			Screen->SetRenderTarget(RT_BITMAP4);
			Screen->Rectangle(2, 0, 0, 511, 511, 15, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (2, 6, SKYSCREEN3, 0, 0, 0);
			Screen->DrawScreen (2, 6, SKYSCREEN3 + 16, 0, 176, 0);
			Screen->SetRenderTarget(RT_BITMAP3);
			Screen->Rectangle(2, 0, 0, 511, 511, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (2, 6, SKYSCREEN2, 0, 0, 0);
			Screen->DrawScreen (2, 6, SKYSCREEN2 + 16, 0, 176, 0);
			Screen->SetRenderTarget(RT_BITMAP2);
			Screen->Rectangle(2, 0, 0, 511, 511, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (2, 6, SKYSCREEN, 0, 0, 0);
			Screen->DrawScreen (2, 6, SKYSCREEN + 16, 0, 176, 0);
			Screen->DrawScreen (2, 6, SKYSCREEN + 32, 0, 352, 0);
			Screen->SetRenderTarget(RT_BITMAP0);
			Screen->Rectangle(2, 0, 0, 511, 511, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (2, 6, (16 * screen), 0, 0, 0);
			Screen->DrawScreen (2, 6, (16 * (screen - 1)), 0, -176, 0);
			Screen->DrawScreen (2, 6, (16 * (screen + 1)), 0, 176, 0);
			Screen->SetRenderTarget(RT_SCREEN);
			Screen->DrawBitmap (2, RT_BITMAP4, 0, Floor(Parallax3), 256, 176, 0, 0, 256, 176, 0, true);
			Screen->DrawBitmap (2, RT_BITMAP3, 0, Floor(Parallax2), 256, 176, 0, 0, 256, 176, 0, true);
			Screen->DrawBitmap (2, RT_BITMAP2, 0, Floor(Parallax), 256, 176, 0, 0, 256, 176, 0, true);
			Screen->DrawBitmap (2, RT_BITMAP0, 0, curheight, 256, 176, 0, 0, 256, 176, 0, true);
			if (height > 64) Screen->FastCombo(2, 120, 80, LINKCOMBO, 6, OP_OPAQUE);
			else Screen->FastCombo(2, 120, 80 + (64 - height), LINKCOMBO + 1, 6, OP_OPAQUE);
			if ((height > 192 && height < 256) || (height <= 144 && height > 112)) Screen->FastCombo(2, 120, 80, LINKCOMBO + 2, 7, OP_OPAQUE);
			Waitframe();
			if (height <= 0) this->Data = CMB_AUTOWARP + 1;
		}
	}
}