int Sidequests[50];

const int SQ_HINOX = 0;
const int SQ_LYNEL = 1;
const int SQ_TEKTITE = 2;


ffc script Sidequest_NPC {
  void run(int m, int SQ_ID, int m2, int m3, int m4, int itemsq, int itemsq2, int npcissolid) {
    int d_x;
    int d_y;
    int a_x;
    int a_y;
    int ir;
    int tho=(this->TileHeight*16-16);
    int orig_d = this->Data;
    int Apressed2;   
    int Appr2;
    int onscreenedge;
   
   
    while(true) {
        //This detects if link is on the edge of the screen
        if (Link->X<8 || Link->Y<8 || Link->X>232 || Link->Y>152){onscreenedge=1;} else {onscreenedge=0;}

        //This checks if you're above or below the NPC to create an overhead effect
        if (Link->Y<this->Y-8+tho && onscreenedge==0){this->Flags[FFCF_OVERLAY] = true;} else {this->Flags[FFCF_OVERLAY] = false;}

        //This detects if A was pressed, allowing you to exit messages with the A button
        if (Link->InputEx2)
        {
            if (Apressed2==1){Apressed2=0;}
        else
        {
            if (Appr2==0){Apressed2=1; Appr2=1;}}
        }
        else
        {
            Apressed2=0;
            Appr2=0;
        }

        d_x = this->X - Link->X;
        d_y = this->Y+(this->TileHeight*16-16) - Link->Y;
        a_x = Abs(d_x);
        a_y = Abs(d_y);

        if (this->Vy>0)this->Data = orig_d + DIR_UP;
        if (this->Vy<0)this->Data = orig_d + DIR_DOWN;
        if (this->Vx>0)this->Data = orig_d + DIR_RIGHT;
        if (this->Vx<0)this->Data = orig_d + DIR_LEFT;
		
		if ((Link->X<this->X-8 && Link->Y>this->Y+tho-12 && Link->Y<this->Y+tho+8 && Link->Dir == DIR_RIGHT || Link->X>this->X+8 && Link->Y>this->Y+tho-12 && Link->Y<this->Y+tho+8 && Link->Dir == DIR_LEFT || Link->Y<this->Y+tho-8 && Link->X>this->X-8 && Link->X<this->X+8 && Link->Dir == DIR_DOWN || Link->Y>this->Y+tho+8 && Link->X>this->X-8 && Link->X<this->X+8 && Link->Dir == DIR_UP) && a_x < 24 && a_y < 24)
		{
			Screen->FastCombo(4, Link->X + 4, Link->Y - 16, 2142, 8, OP_OPAQUE);
		}
     
        if(Apressed2==1 && a_x < 24 && a_y < 24) {
            //This is all checking if Link is facing the NPC while to the left, to the right, above, or below the NPC
            if (Link->X<this->X-8 && Link->Y>this->Y+tho-12 && Link->Y<this->Y+tho+8 && Link->Dir == DIR_RIGHT || Link->X>this->X+8 && Link->Y>this->Y+tho-12 && Link->Y<this->Y+tho+8 && Link->Dir == DIR_LEFT || Link->Y<this->Y+tho-8 && Link->X>this->X-8 && Link->X<this->X+8 && Link->Dir == DIR_DOWN || Link->Y>this->Y+tho+8 && Link->X>this->X-8 && Link->X<this->X+8 && Link->Dir == DIR_UP){
                Apressed2=0;
				if (Sidequests[SQ_ID] <= 0)
				{
					Screen->Message(m);
					Sidequests[SQ_ID] = 1;
				}
				else if (Sidequests[SQ_ID] == 1) Screen->Message(m2);
				else if (Sidequests[SQ_ID] == 2)
				{
					Screen->Message(m3);
					Waitframe();
					if (itemsq > 0)
					{
						item reward = Screen->CreateItem(itemsq);
						SetItemPickup(reward, IP_HOLDUP, true);
						reward->X = Link->X;
						reward->Y = Link->Y;
					}
					else if (itemsq < 0) Game->DCounter[CR_RUPEES] = Abs(itemsq);
					if (itemsq2 > 0)
					{
						item reward = Screen->CreateItem(itemsq2);
						SetItemPickup(reward, IP_HOLDUP, true);
						reward->X = Link->X;
						reward->Y = Link->Y;
					}
					else if (itemsq2 < 0) Game->DCounter[CR_RUPEES] = Abs(itemsq2);
					Sidequests[SQ_ID] = 3;
				}
				else if (Sidequests[SQ_ID] >= 3) Screen->Message(m4);
                Link->InputEx2 = false;
            }
        }
		
		if (Sidequests[SQ_ID] <= 2) Screen->FastCombo(4, this->X + 4, this->Y - 16, 2270, 8, OP_OPAQUE);

        //This enables the NPC to be solid without having to lay a solid combo under it.
        if (npcissolid>0){
            if ((Abs(Link->X - this->X) < 10) && 
                (Link->Y <= this->Y+tho + 12) && (Link->Y > this->Y+tho+8)){Link->Y = this->Y+tho+12;}
            
            if ((Abs(Link->Y - this->Y-tho) < 10) && 
                (Link->X >= this->X - 12) && (Link->X < this->X-8)){Link->X = this->X-12;}
        
            if ((Abs(Link->X - this->X) < 10) && 
                (Link->Y >= this->Y+tho - 12) && (Link->Y < this->Y+tho-8)){Link->Y = this->Y+tho-12;}
        
            if ((Abs(Link->Y - this->Y-tho) < 10) && 
                (Link->X <= this->X + 12) && (Link->X > this->X+8)){Link->X = this->X+12;}
        }
        
        Waitframe();
    }
  }
}

void SideQuestGlobal()
{
	if (Sidequests[0] == 1)
	{
		for (int i = Screen->NumNPCs(); i > 0; i--)
		{
			npc sqnpc = Screen->LoadNPC(i);
			if ((sqnpc->ID == 327 || sqnpc->ID == 328) && sqnpc->HP <= 0 && sqnpc->Misc[4] <= 0 && GenInt[SQ_HINOX] < 5) 
			{
				sqnpc->Misc[4] = 1;
				GenInt[SQ_HINOX]++;
				for (int l = 0; l < 5; l++)
				{
					lweapon Popup1 = Screen->CreateLWeapon(LW_SPARKLE);
					Popup1->X = 88 + (l * 16);
					Popup1->Y = 88;
					Popup1->Z = 88;
					Popup1->UseSprite(125);
					Popup1->Tile += l;
					Popup1->OriginalTile += l;
				}
				for (int l = 0; l < 5; l++)
				{
					lweapon Popup1 = Screen->CreateLWeapon(LW_SPARKLE);
					Popup1->X = 88 + (l * 16);
					Popup1->Y = 88 + 16;
					Popup1->Z = 88;
					Popup1->UseSprite(125);
					Popup1->Tile += (l + 20);
					Popup1->OriginalTile += (l + 20);
				}
				
				lweapon Popup2 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup2->X = 96;
				Popup2->Y = 96;
				Popup2->Z = 88;
				Popup2->UseSprite(126);
				Popup2->Tile+=0;
				Popup2->OriginalTile+=0;
				
				lweapon Popup3 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup3->X = 116;
				Popup3->Y = 96;
				Popup3->Z = 88;
				Popup3->UseSprite(127);
				Popup3->Tile+=GenInt[SQ_HINOX];
				Popup3->OriginalTile+=GenInt[SQ_HINOX];
				
				lweapon Popup4 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup4->X = 143;
				Popup4->Y = 96;
				Popup4->Z = 88;
				Popup4->UseSprite(127);
				Popup4->Tile+=5;
				Popup4->OriginalTile+=5;
			}
			if ((sqnpc->ID == 30 || sqnpc->ID == 31) && sqnpc->HP <= 0 && sqnpc->Misc[4] <= 0 && GenInt[SQ_LYNEL] < 25) 
			{
				sqnpc->Misc[4] = 1;
				GenInt[SQ_LYNEL]++;
				for (int l = 0; l < 5; l++)
				{
					lweapon Popup1 = Screen->CreateLWeapon(LW_SPARKLE);
					Popup1->X = 88 + (l * 16);
					Popup1->Y = 88;
					Popup1->Z = 88;
					Popup1->UseSprite(125);
					Popup1->Tile += l;
					Popup1->OriginalTile += l;
				}
				for (int l = 0; l < 5; l++)
				{
					lweapon Popup1 = Screen->CreateLWeapon(LW_SPARKLE);
					Popup1->X = 88 + (l * 16);
					Popup1->Y = 88 + 16;
					Popup1->Z = 88;
					Popup1->UseSprite(125);
					Popup1->Tile += (l + 20);
					Popup1->OriginalTile += (l + 20);
				}
				
				lweapon Popup2 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup2->X = 96;
				Popup2->Y = 96;
				Popup2->Z = 88;
				Popup2->UseSprite(126);
				Popup2->Tile+=1;
				Popup2->OriginalTile+=1;
				
				lweapon Popup3 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup3->X = 116;
				Popup3->Y = 96;
				Popup3->Z = 88;
				Popup3->UseSprite(127);
				Popup3->Tile+=GenInt[SQ_LYNEL];
				Popup3->OriginalTile+=GenInt[SQ_LYNEL];
				
				lweapon Popup4 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup4->X = 143;
				Popup4->Y = 96;
				Popup4->Z = 88;
				Popup4->UseSprite(127);
				Popup4->Tile+=25;
				Popup4->OriginalTile+=25;
			}
			if ((sqnpc->ID == 24 || sqnpc->ID == 25) && sqnpc->HP <= 0 && sqnpc->Misc[4] <= 0 && GenInt[SQ_TEKTITE] < 10) 
			{
				sqnpc->Misc[4] = 1;
				GenInt[SQ_TEKTITE]++;
				for (int l = 0; l < 5; l++)
				{
					lweapon Popup1 = Screen->CreateLWeapon(LW_SPARKLE);
					Popup1->X = 88 + (l * 16);
					Popup1->Y = 88;
					Popup1->Z = 88;
					Popup1->UseSprite(125);
					Popup1->Tile += l;
					Popup1->OriginalTile += l;
				}
				for (int l = 0; l < 5; l++)
				{
					lweapon Popup1 = Screen->CreateLWeapon(LW_SPARKLE);
					Popup1->X = 88 + (l * 16);
					Popup1->Y = 88 + 16;
					Popup1->Z = 88;
					Popup1->UseSprite(125);
					Popup1->Tile += (l + 20);
					Popup1->OriginalTile += (l + 20);
				}
				
				lweapon Popup2 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup2->X = 96;
				Popup2->Y = 96;
				Popup2->Z = 88;
				Popup2->UseSprite(126);
				Popup2->Tile+=2;
				Popup2->OriginalTile+=2;
				
				lweapon Popup3 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup3->X = 116;
				Popup3->Y = 96;
				Popup3->Z = 88;
				Popup3->UseSprite(127);
				Popup3->Tile+=GenInt[SQ_TEKTITE];
				Popup3->OriginalTile+=GenInt[SQ_TEKTITE];
				
				lweapon Popup4 = Screen->CreateLWeapon(LW_SPARKLE);
				Popup4->X = 143;
				Popup4->Y = 96;
				Popup4->Z = 88;
				Popup4->UseSprite(127);
				Popup4->Tile+=10;
				Popup4->OriginalTile+=10;
			}
		}
		if (GenInt[SQ_TEKTITE] >= 10 && GenInt[SQ_LYNEL] >= 25 && GenInt[SQ_HINOX] >= 5) Sidequests[0] = 2;
	}
}