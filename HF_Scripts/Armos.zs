// import "std.zh"
// import "string.zh"
// import "ghost.zh"

const float ARMOS_JUMP_HEIGHT 		= 1.5;

// npc->Attribute[] indices
const int ARMOS_ATTR_START_SOUND 	= 0;
const int ARMOS_ATTR_JUMP_SOUND 	= 1;
const int ARMOS_ATTR_NATURAL	 	= 2;

ffc script Armos_LttP
{
	void run(int enemyID)
	{
		npc ghost;
		float step;
		int jumpSound;
		
		// Initialize - come to life and set the combo
		ghost=Ghost_InitAutoGhost(this, enemyID);
		Ghost_SetFlag(GHF_NORMAL);
		Ghost_SetFlag(GHF_KNOCKBACK_4WAY);
		Ghost_SetFlag(GHF_FAKE_Z);
		Game->PlaySound(ghost->Attributes[ARMOS_ATTR_START_SOUND]);
		SpawnAnimation(this, ghost);
		
		step=ghost->Step/100;
		jumpSound=ghost->Attributes[ARMOS_ATTR_JUMP_SOUND];
		
		// Just jump toward Link forever
		while(true)
		{
			if(Ghost_Z==0)
			{
				if(Ghost_Jump<=0)
				{
					Ghost_Jump=ARMOS_JUMP_HEIGHT;
					Game->PlaySound(jumpSound);
				}
			}
			
			Ghost_MoveTowardLink(step, 3);
			Ghost_Waitframe(this, ghost, true, true);
		}
	}

	// A modified version of Ghost_SpawnAnimationFlicker(). This removes the
	// Armos combo near the end of the animation.
	void SpawnAnimation(ffc this, npc ghost)
	{
		int combo=this->Data;
		bool collDet=ghost->CollDetection;
		int xOffset=ghost->DrawXOffset;
		
		Ghost_SetPosition(this, ghost);
		ghost->CollDetection=false;
		
		// Alternate drawing offscreen and in place for 64 frames
		for(int i=0; i<32; ++i)
		{
			this->Data=0;
			ghost->DrawXOffset=32768;
			Ghost_SetPosition(this, ghost);
			Ghost_WaitframeLight(this, ghost);
			
			this->Data=combo;
			ghost->DrawXOffset=xOffset;
			Ghost_SetPosition(this, ghost);
			if (i!=29) Ghost_WaitframeLight(this, ghost);
			
			// The combo has to be removed shortly before the animation
			// finishes; otherwise, it's possible to spawn two of them.
			if(i==29 && ghost->Attributes[ARMOS_ATTR_NATURAL] == 0)
			{
				if ((Screen->ComboF[ComboAt(ghost->X + 8, ghost->Y + 8)] == 10 || Screen->ComboI[ComboAt(ghost->X + 8, ghost->Y + 8)] == 10) && Screen->RoomType == RT_SPECIALITEM && Screen->State[ST_SPECIALITEM] != true)
				{
					Game->PlaySound(SFX_SECRET);
					item armositem = Screen->CreateItem(Screen->RoomData);
					armositem->Pickup |= IP_ST_SPECIALITEM;
					if ((Screen->Flags[SF_ITEMS] & 1)) armositem->Pickup |= IP_HOLDUP;
					armositem->X = ghost->X;
					armositem->Y = ghost->Y;
				}
				if (Screen->ComboF[ComboAt(ghost->X, ghost->Y)] == 9 || Screen->ComboI[ComboAt(ghost->X, ghost->Y)] == 9)
				{
					Screen->ComboD[ComboAt(ghost->X, ghost->Y)]=Screen->UnderCombo;
					Screen->ComboC[ComboAt(ghost->X, ghost->Y)]=Screen->UnderCSet;
					Ghost_WaitframeLight(this, ghost);
					Screen->TriggerSecrets();
					Game->PlaySound(SFX_SECRET);
				}
				else
				{
					Screen->ComboD[ComboAt(ghost->X, ghost->Y)]=Screen->UnderCombo;
					Screen->ComboC[ComboAt(ghost->X, ghost->Y)]=Screen->UnderCSet;
				}
			}
		}
		
		this->Data=combo;
		ghost->CollDetection=collDet;
		ghost->DrawXOffset=xOffset;
	}
}