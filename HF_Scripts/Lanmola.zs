const int CMB_LANMOLA_EMERGE = 10265; //The first of three combos used for the dirt patch where the enemy emerges (small, medium, large)
const int CS_LANMOLA_EMERGE = 10; //The CSet used for the dirt patch
const int LANMOLA_MIN_RANGE = 2; //The minimum distance the lanmola will look to submerge from the point it emerges.
const int LANMOLA_MAX_RANGE = 5; //The maximum distance the lanmola will look to submerge from the point it emerges.
 
//Attributes:
//A1: The ID of the NPC used for the tail
//A2: The number of segments
//A3: Pixels trimmed off the head's hitbox
//A4: Pixels trimmed off the largest tail segment's hitbox
//A5: Pixels trimmed off the medium tail segment's hitbox
//A6: Pixels trimmed off the smallest tail segment's hitbox
//A7: Sprite of the 8-way projectiles the enemy shoots when emerging (0 for no projectiles)
 
//Unlike most autoghosted enemies, this uses the enemy's tiles for graphics instead of combos. Attribute 11 should be an invisible combo.
//Head tiles: Invisible, up, down, left, right, left-up, right-up, left-down, right-down
//Tail tiles: Biggest, medium, smallest
 
ffc script Diving_Lanmola{
    int FramestoFall(int Z, int Jump, int Gravity){
        int Frames = 0;
        while(Z>0||Jump>0){
            Jump -= Gravity;
            Z -= Jump;
            Frames++;
        }
        return Frames;
    }
    bool AboveGround(npc Segment){
        for(int i=0; i<9; i++){
            if(Segment[i]->isValid()){
                if(Segment[i]->X>-16)
                    return true;
            }
        }
        return false;
    }
    void Lanmola_Waitframe(ffc this, npc ghost, npc Segment, int SegmentX, int SegmentY, int SegmentZ){
        SegmentX[0] = Ghost_X;
        SegmentY[0] = Ghost_Y-Ghost_Z;
        SegmentZ[0] = Ghost_Z;
        int SegmentDist = Round(8/(ghost->Step/100));
        for(int i=159; i>0; i--){
            SegmentX[i] = SegmentX[i-1];
            SegmentY[i] = SegmentY[i-1];
            SegmentZ[i] = SegmentZ[i-1];
        }
        for(int i=0; i<9; i++){
            if(Segment[i]->isValid()){
                Segment[i]->X = SegmentX[SegmentDist+i*SegmentDist];
                Segment[i]->Y = SegmentY[SegmentDist+i*SegmentDist];
                Segment[i]->CSet = this->CSet;
               
                if(SegmentZ[SegmentDist+i*SegmentDist]>0&&!(GH_SHADOW_FLICKER!=0 && (__ghzhData[__GHI_GLOBAL_FLAGS]&__GHGF_FLICKER)!=0)){
                    int x;
                    int y;
                    int tile;
                    x=Segment[i]->X;
                    y=Segment[i]->Y+SegmentZ[SegmentDist+i*SegmentDist];
                    if(Ghost_FlagIsSet(GHF_STATIC_SHADOW))
                        tile=GH_SHADOW_TILE;
                    else
                        tile=GH_SHADOW_TILE+__ghzhData[__GHI_SHADOW_FRAME];
                       
                    if(GH_SHADOW_TRANSLUCENT>0)
                        Screen->DrawTile(1, x, y, tile, 1, 1, GH_SHADOW_CSET,
                                         -1, -1, 0, 0, 0, 0, true, OP_TRANS);
                    else
                        Screen->DrawTile(1, x, y, tile, 1, 1, GH_SHADOW_CSET,
                                         -1, -1, 0, 0, 0, 0, true, OP_OPAQUE);
                }
            }
        }
        if(!Ghost_Waitframe(this, ghost, false, false)){
            for(int i=0; i<9; i++){
                if(Segment[i]->isValid()){
                    if(ghost->HP<1)
                        Segment[i]->HP = 0;
                }
            }
            this->Data=0;
            Ghost_Data=0;
            Quit();
        }
    }
    void run(int enemyid){
        npc ghost = Ghost_InitAutoGhost(this, enemyid);
       
        Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
        Ghost_SetFlag(GHF_IGNORE_NO_ENEMY);
        Ghost_SetFlag(GHF_FAKE_Z);
        Ghost_SetFlag(GHF_NO_FALL);
       
        int SegmentID = ghost->Attributes[0];
        int NumSegments = Max(4, ghost->Attributes[1]);
        int HeadTrim = ghost->Attributes[2];
        int Segment1Trim = ghost->Attributes[3];
        int Segment2Trim = ghost->Attributes[4];
        int Segment3Trim = ghost->Attributes[5];
        int RockSprite = ghost->Attributes[6];
       
        npc Segment[9];
        int SegmentX[160];
        int SegmentY[160];
        int SegmentZ[160];
        for(int i=0; i<160; i++){
            SegmentX[i] = -16;
            SegmentY[i] = -16;
            SegmentZ[i] = 0;
        }
        Ghost_X = -16;
        Ghost_Y = -16;
        ghost->X = -16;
        ghost->Y = -16;
        Ghost_SetHitOffsets(ghost, HeadTrim, HeadTrim, HeadTrim, HeadTrim);
        int OriginalTile = ghost->Tile;
		int OrigTail;
        for(int i=0; i<NumSegments; i++){
            Segment[i] = CreateNPCAt(SegmentID, Ghost_X, Ghost_Y);
            if(i==NumSegments-1){
                Segment[i]->OriginalTile += 1;
                Segment[i]->Tile += 1;
				OrigTail = Segment[i]->OriginalTile;
                Ghost_SetHitOffsets(Segment[i], Segment2Trim, Segment2Trim, Segment2Trim, Segment2Trim);
            }
            else
                Ghost_SetHitOffsets(Segment[i], Segment1Trim, Segment1Trim, Segment1Trim, Segment1Trim);
            Ghost_SetAllDefenses(Segment[i], NPCDT_IGNORE);
        }
        while(true){
            for(int i=0; i<90; i++){
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
            int StartCombo = FindSpawnPoint(true, false, false, false);
            int MinX = ComboX(StartCombo)/16-LANMOLA_MAX_RANGE;
            int MaxX = ComboX(StartCombo)/16+LANMOLA_MAX_RANGE;
            int MinY = ComboY(StartCombo)/16-LANMOLA_MAX_RANGE;
            int MaxY = ComboY(StartCombo)/16+LANMOLA_MAX_RANGE;
            int EndCombo;
            for(int i=0; i<120; i++){
                int X = Rand(MinX, MaxX)*16;
                int Y = Rand(MinY, MaxY)*16;
                EndCombo = ComboAt(X+8, Y+8);
                if((Screen->ComboT[EndCombo]==CT_NONE||Screen->ComboT[EndCombo]==CT_WALKSLOW)&&Screen->ComboS[EndCombo]==0000b&&Screen->ComboF[EndCombo]!=96&&Screen->ComboF[EndCombo]!=97&&EndCombo!=StartCombo&&Abs(X-ComboX(StartCombo))/16>=LANMOLA_MIN_RANGE&&Abs(Y-ComboY(StartCombo))/16>=LANMOLA_MIN_RANGE)
                    break;
                else EndCombo = -1;
            }
            while(EndCombo<0){
                int Combo = Rand(0, 175);
                if(Screen->ComboT[Combo]==CT_NONE&&Screen->ComboS[Combo]==0000b&&Combo!=StartCombo)
                    EndCombo = Combo;
            }
            for(int i=0; i<8/(ghost->Step/100); i++){
                Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE, CS_LANMOLA_EMERGE, 128);
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
            for(int i=0; i<8/(ghost->Step/100); i++){
                Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE+1, CS_LANMOLA_EMERGE, 128);
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
            for(int i=0; i<8/(ghost->Step/100); i++){
                Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE+2, CS_LANMOLA_EMERGE, 128);
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
            if(RockSprite>0){
				int j = 0;
				if (Rand(2) < 1) j = 45;
                for(int i=0; i<4; i++){
                    eweapon e = FireEWeapon(EW_SCRIPT10, ComboX(StartCombo), ComboY(StartCombo), DegtoRad((i * 90) + j), 250, ghost->WeaponDamage, RockSprite, SFX_ROCK, EWF_UNBLOCKABLE);
                    e->HitWidth = 8;
                    e->HitHeight = 8;
                    e->HitXOffset = 4;
                    e->HitYOffset = 4;
                }
            }
            Ghost_X = ComboX(StartCombo);
            Ghost_Y = ComboY(StartCombo);
            int SegmentDist = Round(8/(ghost->Step/100));
            int FloatDistance = Distance(Ghost_X, Ghost_Y, ComboX(EndCombo), ComboY(EndCombo));
            int FloatAngle = Angle(Ghost_X, Ghost_Y, ComboX(EndCombo), ComboY(EndCombo));
            int FloatFrames = FloatDistance/(ghost->Step/100);
            ghost->OriginalTile = OriginalTile+AngleDir8(FloatAngle)+1;
            ghost->Tile = OriginalTile+AngleDir8(FloatAngle)+1;
			Segment[NumSegments-1]->Tile = OrigTail+AngleDir8(FloatAngle);
			Segment[NumSegments-1]->OriginalTile = OrigTail+AngleDir8(FloatAngle);
			//Ghost_Dir = AngleDir8(FloatAngle);
            bool DrawStartPoint = true;
            for(int i=0; i<FloatFrames; i++){
                if(SegmentX[SegmentDist*(NumSegments-2)]==-16)
                    Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE+2, CS_LANMOLA_EMERGE, 128);
                else if(SegmentX[SegmentDist*(NumSegments-1)]==-16)
                    Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE+1, CS_LANMOLA_EMERGE, 128);
                else if(SegmentX[SegmentDist*(NumSegments)]==-16)
                    Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE, CS_LANMOLA_EMERGE, 128);
                else if(SegmentX[SegmentDist*(NumSegments)]>-16)DrawStartPoint = false;
                int HalfA = 180/FloatFrames;
                int FullA = 360/FloatFrames;
                int Height = Clamp(FloatDistance/4, 8, 40);
                if(FloatDistance<48)Ghost_Z = Height*Sin(i*HalfA);
                else
                    Ghost_Z = Height*Sin(i*HalfA)+Floor(Height/6)*Sin(i*FullA*(Floor(FloatDistance/32)+0.5));
                Ghost_X += VectorX(ghost->Step/100, FloatAngle);
                Ghost_Y += VectorY(ghost->Step/100, FloatAngle);
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
            int X = Ghost_X;
            int Y = Ghost_Y;
            Ghost_X = -16;
            Ghost_Y = -16;
            while(AboveGround(Segment)){
                if(DrawStartPoint){
                    if(SegmentX[SegmentDist*(NumSegments)]>-16)DrawStartPoint = false;
                    else{
                        if(SegmentX[SegmentDist*(NumSegments-2)]==-16)
                            Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE+2, CS_LANMOLA_EMERGE, 128);
                        else if(SegmentX[SegmentDist*(NumSegments-1)]==-16)
                            Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE+1, CS_LANMOLA_EMERGE, 128);
                        else if(SegmentX[SegmentDist*(NumSegments)]==-16)
                            Screen->FastCombo(2, ComboX(StartCombo), ComboY(StartCombo), CMB_LANMOLA_EMERGE, CS_LANMOLA_EMERGE, 128);
                    }
                }
                Screen->FastCombo(2, X, Y, CMB_LANMOLA_EMERGE+2, CS_LANMOLA_EMERGE, 128);
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
            for(int i=0; i<8/(ghost->Step/100); i++){
                Screen->FastCombo(2, X, Y, CMB_LANMOLA_EMERGE+1, CS_LANMOLA_EMERGE, 128);
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
            for(int i=0; i<8/(ghost->Step/100); i++){
                Screen->FastCombo(2, X, Y, CMB_LANMOLA_EMERGE, CS_LANMOLA_EMERGE, 128);
                Lanmola_Waitframe(this, ghost, Segment, SegmentX, SegmentY, SegmentZ);
            }
        }
    }
}
