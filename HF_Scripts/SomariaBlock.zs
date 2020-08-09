bool pushing = false;

const int CMB_SOMARIABLOCK = 10322;
const int CS_SOMARIABLOCK = 8;

const int SFX_SOMARIA = 103;
const int SFX_SOMARIABEAM = 102;

const int SPR_SOMARIABEAM = 113;
const int SPR_SOMARIABEAMTRAIL = 115;
const int SPR_SOMARIAPLATFORMPOOF = 114;

ffc script SomariaBlock
{
	void run()
	{
		this->X = Link->X+InFrontX(Link->Dir, 0);
		this->Y = Link->Y+InFrontY(Link->Dir, 0);
		Game->PlaySound(SFX_SOMARIA);
		lweapon poof = CreateLWeaponAt(LW_SPARKLE, this->X, this->Y);
		poof->UseSprite(22);
		Waitframes(12);
		this->InitD[0] = 1; //State 1: BlockActive
		this->Data = CMB_SOMARIABLOCK;
		this->CSet = CS_SOMARIABLOCK;
		while(this->InitD[0] == 1)
		{
			bool cvdir[4];
			SomariaOnConveyor(this, cvdir);
			int vx;
			int vy;
			if(cvdir[DIR_UP])
				vy -= 0.6;
			else if(cvdir[DIR_DOWN])
				vy += 0.6;
			if(cvdir[DIR_LEFT])
				vx -= 0.6;
			else if(cvdir[DIR_RIGHT])
				vx += 0.6;
			FFC_MoveXY(this, vx, vy);
			if (Link->Dir == AngleDir4(Angle(Link->X + 7, Link->Y + 11, this->X + 7, this->Y + 7)) && pushing == true)
			{
				if (Link->InputUp && Link->Dir == DIR_UP && CanWalk(this->X, this->Y, Link->Dir, 1, true)) this->Y--;
				else if (Link->InputDown && Link->Dir == DIR_DOWN && CanWalk(this->X, this->Y, Link->Dir, 1, true)) this->Y++;
				else if (Link->InputLeft && Link->Dir == DIR_LEFT && CanWalk(this->X, this->Y, Link->Dir, 1, true)) this->X--;
				else if (Link->InputRight && Link->Dir == DIR_RIGHT && CanWalk(this->X, this->Y, Link->Dir, 1, true)) this->X++;
			}
			int onTrack = SomariaOnTrack(this);
			if(onTrack>-1){
				int i = FindSomariaPlatform();
				if(i>-1){
					Game->PlaySound(SFX_SOMARIA);
					ffc f = Screen->LoadFFC(i);
					int combopos = onTrack;
					f->X = ComboX(combopos)-f->InitD[0];
					f->Y = ComboY(combopos)-f->InitD[1];
					f->InitD[3] = 1;
					lweapon poof = CreateLWeaponAt(LW_SPARKLE, f->X-8, f->Y-8);
					poof->UseSprite(SPR_SOMARIAPLATFORMPOOF);
					poof->Extend = 3;
					poof->TileWidth = 3;
					poof->TileHeight = 3;
					this->Data = 0;
					Quit();
				}
			}
			Waitframe();
		}
		this->InitD[0] = 0;
		this->Data = 1;
		lweapon Magic[4];
		for (int i = 0; i < 4; i++)
		{
			Magic[i] = Screen->CreateLWeapon(LW_MAGIC);
			Magic[i]->Damage = 6;
			Magic[i]->Dir = i;
			Magic[i]->X = this->X;
			Magic[i]->Y = this->Y;
			int ang;
			if(i==DIR_UP)
				ang = -90;
			else if(i==DIR_DOWN)
				ang = 90;
			else if(i==DIR_LEFT)
				ang = 180;
			Magic[i]->Angle = DegtoRad(ang);
			Magic[i]->Step = 400;
			Magic[i]->UseSprite(113);
			Magic[i]->OriginalTile+= (i * 3);
			Magic[i]->Tile+= (i * 3);
		}
		int acounter = 0;
		while(BeamsValid(Magic)){
			acounter = (acounter+1)%360;
			for(int i=0; i<4; i++){
				if(Magic[i]->isValid()){
					if(acounter%2==0){
						int x; int y; int a;
						a = RadtoDeg(Magic[i]->Angle);
						x = Magic[i]->X + VectorX(12*Sin(acounter*16), a+90);
						y = Magic[i]->Y + VectorY(12*Sin(acounter*16), a+90);
						lweapon particle = CreateLWeaponAt(LW_SPARKLE, x, y);
						particle->UseSprite(SPR_SOMARIABEAMTRAIL);
						
						x = Magic[i]->X + VectorX(-12*Sin(acounter*16), a+90);
						y = Magic[i]->Y + VectorY(-12*Sin(acounter*16), a+90);
						particle = CreateLWeaponAt(LW_SPARKLE, x, y);
						particle->UseSprite(SPR_SOMARIABEAMTRAIL);
					}
				}
			}
			Waitframe();
		}
		this->Data = 0;
		this->Script = 0;
		Quit();
	}
	bool BeamsValid(lweapon beams){
		for(int i=0; i<4; i++){
			if(beams[i]->isValid())
				return true;
		}
		return false;
	}
	void SomariaOnConveyor(ffc this, bool dir){
		for(int x=0; x<2; x++){
			for(int y=0; y<2; y++){
				int ct = Screen->ComboT[ComboAt(this->X+15*x, this->Y+15*y)];
				if(ct==CT_CVUP)
					dir[DIR_UP] = true;
				else if(ct==CT_CVDOWN)
					dir[DIR_DOWN] = true;
				else if(ct==CT_CVLEFT)
					dir[DIR_LEFT] = true;
				else if(ct==CT_CVRIGHT)
					dir[DIR_RIGHT] = true;
			}
		}
	}
	int SomariaOnSolid(ffc this){
		int onPit;
		int noSolid;
		for(int x=0; x<2; x++){
			for(int y=0; y<2; y++){
				int under = ComboAt(this->X+4+7*x, this->Y+4+7*y);
				if(!Screen->isSolid(this->X+4+7*x, this->Y+4+7*y))
					noSolid++;
				if(Screen->ComboT[under]==CT_HOLELAVA)
					onPit++;
			}
		}
		if(onPit==4)
			return 2;
		if(noSolid>0)
			return 0;
		return 1;
	}
	int SomariaOnTrack(ffc this){
		for(int x=0; x<2; x++){
			for(int y=0; y<2; y++){
				if(Screen->ComboF[ComboAt(this->X+4+7*x, this->Y+4+7*y)]==CF_ELEVATORSTOP)
						return ComboAt(this->X+4+7*x, this->Y+4+7*y);
			}
		}
		return -1;
	}
}

void SomariaBlockCollision()
{
	int SomariaScript[] = "SomariaBlock";
	int SomariaID = Game->GetFFCScript(SomariaScript);
	ffc Somaria = Screen->LoadFFC(FindFFCRunning(SomariaID));
	if (Somaria->Script == SomariaID && Somaria->InitD[0] == 1)
	{
		if (RectCollision(Link->X + 1, Link->Y + 8, Link->X + 14, Link->Y + 15, Somaria->X, Somaria->Y, Somaria->X + 15, Somaria->Y + 15))
		{
			if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_UP)
			{
				Link->Y += (8 - Abs(Link->Y - Somaria->Y));
			}
			else if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_DOWN)
			{
				Link->Y -= (16 - Abs(Link->Y - Somaria->Y));
			}
			else if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_LEFT)
			{
				Link->X += (15 - Abs(Link->X - Somaria->X));
			}
			else if (AngleDir4(Angle(Link->X + 7, Link->Y + 11, Somaria->X + 7, Somaria->Y + 7)) == DIR_RIGHT)
			{
				Link->X -= (15 - Abs(Link->X - Somaria->X));
			}
			pushing = true;
		}
		else pushing = false;
	}
}

const int CMB_SOMARIA = 10323;

int FindSomariaPlatform(){
	FindSomariaPlatform(false);
}

int FindSomariaPlatform(bool activeOnly){
	int ffcs[] = "Elevator";
	int slot = Game->GetFFCScript(ffcs);
	for(int i=1; i<=32; i++){
		ffc f = Screen->LoadFFC(i);
		if(f->Script==slot){
			if(f->InitD[2]==CMB_SOMARIA){
				if(activeOnly){
					if(f->InitD[3]==1)
						return i;
				}
				else
					return i;
			}
		}
	}
	return -1;
}

void FFC_MoveXY(ffc f, int xStep, int yStep){
	int imprecision = 0; //hacking stuff together! woo woo!
    // If moving more than 8 pixels along either axis, go 8 at a time
    while(Abs(xStep)>8 || Abs(yStep)>8)
    {
        if(Abs(xStep)>=Abs(yStep))
        {
            if(xStep>0)
            {
                FFC_MoveXY(f, 8, 0);
                xStep-=8;
            }
            else
            {
                FFC_MoveXY(f, -8, 0);
                xStep+=8;
            }
        }
        else // yStep>=xStep
        {
            if(yStep>0)
            {
                FFC_MoveXY(f, 0, 8);
                yStep-=8;
            }
            else
            {
                FFC_MoveXY(f, 0, -8);
                yStep+=8;
            }
        }
    }
    
    int edge; // Position of leading edge
    int edgeDiff; // Difference between Ghost_X/Ghost_Y and edge
    int startHT; // The half-tile position where the edge starts
    int endHT; // And where it ends up
    
    if(xStep<0) // Left
    {
        edgeDiff=0>>8;
        edge=f->X+edgeDiff;
        
        startHT=Floor(edge/8);
        endHT=Floor((edge+xStep)/8);
        
        // If the edge ends up on the same half-tile line it's already on,
        // there's no need to check walkability
        if(startHT==endHT)
            edge+=xStep;
        else if(CanWalk(f->X, f->Y, DIR_LEFT, -xStep, true))
            edge+=xStep;
        else // Can't move all the way; snap to the grid
            edge=(edge>>3)<<3;
        
        //Enemy_SetAttrib(slot, E_X, edge-edgeDiff);
		f->X = edge-edgeDiff;
    }
    else if(xStep>0) // Right
    {
        edgeDiff=16-(0&0xFF)-1;
        edge=f->X+edgeDiff;
        
        startHT=Floor(edge/8);
        endHT=Floor((edge+xStep)/8);
        
        if(startHT==endHT)
            edge+=xStep;
        else if(CanWalk(f->X, f->Y, DIR_RIGHT, xStep, true))
            edge+=xStep;
        else
            edge=(((edge+7)>>3)<<3)-1;
        
        //Enemy_SetAttrib(slot, E_X, edge-edgeDiff);
		f->X = edge-edgeDiff;
    }
    
    if(yStep<0) // Up
    {
        edgeDiff=0>>8;
        edge=f->Y+edgeDiff;
        
        startHT=Floor(edge/8);
        endHT=Floor((edge+yStep)/8);
        
        // If the edge ends up on the same half-tile line it's already on,
        // there's no need to check walkability
        if(startHT==endHT)
            edge+=yStep;
        else if(CanWalk(f->X, f->Y, DIR_UP, -yStep, true))
            edge+=yStep;
        else // Can't move all the way; snap to the grid
            edge=(edge>>3)<<3;
        
        //Enemy_SetAttrib(slot, E_Y, edge-edgeDiff);
		f->Y = edge-edgeDiff;
    }
    else if(yStep>0) // Down
    {
        edgeDiff=16-(0&0xFF)-1;
        edge=f->Y+edgeDiff;
        
        startHT=Floor(edge/8);
        endHT=Floor((edge+yStep)/8);
        
        if(startHT==endHT)
            edge+=yStep;
        else if(CanWalk(f->X, f->Y, DIR_DOWN, yStep, true))
            edge+=yStep;
        else
            edge=(((edge+7)>>3)<<3)-1;
        
        f->Y = edge-edgeDiff;
    }
}