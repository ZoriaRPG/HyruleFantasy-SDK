ffc script RiverZora{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_4WAY);
		int shotFreq = Ghost_GetAttribute(ghost, 0, 120);
		int combo = ghost->Attributes[10];
		bool inWater = true;
		ghost->CollDetection = false;
		Ghost_Data = GH_INVISIBLE_COMBO;
		if(!RZ_IsWater(Ghost_X+8, Ghost_Y+8)){
			Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
			Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
			Ghost_Y -= 8;
			inWater = false;
			ghost->CollDetection = true;
		}
		int shotCounter;
		int moveAngle;
		while(true){
			if(inWater){
				Ghost_Dir = AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y));
				if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<112){
					if(Ghost_Data==GH_INVISIBLE_COMBO){
						ghost->CollDetection = false;
						Ghost_Data = combo;
						Ghost_Waitframes(this, ghost, 32);
						ghost->CollDetection = true;
						Ghost_Data = combo+4;
						shotCounter = shotFreq;
					}
					if(shotCounter>0)
						shotCounter--;
					else if(Rand(16)==0){
						Ghost_Data = combo+8;
						Ghost_Waitframes(this, ghost, 32);
						eweapon e = FireAimedEWeapon(EW_FIREBALL, Ghost_X, Ghost_Y, 0, 250, ghost->WeaponDamage, -1, -1, 0);
						Ghost_Waitframes(this, ghost, 32);
						Ghost_Data = combo+4;
						shotCounter = shotFreq;
					}
					if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<48){
						int landCombo = RZ_FindLand(AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)));
						if(landCombo>-1){
							if(RZ_CanPlace(ComboX(landCombo), ComboY(landCombo))){
								int dist = Distance(Ghost_X, Ghost_Y, ComboX(landCombo), ComboY(landCombo));
								moveAngle = Angle(Ghost_X, Ghost_Y, ComboX(landCombo), ComboY(landCombo));
								Ghost_Dir = AngleDir4(moveAngle);
								Ghost_Jump = 2;
								Game->PlaySound(SFX_SPLASH);
								Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
								Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
								Ghost_Y -= 8;
								for(int i=0; i<26; i++){
									Ghost_X += VectorX(dist/26, moveAngle);
									Ghost_Y += VectorY(dist/26, moveAngle);
									Ghost_Waitframe(this, ghost);
								}
								Ghost_X = ComboX(landCombo);
								Ghost_Y = ComboY(landCombo)-16;
								inWater = false;
								ghost->CollDetection = true;
							}
						}
					}
				}
				else{
					if(Ghost_Data>combo){
						ghost->CollDetection = false;
						Ghost_Data = combo;
						Ghost_Waitframes(this, ghost, 32);
						Ghost_Data = GH_INVISIBLE_COMBO;
					}
				}
			}
			else{
				int waterCombo = RZ_FindWater(Ghost_Dir);
				if(waterCombo>-1){
					int dist = Distance(Ghost_X, Ghost_Y+16, ComboX(waterCombo), ComboY(waterCombo));
					moveAngle = Angle(Ghost_X, Ghost_Y+16, ComboX(waterCombo), ComboY(waterCombo));
					Ghost_Jump = 2;
					Game->PlaySound(SFX_JUMP);
					for(int i=0; i<26; i++){
						Ghost_X += VectorX(dist/26, moveAngle);
						Ghost_Y += VectorY(dist/26, moveAngle);
						Ghost_Waitframe(this, ghost);
					}
					Ghost_Transform(this, ghost, combo+4, -1, 1, 1);
					Ghost_Y += 8;
					Ghost_X = ComboX(waterCombo);
					Ghost_Y = ComboY(waterCombo);
					inWater = true;
					ghost->CollDetection = true;
					Ghost_Waitframes(this, ghost, 32);
				}
				else{
					if(Abs(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))>5)
						moveAngle = WrapDegrees(moveAngle+Sign(RZ_AngDiff(moveAngle, Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y)))*5);
					else
						moveAngle = Angle(Ghost_X, Ghost_Y+16, Link->X, Link->Y);
					Ghost_Dir = AngleDir4(moveAngle);
					Ghost_MoveAtAngle(moveAngle, ghost->Step/100, 0);
					if(Ghost_GotHit()){
						int stunCount = 48;
						int knockbackCount = 2;
						Ghost_Transform(this, ghost, combo+16, -1, 1, 1);
						Ghost_Y += 8;
						int knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
						while(stunCount>0){
							stunCount--;
							if(Ghost_GotHit()){
								stunCount = 48;
								knockbackCount = 2;
								knockbackAngle = Angle(Link->X, Link->Y, Ghost_X, Ghost_Y);
							}
							if(knockbackCount>0){
								Ghost_MoveAtAngle(knockbackAngle, knockbackCount, 0);
								knockbackCount -= 0.2;
							}
							Ghost_Waitframe(this, ghost);
						}
						Ghost_Transform(this, ghost, combo+12, -1, 1, 2);
						Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
						Ghost_Y -= 8;
					}
				}
			}
			Ghost_Waitframe(this, ghost);
		}
	}
	float RZ_AngDiff(float angle1, float angle2)
	{
		float dif = WrapDegrees(angle2) - WrapDegrees(angle1);
	   
		if(dif >= 180)
			dif -= 360;
		else if(dif <= -180)
			dif += 360;
		   
		return dif;
	}
	bool RZ_IsWater(int x, int y){
		int ct = Screen->ComboT[ComboAt(x, y)];
		if(ct==CT_WATER)
			return true;
		if(ct==CT_DIVEWARP||ct==CT_DIVEWARPB||ct==CT_DIVEWARPC||ct==CT_DIVEWARPD)
			return true;
		if(ct==CT_SWIMWARP||ct==CT_SWIMWARPB||ct==CT_SWIMWARPC||ct==CT_SWIMWARPD)
			return true;
		return false;
	}
	bool RZ_CanPlace(int X, int Y){
		for(int x=0; x<=15; x=Min(x+8, 15)){
			for(int y=0; y<=15; y=Min(y+8, 15)){
				if(Screen->isSolid(X+x, Y+y))
					return false;
				if(y==15)
					break;
			}
			if(x==15)
				break;
		}
		return true;
	}
	int RZ_FindLand(int dir){
		int x; int y;
		if(dir==DIR_UP){
			x = Ghost_X+8;
			y = Ghost_Y-1;
		}
		else if(dir==DIR_DOWN){
			x = Ghost_X+8;
			y = Ghost_Y+16;
		}
		else if(dir==DIR_LEFT){
			x = Ghost_X-1;
			y = Ghost_Y+8;
		}
		else if(dir==DIR_RIGHT){
			x = Ghost_X+16;
			y = Ghost_Y+8;
		}	
		if(!RZ_IsWater(x, y))
			return ComboAt(x, y);
		for(int i=0; i<=15; i=Min(i+15, 15)){
			if(dir==DIR_UP){
				x = Ghost_X+i;
				y = Ghost_Y-1;
			}
			else if(dir==DIR_DOWN){
				x = Ghost_X+i;
				y = Ghost_Y+16;
			}
			else if(dir==DIR_LEFT){
				x = Ghost_X-1;
				y = Ghost_Y+i;
			}
			else if(dir==DIR_RIGHT){
				x = Ghost_X+16;
				y = Ghost_Y+i;
			}	
			if(!RZ_IsWater(x, y))
				return ComboAt(x, y);
			if(i==15)
				break;
		}
		return -1;
	}
	int RZ_FindWater(int dir){
		int x; int y;
		if(dir==DIR_UP){
			x = Ghost_X+8;
			y = Ghost_Y-1;
		}
		else if(dir==DIR_DOWN){
			x = Ghost_X+8;
			y = Ghost_Y+16;
		}
		else if(dir==DIR_LEFT){
			x = Ghost_X-1;
			y = Ghost_Y+8;
		}
		else if(dir==DIR_RIGHT){
			x = Ghost_X+16;
			y = Ghost_Y+8;
		}	
		y += 16;
		if(RZ_IsWater(x, y))
			return ComboAt(x, y);
		for(int i=0; i<=15; i=Min(i+15, 15)){
			if(dir==DIR_UP){
				x = Ghost_X+i;
				y = Ghost_Y-1;
			}
			else if(dir==DIR_DOWN){
				x = Ghost_X+i;
				y = Ghost_Y+16;
			}
			else if(dir==DIR_LEFT){
				x = Ghost_X-1;
				y = Ghost_Y+i;
			}
			else if(dir==DIR_RIGHT){
				x = Ghost_X+16;
				y = Ghost_Y+i;
			}	
			y += 16;
			if(RZ_IsWater(x, y))
				return ComboAt(x, y);
			if(i==15)
				break;
		}
		return -1;
	}
}