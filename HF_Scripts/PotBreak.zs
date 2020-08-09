//import "std.zh"



const int PotBreak_Flag = 102; //Flag to use for pots

const int PotBreak_SFX = 81; //SFX to use for pots



void PotBreak(){

    for(int i=0; i<176; i++){

        if(Screen->ComboF[i]==PotBreak_Flag || Screen->ComboI[i]==PotBreak_Flag){

            Game->PlaySound(PotBreak_SFX);

            Screen->ComboD[i]++;

        }

    }

}