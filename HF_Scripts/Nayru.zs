#include "Reflect.zs"

const int LINKMISC_DEFENSE = 4;

void NayrusLove()
{
	if (Link->Misc[LINKMISC_DEFENSE] > 0)
	{
		Link->Misc[LINKMISC_DEFENSE]--;
		if (Link->Misc[LINKMISC_DEFENSE] % 15 == 0 && Link->HP < Link->MaxHP) Link->HP++;
		Link->HitDir = -1;
		if (Link->Item[61] == true)
		{
			itemdata id = Game->LoadItemData(61);
			id->Power = 12;
		}
		else if (Link->Item[18] == true)
		{
			itemdata id = Game->LoadItemData(18);
			id->Power = 6;
		}
		else if (Link->Item[17] == true)
		{
			itemdata id = Game->LoadItemData(17);
			id->Power = 3;
		}
		else if (Link->Item[159] == true)
		{
			itemdata id = Game->LoadItemData(159);
			id->Power = 2;
		}
		if (Link->Misc[LINKMISC_DEFENSE] > 120 || Link->Misc[LINKMISC_DEFENSE] % 2 == 0)
		{
			Screen->FastCombo(3, Link->X - 8, Link->Y - 8, 10464, 5, OP_TRANS);
			Screen->FastCombo(3, Link->X + 8, Link->Y - 8, 10465, 5, OP_TRANS);
			Screen->FastCombo(3, Link->X - 8, Link->Y + 8, 10468, 5, OP_TRANS);
			Screen->FastCombo(3, Link->X + 8, Link->Y + 8, 10469, 5, OP_TRANS);
			
			Screen->FastCombo(2, Link->X - 8, Link->Y - 8, 10464, 5, OP_OPAQUE);
			Screen->FastCombo(2, Link->X + 8, Link->Y - 8, 10465, 5, OP_OPAQUE);
			Screen->FastCombo(2, Link->X - 8, Link->Y + 8, 10468, 5, OP_OPAQUE);
			Screen->FastCombo(2, Link->X + 8, Link->Y + 8, 10469, 5, OP_OPAQUE);
		}
	}
	else
	{
		if (Link->Item[61] == true)
		{
			itemdata id = Game->LoadItemData(61);
			id->Power = 8;
		}
		else if (Link->Item[18] == true)
		{
			itemdata id = Game->LoadItemData(18);
			id->Power = 4;
		}
		else if (Link->Item[17] == true)
		{
			itemdata id = Game->LoadItemData(17);
			id->Power = 2;
		}
		else if (Link->Item[159] == true)
		{
			itemdata id = Game->LoadItemData(159);
			id->Power = 1;
		}
	}
}

item script NayrusLove
{
	void run(int timer)
	{
		Link->Misc[LINKMISC_DEFENSE]+=timer;
	}
}

ffc script Cutscene
{
	void run(bool skip)
	{
		while (true)
		{
			if (!skip) WaitNoAction();
			else
			{
				if (Link->PressStart) this->Data = CMB_AUTOWARP + 1;
				WaitNoAction();
			}
		}
	}
}

//////////////////////////
/// Title Screen FFC   ///
///   By: ZoriaRPG     ///
///  With Assistance   ///
/// From: MasterManiac ///
//////////////////////////////////////////////////////////////////////////////
/// This script is used to run a title screen, using FFCs, and uses one    ///
/// FFC to establish the functions of the title screen, which begins the   ///
/// game by pressing the START button, as one might expect to happen in    ///
/// games that actually *have* a START button.                             ///
///                                                                        ///
/// You may change the button to suit your game, by replacing ImputStart   ///
/// with the desired input, such as InputEx1, if you want a game to start  ///
/// by pressing SELECT, such as a few Kusoge titles do, that I can recall. ///
///                                                                        ///
/// Set to 'Run at Screen init' in FFC Flags!                              ///
//////////////////////////////////////////////////////////////////////////////
///                            ...............                             ///
///                             FFC ARGUMENTS                              ///
///                            ...............                             ///
///---------------------------{ D0: Start SFX }----------------------------///
/// D0: SFX to play when the player presses 'START'.                       ///
/// Set from Quest->Audio->SFX Data.                                       ///
///---------------------------{ D1: Delay Time }---------------------------///
/// D1: Length of time, between pressing start, and the game starting.     ///
/// Time this to match your SFX, where 60 = 1-second.                      ///
/// (240, would therefore be four-seconds, and is my default value.)       ///
///----------------------{ D2/D3: Warp Destinations }----------------------///
/// D2: If using a direct warp, set this to the DMAP number for the warp   ///
/// (not the 'Map' number, but the 'DMAP' number), stating at 0.           ///
/// D3: If using direct warps, set this to the screen number for the       ///
/// warp destination. This will use WARP RETURN 'A'.                       ///
///------------------------{ D4: Secret Warp Mode }------------------------///
/// D4: If you are going to use a SENSITIVE WARP tile, placed under the    ///
/// player, to control the warp (and thus, control fade effects), then     ///
/// set this to a value of '1' (or greater). Set warp destinations from    ///
/// Screen->Tilewarp, and set your tile warp combo in Screen->Secrets, as  ///
/// SECRET TILE 0, then place Flag-16 over where the player is caged on    ///
/// your title screen.                                                     ///
//////////////////////////////////////////////////////////////////////////////


ffc script titleScreen {
    void run(int SFX, int timeValue, int W_DMAP_NUMBER, int W_SREEN_NUMBER, int secrets) {
    Link->InputStart = false; //present subscreen from falling.
    bool waiting = true; //Establish main while loop.
    bool pressed = false; //Establish timer requirements.
    int timer = 0; //Set timer to exist.
    
        while(waiting){  //The main while loop. 
             
            if (Link->InputStart && !pressed) {  //Is the player presses START
                Link->InputStart = false; //Keep subscreen from falling.
                pressed = true; //Initiate countdown timer.
				this->Data += 4;
                Game->PlaySound(SFX); //Play SFX set in D0.
            }
            if(pressed){   //Run Timer
                timer++;   //Timer counts up, until it reaches amount set in D1.
            }
            
            if(timer >= timeValue){  //if timer is equal to, or greater than value of D1.
                if ( secrets > 0 ) {  //If D4 is set to 1 or higher...
                    Screen->TriggerSecrets();  //Trigger secret combos. Use this if using a warp combo.
                }
                else {  //If D4 is set to 0, and we are using direct warps...
                    //Link->Warp(W_DMAP_NUMBER, W_SREEN_NUMBER);  //Warp Link to the DMAP set in D2, and the screen set in D3, using Warp Return A.
					this->Data = CMB_AUTOWARP;
					this->TileWidth = 1;
                }
            }
            Waitframe(); //Pause, to cycle the loop.
        }
    }
}

ffc script DrawShadow
{
	void run(int offset)
	{
		int shadowy = this->Y + offset;
		while(true)
		{
			Screen->FastCombo(2, this->X, shadowy, 10502, 8, OP_OPAQUE);
			Waitframe();
		}
	}
}

ffc script BreakSword
{
	void run()
	{
		ffc Hey[4] = {Screen->LoadFFC(10), Screen->LoadFFC(11), Screen->LoadFFC(12), Screen->LoadFFC(13)};
		
		Hey[0]->Vx = -0.5;
		Hey[1]->Vx = -0.5;
		Hey[2]->Vx = 0.5;
		Hey[3]->Vx = 0.5;
		Hey[0]->Vy = -0.25;
		Hey[1]->Vy = 0.25;
		Hey[2]->Vy = -0.25;
		Hey[3]->Vy = 0.25;
		Game->ContinueDMap = 0;
		Game->ContinueScreen = 77;
		Link->Item[166] = false;
		Game->PlaySound(81);
		
		for (int i = 0; i < 4; i++)
		{
			Hey[i]->Vy -=2;
			Hey[i]->Ay = 0.16;
			Hey[i]->X = Link->X;
			Hey[i]->Y = Link->Y;
			Hey[i]->Data = 10475;
			Hey[i]->CSet = 8;
			Hey[i]->Flags[FFCF_OVERLAY] = true;
		}
		
		WaitNoAction(60);
		
		for (int i = 0; i < 4; i++)
		{
			lweapon Sparkle = CreateLWeaponAt(LW_SPARKLE, Hey[i]->X, Hey[i]->Y);
			Sparkle->UseSprite(22);
			Hey[i]->Data = 0;
		}
		
		Screen->Message(140);
	}
}

ffc script DrawIntro
{
	void run()
	{
		while(true)
		{
			Screen->DrawLayer (0, 31, 0x64, 0, 0, -176, 0, OP_OPAQUE);
			Screen->DrawLayer (1, 31, 0x64, 1, 0, -176, 0, OP_OPAQUE);
			Screen->DrawLayer (2, 31, 0x64, 2, 0, -176, 0, OP_TRANS);
			Waitframe();
		}
	}
}

ffc script CopyTileFFC
{
	void run(int tile1, int tile2)
	{
		CopyTile(tile1, tile2);
	}
}