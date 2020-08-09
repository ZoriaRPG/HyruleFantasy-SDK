const int SCROLLSCRIPT = 38;

ffc script ZolGel{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_FAKE_Z);
		int counter = 20;
		int counter2 = Rand(3, 7);
		int ZolData = Ghost_Data;
		int JumpData = Ghost_Data + 2;
		Ghost_CSet = ghost->Attributes[9];
		while(true)
		{
			counter--;
			if (counter<=0 && Ghost_Z <= 0)
			{
				Ghost_MoveTowardLink(2, 4);
				counter = Rand(17, 23);
				counter2--;
			}
			for (int i = 1; i <= 32; i++)
			{
				ffc f = Screen->LoadFFC(i);
				if (f->Script == SCROLLSCRIPT && f->InitD[1] == 0 && f->InitD[2] == 1)
				{
					Ghost_Y-=0.1807;
					if (Ghost_Y < -20) Ghost_HP = 0;
				}
			}
			if (Link->X > Ghost_X && Ghost_Z <= 0) Ghost_Data = ZolData + 1;
			else if (Ghost_Z <= 0) Ghost_Data = ZolData;
			if (counter2<=0 && Ghost_Z <= 0)
			{
				Ghost_Jump = 1;
				if (Link->X > Ghost_X) Ghost_Data = JumpData + 1;
				else Ghost_Data = JumpData;
				Game->PlaySound(SFX_JUMP);
				ZolWait(this, ghost);
				while (Ghost_Z > 0)
				{
					Ghost_MoveTowardLink(1, 4);
					ZolWait(this, ghost);
				}
				counter2 = Rand(3, 7);
			}
			if (Ghost_Z > 16)
			{
				Ghost_UnsetFlag(GHF_FAKE_Z);
				if(GH_SHADOW_TRANSLUCENT>0) Screen->DrawTile(1, Ghost_X, Ghost_Y, GH_SHADOW_TILE+__ghzhData[__GHI_SHADOW_FRAME], 1, 1, GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
				else Screen->DrawTile(1, Ghost_X, Ghost_Y, GH_SHADOW_TILE+__ghzhData[__GHI_SHADOW_FRAME], 1, 1, GH_SHADOW_CSET, -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
			}
			else Ghost_SetFlag(GHF_FAKE_Z);
			ZolWait(this, ghost);
		}
	}
	void ZolWait(ffc this, npc ghost)
	{
		if (!Ghost_Waitframe(this, ghost, true, false))
		{
			for (int i = ghost->Attributes[1]; i > 0; i--)
			{
				CreateNPCAt(ghost->Attributes[0], Ghost_X + 2 + Rand(12), Ghost_Y + 2 + Rand(12));
			}
			Quit();
		}
	}
}