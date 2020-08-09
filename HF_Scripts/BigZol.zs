//const int WPN_SLIMEBALL = 150;

ffc script bigzol{
void run(int enemyID){
npc ghost = Ghost_InitAutoGhost(this,enemyID);
Ghost_Data = 10000;
		Ghost_CSet = 9;
		Ghost_TileWidth = 2;
		Ghost_TileHeight = 2;
		Ghost_SetFlag(GHF_SET_OVERLAY);
int quit_countdown = 10;
bool spawnkids = false;
int jumpcounter = Rand(10) + 30;
int zol_jump = 2 + Rand(3);
int jumpdir = Rand(7);
while(true){
jumpcounter--;
if (jumpcounter <=0){
if(Ghost_Z == 0){
Ghost_Jump = zol_jump;


if(Rand(5) > 3){
for(int i = 0; i <= 3; i++){
if(Rand(6) > 2){
//eweapon slimeball = FireNonAngularEWeapon(EW_FIREBALL,Ghost_X + 12, Ghost_Y + 20,i,100,4,WPN_SLIMEBALL,0,0);
//SetEWeaponMovement(slimeball,EWM_THROW,3,EWMF_DIE);
//SetEWeaponDeathEffect(slimeball, EWD_SPAWN_NPC, 88);
}
}
}

if(Rand(4) > 2){
//CreateNPCAt(89, Ghost_X + 12, Ghost_Y + 20);
}




}
jumpdir = Rand(7);
jumpcounter = Rand(10)+ 30;
zol_jump = 2 + Rand(3);
}
if(Ghost_Y < 48){jumpdir=DIR_DOWN;}
if(Ghost_Y > 144){jumpdir=DIR_UP;}
if(Ghost_X < 32){jumpdir=DIR_RIGHT;}
if(Ghost_X > 224){jumpdir=DIR_LEFT;}
if(Ghost_Z > 0){Ghost_Move(jumpdir,1,2);}
bool stillAlive=Ghost_Waitframe(this, ghost, false, false);
if(!stillAlive)
{
if(!spawnkids){
CreateNPCAt(89, Ghost_X + 12, Ghost_Y + 20);
CreateNPCAt(89, Ghost_X + 12, Ghost_Y + 20);
spawnkids = true;
}
Ghost_Data = GH_INVISIBLE_COMBO;
Ghost_X = -2000;
quit_countdown--;
if(quit_countdown<=0){Quit();}
}
}
}
}