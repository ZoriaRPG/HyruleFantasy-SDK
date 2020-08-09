const int SPR_KYAMERON_RISING = 122;
const int SPR_KYAMERON_BURST = 123;
const int SPR_KYAMERON_SPARKLE = 124;

const int KYAMERON_DELAY_FRAMES = 40;
const int KYAMERON_RIPPLE_FRAMES = 130;

ffc script Kyameron{
	void run(int enemyid){
		npc ghost = Ghost_InitAutoGhost(this, enemyid);
		int maxBounce = Ghost_GetAttribute(ghost, 0, 3);
		int combo = ghost->Attributes[10];
		Ghost_SetFlag(GHF_WATER_ONLY);
		int startX = Ghost_X;
		int startY = Ghost_Y;
		Ghost_SetAllDefenses(ghost, NPCDT_IGNORE);
		ghost->CollDetection = false;
		while(true){
			Ghost_Data = combo;
			Ghost_Waitframes(this, ghost, KYAMERON_RIPPLE_FRAMES);
			
			Ghost_Data = GH_INVISIBLE_COMBO;
			eweapon spawn = CreateEWeaponAt(EW_SCRIPT10, Ghost_X, Ghost_Y-32);
			spawn->UseSprite(SPR_KYAMERON_RISING);
			spawn->CSet = Ghost_CSet;
			spawn->Extend = 3;
			spawn->TileWidth = 1;
			spawn->TileHeight = 3;
			spawn->DeadState = spawn->NumFrames*spawn->ASpeed;
			spawn->CollDetection = false;
			while(spawn->isValid()){
				Ghost_Waitframe(this, ghost);
			}
			
			Ghost_Y -= 32;
			Ghost_Data = combo+1;
			
			int vX = ghost->Step/100;
			int vY = ghost->Step/100;
			if(Ghost_X>Link->X)
				vX = -vX;
			if(Ghost_Y>Link->Y)
				vY = -vY;
			
			int bounces = maxBounce;
			int aFrames;
			ghost->CollDetection = true;
			while(bounces>0){
				if( (vX<0&&!Ghost_CanMove(DIR_LEFT, 1, 0)) || (vX>0&&!Ghost_CanMove(DIR_RIGHT, 1, 0)) ){
					vX = -vX;
					bounces--;
				}
				if( (vY<0&&!Ghost_CanMove(DIR_UP, 1, 0)) || (vY>0&&!Ghost_CanMove(DIR_DOWN, 1, 0)) ){
					vY = -vY;
					bounces--;
				}
				Ghost_MoveXY(vX, vY, 0);
				if((Link->Action==LA_GOTHURTLAND||Link->Action==LA_GOTHURTWATER)&&LinkCollision(ghost))
					break;
				lweapon sword = LoadLWeaponOf(LW_SCRIPT3);
				if(sword->isValid()){
					if(Collision(sword, ghost))
						break;
				}
				aFrames = (aFrames+1)%360;
				if(aFrames%8==0){
					eweapon sparkle = CreateEWeaponAt(EW_SCRIPT10, Ghost_X+Rand(-8, 8), Ghost_Y+Rand(-8, 8));
					sparkle->UseSprite(SPR_KYAMERON_SPARKLE);
					sparkle->DeadState = sparkle->NumFrames*sparkle->ASpeed;
					sparkle->CollDetection = false;
				}
				Ghost_Waitframe(this, ghost);
			}
			ghost->CollDetection = false;
			
			Game->PlaySound(SFX_SPLASH);
			Ghost_Data = GH_INVISIBLE_COMBO;
			eweapon poof = CreateEWeaponAt(EW_SCRIPT10, Ghost_X-8, Ghost_Y-8);
			poof->UseSprite(SPR_KYAMERON_BURST);
			poof->CSet = Ghost_CSet;
			poof->Extend = 3;
			poof->TileWidth = 2;
			poof->TileHeight = 2;
			poof->DeadState = poof->NumFrames*poof->ASpeed;
			poof->CollDetection = false;
			
			Ghost_X = startX;
			Ghost_Y = startY;
			
			Ghost_Waitframes(this, ghost, KYAMERON_DELAY_FRAMES);
		}
	}
}