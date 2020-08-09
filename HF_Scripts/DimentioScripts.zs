//import "std.zh"
//import "string.zh"
//import "ghost.zh"

global script slot_2{
	void run(){
		InitializeGhostZHData();
		while(true){
			UpdateGhostZHData();
			CleanUpGhostFFCs(); // Only needed if __GH_USE_DRAWCOMBO is 0
			Waitdraw();
			AutoGhost();
            DrawGhostFFCs();
			Waitframe();
		}
	}
}

//If you're not using laser.zh, you'll need this function
void DamageLinkModified(int Damage){
	eweapon e = FireEWeapon(EW_SCRIPT10, Link->X+InFrontX(Link->Dir, 12), Link->Y+InFrontY(Link->Dir, 12), 0, 0, Damage, -1, -1, EWF_UNBLOCKABLE);
	e->Dir = Link->Dir;
	e->DrawYOffset = -1000;
	e->Misc[0] = 10;
	SetEWeaponLifespan(e, EWL_TIMER, 1);
	SetEWeaponDeathEffect(e, EWD_VANISH, 0);
}

//Note for Dimentio: This is edited from an enemy in YuuRand.
//While I took out all the YuuRand-specific stuff (such as check if Link is submerged), I left in the fake hitboxes to allow Link to damage it.
//I know you said he'd be invincible, but if you want to change that, there's a framework in place to do that.
//You'll have to manually assign what weapons should and shouldn't be removed though.
//All that stuff is commented out, but clearly labeled in case you choose to enable collision.

//Anyways, for setup.
//As with all ghosted enemies, Misc. Attribute 12 is the script number. 
//11 is the combo for the head.
//10 is the combo for the body.
//9 is the combo for the tail.
//8 is how many segments it should have.
//If 7 is set to 0, he'll use the same combo for all directions. Otherwise, his combos will have directionality.
//If you choose to give them directionality, lay out 4 combos in your combo page in a row: Up, down, left, right. The up facing combo is the value you should use for the above attributes.
//This needs to be done with the head, body, and tail combos.
//6 is which direction they turn when hitting a wall. 0 = clockwise, 1 = counterclockwise.
//5 is the imprecision. If you make that number bigger, they'll be able to clip through corners and whatnot. Should probably be set to 0 unless you notice them getting caught on little bits of level geometry.

ffc script Winder{
	void run(int enemyID){
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		int originaldata = ghost->Attributes[10];
		Ghost_Data = 1;
		Ghost_Waitframes(this, ghost, true, true,8);
		Ghost_Data = originaldata;
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		int counter = -1;
		int segmentdata = ghost->Attributes[9];
		int taildata = ghost->Attributes[8];
		int spacing = Ceiling(100/ghost->Step * (16-8)); //AAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaaah
		int NumSegments = ghost->Attributes[7];
		int OriginalHP = ghost->HP;
		Ghost_HP = OriginalHP*(NumSegments+1);
		int MultiDirectional = ghost->Attributes[6];
		if(MultiDirectional != 0)
			Ghost_SetFlag(GHF_4WAY); 
		int RotationDirection = ghost->Attributes[5];
		int Imprecision = ghost->Attributes[4];
		
		ghost->CollDetection = false; //Uncomment this if you want it to take damage.
		
		int SkullX[128];
		int SkullY[128];
		int SkullDir[128];
		for(int i = 0; i<128; i++){
			SkullX[i] = Ghost_X;
			SkullY[i] = Ghost_Y;
			SkullDir[i] = Ghost_Dir;
		}
		
		
		int Misc[9] = {NumSegments, spacing, MultiDirectional, 0, 0, OriginalHP, taildata, segmentdata}; //Number of segments, spacing of them, the flag for multi directionality, two blank variables from when this script was very different, original HP, combo of the tail, combo of the segments
		int vars[5] = {SkullX, SkullY, SkullDir, 0, Misc};
		
		Ghost_Dir = Rand(0,3); //Choose a direction to start in
		
		
		while(true){
			if(Ghost_CanMove(Ghost_Dir, ghost->Step / 100, Imprecision)) //Can move
				Ghost_Move(Ghost_Dir, ghost->Step / 100, Imprecision); //So move
			else{ //Hit a wall
				if(RotationDirection == 0){ //Should turn clockwise
					if(Ghost_Dir == 0) //Moving up
						Ghost_Dir = 3; //So move right
					else if(Ghost_Dir == 3) //Moving right
						Ghost_Dir = 1; //So move down
					else if(Ghost_Dir == 1) //Moving down
						Ghost_Dir = 2; //So move left
					else if (Ghost_Dir == 2) //Moving left
						Ghost_Dir = 0; //So move up
				}
				if(RotationDirection == 1){ //Should turn counterclockwise
					if(Ghost_Dir == 0) //Moving up
						Ghost_Dir = 2; //So move left
					else if(Ghost_Dir == 3) //Moving right
						Ghost_Dir = 0; //So move up
					else if(Ghost_Dir == 1) //Moving down
						Ghost_Dir = 3; //So move right
					else if (Ghost_Dir == 2) //Moving left
						Ghost_Dir = 1; //So move down
				}
			}
			// counter = Ghost_ConstantWalk4(counter, ghost->Step, ghost->Rate, ghost->Homing, ghost->Hunger);
			Bone_Waitframe(this, ghost, vars, 1);
		}
	}
	void Bone_Waitframe(ffc this, npc ghost, int vars, int timer){
		int SkullX = vars[0];
		int SkullY = vars[1];
		int SkullDir = vars[2];
		int Misc = vars[4];
		int Spacing = Misc[1];
		int MultiDirectional = Misc[2];
		int taildata = Misc[6];
		int segmentdata = Misc[7];
		
		//First, shift all array values
		for(int i = 128; i>0; i--){
			SkullX[i] = SkullX[i-1];
			SkullY[i] = SkullY[i-1];
			SkullDir[i] = SkullDir[i-1];
		}
		//Then, assign current values
		SkullX[0] = Ghost_X;
		SkullY[0] = Ghost_Y;
		SkullDir[0] = Ghost_Dir;
		//Now let's check some weapon collisions and do some drawing
		//First, see if it has too many segments
		//Note: This bit can be uncommented if you allow the enemy to take damage.
		//It will cause the tail segments to die one by one, as in Lanmolas.
		// if(Ghost_HP <= (Misc[0])*Misc[5]){ //If HP is less than segments-1 * segment HP
			// int spot = Spacing - Misc[0];
			// Misc[0]--; //Get rid of a segment.
			// Game->PlaySound(10); //Kill noise
			// lweapon l = CreateLWeaponAt(LW_SPARKLE, SkullX[spot], SkullY[spot]);
			// l->UseSprite(23);
			// l->DeadState = 12;

		// }
		//Now let's draw the segments and give them a Link hitbox
		for(int j=Misc[0]; j>0; j--){
			if(j==Misc[0]){ //Tail
				if(MultiDirectional != 0)
					Screen->DrawCombo(2, SkullX[Spacing*j], SkullY[Spacing*j]-2, taildata + SkullDir[Spacing*j], 1, 1, ghost->CSet, -1, -1, 0, 0, 0, 0, 0, true, 128);
				else
					Screen->DrawCombo(2, SkullX[Spacing*j], SkullY[Spacing*j]-2, taildata, 1, 1, ghost->CSet, -1, -1, 0, 0, 0, 0, 0, true, 128);
			}
			else{ //Body
				if(MultiDirectional != 0)
					Screen->DrawCombo(2, SkullX[Spacing*j], SkullY[Spacing*j]-2, segmentdata + SkullDir[Spacing*j], 1, 1, ghost->CSet, -1, -1, 0, 0, 0, 0, 0, true, 128);
				else
					Screen->DrawCombo(2, SkullX[Spacing*j], SkullY[Spacing*j]-2, segmentdata, 1, 1, ghost->CSet, -1, -1, 0, 0, 0, 0, 0, true, 128);
			}
			//And Damage
			if(RectCollision(SkullX[Spacing]+2, SkullY[Spacing*j]+2, SkullX[Spacing*j]+14, SkullY[Spacing*j]+14, Link->X+2, Link->Y+2, Link->X+14, Link->Y+14) && __Ghost_FlashCounter == 0){
				DamageLinkModified(ghost->Damage);
			}
		}
		
		//Note for Dimentio: This bit shouldn't be necessary, as ghost should clear the hitboxes created.
		//However, I was noticing phantom hitboxes on my test file.
		//It didn't happen in YuuRand, but... eh. Not sure what's up, but this doesn't hurt anything.
		//If it interferes with anything you're doing, you can probably comment it out, as it's just a failsafe
		for(int i = Screen->NumEWeapons(); i >0; i--){
			eweapon e = Screen->LoadEWeapon(i);
			if(e->ID == EW_SCRIPT10 && e->DrawYOffset == -1000){
				if(e->Misc[0] >0)
					e->Misc[0] --;
				else
					Remove(e);
			}
		}
		
		//Finally, a weapon hitbox
		//Not for Dimention: Uncomment this to allow for it taking damage. The bit at the bottom that removes the weapon will have to be modified so it doesn't remove swords or whatnot.
		// for(int i = Screen->NumLWeapons(); i >0; i--){
			// lweapon l = Screen->LoadLWeapon(i);
			// for(int j=Misc[0]; j>0; j--){
				// if(RectCollision(SkullX[Spacing]+2, SkullY[Spacing*j]+2, SkullX[Spacing*j]+14, SkullY[Spacing*j]+14, l->X+2, l->Y+2, l->X+14, l->Y+14) && __Ghost_FlashCounter == 0){ //Collides while he's not flashing
					// Ghost_HP -= l->Damage;
					// Ghost_StartFlashing();
					// Game->PlaySound(72);
					// if(l->ID != LW_ARROW && l->ID != LW_BOMBBLAST && l->OriginalTile !=2326 && l->ID != LW_SCRIPT1){
						// Remove(l);
					// }
				// }
			// }
		// }
		Ghost_Waitframes(this, ghost, true, true, timer);
	}
}

//Since this enemy doesn't move, you'll wanna place it using enemy flags.
//As with all ghosted enemies, Misc. Attribute 12 is the script number. 
//11 is the combo for it. Set to 0 for it to be invisible (using whatever combo you have placed below it).
//10 is the Weapon type. Use the list in std_constants.zh.
//9 is the sprite of the weapon.
//8 is the SFX to play when it fires.
//7 is the speed of the projectile
//6 is whether or not the projectile should be rotated.
//If 5 is set to 0, the enemy will not give or take damage on contact (LttP style statues).
//If it set to anything else, it will deal contact damage and be damged by weapons (IoR style statues).

ffc script YomoMedusa{
	void run(int enemyID){
		npc ghost = Ghost_InitAutoGhost(this, enemyID);
		int originaldata = ghost->Attributes[10];
		int ProjectileType = ghost->Attributes[9]; //The type of weapon it fires.
		int ProjectileSprite = ghost->Attributes[8]; //The sprite the weapon uses.
		int ProjectileSFX = ghost->Attributes[7]; //The SFX it uses.
		int ProjectileStep = ghost->Attributes[6];  //The speed it uses
		int ProjectileRotation = ghost->Attributes[5];
		int DamageFlag = ghost->Attributes[4]; //Whether the statue should deal contact damage.
		if(DamageFlag == 0)
			ghost->CollDetection = false; //It's just a statue, so it shouldn't hit Link.
		Ghost_Transform(this, ghost, originaldata, ghost->CSet, 1, 1);
		while(true){
			for(int i = Screen->NumLWeapons(); i>0; i--){  //Look at all lweapons
				lweapon l = Screen->LoadLWeapon(i);
				if(l->ID == LW_SWORD || l->ID == LW_SCRIPT3){ //If it's a sword
					//Fire something
					if(ProjectileRotation == 1)
						FireNonAngularEWeapon(ProjectileType, Ghost_X, Ghost_Y, AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)), ProjectileStep, ghost->WeaponDamage, ProjectileSprite, ProjectileSFX, EWF_ROTATE);
					else
						FireNonAngularEWeapon(ProjectileType, Ghost_X, Ghost_Y, AngleDir4(Angle(Ghost_X, Ghost_Y, Link->X, Link->Y)), ProjectileStep, ghost->WeaponDamage, ProjectileSprite, ProjectileSFX, 0);
					while(l->isValid()) //Now we wanna wait til that sword goes away.
						Ghost_Waitframe(this, ghost, true, true);
				}
			}
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}

//This one's edited from a Moosh script for FiC/FA's Wall Crawlers
//I'd noticed the logic was off for a while and basically designed around that, only putting them in situations they couldn't get stuck in
//This script request gave me the excuse I needed to just go in and fix their logic

//Anyways, setup
//As with all ghosted enemies, Misc. Attribute 12 is the script number. 
//11 is the combo for it.
//Attibute 1 is wether it moves clockwise or counterclockwise
//2 is whether it should move off screen.
//0=no, 1=yes, 2=yes, but die if offscreen
//If you don't want it to take damage, set all defense flags to ignore
ffc script WallCrawl{
	bool WC_OnWall(int ClingDir, int CCW){
		if(CCW==0){
			if(ClingDir==DIR_UP){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X-16, Ghost_Y, ClingDir, 1, true))
					return false;
				else
					return true;
			}
			else if(ClingDir==DIR_DOWN){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X+16, Ghost_Y, ClingDir, 1, true))
					return false;
				else
					return true;
			}
			else if(ClingDir==DIR_LEFT){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X, Ghost_Y+16, ClingDir, 1, true))
					return false;
				else
					return true;
			}
			else if(ClingDir==DIR_RIGHT){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X, Ghost_Y-16, ClingDir, 1, true))
					return false;
				else
					return true;
			}
		}
		else{
			if(ClingDir==DIR_UP){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X+16, Ghost_Y, ClingDir, 1, true))
					return false;
				else
					return true;
			}
			else if(ClingDir==DIR_DOWN){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X-16, Ghost_Y, ClingDir, 1, true))
					return false;
				else
					return true;
			}
			else if(ClingDir==DIR_LEFT){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X, Ghost_Y-16, ClingDir, 1, true))
					return false;
				else
					return true;
			}
			else if(ClingDir==DIR_RIGHT){
				if(CanWalk(Ghost_X, Ghost_Y, ClingDir, 1, true)&&CanWalk(Ghost_X, Ghost_Y+16, ClingDir, 1, true))
					return false;
				else
					return true;
			}
		}
	}
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		Ghost_SetFlag(GHF_STUN);
		Ghost_SetFlag(GHF_CLOCK);
		// Ghost_SetFlag(GHF_4WAY);
		int CCW = ghost->Attributes[0]; //Whether or not the enemy goes counterclockwise
		if(ghost->Attributes[1]>=1) //0 = Don't move offscreen, 1 = Move offscreen, 2 = Move offscreen and die if offscreen
			Ghost_SetFlag(GHF_MOVE_OFFSCREEN);
		int Combo = ghost->Attributes[10];
		int ClingDir = -1;
		int FlashCounter;
		float FakeJump;
		for(int i=0; i<4; i++){
			if(!Ghost_CanMove(OppositeDir(i), 1, 0)){
				ClingDir = OppositeDir(i);
				break;
			}
		}
		while(true){
			if(Ghost_GotHit())
				FlashCounter = 32;
			else if(FlashCounter>0)
				FlashCounter--;
			if(ClingDir==-1){
				FakeJump = Min(FakeJump+GH_GRAVITY, GH_TERMINAL_VELOCITY);
				Ghost_MoveXY(0, FakeJump, 0);
				for(int i=0; i<4; i++){
					if(!CanWalk(Ghost_X, Ghost_Y, OppositeDir(i), 1, true)){
						ClingDir = OppositeDir(i);
						break;
					}
				}
			}
			else if(FlashCounter==0){
				float Step = ghost->Step/100;
				for(int i=0; i<Step; i++){
					if(CCW==0){
						if(!WC_OnWall(ClingDir, CCW)){
							ClingDir = -1;
							FakeJump = 0;
						}
						if(ClingDir==DIR_UP){
							Ghost_Dir = DIR_DOWN;
							Ghost_Move(DIR_LEFT, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_LEFT, 1, 0))
								if(Ghost_CanMove(DIR_UP, 1, 0)){
									ClingDir = DIR_RIGHT;
									Ghost_Move(DIR_UP, 1, 0);
								}
								else
									ClingDir = DIR_LEFT;
							else if(Ghost_CanMove(DIR_UP, 1, 0)){
								ClingDir = DIR_RIGHT;
								Ghost_Move(DIR_UP, 1, 0);
							}
						}
						else if(ClingDir==DIR_DOWN){
							Ghost_Dir = DIR_UP;
							Ghost_Move(DIR_RIGHT, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_RIGHT, 1, 0)){
								 if(Ghost_CanMove(DIR_DOWN, 1, 0)){
									ClingDir = DIR_LEFT;
									Ghost_Move(DIR_DOWN, 1, 0);
								 }
								 else
									ClingDir = DIR_RIGHT;
							}
							else if(Ghost_CanMove(DIR_DOWN, 1, 0)){
								ClingDir = DIR_LEFT;
								Ghost_Move(DIR_DOWN, 1, 0);
							}
						}
						else if(ClingDir==DIR_LEFT){
							Ghost_Dir = DIR_RIGHT;
							Ghost_Move(DIR_DOWN, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_DOWN, 1, 0))
								if(Ghost_CanMove(DIR_LEFT, 1, 0)){
									ClingDir = DIR_UP;
									Ghost_Move(DIR_LEFT, 1, 0);
								}
								else
									ClingDir = DIR_DOWN;
							else if(Ghost_CanMove(DIR_LEFT, 1, 0)){
								ClingDir = DIR_UP;
								Ghost_Move(DIR_LEFT, 1, 0);
							}
						}
						else if(ClingDir==DIR_RIGHT){
							Ghost_Dir = DIR_LEFT;
							Ghost_Move(DIR_UP, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_UP, 1, 0))
								if(Ghost_CanMove(DIR_RIGHT, 1, 0)){
									ClingDir = DIR_DOWN;
									Ghost_Move(DIR_RIGHT, 1, 0);
								}
								else
									ClingDir = DIR_UP;
							else if(Ghost_CanMove(DIR_RIGHT, 1, 0)){
								ClingDir = DIR_DOWN;
								Ghost_Move(DIR_RIGHT, 1, 0);
							}
						}
					}
					else{
						if(!WC_OnWall(ClingDir, CCW)){
							ClingDir = -1;
							FakeJump = 0;
						}
						if(ClingDir==DIR_UP){
							Ghost_Dir = DIR_DOWN;
							Ghost_Move(DIR_RIGHT, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_RIGHT, 1, 0))
								if(Ghost_CanMove(DIR_UP, 1, 0)){
									ClingDir = DIR_LEFT;
									Ghost_Move(DIR_UP, 1, 0);
								}
								else
									ClingDir = DIR_RIGHT;
							else if(Ghost_CanMove(DIR_UP, 1, 0)){
								ClingDir = DIR_LEFT;
								Ghost_Move(DIR_UP, 1, 0);
							}
						}
						else if(ClingDir==DIR_DOWN){
							Ghost_Dir = DIR_UP;
							Ghost_Move(DIR_LEFT, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_LEFT, 1, 0))
								if(Ghost_CanMove(DIR_DOWN, 1, 0)){
									ClingDir = DIR_RIGHT;
									Ghost_Move(DIR_DOWN, 1, 0);
								}
								else
									ClingDir = DIR_LEFT;
							else if(Ghost_CanMove(DIR_DOWN, 1, 0)){
								ClingDir = DIR_RIGHT;
								Ghost_Move(DIR_DOWN, 1, 0);
							}
						}
						else if(ClingDir==DIR_LEFT){
							Ghost_Dir = DIR_RIGHT;
							Ghost_Move(DIR_UP, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_UP, 1, 0))
								if(Ghost_CanMove(DIR_LEFT, 1, 0)){
									ClingDir = DIR_DOWN;
									Ghost_Move(DIR_LEFT, 1, 0);
								}
								else
									ClingDir = DIR_UP;
							else if(Ghost_CanMove(DIR_LEFT, 1, 0)){
								ClingDir = DIR_DOWN;
								Ghost_Move(DIR_LEFT, 1, 0);
							}
						}
						else if(ClingDir==DIR_RIGHT){
							Ghost_Dir = DIR_LEFT;
							Ghost_Move(DIR_DOWN, Min(1, Step), 0);
							if(!Ghost_CanMove(DIR_DOWN, 1, 0))
								if(Ghost_CanMove(DIR_RIGHT, 1, 0)){
									ClingDir = DIR_UP;
									Ghost_Move(DIR_RIGHT, 1, 0);
								}
								else
									ClingDir = DIR_DOWN;
							else if(Ghost_CanMove(DIR_RIGHT, 1, 0)){
								ClingDir = DIR_UP;
								Ghost_Move(DIR_RIGHT, 1, 0);
							}
						}
					}
					Step--;
				}
			}
			if(ghost->Attributes[1]==2&&Ghost_X<=-15||Ghost_X>=255||Ghost_Y<=-15||Ghost_Y>=175){
				Ghost_HP = -1000;
			}
			Ghost_Waitframe(this, ghost);
		}
	}
}