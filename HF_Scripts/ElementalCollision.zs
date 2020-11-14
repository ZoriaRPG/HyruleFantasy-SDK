const int SPR_FIRE_DIE = 110;

void DetectFireColl()
{
	for (int i = Screen->NumEWeapons(); i > 0; i--)
	{
		eweapon fire = Screen->LoadEWeapon(i);
		if (fire->ID == EW_FIRE2 && fire->DeadState != 0)
		{
			if (!CanWalk(fire->X, fire->Y, fire->Dir%4, fire->Step, false) && 
			Screen->ComboS[ComboAt(fire->X + 8 + InFrontX(fire->Dir, 16-(fire->Step / 100)), fire->Y + 8 + InFrontY(fire->Dir, 16-(fire->Step / 100)))] == 1111b)
			{
				lweapon sparkle = Screen->CreateLWeapon(LW_SPARKLE);
				sparkle->UseSprite(110);
				sparkle->X = fire->X;
				sparkle->Y = fire->Y;
				Remove(fire);
			}
		}
	}
}

void DetectIceColl()
{
	int name[] = "paralyze";
	int scr = Game->GetFFCScript(name);
	if (CountFFCsRunning(scr) <= 0)
	{
		if (Link->Item[169]) Link->Item[169] = false;
		for (int i = Screen->NumEWeapons(); i > 0; i--)
		{
			eweapon ice = Screen->LoadEWeapon(i);
			if (ice->ID == EW_SCRIPT3 && ice->DeadState != 0)
			{
				if (LinkCollision(ice) && Link->CollDetection)
				{
					int arg[8] = {ice->Damage,90,1,0,0,0,0,0};
					RunFFCScript(scr, arg);
					Remove(ice);
					return;
				}
			}
		}
	}
}

ffc script paralyze{
    void run(int damage, int duration, int endOnHit ){
		//Link->Action = LA_GOTHURTLAND;
		Game->PlaySound(19);
        int startX; //Link's starting position when hit - he can move a pixel in each direction while paralyzed
        int startY;
        startX = Link->X;
        startY = Link->Y;
		if (!Link->Item[169]) Link->Item[169] = true;
		if (Link->Item[61] == true)
		{
			itemdata id = Game->LoadItemData(169);
			id->Power = 8;
		}
		else if (Link->Item[18] == true)
		{
			itemdata id = Game->LoadItemData(169);
			id->Power = 4;
		}
		else if (Link->Item[17] == true)
		{
			itemdata id = Game->LoadItemData(169);
			id->Power = 2;
		}
		else
		{
			itemdata id = Game->LoadItemData(169);
			id->Power = 1;
		}
		itemdata id = Game->LoadItemData(169);
		Link->HP -= ((damage * 4) / id->Power);
		int startHP = Link->HP; //Set starting HP
        while ( duration-- > 0 && (endOnHit && Link->HP >= startHP) ){ //Until duration ends or Link is hurt
			Link->HitDir = -1;
			Link->X = startX; //Reset Link's position
            Link->Y = startY;
            
            if ( Link->InputUp ) {Link->Y--; duration--;} //Allow him to struggle
            else if ( Link->InputDown ) {Link->Y++; duration--;}
            if ( Link->InputLeft ) {Link->X--; duration--;}
            else if ( Link->InputRight ) {Link->X++; duration--;}
            
            if ( Link->HP > startHP ) //If Link somehow heals, set current HP to start HP
                Link->HP = startHP;
            
            WaitNoAction(); //Cancel all actions and advance to next frame
        }
	Link->X = startX; //Reset Link's position
        Link->Y = startY;
		if (Link->Item[169]) Link->Item[169] = false;
    }
}

item script MsgWeaponLauncher{
	void run (int none, int d0, int d1, int d2, int d3, int d4, int d5, int ffcscript){
		int itm = LastItemUsed();
		int args[8] = {d0,d1,d2,d3,d4,d5,0,itm};
		ffc launch = RunFFCScriptOrQuit(ffcscript, args);
	}
}