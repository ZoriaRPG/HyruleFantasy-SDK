int DifficultyLevel = 1;

const int DIFF_CASUAL = 0;
const int DIFF_STANDARD = 1;
const int DIFF_CHALLENGING = 2;
const int DIFF_INTENSE = 3;
const int DIFF_MASOCHISTIC = 4;

const int SKYSCREEN = 0x01;
const int LINKCOMBO = 10472;

ffc script ScrollTitle
{
	
	void run(int screenheight)
	{
		//Declare variables
		int maxdrawheight = (screenheight) * 176;
		int height = maxdrawheight;
		int screen = Floor(height / 176);
		int curheight = height % 176;
		int LinkPos = 0;
		int othercounter = 0;
		int parallax = (maxdrawheight / 3) * 2;
		int pausecounter = 0;
		
		//Initialize bitmaps
		Screen->SetRenderTarget(RT_BITMAP2);
		Screen->Rectangle(2, 0, 0, 511, 511, 15, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->DrawScreen (2, 6, SKYSCREEN, 0, 0, 0);
		Screen->DrawScreen (2, 6, SKYSCREEN + 16, 0, 176, 0);
		Screen->SetRenderTarget(RT_BITMAP0);
		Screen->Rectangle(2, 0, 0, 511, 511, 0, 1, 0, 0, 0, true, OP_OPAQUE);
		Screen->DrawScreen (2, 6, (16 * screen), 0, 0, 0);
		Screen->DrawScreen (2, 6, (16 * (screen - 1)), 0, -176, 0);
		Screen->DrawScreen (2, 6, (16 * (screen + 1)), 0, 176, 0);
		Screen->SetRenderTarget(RT_SCREEN);
		
		//Link is walking, but screen not scrolling yet
		for (int i = 168; i >= 80; --i)
		{
			Screen->FastCombo(2, 120, i, LINKCOMBO, 6, OP_OPAQUE);
			Waitframe();
		}
		while (true)
		{
			if (height <= 0) this->Data = CMB_AUTOWARP + 1;
			height = (height > maxdrawheight) ? maxdrawheight : height;
			if (height > 64 || (height > 0 && pausecounter >= 60))
			{
				if (parallax > 0)
				{
					if (height > 64) parallax-=0.5;
					else if (height <= 64) parallax-=3.7187;
				}
				if (height > 64) --height;
				else height-=2.6666;
			}
			height = (height < 0) ? 0 : height;
			parallax = (parallax < 0) ? 0 : height;
			if (pausecounter < 60 && height <= 64) ++pausecounter;
			screen = Floor(height / 176);
			curheight = height % 176;
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
			Screen->DrawBitmap (2, RT_BITMAP2, 0, Floor(parallax), 256, 176, 0, 0, 256, 176, 0, true);
			Screen->DrawBitmap (2, RT_BITMAP0, 0, curheight, 256, 176, 0, 0, 256, 176, 0, true);
			
			if (height > 64) Screen->FastCombo(2, 120, 80, LINKCOMBO, 6, OP_OPAQUE);
			else Screen->FastCombo(2, 120, 80 + (64 - height), LINKCOMBO + 1, 6, OP_OPAQUE);
			
			switch(height)
			{
			    case 112...144:
			    case 193...255:
				Screen->FastCombo(2, 120, 80, LINKCOMBO + 2, 7, OP_OPAQUE);
				break;
			    default: break; //If you have related conds, as an 'else', they go here.
			}
			Waitframe();
		}
	}
}
