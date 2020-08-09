ffc script Pride{
	void run(int enemyid){
		int tics=0;
		npc n = Ghost_InitAutoGhost(this, enemyid);
		int Combo = n->Attributes[10];
		Ghost_Transform(this, n, Combo, -1, 2, 2);
		int destx;
		int desty;
		int angle;
		while(true){
			destx=Link->X-8+VectorX(60, angle);
			desty=Link->Y-8+VectorY(60, angle);
			angle = (angle+1)%360;
			if(this->X+8>Link->X&&Ghost_Data!=888)Ghost_Data=Combo;
			if(this->X+8<Link->X&&Ghost_Data!=889)Ghost_Data=Combo+1;
			Ghost_MoveAtAngle(Angle(this->X, this->Y, destx, desty), 0.5, 0);
			if(tics==240){
				for(int i=0; i<=5; i++){
					eweapon e=FireAimedEWeapon(EW_FIREBALL, this->X+8, this->Y, DegtoRad(-30+i*15), 200, n->WeaponDamage, -1, SFX_FIREBALL, EWF_UNBLOCKABLE);
					SetEWeaponLifespan(e, EWL_TIMER, 45);
					SetEWeaponDeathEffect(e, EWD_AIM_AT_LINK, 40+i*20);
				}
			}
			if(tics==360)tics=0;
			if(tics<360)tics++;
			Boss_Waitframe(this, n);
		}
		for(int i=0; i<=Screen->NumEWeapons(); i++){
			eweapon e=Screen->LoadEWeapon(i);
			e->X=-900;
		}
	}
}