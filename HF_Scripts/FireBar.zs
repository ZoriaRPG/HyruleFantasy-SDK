//D0: # of arms to give the trap. (1-4).
//D1: Speed at which it circles, in degrees. Negative # will result in a Counter Clockwise spin.
//D2: Parts to the Arm. Larger # will give a bigger spinner.


const int FIREBAR_NPC = 378; //Sprite to use.
const int FIREBAR_SPACE = 12; //Spacing between each Sprite.

ffc script FireArm{
	void run(int Arms, float speed, int Parts){
		
		int Center_X = this->X;
		int Center_Y = this->Y;
		int RealNPC;
		int radius;
		float angle;
		bool first = true;
		int CurNPC = 0;
		
		//Create npc
		npc tempNPC;
		
		int num = 1;
		
		for (int i = 1; i <= 32; i++)
		{
			ffc TempLoad = Screen->LoadFFC(i);
			if (TempLoad->Script == this->Script)
			{
				if (TempLoad == this) break;
				else num++;
			}
		}
		
		Waitframes(num);
		
		CurNPC = Screen->NumNPCs();
		
		for(int a = 0; a < (Arms * Parts); a++){
			tempNPC = Screen->CreateNPC(FIREBAR_NPC);
			if(Link->Item[61]) tempNPC->Damage *= 8;
			else if(Link->Item[18]) tempNPC->Damage *= 4;
			else if(Link->Item[17]) tempNPC->Damage *= 2;
			if(a <= (Parts - 1)){
				tempNPC->X = Center_X;
				tempNPC->Y = Center_Y - (FIREBAR_SPACE * ((a%Parts)+1) + FIREBAR_SPACE);
			}//end if
			else if(a <= (Parts * 2 - 1)){
				tempNPC->X = Center_X;
				tempNPC->Y = Center_Y + (FIREBAR_SPACE * ((a%Parts)+1) + FIREBAR_SPACE);
			}//end else if
			else if(a <= (Parts * 3 - 1)){
				tempNPC->X = Center_X + (FIREBAR_SPACE * ((a%Parts)+1) + FIREBAR_SPACE);
				tempNPC->Y = Center_Y;
			}//end else if
			else{
				tempNPC->X = Center_X - (FIREBAR_SPACE * ((a%Parts)+1) + FIREBAR_SPACE);
				tempNPC->Y = Center_Y;
			}//end else
		}//end if
		
		while(true){
		
			for(int b = 1; b < Screen->NumNPCs(); b++){
				tempNPC = Screen->LoadNPC(b);
				if(tempNPC->ID == FIREBAR_NPC){
					RealNPC = b + CurNPC;
					break;
				}//end if
			}//end for
		
			for (int a = 0; a < (Arms * Parts); a++){
				tempNPC = Screen->LoadNPC(a + RealNPC);
				angle = tempNPC->Misc[0];
				tempNPC->HitWidth = 8;
				tempNPC->HitHeight = 8;
				tempNPC->HitXOffset = 4;
				tempNPC->HitYOffset = 4;
				
				if(first){
					//Find Radius
					if(a <= (Parts * 2 - 1)) radius = Center_Y - tempNPC->Y;
					else radius = Center_X - tempNPC->X;
				
					//Change Radius to positive
					if(radius < 0) radius *= -1;
				
					//Save Radius
					tempNPC->Misc[1] = radius;
				}//end if
				else radius = tempNPC->Misc[1];
				
				//Find start angle
				if(first){
					if(a <= (Parts - 1)) angle = 0;
					else if(a <= (Parts * 2 - 1)) angle = 180;
					else if(a <= (Parts * 3 - 1)) angle = 90;
					else angle = 270;
				}//end if
				
				angle += speed;
				if(angle < -360) angle += 360;
				else if(angle > 360) angle -= 360;
				tempNPC->X = Center_X + radius * Cos(angle);
				tempNPC->Y = Center_Y + radius * Sin(angle);
				tempNPC->Misc[0] = angle;
			}//end for
		
			first = false;
			Waitframe();
		}//end while
		
	}//end run
}//end ffc