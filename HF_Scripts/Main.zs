#include "std.zh"

#include "ffcscript.zh"
#include "stdCombos.zh"
#include "ghost_HF.zh"
#include "stdWeapons_HF.zh"
#include "Tango_HF.zh"
#include "laser.zh"
#include "stdExtra.zh" 
#include "LinkMovement.zh"
#include "scrollingDraws.zh" 
#include "DrawLayerFix.zh" 

#include "SolidFFC.zs"
#include "LttP_Buttons.zs"
//#include "theRandomHeader.zh"
#include "ALTTP_Barriers.zs"
#include "NPC_Shenannighans.zs"
#include "Better_Aquamentus.zs"
#include "Popo.zs"
#include "Hardhat_Beetle.zs"
#include "BigZol.zs"
#include "Ceiling_Master.zs"
#include "Bari.zs"
#include "Mothula.zs"
#include "compass.zs"
#include "Eyegores.zs"
#include "LTTP_Goriya.zs"
#include "antifairy.zs"
#include "LTTP_Beamos.zs"
//#include "HoleLava.zs"
#include "MooshPit.zs"
#include "Smarter_Boss_Music.zs"
#include "ALTTP_Bumpers.zs"
#include "GBZ_Chaser.zs"
#include "BigBeamos.zs"
#include "Gleeok.zs"
#include "FireRobe.zs"
#include "FireWalkRobe.zs"
#include "Zol.zs"
#include "Gleeok2.zs"
#include "IceRobe.zs"
#include "IceWalkRobe.zs"
#include "Gleeok3.zs"
#include "Gohma.zs"
#include "Z3Auto.zs"
#include "Gohma2.zs"
#include "shutterControl.zs"
#include "Mooshdorm2.zs"
#include "intro.zs"
#include "BurningMoosh.zs"
#include "Mace.zs"
#include "Soldier.zs"
#include "Medidorm.zs"
#include "Megadorm.zs"
#include "LightningReturnsFinalFantasyXIIIMusicExtendedDeluxeEdition&KnucklesFeaturingDanteFromTheDevilMayCrySeries.zs"
#include "DarkWizard.zs"
#include "MiniMoldorm.zs"
#include "Ice.zs"
#include "BombShake.zs"
#include "PegasusBoots.zs"
#include "PotBreak.zs"
#include "Bottles.zs"
#include "Z3Stun.zs"
#include "Stalfos.zs"
#include "Lanmola.zs"
#include "Hoarder.zs"
#include "Bombite.zs"
#include "Vire.zs"
#include "SomariaBlock.zs"
#include "Bracelet.zs"
#include "Bombs.zs"
#include "Pushing.zs"
#include "DarkWizard2.zs"
#include "FireAttack.zs"
#include "LinkSpeed.zs"
#include "IceBlock.zs"
#include "ArmosKnights.zs"
#include "Helmasaur.zs"
#include "Layer3.zs"
#include "Hokkubokku.zs"
#include "Wizzrobe.zs"
#include "PhaseRobe.zs"
#include "Fairy.zs"
#include "firerod.zs"
#include "ice_rod.zs"
#include "SomariaRod.zs"
#include "Nayru.zs"
#include "LttPOutline.zh"
#include "IntroBackstory.zs"
#include "RiverZora.zs"
#include "Kyameron.zs"
#include "Sidequests.zs"
#include "ZoraKnight.zs"
#include "Miniboss.zs"
#include "DimentioScripts.zs"
#include "VacuumMouth.zs"
#include "Circle_FFCs.zs"
#include "Armos.zs"
#include "Kodongo.zs"
#include "ElementalCollision.zs"
#include "BossBar.zs"
#include "Hatrobe.zs"
#include "Sluggy.zs"
#include "Minimentus.zs"
#include "DarkRoomLvl8.zs"
#include "LttP_Doors.zs"
#include "FireBar.zs"
#include "SpinAttack.zs"
#include "Z3Sword.zs"
#include "Minecart.zs"
#include "LTTP_Beamos2.zs"
#include "KhrackStare.zs"
#include "GreedWallet.zs"
#include "Lever.zs"

//----GAMEPLAY_ELEMENTS----

//ALTTP BARRIERS
const int SCRIPT_BARRIERS = 3; // Must refer to "Barrier"'s ffc script slot in the quest

//ALTTP BEAMOS
const int LAYER_BEAMOS1 = 2; //Beamos use this layer to draw the bottom half
const int LAYER_BEAMOS2 = 3; //Beamos use this layer to draw the top half and eye
const int BEAMOS_IMPRECISION = 6; //How close the beamos must be aiming at Link to shoot
const int BEAMOS_FLASHFRAMES = 10; //How many frames the beamos flashes for before firing
const int BEAMOS_LASER_SPEED = 6; //How fast the laser shoots out
const int BEAMOS_LASER_LENGTH = 80; //How long the laser is
const int BEAMOS_LASER_MINDIST = 16; //How far the beamos can see/shoot through solid objects
const int COLOR_BEAMOS_LASER1 = 0x84; //The color of the inner laser
const int COLOR_BEAMOS_LASER2 = 0x85; //The color of the outer laser
const int CMB_BEAMOS_LASER_ENDPOINT = 10046; //The combo used for the ends of the laser
const int CS_BEAMOS_LASER_ENDPOINT = 8; //The cset used for the ends of the laser
const int SFX_BEAMOS_SIGHT = 40; //The sound that plays when the beamos sees Link
const int SFX_BEAMOS_LASER = 74; //The sound that plays when the beamos fires its laser

//ALTTP BUMPERS
const int LTTP_BUMPER_FORCE = 3; //How fast Link gets pushed back when he hits a bumper
const int LTTP_BUMPER_ANIM_SPEED = 4; //How fast the bumpers animate in frames
const int SFX_LTTP_BUMPER = 40; //The sound that plays when Link hits a bumper

const int MAX_PUSH = 4; //Max speed the script can move Link in one frame

//LADX, OOA & OOS CHASERS
const int CHASER_ACCELERATION = 0.05;
const int CHASER_DEFAULT_STEP = 100;

// npc->Misc[] indices
const int CHASER_ATTR_IGNORE_WATER = 0;
const int CHASER_ATTR_IGNORE_PITS = 0;
const int CHASER_ATTR_WIDTH = 1;
const int CHASER_ATTR_HEIGHT = 1;
const int CHASER_ATTR_START_SOUND = 50;
const int CHASER_ATTR_STOP_SOUND = 0;
const int CHASER_ATTR_MOVE_SOUND = 4;
const int CHASER_ATTR_MOVE_SOUND_LOOP_TIME = 7;


//----BOSSES----

//BETTER AQUAMENTUS
const int TILE_AQUA1 = 20290; // The first tile of Aquamentus's default animation.
const int TILE_AQUA2 = 20370; // The first tile of Aquamentus's attacking animation.
const int TILE_AQUA3 = 20330; // The first tile of Aquamentus's flying animation.
const int SFX_AQUA_WALLCRASH = 3;
const int SFX_AQUA_STOMP = 3;

//----COMMON ENEMIES----

//POPOS

// Wait time between movement
const int POPO_MIN_WAIT_TIME = 90;
const int POPO_MAX_WAIT_TIME = 240;

// Number of jumps before stopping
const int POPO_MIN_JUMPS = 8;
const int POPO_MAX_JUMPS = 12;

//HARDHAT BEETLES

const int HARDHAT_ATTR_MIN_STEP = 0;
const int HARDHAT_ATTR_MAX_STEP = 1;


//JUMPING STALFOSES
const int SHADOW      = 4737; //combo ID on the tiles page
const int SHADOW_CSET = 7;  
const int SFX_JMP     = 64;
const int SFX_LAND    = 65;   

//jump settings
const int JUMP_FORCE  = 4;   //any lower and you may or may-not break the script
const int MAX_HEIGHT  = 32;
const int PROXIMITY   = 32;  //how close stalfos get before they jump
const int JUMP_BACK   = 1;   //distance that stalfos jump away per-frame

//jump states
const int ON_GROUND  = 0;
const int GOING_UP   = 1;
const int GOING_DOWN = 2;

//npc->Misc indexes
const int JUMP_DIR   = 0;
const int JUMP_STATE = 1;

//------GENERIC ARRAYS------------

bool GenBool[1000];
int GenInt[1000];

//------MAIN GLOBAL SCRIPT--------

global script Main_Loop{
  void run() 
  {
      int curscreen = -1;
      StartGhostZH();
      //InitHoleLava(); //Inits Tamamo's holes and lava.
	  MooshPit_Init();
	  RefreshBottles();
	  Tango_Start();
	  ScrollingDraws_Init();
	  Minecart_Init();

      //Initialize variables used to store Link's strating position on Screen Init.
      int olddmap = Game->GetCurDMap();
      int oldscreen = Game->GetCurDMapScreen();
      int startx = Link->X;
      int starty = Link->Y;
      int startdir = Link->Dir;
	  int lastscreen = 0;
	  int scrollCounter = 0;
	  int scrollDir = 0;
	  int drawX = 0;
	  int drawY = 0;

      //Clear global variables used by Bottomless pits.
      //Falling = 0;
      //Warping = false;
	  
	  int XCounter = 0;
	  int YCounter = 0;
	  int screeny = 0;
	  int mapy = 0;
	  Setup_IceCombos();
	  int Olderscreen = Game->GetCurScreen();
	  
	  powerBracelet[HOLDING_BLOCK] = 0;
	  holding_bomb = 0;

	  LinkMovement_Init();
	  bool HelloDarknessMyOldFriend = false;
	  InitGrassClippings();
	  
    while(1)
    {
	  //Trace(1);
	  BobOmb(NPC_BOBOMB, BOBOMB_FFC_SLOT, BOBOMB_FFC_DATA, BOBOMB_FFC_D_TIMER_SLOT, BOBOMB_FFC_D_CSET_SLOT, BOBOMB_FFC_FLASH_CSET);
	  ScrollPFix();
      UpdateGhostZH1();
	  Tango_Update1();
	  Z3_STUN();
	  Z3_BRANG();
	  //Trace(2);
	  PushAnimation();
	  //Trace(2.1);
	  Bombs();
	  //Trace(2.2);
	  DoPowerBracelet();
	  //Trace(2.3);
	  PowerBracelet();
	  //Trace(2.4);
	  ScreenChange_Update();
	  //Trace(2.5);
      LS_Update();
	  //Trace(3);
      
	  MooshPit_Update();
	  
	  NayrusLove();
	  DetectFireColl();
	  DetectIceColl();
	  SideQuestGlobal();
	  //Z3_Sword();
	  
	  UpdateLweaponZH();
	  HelloDarknessMyOldFriend = DarkRoomGlobal(HelloDarknessMyOldFriend);
	  SpinAttack();
	  
	  if (Link->PressEx3) Link->MaxHP -= 16;
	  if (Link->PressEx4) Link->MaxHP += 16;
	  
      if(Link->Action != LA_SCROLLING)
      {
		if(oldscreen != Game->GetCurDMapScreen() || olddmap != Game->GetCurDMap())
        {
			if (Game->GetCurMap() == 1 && olddmap != Game->GetCurDMap())
			{
				Game->ContinueDMap = Game->GetCurDMap();
				Game->ContinueScreen = Game->GetCurScreen();
				Game->LastEntranceDMap = Game->GetCurDMap();
				Game->LastEntranceScreen = Game->GetCurScreen();
			}
		}
        //Update_HoleLava(startx, starty, olddmap, oldscreen, startdir);
        if(Link->Z==0 && (oldscreen != Game->GetCurDMapScreen() || olddmap != Game->GetCurDMap()) && shutterRunning != true)
        {
          olddmap = Game->GetCurDMap();
          oldscreen = Game->GetCurDMapScreen();
          startx = Link->X;
          starty = Link->Y;
          startdir = Link->Dir;
        }
      }
	  
	  //Trace(4);
 
      // Other things can go here
	  if (Game->GetCurScreen() != curscreen) {
      curscreen = Game->GetCurScreen();
      Barriers_NewScreen();}
	  shutterControl();
	  updatePrev();
	  LWeaponLifespan();
	  
	  //Trace(5);
	  
	  if (Game->GetCurDMap() == 19) //Snake Island Temple Drawing
	  {
		if(Link->Action==LA_SCROLLING)
		{
			if(scrollDir==-1)
			{
				if(Link->Y>160)
				{
					scrollDir=DIR_UP;
					scrollCounter=45;
				}
				else if(Link->Y<0)
				{
					scrollDir=DIR_DOWN;
					scrollCounter=45;
				}
				else if(Link->X>240)
				{
					scrollDir=DIR_LEFT;
					scrollCounter=65;
				}
				else
				{
					scrollDir=DIR_RIGHT;
					scrollCounter=65;
				}
			}
			
			if(scrollDir==DIR_UP && scrollCounter<45 && scrollCounter>0)
				drawY+=4;
			else if(scrollDir==DIR_DOWN && scrollCounter<45 && scrollCounter>0)
				drawY-=4;
			else if(scrollDir==DIR_LEFT && scrollCounter<65 && scrollCounter>0)
				drawX+=4;
			else if(scrollDir==DIR_RIGHT && scrollCounter<65 && scrollCounter>0)
				drawX-=4;
			
			scrollCounter--;
			Screen->Rectangle(3, 0, 0, 256, 176, 15, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (3, Game->GetCurMap(), lastscreen - 6, drawX, drawY, 0);
			Screen->DrawScreen (3, Game->GetCurMap(), Game->GetCurScreen() - 6, drawX + 256, drawY, 0);
			Screen->DrawScreen (3, Game->GetCurMap(), Game->GetCurScreen() - 6, drawX - 256, drawY, 0);
			Screen->DrawScreen (3, Game->GetCurMap(), Game->GetCurScreen() - 6, drawX, drawY + 176, 0);
			Screen->DrawScreen (3, Game->GetCurMap(), Game->GetCurScreen() - 6, drawX, drawY - 176, 0);
		}
		else
		{
			drawX=0;
			drawY=0;
			Screen->Rectangle(3, 0, 0, 256, 176, 15, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (3, Game->GetCurMap(), Game->GetCurScreen() - 6, 0, 0, 0);
			lastscreen = Game->GetCurScreen();
			if(scrollDir!=-1)
				scrollDir=-1;
		}
	  }
	  //Trace(6);
	  if (Game->GetCurDMap() == 22 || ScreenFlag(SF_MISC, 3)!=0) //Inverse/Dark Dragon's Crypt drawing
	  {
		if (false)
		{
			screeny = 0x6D;
			mapy = 31;
			Screen->SetRenderTarget(RT_BITMAP1);
			Screen->Rectangle(6, 0, 0, 512, 176 + (16 * 7) + 176, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->DrawScreen (6, mapy, screeny, 0, 0, 0);
			Screen->DrawScreen (6, mapy, screeny + 16, 0, 176, 0);
			Screen->DrawScreen (6, mapy, screeny, 0, 176 + (16 * 7), 0);
			Screen->DrawScreen (6, mapy, screeny, 256, 0, 0);
			Screen->DrawScreen (6, mapy, screeny + 16, 256, 176, 0);
			Screen->DrawScreen (6, mapy, screeny, 256, 176 + (16 * 7), 0);
			Screen->Circle(6, Link->X + 8 + XCounter, Link->Y + 8 + YCounter, 24, 0, 1, 0, 0, 0, true, OP_OPAQUE);
			Screen->SetRenderTarget(RT_SCREEN);
			Screen->DrawBitmap (6, RT_BITMAP1, XCounter, YCounter, 256, 176, 0, 0, 256, 176, 0, true);
		}
		if (true)
		{
			Screen->DrawTile(6, 0 - Round(XCounter), 0 - Round(YCounter), 32500, 16, 18, 0, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
			Screen->DrawTile(6, (16 * 16) - Round(XCounter), (16 * 18) + 1 - Round(YCounter), 32500, 16, 18, 0, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
			Screen->DrawTile(6, (16 * 16) - Round(XCounter), 0 - Round(YCounter), 32500, 16, 18, 0, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
			Screen->DrawTile(6, 0 - Round(XCounter), (16 * 18) + 1 - Round(YCounter), 32500, 16, 18, 0, -1, -1, 0, 0, 0, 0, true, OP_TRANS);
		}
		XCounter+=0.5;
		YCounter+=0.25;
		XCounter %= 256;
		YCounter %= 176 + (16 * 7);
	  }
	  //Trace(7);
	  BombsScreenShake();
	  if (Link->Item[PEGASUS_ITEM] == true) PegasusBootsEx2();
	  PegasusBoots();
	  PotBreak();
	  EmptyBottleGlobal();
	  //Trace(8);
	  DrawLayer3();
	  
	  if (Link->Action == LA_SCROLLING) InitGrassClippings();
	  Z3SwordGlobalA();
	  Z3SwordBush();
	  UpdateGrassClippings();
	  
	  LinkMovement_Update1();
	  ScrollingDraws_Update();
	  
      Waitdraw();
	  GreedWallet();
	  Minecart_Update();
	  //Trace(9);
 
      // Anything that says it needs to go after waitdraw goes here.
      UpdateGhostZH2();
	  Tango_Update2();
      //if (Link->Action != LA_SCROLLING && shutterRunning != true) RunHoleLava(); //Main Tamamo Holes and Lava function.
      Update_IceCombos(Olderscreen);
      DiagonAlley();
	  SomariaBlockCollision();
	  //Trace(10);
	  if (IsFreezing)
	  {
		LS_Speed = 0.5;
	  }
	  else LS_Speed = 1;
	  IsFreezing = false;
	  Olderscreen = Game->GetCurScreen();
	  //Trace(11);
	  SolidObjects_Update();
	  LinkMovement_Update2();
	  
	  RunInvisible();
	  
	  Waitframe();
      //Stalfos_Jump();
    }
  }
}

void Stalfos_Jump(){
  npc e;
  for(int i = Screen->NumNPCs(); i > 0 ; i--) {
    e = Screen->LoadNPC(i);
    if(e->ID != NPC_STALFOS1 && e->ID != NPC_STALFOS2 && e->ID != NPC_STALFOS3)
      continue;
    if(
      Link->Action == LA_ATTACKING                                                 &&
      ((Sword_EquippedA() && Link->InputA) || (Sword_EquippedB() && Link->InputB)) &&
      e->Misc[JUMP_STATE] == ON_GROUND                                             &&
      Is_Within_Proximity(e)                                                       &&
      !e->Stun                                                                     &&
      Link_Is_Facing(e)                                                            &&
      !Link->SwordJinx
    ){
      e->Misc[JUMP_STATE] = GOING_UP;
      e->Misc[JUMP_DIR] = Link->Dir;
      Game->PlaySound(SFX_JMP);
    }
    if(e->Misc[JUMP_STATE] != ON_GROUND)
      do_jump(e);
  }
}

bool E_Can_Move(npc e, int dir, int step){
  int x = e->X; int y = e->Y;
  int c = 8;
  int xx = x + 15;
  int yy = y + 15;

  if(dir==DIR_UP) return !(y-step<0 || Screen->isSolid(x,y+c-step) || Screen->isSolid(x+8,y+c-step)
    || Screen->isSolid(xx,y+c-step) || IsWater_Pit_OrNoEnemy(ComboAt(x,y-step)));
  else if(dir==DIR_DOWN) return !(yy+step>=176 || Screen->isSolid(x,yy+step) || Screen->isSolid(x+8,yy+step)
    || Screen->isSolid(xx,yy+step) || IsWater_Pit_OrNoEnemy(ComboAt(x,yy+step)));
  else if(dir==DIR_LEFT) return !(x-step<0 || Screen->isSolid(x-step,y+c) || Screen->isSolid(x-step,y+c+7)
    || Screen->isSolid(x-step,yy) || IsWater_Pit_OrNoEnemy(ComboAt(x-step,y)));
  else if(dir==DIR_RIGHT) return !(xx+step>=256 || Screen->isSolid(xx+step,y+c) || Screen->isSolid(xx+step,y+c+7)
    || Screen->isSolid(xx+step,yy) || IsWater_Pit_OrNoEnemy(ComboAt(xx+step,y)));
  return false; //invalid direction
}

bool Link_Is_Facing(npc e){
  if(e->X < Link->X && Link->Dir == DIR_LEFT)
    return true;
  else if(e->X > Link->X && Link->Dir == DIR_RIGHT)
    return true;
  else if(e->Y > Link->Y && Link->Dir == DIR_DOWN)
    return true;
  else if(e->Y < Link->Y && Link->Dir == DIR_UP)
    return true;
  return false;
}

void do_jump(npc e){
  int dir = e->Misc[JUMP_DIR];
  Screen->FastTile(0, e->X, e->Y, SHADOW, SHADOW_CSET, 255);
  if(E_Can_Move(e, dir, 1)){
    if(dir == DIR_LEFT) e->X -= (JUMP_BACK + 1);  //stalfos are more stubbron to push left and up for some reason
    else if(dir == DIR_RIGHT) e->X += JUMP_BACK;
    else if(dir == DIR_DOWN) e->Y += JUMP_BACK;
    else e->Y -= (JUMP_BACK + 1);
  }

  if(e->Misc[JUMP_STATE] == GOING_UP){
    e->Z += JUMP_FORCE;
    if(e->Z >= MAX_HEIGHT) e->Misc[JUMP_STATE] = GOING_DOWN;
  }else{
    //no need to subtract from Z, the game enforces gravity on top-down view
    if(e->Z <= 0) e->Misc[JUMP_STATE] = ON_GROUND;
    Game->PlaySound(SFX_LAND);
  }
}

bool IsWater_Pit_OrNoEnemy(int position){
  int combo=Screen->ComboT[position];
  int flag = Screen->ComboF[position];
  if(combo==CT_WATER || combo==CT_SWIMWARP || combo==CT_DIVEWARP || (combo>=CT_SWIMWARPB && combo<=CT_DIVEWARPD)
    || combo==CT_PIT || combo==CT_PITR || (combo>=CT_PITB && combo<=CT_PITD)
    || flag==CF_NOENEMY || flag==CF_NOGROUNDENEMY)
       return true;
  else
       return false;
}

bool Sword_EquippedA(){
  int ID = GetEquipmentA();
  return (ID == I_SWORD1 || ID == I_SWORD2 || ID == I_SWORD3 || ID == I_SWORD4);
}

bool Sword_EquippedB(){
  int ID = GetEquipmentB();
  return (ID == I_SWORD1 || ID == I_SWORD2 || ID == I_SWORD3 || ID == I_SWORD4);
}

int av(int a){
  if(a >= 0) return a;
  else return (-1 * a);
}

bool Is_Within_Proximity(npc e){
  int offset;
  if(Game->Generic[GEN_CANSLASH]) offset = 16;
  else offset = 0;

  if(Link->Dir == DIR_LEFT || Link->Dir == DIR_RIGHT)
    return (av(e->X - Link->X) <= PROXIMITY && Link->Y - e->Y < 16 + offset && e->Y - Link->Y < 16);
  else if(Link->Dir == DIR_UP)
    return (av(e->Y - Link->Y) <= PROXIMITY && Link->X - e->X < 16 && e->X - Link->X < 16 + offset);
  else //DIR_DOWN
    return (av(e->Y - Link->Y) <= PROXIMITY && Link->X - e->X < 16 + offset && e->X - Link->X < 16);
}

#include "ffcscript.cfg"

int RunFFCScriptAbove(char32 ptr, untyped args, int above)
{
	if ( above < 0 ) above = 1;
	if ( above > 32 ) above = 32;
	args = ( args < 0 ) ? NULL : args;
	unless ( IsValidArray(ptr) )
	{
		printf("Invalid string / pointer, passed to RunFFCScript(char32)\n");
		return 0;
	}
		
	int scriptNum = Game->GetFFCScript(ptr);
	//Invalid script
	if(scriptNum < 0 || scriptNum > 511)
	{
		printf("Invalid Script Name (%s) passed to RunFFCScript", scriptNum);
		return 0;
	}
	const int MIN = 0; //attibytes
	const int MAX = 1; //attibytes
	unless( args && IsValidArray(args) )
	{	
		args = NULL; //sanity guard against invalid arrays
		printf("Invlalid array passed to RunFFCScript(args)\n");
	}
	
	ffc theFFC = NULL;
	
	int ffscripth = NEVER_USE_COMBO_LABEL ? 0 : Game->GetCombo("FFCSCRIPTH");
	int inv = NEVER_USE_COMBO_LABEL ? 0 : Game->GetCombo("INVISIBLE");
	combodata c = ( ffscripth > 0 ) ? Game->LoadComboData(ffscripth) : NULL;
	int invisible = ( inv > 0 ) ? inv : FFCS_INVISIBLE_COMBO;
	int min = ( (c) ? c->Attribytes[MIN] : FFCS_MIN_FFC );
	int max = ( (c) ? c->Attribytes[MAX] : FFCS_MAX_FFC );
	min = Max(min,above);
	// Find an FFC not already in use
	for( int i = min; i <= max; ++i )
	{
		theFFC=Screen->LoadFFC(i);
	
		if
		(
			theFFC->Script!=0 ||
			(theFFC->Data!=0 && theFFC->Data!=invisible) ||
			theFFC->Flags[FFCF_CHANGER]
		)
			continue;
	
		// Found an unused one; set it up
		theFFC->Data=inv;
		theFFC->Script=scriptNum;
		
		if (args)
		{
			for ( int j = Min(SizeOfArray(args), 8)-1; j >= 0; --j)
				theFFC->InitD[j] = args[j];
		}
	
		return i;
	}
	
	// No FFCs available
	return 0;
}

int RunFFCScriptAbove(int scriptNum, untyped args, int above)
{
	if ( above < 0 ) above = 1;
	if ( above > 32 ) above = 32;
	args = ( args < 0 ) ? NULL : args;
	//Invalid script
	if(scriptNum < 0 || scriptNum > 511)
	{
		printf("Invalid script ID (%d) passed to RunFFCScript", scriptNum);
		return 0;
	}
	const int MIN = 0; //attibytes
	const int MAX = 1; //attibytes
	unless( args && IsValidArray(args) )
	{	
		args = NULL; //sanity guard against invalid arrays
		printf("Invlalid array passed to RunFFCScript(args)\n");
	}
	
	ffc theFFC = NULL;
	
	int ffscripth = NEVER_USE_COMBO_LABEL ? 0 : Game->GetCombo("FFCSCRIPTH");
	int inv = NEVER_USE_COMBO_LABEL ? 0 : Game->GetCombo("INVISIBLE");
	combodata c = ( ffscripth > 0 ) ? Game->LoadComboData(ffscripth) : NULL;
	int invisible = ( inv > 0 ) ? inv : FFCS_INVISIBLE_COMBO;
	int min = ( (c) ? c->Attribytes[MIN] : FFCS_MIN_FFC );
	int max = ( (c) ? c->Attribytes[MAX] : FFCS_MAX_FFC );
	min = Max(min,above);
	// Find an FFC not already in use
	for( int i = min; i <= max; ++i )
	{
		theFFC=Screen->LoadFFC(i);
	
		if
		(
			theFFC->Script!=0 ||
			(theFFC->Data!=0 && theFFC->Data!=invisible) ||
			theFFC->Flags[FFCF_CHANGER]
		)
			continue;
	
		// Found an unused one; set it up
		theFFC->Data=inv;
		theFFC->Script=scriptNum;
		
		if (args)
		{
			for ( int j = Min(SizeOfArray(args), 8)-1; j >= 0; --j)
				theFFC->InitD[j] = args[j];
		}
	
		return i;
	}
	
	// No FFCs available
	return 0;
}

