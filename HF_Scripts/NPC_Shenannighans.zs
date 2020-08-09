//NPC SHENANNIGHANS

ffc script real_npcV2 {
  void run(int m, int gmitem, int f, int d, int def_dir, int npcissolid, int gm_min, int gm_max) {
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
    if(d == 0) d = 48;
   
   
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
     
        if(f != 0) {
            if(a_x < d && a_y < d) {
                  if(a_x <= a_y) {
                    if(d_y >= 0) {
                          this->Data = orig_d + DIR_DOWN;
                    } else {
                        this->Data = orig_d + DIR_UP;
                    }
                } else {
                    if(d_x >= 0) {
                        this->Data = orig_d + DIR_LEFT;
                    } else {
                        this->Data = orig_d + DIR_RIGHT;
                    }
                  }
            } else {
                this->Data = orig_d + def_dir;
            }
        }
        
        //This checks if you have item D1, and makes the NPC disappear if you do.
        if (Link->Item[gmitem] == true){this->X=-256; this->Y=-256;}
        else
        {

            //This enables horizontal guard mode.
            if (gm_max>0)
            {
                if (Link->X>gm_min-32 && Link->X<gm_max+32 && Link->Y>this->Y+tho-32 && Link->Y<this->Y+tho+32) {ir=1;}
                else {ir=0;}
                if (Link->X<this->X-2 && this->X>gm_min && ir==1)
                {
                    if (Link->X>gm_min){this->Vx= (- this->X + Link->X)/4;}
                    else{this->Vx= (- this->X + gm_min)/4;}
                }
                if (Link->X>this->X+2 && this->X<gm_max && ir==1)
                {
                    if (Link->X<gm_max){this->Vx= (Link->X - this->X)/4;}
                    else{this->Vx= (gm_max - this->X)/4;}
                }
                if (Link->X<this->X+2 && Link->X>this->X-2){this->Vx=0;}
                if (ir==0){this->Vx=0;}
                if (this->X<gm_min+1){
                    if (this->Vx<0) this->Vx=0;
                        this->X=gm_min;
                }
                if (this->X>gm_max-1){
                    if (this->Vx>0) this->Vx=0;
                    this->X=gm_max;
            }
        }

        //This enables vertical guard mode.
        if (gm_max<0)
        {
            if (Link->Y>-gm_min-32 && Link->Y<-gm_max+32 && Link->X>this->X-32 && Link->X<this->X+32) {ir=1;}
            else {ir=0;}
            if (Link->Y<this->Y-2+tho && this->Y+tho>-gm_min && ir==1)
            {
                if (Link->Y>-gm_min){this->Vy= (- this->Y-tho + Link->Y)/4;}
                else {this->Vy= (- this->Y-tho + -gm_min)/4;}
            }
            if (Link->Y>this->Y+2+tho && this->Y+tho<-gm_max && ir==1)
            {
                if (Link->Y<-gm_max){this->Vy= (Link->Y - this->Y-tho)/4;}
                else {this->Vy= (-gm_max - this->Y-tho)/4;}
            }
                if (Link->Y<this->Y+2+tho && Link->Y>this->Y-2+tho){this->Vy=0;}
                if (ir==0){this->Vy=0;}
                if (this->Y+tho<-gm_min+1){
                    if (this->Vy<0)this->Vy=0;
                    this->Y=-gm_min-tho;
                }
                if (this->Y+tho>-gm_max-1){
                    if (this->Vy>0)this->Vy=0;
                    this->Y=-gm_max-tho;
                }
            }

        }

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
                Screen->Message(m);
                Link->InputEx2 = false;
            }
        }

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

item script Message{
	void run(int m){
		Screen->Message(m);
	}
}
