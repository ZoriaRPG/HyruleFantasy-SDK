//const int WPN_SLIMEBALL = 150;

//! Oh yuck. Who made this mess?!

ffc script bigzol
{
	void run(int enemyID)
	{
		npc ghost = Ghost_InitAutoGhost(this,enemyID);
		Ghost_Data = 10000;
		Ghost_CSet = 9;
		Ghost_TileWidth = 2;
		Ghost_TileHeight = 2;
		Ghost_SetFlag(GHF_SET_OVERLAY);
		int quit_countdown = 10;
		bool spawnkids = false;
		int jumpcounter = Rand(10) + 30;
		int zol_jump = 2 + Rand(3);
		int jumpdir = Rand(7);
		while(true)
		{
			if ((--jumpcounter) <=0)
			{
				unless(Ghost_Z)
				{
					Ghost_Jump = zol_jump;
				}
				jumpdir = Rand(7);
				jumpcounter = Rand(10)+ 30;
				zol_jump = 2 + Rand(3);
			}
			
			if(Ghost_Y < 48)
			{
				jumpdir=DIR_DOWN;
			}
			if(Ghost_Y > 144)
			{
				jumpdir=DIR_UP;
			}
			if(Ghost_X < 32)
			{
				jumpdir=DIR_RIGHT;
			}
			if(Ghost_X > 224)
			{
				jumpdir=DIR_LEFT;
			}
			if(Ghost_Z > 0)
			{
				Ghost_Move(jumpdir,1,2);
			}
			bool stillAlive=Ghost_Waitframe(this, ghost, false, false);
			unless(stillAlive)
			{
				unless(spawnkids)
				{
					CreateNPCAt(89, Ghost_X + 12, Ghost_Y + 20);
					CreateNPCAt(89, Ghost_X + 12, Ghost_Y + 20);
					spawnkids = true;
				}
				Ghost_Data = GH_INVISIBLE_COMBO;
				Ghost_X = -2000;
				--quit_countdown;
				if(quit_countdown<=0)
				{
					Quit();
				}
			}
		}
	}
}