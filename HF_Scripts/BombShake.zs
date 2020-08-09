const int BombsScreenShakeFrames = 10; //how many frames a bomb shakes the screen
const int BombsScreenShakeSFrames = 30; //how many frames a superbomb shakes the screen
const int BombsScreenShakeWeaponMisc = 0; //what weapon misc to use for explosion eweapons and lweapons (leave at 0 if no other script uses them)

void BombsScreenShake() 
{
	for (int i = Screen->NumLWeapons(); i > 0; --i) 
	{ 
		//lweapons
		lweapon lweap = Screen->LoadLWeapon(i);
		unless(lweap->Misc[BombsScreenShakeWeaponMisc])
		{
			if ( lweap->ID == LW_BOMBBLAST ) 
			{ 
				//if there is a normal explosion on screen and the misc value is 0
				Screen->Quake = BombsScreenShakeFrames; //shake the screen
				lweap->Misc[BombsScreenShakeWeaponMisc] = 1; //change the misc value to 1
			}
			else if ( lweap->ID == LW_SBOMBBLAST ) 
			{ 
				//if there is a super explosion on screen and the misc value is 0
				Screen->Quake = BombsScreenShakeSFrames; //shake the screen
				lweap->Misc[BombsScreenShakeWeaponMisc] = 1; //change the misc value to 1
			}
		}
	}
	for (int i = Screen->NumEWeapons(); i > 0; --i)  
	{ 
		//eweapons
		eweapon eweap = Screen->LoadEWeapon(i);
		unless(eweap->Misc[BombsScreenShakeWeaponMisc])
		{
			if ( eweap->ID == EW_BOMBBLAST ) 
			{ 
				//if there is a normal explosion on screen and the misc value is 0
				Screen->Quake = BombsScreenShakeFrames; //shake the screen
				eweap->Misc[BombsScreenShakeWeaponMisc] = 1; //change the misc value to 1
			}
			else if ( eweap->ID == EW_BOMBBLAST ) 
			{ //if there is a super explosion on screen and the misc value is 0
				Screen->Quake = BombsScreenShakeSFrames; //shake the screen
				eweap->Misc[BombsScreenShakeWeaponMisc] = 1; //change the misc value to 1
			}
		}
	}
}