//Simple fire rod
//D0-Damage dealt by both direct hit by wand and flame magic.
//D1-Sprite used for wand.
//D2-Sprite for flame
//D3-projectile speed
//D4-Cost, in MP.

ffc script FireRod{
	void run(int damage, int wandsprite, int flamesprite, int speed, int cost, int freezeduration){
		lweapon wand = LweaponInit (this, LW_GHOSTED, damage, wandsprite, 0);
		MeleeWeaponSlash90Alt(this, wand, wand->Misc[LWEAPON_MISC_ORIGTILE], 8, 12, 88, 0, NPCD_WAND, 0, 2);
		if (!AmmoManager(CR_MAGIC, cost, 104, false)){
			MeleeWeaponEndStrike(this, wand, wand->Misc[LWEAPON_MISC_ORIGTILE], 12, 2, 2);
		}
		int it = GetItemID(wand);
		int args[8] = {damage, flamesprite, speed, freezeduration, 0, 0 ,0, it};
		int buffer[] = "FireRodFlame";
		int scr = Game->GetFFCScript(buffer);
		ffc magic = LaunchScriptedLweapon(scr, args);
		PutFFCInFrontOfLink(magic, 16);
		Game->PlaySound(SFX_FIRE);
		MeleeWeaponEndStrike(this, wand, wand->Misc[LWEAPON_MISC_ORIGTILE], 12, 2, 2);
	}	
}

ffc script FireRodFlame{
	void run(int dam, int sprite, int speed, int freezeduration){
		lweapon fire =  CreateNewWeapon (this, LW_GHOSTED, dam, sprite);
		LweaponSetFlag(fire, LWF_NO_FALL);
		//LweaponSetFlag(fire, LWF_PENETRATING);
		SetStraightMotion4(this, speed);
		while (true){
			SetEnemyDefense(fire, NPCD_FIRE);
			TriggerUpdate2 (fire, 4, SFX_SECRET, true);
			if (dam>2) TriggerUpdate2 (fire, 74, SFX_SECRET, true);
			if (dam>4) TriggerUpdate2 (fire, 73, SFX_SECRET, true);
			TriggerUpdate2 (fire, 79, SFX_SECRET, true);
			npc frozen = OnHitEnemy(fire);
			
			
			if (frozen->isValid() && frozen->Defense[NPCD_STOMP] != NPCDT_STUNORBLOCK){
				int args[1] = {freezeduration};
				int buffer[] = "StatusEffectFlaming";
				int scr = Game->GetFFCScript(buffer);
				InduceEnemyStatusEffect(this, scr, args, frozen);
			}	
			
			if ((WallCollision8wayBush(fire))||(BlockedByEnemy(fire))||(fire->X < 15 || fire->X > 241 || fire->Y < 15 || fire->Y > 161))
			{
				lweapon Fireball = Screen->CreateLWeapon(LW_FIRESPARKLE);
				Fireball->Damage = dam;
				Fireball->X = this->X;
				Fireball->Y = this->Y;
				Fireball->UseSprite(110);
				TerminateLweapon (this, fire);
			}
			
			LweaponWaitframe (this,fire, true);
		}
	}
}

ffc script StatusEffectFlaming{
	void run(int flameduration){
		npc n = Screen->LoadNPC(this->InitD[7]);
		if (!n->isValid())Quit();
		
		int timer = flameduration;
		this->X = n->X;
		this->Y = n->Y;
		while (n->isValid()){
			if ((timer>=90)||(IsOdd(timer)))Screen->FastCombo(3, n->X, n->Y, 10123, 8, OP_TRANS);
			timer--;
			if (timer % 30 == 0) n->HP--;
			if (timer<=0){
				this->Data = 0;
				this->Script = 0;
				Quit();
			}
			Waitframe();
		}
	}
}

void TriggerUpdate2 (lweapon l, int flag, int sound, bool perm){
	if (flag==0) return;
	bool Alltriggered = false;
	while (!Alltriggered){
		int loc = ComboAnyFlagCollision (flag, l, false, -1);
		if (loc < 0) Alltriggered = true;
		else{
			Game->PlaySound(sound);
			if (ComboFI(loc, CF_SINGLE)){
			
			}
			else if (ComboFI(loc, CF_SINGLE16)){
				Screen->TriggerSecrets();
			}
			else {
				Screen->TriggerSecrets();
				if (perm) Screen->State[ST_SECRET] = true;
			}
		}
	}
}

//Retuns TRUE if FFC hits a solid combo.
bool WallCollision8wayBush(lweapon lw){
	int lwx = lw->X + lw->HitXOffset + 2;
	int lwy = lw->Y + lw->HitYOffset + 2;
	int COLL_POINTSX[8]={lwx, lwx+(lw->HitWidth-4)/2, lwx+(lw->HitWidth-4), lwx, lwx+(lw->HitWidth-4), lwx, lwx+(lw->HitWidth-4)/2, lwx+(lw->HitWidth-4)};
	int COLL_POINTSY[8]={lwy, lwy, lwy, lwy+(lw->HitHeight-4)/2, lwy+(lw->HitHeight-4)/2, lwy+(lw->HitHeight-4), lwy+(lw->HitHeight-4), lwy+(lw->HitHeight-4)};
	for (int i=0; i<=7; i++){
		//Screen->PutPixel(0, COLL_POINTSX[i], COLL_POINTSY[i], 1, 0, 0, 0, 128);
		if (Screen->isSolid(COLL_POINTSX[i], COLL_POINTSY[i]) && Screen->ComboT[ComboAt(COLL_POINTSX[i], COLL_POINTSY[i])] != CT_BUSHNEXTC
		&& Screen->ComboT[ComboAt(COLL_POINTSX[i], COLL_POINTSY[i])] != CT_BUSHNEXT
		&& Screen->ComboT[ComboAt(COLL_POINTSX[i], COLL_POINTSY[i])] != CT_TALLGRASSNEXT
		&& Screen->ComboT[ComboAt(COLL_POINTSX[i], COLL_POINTSY[i])] != CT_HOOKSHOTONLY
		&& Screen->ComboT[ComboAt(COLL_POINTSX[i], COLL_POINTSY[i])] != CT_LADDERHOOKSHOT
		&& Screen->ComboT[ComboAt(COLL_POINTSX[i], COLL_POINTSY[i])] != CT_LADDERONLY
		&& Screen->ComboS[ComboAt(COLL_POINTSX[i], COLL_POINTSY[i])] == 1111b) return true;
	}
	return false;
}