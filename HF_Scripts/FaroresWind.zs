const int SFX_FARORESWINDSET = 59; //Default Whistle Whirlwind
const int SFX_FARORESWINDWARP = 39; //Default Farores Wind

const int CMB_AUTOWARP = 411; //An invisible "Auto Warp A" combo
const int CMB_WARPPOINT = 755; //The combo for the warp point
const int CMB_CSET_WARPPOINT = 2; //The CSet of the above combo
const int WPS_FARORESWINDSET = 35; //The Weapon/Misc sprite for setting the warp point (appears above Link)
const int WPS_FARORESWINDWARP = 81; //The Weapon/Misc sprite for Link's warp animation

//Global array - gets saved across sessions
int fwData[5] = {-1, -1, -1, -1, 0};
const int FWD_DMAP = 0;
const int FWD_SCREEN = 1;
const int FWD_X = 2;
const int FWD_Y = 3;
const int FWD_ACTIVE = 4; //If 1, call set or warp function

global script active{
    void run(){
        int faroresWindTimer = 0;
        Link->Invisible = false;
        while(true){
            //Implement cooldown for Farore's Wind
            if ( faroresWindTimer > 0 )
                faroresWindTimer--;
            
            //If Farores Wind was called by item script
            else if ( fwData[FWD_ACTIVE] != 0 ){
                //No warp point set: set one
                if ( fwData[FWD_DMAP] < 0 ){
					Tango_InitializeMenu();
					int menuStr[]="@choice(1)Store Checkpoint@26@choice(2)Warp to Checkpoint@26@choice(3)Warp to Entrance@domenu(1)@close()";
					
					int TextSlot = Tango_GetFreeSlot();
					Tango_ClearSlot(TextSlot);
					Tango_LoadString(TextSlot, menuStr);
					
					Tango_SetSlotStyle(TextSlot, style);
					Tango_SetSlotPosition(TextSlot, x, y);
					Tango_ActivateSlot(TextSlot);
					
					while(!Tango_MenuIsActive())
						Waitframe();

					while(Tango_MenuIsActive())
						Waitframe();

					int selected=Tango_GetLastMenuChoice();
					if (selected == 1)
					{
						//Start animation (sprite above Link)
						Game->PlaySound(SFX_FARORESWINDSET);
						lweapon anim = CreateLWeaponAt(LW_SPARKLE, Link->X, Link->Y-16);
						anim->UseSprite(WPS_FARORESWINDSET);
						freezeScreen();
						
						//Let it finish
						while(anim->isValid())
							WaitNoAction();
						
						//Animation done; set warp point
						unfreezeScreen();
						
						//Store warp point data
						fwData[FWD_DMAP] = Game->GetCurDMap();
						fwData[FWD_SCREEN] = Game->GetCurDMapScreen();
						fwData[FWD_X] = Link->X;
						fwData[FWD_Y] = Link->Y;
						fwData[FWD_ACTIVE] = 0;
						
						createWarpPointFFC();
					}
                }
                
                //Warp point set: warp to it
                else{
                    //Start animation (sprite replaces Link)
                    Game->PlaySound(SFX_FARORESWINDWARP);
                    lweapon anim = CreateLWeaponAt(LW_SPARKLE, Link->X, Link->Y);
                    anim->UseSprite(WPS_FARORESWINDWARP);
                    Link->Invisible = true;
                    freezeScreen();
                    
                    //Let it finish
                    while(anim->isValid())
                        WaitNoAction();
                    
                    //Animation done; warp
                    unfreezeScreen();
                    Link->Invisible = false;
                    Screen->SetSideWarp(0, fwData[FWD_SCREEN], fwData[FWD_DMAP], WT_IWARPWAVE);
                    ffc warpFFC = loadUnusedFFC(true);
                    warpFFC->Data = CMB_AUTOWARP;
                    
                    //Wait for warp to take place (warp pauses global script), then place Link
                    Waitframe();
                    Link->X = fwData[FWD_X];
                    Link->Y = fwData[FWD_Y];
                    
                    //Un-set warp
                    fwData[FWD_DMAP] = -1;
                }
                
                fwData[FWD_ACTIVE] = 0;
                faroresWindTimer = 60;
            }
        
            //THIS REPLACES YOUR NORMAL WAITFRAME()
            //Any other scripts that check screen changes can share this section
            if ( WaitframeCheckScreenChange() ){
                createWarpPointFFC(); //If screen changed, try to create warp point
            }
        }
    }
}

void createWarpPointFFC(){
    if ( Game->GetCurDMap() == fwData[FWD_DMAP] //If on warp point DMap/screen
        && Game->GetCurDMapScreen() == fwData[FWD_SCREEN]
    ){
        ffc warpPointFFC = loadUnusedFFC(false); //Get an unused FFC
        
        if ( !ffcIsBlank(warpPointFFC) ) //If non-blank FFC, quit now
            return;
            
        //Place the FFC
        warpPointFFC->Data = CMB_WARPPOINT;
        warpPointFFC->CSet = CMB_CSET_WARPPOINT;
        warpPointFFC->X = fwData[FWD_X];
        warpPointFFC->Y = fwData[FWD_Y];
    }
}

//D0: MP Cost
item script faroresWind{
    void run(int mpCost){
        //If warp currently active, quit
        if ( fwData[FWD_ACTIVE] != 0 )
            return;
    
        //If no warp point and insufficient magic, quit
        if ( fwData[FWD_DMAP] > 0 && Link->MP < mpCost )
            return;
        
        //Otherwise if no warp point, pay to make one
        if ( fwData[FWD_DMAP] > 0 )
            Link->MP -= mpCost;
        
        //Then activate
        fwData[FWD_ACTIVE] = 1;
    }
}