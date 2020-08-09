void Z3_STUN()
{
	for (int i = Screen->NumNPCs(); i > 0; i--)
	{
		npc Meh = Screen->LoadNPC(i);
		if (Meh->Defense[NPCD_STOMP] != NPCDT_STUNORBLOCK && IsNonBoss(Meh))
		{
			if (Meh->Stun > 0 && Meh->Misc[3] <= 0) Meh->Misc[3] = Meh->Stun;
			else if (Meh->Stun >= Meh->Misc[3] && Meh->Misc[3] > 0 && Meh->Stun > 0)
			{
				Meh->Stun = Max(Meh->Misc[3], 0);
				Meh->Misc[3] = Meh->Stun;
			}
			else if (Meh->Stun > 0) Meh->Misc[3] = Meh->Stun;
			else if (Meh->Misc[3] > 0) Meh->Misc[3]--;
			if (Meh->Misc[3] > 170 && NumLWeaponsOf(LW_BRANG) <= 0 && NumLWeaponsOf(LW_HOOKSHOT) <= 0) Meh->Misc[3] = 169;
			if (Meh->Misc[3] > 0 && Meh->Misc[3] <= 166)
			{
				Meh->Defense[NPCD_HOOKSHOT] = NPCDT_BLOCK;
				Meh->Defense[NPCD_BRANG] = NPCDT_BLOCK;
			}
			else if (Meh->Misc[3] > 0 && Meh->Misc[3] > 166)
			{
				Meh->Defense[NPCD_HOOKSHOT] = NPCDT_IGNORE;
				Meh->Defense[NPCD_BRANG] = NPCDT_IGNORE;
			}
			else
			{
				if (Meh->Misc[5] == 0) Meh->Misc[5] = Meh->Defense[NPCD_HOOKSHOT] + 1;
				if (Meh->Misc[6] == 0) Meh->Misc[6] = Meh->Defense[NPCD_BRANG] + 1;
				Meh->Defense[NPCD_HOOKSHOT] = Meh->Misc[5] - 1;
				Meh->Defense[NPCD_BRANG] = Meh->Misc[6] - 1;
			}
			//if (Meh->Stun > 0) Game->Counter[CR_RUPEES] = Meh->Stun;
		}
		if (Meh->Defense[NPCD_STOMP] == NPCDT_STUNORIGNORE)
		{
			if (Meh->Stun > 0) Meh->Stun--;
		}
		if (Meh->Misc[7] == 0)
		{
			if (Meh->Defense[NPCD_BYRNA] == NPCDT_BLOCK1)
			{
				if (Link->Item[61]) {Meh->Damage *= 8; Meh->WeaponDamage *= 8;}
				else if (Link->Item[18]) {Meh->Damage *= 4; Meh->WeaponDamage *= 4;}
				else if (Link->Item[17]) {Meh->Damage *= 2; Meh->WeaponDamage *= 2;}
			}
			if (Meh->Defense[NPCD_BYRNA] == NPCDT_BLOCK2)
			{
				if (Link->Item[61]) {Meh->Damage *= 2; Meh->WeaponDamage *= 2;}
				else if (Link->Item[18]) {Meh->Damage *= 2; Meh->WeaponDamage *= 2;}
				else if (Link->Item[17]) {Meh->Damage *= 1.5; Meh->WeaponDamage *= 1.5;}
			}
			Meh->Defense[NPCD_BYRNA] = Meh->Defense[NPCD_BEAM];
			Meh->Misc[7] = 1;
		}
	}
}

const int LTM_BRANG = 161;
const int BRANGCOMBO = 10324;

void Z3_BRANG()
{
	if (Link->Misc[0] <= 0)
	{
		if(Link->Item[LTM_BRANG]) Link->Item[LTM_BRANG] = false;
	}
	if ((UsingItem(23) || UsingItem(24) || UsingItem(35)) && Link->Misc[0] <= 0 && powerBracelet[HOLDING_BLOCK] <= 0 && holding_bomb <= 0 && (Link->Action == LA_NONE || Link->Action == LA_WALKING || Link->Action == LA_GOTHURTLAND) && NumLWeaponsOf(LW_BRANG) <= 0)
	{
		if (Link->PressB && Link->Action != LA_GOTHURTLAND)
		{
			Link->Misc[0] = 8;
			Link->Action == LA_NONE;
		}
		NoAction();
	}
	if (Link->Misc[0] > 1)
	{
		Link->Misc[0]--;
		NoAction();
		int brangmodifier = 0;
		if (Link->Item[35]) brangmodifier = 2;
		else if (Link->Item[24]) brangmodifier = 1;
		if(!Link->Item[LTM_BRANG]) Link->Item[LTM_BRANG] = true;
		if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
		if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
		if(Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = false;
		if(Link->Item[LTM_PUSHING]) Link->Item[LTM_HOLDING] = false;
		if (Link->Dir == DIR_UP) Screen->DrawCombo(3, Link->X - 10, Link->Y - 11, BRANGCOMBO + brangmodifier, 1, 1, 7, -1, -1, 0, 0, 0, -1, 1, true, OP_OPAQUE);
		else if (Link->Dir == DIR_DOWN) Screen->DrawCombo(3, Link->X + 10, Link->Y - 10, BRANGCOMBO + brangmodifier, 1, 1, 7, -1, -1, 0, 0, 0, -1, 0, true, OP_OPAQUE);
		else if (Link->Dir == DIR_LEFT) Screen->DrawCombo(3, Link->X + 10, Link->Y - 10, BRANGCOMBO + brangmodifier, 1, 1, 7, -1, -1, 0, 0, 0, -1, 0, true, OP_OPAQUE);
		else if (Link->Dir == DIR_RIGHT) Screen->DrawCombo(3, Link->X - 10, Link->Y - 10, BRANGCOMBO + brangmodifier, 1, 1, 7, -1, -1, 0, 0, 0, -1, 1, true, OP_OPAQUE);
	}
	else if (Link->Misc[0] == 1)
	{
		int sprite = 4;
		int damage = 0;
		if (Link->Item[35]) 
		{
			sprite = 6;
			damage = 4;
		}
		else if (Link->Item[24])
		{
			sprite = 5;
			damage = 2;
		}
		lweapon brango = NextToLink(LW_BRANG, 4, 4);
		brango->UseSprite(sprite);
		brango->Damage = damage;
		Link->Action = LA_ATTACKING;
		Link->Misc[0] = 0;
		if(Link->Item[LTM_BRANG]) Link->Item[LTM_BRANG] = false;
		if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
		if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
		if(Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = false;
		if(Link->Item[LTM_PUSHING]) Link->Item[LTM_HOLDING] = false;
	}
}

bool IsNonBoss(npc enemy)
{
	int BossArray[] = {
	299,
	306,
	259,
	268,
	269,
	307,
	315,
	321,
	308,
	335,
	309,
	364,
	285,
	286,
	291,
	293,
	296,
	297,
	282
	};
	
	for (int i = 0; i < SizeOfArray(BossArray); i++)
	{
		if (enemy->ID == BossArray[i]) return false;
	}
	return true;
}