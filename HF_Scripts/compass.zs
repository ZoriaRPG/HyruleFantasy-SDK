//import "std.zh"

//VERSION A BY DEMONLINK:

const int COMPASS_BEEP = 72; //Set this to the SFX id you want to hear when you have the compass,

//Instructions:
//1.- Compile and add this to your ZQuest buffer.
//2.- Add an FFC with this script attached to the screen where you want to hear the compass beep. 
//3.- Let the script do the rest.

//How does it work:
//The script checks if ANY of the following has been done:
//a) Item or Special Item has been picked up.
//b) Any type of chest has been opened.
//c) If NOTHING of the above has been done, the script runs. Otherwise, no SFX is heard. 

ffc script CompassBeep{
     void run(){
          if(!Screen->State[ST_ITEM] &&
             !Screen->State[ST_CHEST] &&
             !Screen->State[ST_LOCKEDCHEST] &&
             !Screen->State[ST_BOSSCHEST] &&
             !Screen->State[ST_SPECIALITEM] && (Game->LItems[Game->GetCurLevel()] & LI_COMPASS)){ 
               Game->PlaySound(COMPASS_BEEP);
          }
     }
}


//VERSION B BY NYROX

const int COMPASS_SFX = 72; //Set this to the SFX id you want to hear when you have the compass.
 
//Instructions:
//1.- Compile and add this to your ZQuest buffer.
//2.- Add an FFC with this script attached to the screen where you want to hear the compass beep. 
//3.- The following arguments are for cases where you have more than one item on a same screen (YES, it is possible).
 
// D0: Set this to 1 if you have a Normal Item set.
// D1: Set this to 1 if you have a Special Item set.
// D2: Set this to 1 if you have a Normal Chest set.
// D3: Set this to 1 if you have a Locked Chest set.
// D4: Set this to 1 if you have a Boss Chest set.
 
//How does it work:
//The script checks if ANY of the following is true.
//a) Depending on the Argument settings, it will check if the condition is met.
//b) If so, it will play the sound.
 
ffc script NyroxCompassBeep{
     void run(int arg1, int arg2, int arg3, int arg4, int arg5){
          if(GetLevelItem(LI_COMPASS)){
               if(!Screen->State[ST_ITEM] && (arg1 == 1)){
                    Game->PlaySound(COMPASS_SFX);
               }
               else if(!Screen->State[ST_SPECIALITEM]&& (arg2 == 1)){
                    Game->PlaySound(COMPASS_SFX);
               }
               else if(!Screen->State[ST_CHEST]&& (arg3 == 1)){
                    Game->PlaySound(COMPASS_SFX);
               }
               else if (!Screen->State[ST_LOCKEDCHEST] && (arg4 == 1)){
                    Game->PlaySound(COMPASS_SFX);
               }
               else if(!Screen->State[ST_BOSSCHEST]&& (arg5 == 1)){
                    Game->PlaySound(COMPASS_SFX);
               }
 
          }
     }
}
