//import "std.zh"
//import "string.zh"
//import "ghost.zh"

const int EXPLOSION_SPRITE = 88;
const int MINI_EXPLOSION_SPRITE = 89;

//HP: Time in frames until it explodes
//Weapon Damage: Power of the explosion
//Attribute 1: Max random additional HP to add to the HP countdown timer

ffc script EnemyBomb{
	void run (int enemy_ID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemy_ID);
		//ghost->CollDetection = false;
		ghost->HitXOffset = -1000;
		Ghost_HP += Rand(ghost->Attributes[0]);
		while(true)
		{
			Ghost_Waitframe(this, ghost, true, true);
			Ghost_HP --;

			if (Ghost_HP <= 1) 
			{
				ghost->HP = -1000;
				eweapon blast = CreateEWeaponAt(EW_BOMBBLAST,Ghost_X,Ghost_Y);
				Game->PlaySound(SFX_BOMB);
				blast->Damage = ghost->WeaponDamage;
			}
		}
	}
}

//Attribute 1: ID of the enemy to spawn
//Attribute 2: Minimum time in frames to spawn an enemy
//Attribute 3: Maximum time in frames to spawn an enemy
//Attribute 4: Max number of spawned enemies allowed on screen 

ffc script Spawner{
	void run (int enemy_ID)
	{
		npc ghost = Ghost_InitAutoGhost(this, enemy_ID);
		Ghost_SetFlag(GHF_NORMAL);
		ghost->Extend = 3;
		int spawn_ID = ghost->Attributes[0]; 
		int duration_min = ghost->Attributes[1];
		int duration_max = ghost->Attributes[2];
		int limit = ghost->Attributes[3];
		
		
		int walk_counter = -1;
		int step = ghost->Step;
		int rate = ghost->Rate;
		int homing = ghost->Homing;
		int hunger = ghost->Hunger;
		int haltRate = ghost->Haltrate;

		ghost->Step = 0;
		ghost->Rate = 0;
		ghost->Homing = 0;
		ghost->Hunger = 0;
		ghost->Haltrate = 0;

		int counter = -1;
		int rand_duration = 30;
		while (true)
		{
			counter++;
			if(counter >= rand_duration)
			{
				counter = 0;
				rand_duration = Rand(duration_max - duration_min) + duration_min;
				if(limit >0 && NumNPCsOf(spawn_ID) < limit)
				{
					CreateNPCAt(spawn_ID, this->X, this->Y);
				}
			
			}

			walk_counter = Ghost_HaltingWalk4(walk_counter, step, rate, homing, hunger, haltRate, 48);
			Ghost_Waitframe(this, ghost, true, true);
		}
	}
}

const int DESTROYED_COMBO = 1276;
ffc script Destroy{
	void run()
	{
		while(true)
		{
			for (int i = 1;i<=Screen->NumEWeapons();i++)
			{
				eweapon ew = Screen->LoadEWeapon(i);
				int loc = ComboAt(ew->X + 8, ew->Y + 8);
				if (ew->ID==EW_SCRIPT1 && Screen->ComboF[loc] == CF_SCRIPT1 )
				{
					Screen->ComboD[loc] = DESTROYED_COMBO;
				}
			
			}
			Waitframe();
		}
	}
}

const int POISON_TILE = 4334;
const int NON_POISON_TILE = 4308;
const int SNAIL_TILE_START = 1100;

const int MIDI_BOSSFIGHT = 3;
const int MIDI_VICTORY = 4;
const int SFX_SNAILHIT = 69;
const int SFX_SNAILDEAD = 70;

ffc script Snail{
	void run()
	{
	Game->PlayMIDI(MIDI_BOSSFIGHT);
	int snail_normal_cset = 10;
	int snail_hurt_cset = 11;
	int snail_cset = snail_normal_cset;
	int snail_HP = 10;
	int hurt_counter = 0;
		while(snail_HP > 0)
		{
		
			if (hurt_counter == 0)
			{
				snail_cset = snail_normal_cset;
				for (int i = 1;i<=Screen->NumLWeapons();i++)
				{
					lweapon lw = Screen->LoadLWeapon(i);
					bool hit = false;
					for (int j = 0;j<16;j++)
					{
						int loc = ComboAt(lw->X + j, lw->Y + j);
						hit = hit || (lw->ID==LW_BOMBBLAST && Screen->ComboF[loc] == CF_NOENEMY ); //We're using the NOENEMY flag to mark the boss's location on the screen and keep slugs away.
					}
					
					if(hit)
					{
						snail_HP--;
						hurt_counter = 60;
						Game->PlaySound(SFX_SNAILHIT);
					}
					
				}
			}
			else hurt_counter--;
			
			if (hurt_counter%3) 
			{
				if (snail_cset == snail_normal_cset) snail_cset = snail_hurt_cset;
				else snail_cset = snail_normal_cset;
			}
			
			Screen->DrawTile(2, 32, 32, SNAIL_TILE_START, 6, 4, snail_cset, -1, 1, 0, 0, 0, 0, true, OP_OPAQUE);
			Waitframe();
		}
		Game->PlaySound(SFX_SNAILDEAD);
		item it = Screen->CreateItem(I_KILLALL);
		it->X = Link->X;
		it->Y = Link->Y;
		for (int i = 0;i<176;i++)
		{
			if(Screen->ComboD[i] == POISON_TILE) Screen->ComboD[i] = NON_POISON_TILE;
		}
		Waitframes(120);
		item tf = Screen->CreateItem(I_TRIFORCE);
		tf->X = 120;
		tf->Y = 64;
		Game->PlayMIDI(MIDI_VICTORY);
		
	}
}