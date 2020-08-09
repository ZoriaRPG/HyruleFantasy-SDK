// Bari's Link Shock Constants
const int BARI_SHOCK_COOLDOWN     = 40;
const int BARI_SHOCK_TIME         = 30;
const int BARI_SFX_SHOCK          = 70;
const int BARI_WPS_SHOCK          = 100;

// npc->Attributes[] index
const int BARI_ATTR_SHOCK_CHANCE  = 5;
const int BARI_ATTR_SHOCK_TIME    = 7;

// ffc->Misc[] index
const int BARI_IDX_SHOCKING       = 0;

ffc script Bari
{
    void run(int enemyID)
    {
        //Init
        npc ghost = Ghost_InitAutoGhost(this, enemyID);
        int swordDefense = ghost->Defense[NPCD_SWORD]; //This is what is initially

        //Flags
        Ghost_SetFlag(GHF_FAKE_Z);
        Ghost_SetFlag(GHF_NO_FALL);
        Ghost_SetFlag(GHF_FLYING_ENEMY);
		Ghost_SetFlag(GHF_IGNORE_WATER);

        //Combos
        int regularCombo = Ghost_Data;
        int shockCombo = Ghost_Data+1;

        //Movement Variables
        int counter = -1;
        int stepSpeed = ghost->Step;
        int randomRate = ghost->Rate;
        int homingFactor = ghost->Homing;
        int hunger = ghost->Hunger;
        int turnFrequency = ghost->Haltrate;
        bool alwaysMove;

        //Shock Variables

        int shockCounter;
        int shockChance = Ghost_GetAttribute(ghost, BARI_ATTR_SHOCK_CHANCE, 100);
        int shockTime = Ghost_GetAttribute(ghost, BARI_ATTR_SHOCK_TIME, 48);
        if(shockChance < 0)
        {
            shockChance *= -1;
            alwaysMove = true;
        }
        
        //Spawn Animation
        Ghost_SpawnAnimationPuff(this, ghost);
		
		int shockDelay = BARI_SHOCK_COOLDOWN;
		
        //Behavior Loop
        do
        {
            if(ghost->Stun > 0 || ClockIsActive())
            {
                if(shockCounter > 0)
                {
                    shockCounter = 0;
                    Ghost_Data = regularCombo;
                }

                while(ghost->Stun > 0 || ClockIsActive())
                    Ghost_Waitframe(this, ghost, true, true);
            }

            //Using the shock attack? then decrement it's counter.
            if(shockCounter > 0)
            {
                shockCounter--;
                if(shockCounter==0)
                    Ghost_Data = regularCombo;
            }

            //Otherwise randomly start the shock attack.
            else{
				if(shockDelay>0)
					shockDelay--;
				if(Rand(shockChance)==0&&shockDelay<=0)
				{
					shockCounter = shockTime;
					Ghost_Data = shockCombo;
					shockDelay = BARI_SHOCK_COOLDOWN;
				}
            }

            //Movement
            if(shockCounter==0 || alwaysMove)
            {
                counter = Ghost_VariableWalk8(counter, stepSpeed, randomRate, homingFactor, hunger, turnFrequency);
                Ghost_Z = 8; //maintain z position.
            }

        } while(BariWaitframe(this, ghost, shockCounter, swordDefense));
    }

    bool BariWaitframe(ffc this, npc ghost, int shockCounter, int swordDefense)
    {
        bool electrified;

        //Is the Bari electrified?
        if(shockCounter > 0)
        {
            electrified = true;
            ghost->Defense[NPCD_SWORD] = NPCDT_IGNORE;
        }
        else
        {
            electrified = false;
            ghost->Defense[NPCD_SWORD] = swordDefense;
        }

        //If stunned or a clock is active, set sword defense to normal and return.
        if(ghost->Stun > 0 || ClockIsActive())
        {
            ghost->Defense[NPCD_SWORD] = swordDefense;
            return Ghost_Waitframe(this, ghost, true, true);
        }
        //If not electrified just wait.
        else if(!electrified)
            return Ghost_Waitframe(this, ghost, true, true);
        //Same thing if another Bari is shocking Link.
        else if(AlreadyBeingShocked(this))
            return Ghost_Waitframe(this, ghost, true, true);

        //Otherwise check for sword collisions.
        else
        {
            lweapon sword;
            for(int i = Screen->NumLWeapons(); i > 0; i--)
            {
                sword = Screen->LoadLWeapon(i);

                if(sword->ID == LW_SWORD || sword->ID == LW_SCRIPT3)
                {
                    // Hit by sword; create an eweapon to hurt Link
                    if(Collision(sword, ghost))
                    {
                        eweapon wpn;
                        int oldLinkX;
                        int oldLinkY;
                        bool oldLinkInvis;
                        bool oldLinkColl;
                        
                        // Set this so other Bari's don't activate
                        this->Misc[BARI_IDX_SHOCKING]=1;
                        
                        // Remember Link's data
                        oldLinkX=Link->X;
                        oldLinkY=Link->Y;
                        oldLinkInvis=Link->Invisible;
                        oldLinkColl=Link->CollDetection;
                        
                        // Hurt Link, hide him, draw the shock graphic, and play the sound
                        Link->HP-=4*ghost->WeaponDamage;
                        
                        Link->Invisible=true;
                        Link->CollDetection=false;
                        
                        lweapon graphic=Screen->CreateLWeapon(LW_SCRIPT1);
                        graphic->UseSprite(BARI_WPS_SHOCK);
                        graphic->X=Link->X;
                        graphic->Y=Link->Y;
                        graphic->CollDetection=false;
                        graphic->DeadState=BARI_SHOCK_TIME;
                        
                        Game->PlaySound(BARI_SFX_SHOCK);
                        Screen->Quake=Max(Screen->Quake, 30);
                        
                        for(int j=0; j<BARI_SHOCK_TIME; j++)
                        {
                            NoAction();
                            Link->X=oldLinkX;
                            Link->Y=oldLinkY;
                            Ghost_Waitframe(this, ghost, true, true);
                            
                            // Make Link visible again if he died
                            if(Link->HP<=0)
                                Link->Invisible=oldLinkInvis;
                        }
                        
                        // Unhide Link, stop flashing
                        Link->Invisible=oldLinkInvis;
                        Link->CollDetection=oldLinkColl;
                        this->Misc[BARI_IDX_SHOCKING]=0;
                    }
                    break;
                }
            }
        }
        return Ghost_Waitframe(this, ghost, true, true);
    }

    //Is another Bari already shocking Link?
    bool AlreadyBeingShocked(ffc this)
    {
        ffc f;
        
		int bari[] = "Bari";
		int shock[] = "ShockLink";
		int script_num1 = Game->GetFFCScript(bari);
		int script_num2 = Game->GetFFCScript(shock);
        // Check each other FFC
        for(int i = 1; i <= 32; i++)
        {
            f = Screen->LoadFFC(i);

            if(f==this)
                continue;

             //Same script and Misc[] index set? then It's shocking Link.
            if((f->Script == this->Script || (f->Script == script_num1 || f->Script == script_num2)) && f->Misc[BARI_IDX_SHOCKING] != 0)
                return true;
        }
        
        return false;
    }
}