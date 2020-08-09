//import "std.zh"

//////////////////////////////////
/// BobOmb for EotM - May 2017 ///
/// By: ZoriaRPG               ///
/// 19th May, 2017             ///
/// v0.2                       ///
//////////////////////////////////
//! Set all npc defences to Stun

ffc script bobomb{
	void run(int enem_id, int misc_id, int misc_cset, int flash_cset){
		npc n; int q;
		itemdata id = Game->LoadItemData(I_BOMB); 
		int pow = id->Power;
		while(true){
			//find any bobomb npcs
			for ( q = Screen->NumNPCs(); q > 0; q-- ) {
				n = Screen->LoadNPC(q);
				if ( n->ID == enem_id ) {
					//n->Attributes[1] = NPCA2_EXPLODE; //Set its death attribute. 
					//found one, check its stun
					if ( n->Stun > 1 ) {
						//check its timer
						if ( n->Misc[misc_id] == 0 ) {
							//its not yet flashing, so set its timer.
							n->Misc[misc_id] = 120; 
							n->Misc[misc_cset] = n->CSet;
						}
						if ( n->Misc[misc_id] > 0 ) {
							n->Misc[misc_id]--;
							if ( n->Misc[misc_id] % 5 == 0 ) {
								//Make it flash
								n->CSet = flash_cset;
							}
							else n->CSet = n->Misc[misc_cset];
						}
						n->Stun -= n->Attributes[1];
					}
					if ( n->Stun == 1 ) {
						//time to explode
						eweapon e = Screen->CreateEWeapon(EW_SBOMBBLAST);
						if (n->Attributes[0] > 0) e->Damage = n->Attributes[0];
						else e->Damage = n->WeaponDamage;
						e->X = n->X; e->Y = n->Y;
						n->HP = -9999;
					}
				}
			}
			Waitframe();
		}
	}
}

const int NPC_BOBOMB = 330;
const int BOBOMB_FFC_SLOT = 29;
const int BOBOMB_FFC_DATA = 1;
const int BOBOMB_FFC_D_TIMER_SLOT = 14;
const int BOBOMB_FFC_D_CSET_SLOT = 13;
const int BOBOMB_FFC_FLASH_CSET = 8;

global script test_bobomb{
	void run(){
		while(true){
			BobOmb(NPC_BOBOMB, BOBOMB_FFC_SLOT, BOBOMB_FFC_DATA, BOBOMB_FFC_D_TIMER_SLOT, BOBOMB_FFC_D_CSET_SLOT, BOBOMB_FFC_FLASH_CSET);
			Waitdraw();
			Waitframe();
		}
	}
}
		
//Globally find any bobombs. If any are on the screen and the script is not running, run it. 
void BobOmb(int npc_id, int ffc_slot, int ffc_data, int misc_timer, int misc_cset_slot, int flash_cset){
	int ff[]="bobomb"; npc n; int fff = Game->GetFFCScript(ff);
	if ( fff < 1 ) return;
	ffc f = Screen->LoadFFC(ffc_slot);
	if ( f->Script == fff ) return;
	for ( int q = Screen->NumNPCs(); q > 0; q-- ) {
		//check or bobombs
		n = Screen->LoadNPC(q);
		if ( n->ID == npc_id ) {
			if ( f->Script != fff ) {
				f->Data = ffc_data;
				f->Script = fff;
				
				f->InitD[0] = npc_id;
				f->InitD[1] = misc_timer;
				f->InitD[2] = misc_cset_slot;
				f->InitD[3] = flash_cset;
				
			}
		}
	}
}
		
							
//Bobomb tiles in the demo qest are from this post: http://www.purezc.net/forums/index.php?showtopic=31432
