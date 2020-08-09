

//Constants used by Ice Combos
const int CT_ICECOMBO = 143; //The combo type "Script1 by default"
const int ICE_ACCELERATION = 4;
const int ICE_DECELERATION = 2;
const int ICE_MAXSTEP     = 150;

//Declare global variables used by Ice Combos.
bool isScrolling;
bool onice;
float Ice_X;
float Ice_Y;
int Ice_XStep;
int Ice_YStep;
bool WasOnIce = false;
int lastPositionX[7];
int lastPositionY[7];
//End declaration

//Active Script
global script slot2_icecombos
{
    void run()
    {
        //Setup variables for ice combos.
        Setup_IceCombos();

        //Variable that stores Game->GetCurScreen() the previous frame.
        int oldscreen = Game->GetCurScreen();

        //Main Loop
        while(true)
        {
            Waitdraw();
            Update_IceCombos(oldscreen);
            oldscreen = Game->GetCurScreen();
            Waitframe();
        }
    }
}


//Initializes global variables used for ice combos.
void Setup_IceCombos()
{
    isScrolling = false;
    onice = false;
    Ice_X = 0;
    Ice_Y = 0;
    Ice_XStep = 0;
    Ice_YStep = 0;
}

//Adds Ice Combo functionally to CT_ICECOMBO;
void Update_IceCombos(int oldscreen)
{
    //Update Variables
    if(Link->Action != LA_SCROLLING)
    {
        if(isScrolling || oldscreen != Game->GetCurScreen() || (!onice && OnIce()))
        {
            Ice_X = Link->X;
            Ice_Y = Link->Y;
            if(isScrolling)
                isScrolling = false;
            else
            {
                Ice_XStep = 0;
                Ice_YStep = 0;
            }
        }
        onice = OnIce();
    }
    else
    {
        isScrolling = true;
        return;
    }

    //Ice Physics
    if(onice)
    {
		if (!WasOnIce && Link->Action != LA_GOTHURTLAND && Link->Action != LA_HOPPING)
		{
			int Average = ((Distance(lastPositionX[6], lastPositionY[6], lastPositionX[5], lastPositionY[5]) + 
			Distance(lastPositionX[5], lastPositionY[5], lastPositionX[4], lastPositionY[4]) + 
			Distance(lastPositionX[4], lastPositionY[4], lastPositionX[3], lastPositionY[3]) + 
			Distance(lastPositionX[3], lastPositionY[3], lastPositionX[2], lastPositionY[2]) + 
			Distance(lastPositionX[2], lastPositionY[2], lastPositionX[1], lastPositionY[1]) + 
			Distance(lastPositionX[1], lastPositionY[1], lastPositionX[0], lastPositionY[0]) + 
			Distance(lastPositionX[0], lastPositionY[0], Link->X, Link->Y)) / 7);
			int angleice = Angle(lastPositionX[0], lastPositionY[0], Link->X, Link->Y);
			if (false)
			{
				int icedir = AngleDir8(angleice);
				if (icedir == DIR_UP) Ice_YStep = -150;
				else if (icedir == DIR_DOWN) Ice_YStep = 150;
				else if (icedir == DIR_LEFT) Ice_XStep = -150;
				else if (icedir == DIR_RIGHT) Ice_XStep = 150;
				
				else if (icedir == DIR_LEFTUP)
				{
					Ice_XStep = -100;
					Ice_YStep = -100;
				}
				else if (icedir == DIR_RIGHTUP)
				{
					Ice_XStep = 100;
					Ice_YStep = -100;
				}
				else if (icedir == DIR_LEFTDOWN)
				{
					Ice_XStep = -100;
					Ice_YStep = 100;
				}
				else if (icedir == DIR_RIGHTDOWN)
				{
					Ice_XStep = 100;
					Ice_YStep = 100;
				}
			}
			Ice_XStep = VectorX(Average * 100, angleice);
			Ice_YStep = VectorY(Average * 100, angleice);
		}
		WasOnIce = true;
        //Y Adjustment
        if(Link_Walking() && (Link->InputUp || Link->InputDown))
        {
			if (!IsFreezing)
			{
				if(Link->InputUp && !Link->InputDown)
					Ice_YStep -= ICE_ACCELERATION;
				else if(!Link->InputUp && Link->InputDown)
					Ice_YStep += ICE_ACCELERATION;
			}
			else
			{
				if(Link->InputUp && !Link->InputDown)
					Ice_YStep -= ICE_ACCELERATION / 3;
				else if(!Link->InputUp && Link->InputDown)
					Ice_YStep += ICE_ACCELERATION / 3;
			}
        }
        else if(Ice_YStep != 0)
            Ice_YStep = Cond(Abs(Ice_YStep) - ICE_DECELERATION > 0, Ice_YStep - Sign(Ice_YStep)*ICE_DECELERATION, 0);
        if (!IsFreezing) Ice_YStep = Clamp(Ice_YStep, -ICE_MAXSTEP, ICE_MAXSTEP);
		else Ice_YStep = Clamp(Ice_YStep, (-ICE_MAXSTEP) / 3, ICE_MAXSTEP / 3);

        //X Adjustment
        if(Link_Walking() && (Link->InputLeft || Link->InputRight))
        {
			if (!IsFreezing) 
			{
				if(Link->InputLeft && !Link->InputRight)
					Ice_XStep -= ICE_ACCELERATION;
				else if(!Link->InputLeft && Link->InputRight)
					Ice_XStep += ICE_ACCELERATION;
			}
			else
			{
				if(Link->InputLeft && !Link->InputRight)
					Ice_XStep -= ICE_ACCELERATION / 3;
				else if(!Link->InputLeft && Link->InputRight)
					Ice_XStep += ICE_ACCELERATION / 3;
			}
        }
        else if(Ice_XStep != 0)
            Ice_XStep = Cond(Abs(Ice_XStep) - ICE_DECELERATION > 0, Ice_XStep -Sign(Ice_XStep)*ICE_DECELERATION, 0);
        if (!IsFreezing) Ice_XStep = Clamp(Ice_XStep, -ICE_MAXSTEP, ICE_MAXSTEP);
		else Ice_XStep = Clamp(Ice_XStep, (-ICE_MAXSTEP) / 3, ICE_MAXSTEP / 3);

        //Reset the Ice Position to Link's Actual Position if he's hurt or hopping out of water.
        if(Link->Action == LA_GOTHURTLAND || Link->Action == LA_HOPPING)
        {
            Ice_X = Link->X;
            Ice_Y = Link->Y;
        }

        //Initialize variables for solidity checking.
        int newx = (Ice_X + Ice_XStep/100)<<0;
        int newy = (Ice_Y + Ice_YStep/100)<<0;

        //Vertical Edge
        if(newx < Ice_X<<0)
        {
            for(int y = Ice_Y+Cond(BIG_LINK, 0, 8); y < (Ice_Y<<0) + 16 && Ice_XStep != 0; y++)
            {
                if(Screen->isSolid(newx, y))
                    Ice_XStep = 0;
            }
        }
        else if(newx > Ice_X<<0)
        {
            for(int y = Ice_Y+8; y < (Ice_Y<<0) + 16 && Ice_XStep != 0; y++)
            {
                if(Screen->isSolid(newx+15, y))
                    Ice_XStep = 0;
            }
        }

        //Horizontal Edge
        if(newy < Ice_Y<<0)
        {
            for(int x = Ice_X; x < (Ice_X<<0) + 16 && Ice_YStep != 0; x++)
            {
                if(Screen->isSolid(x, newy+Cond(BIG_LINK, 0, 8)))
                {
                    Ice_YStep = 0;
                }
            }
        }
        else if(newy > Ice_Y<<0)
        {
            for(int x = Ice_X; x < (Ice_X<<0) + 16 && Ice_YStep != 0; x++)
            {
                if(Screen->isSolid(x, newy+15))
                {
                    Ice_YStep = 0;
                }
            }
        }
		lweapon hookshot = LoadLWeaponOf(LW_HOOKSHOT);
		if(hookshot->isValid())
		{
			Ice_X = Link->X;
			Ice_Y = Link->Y;
			Ice_XStep = 0;
			Ice_YStep = 0;
		}
		else
		{
			Ice_X += Ice_XStep/100;
			Ice_Y += Ice_YStep/100;
			Link->X = Ice_X;
			Link->Y = Ice_Y;
		}
    }
    else
    {
        Ice_XStep = 0;
        Ice_YStep = 0;
		WasOnIce = false;
    }
	lastPositionX[6] = lastPositionX[5];
	lastPositionY[6] = lastPositionY[5];
	lastPositionX[5] = lastPositionX[4];
	lastPositionY[5] = lastPositionY[4];
	lastPositionX[4] = lastPositionX[3];
	lastPositionY[4] = lastPositionY[3];
	lastPositionX[3] = lastPositionX[2];
	lastPositionY[3] = lastPositionY[2];
	lastPositionX[2] = lastPositionX[1];
	lastPositionY[2] = lastPositionY[1];
	lastPositionX[1] = lastPositionX[0];
	lastPositionY[1] = lastPositionY[0];
	lastPositionX[0] = Link->X;
	lastPositionY[0] = Link->Y;
}

//Function used to check if Link is over a ice combo.
bool OnIce()
{
    if(Link->Z != 0)
        return false;
    else
    {
        int comboLoc = ComboAt(Link->X + 8, Link->Y + 12);
        if(Screen->ComboT[comboLoc] == CT_ICECOMBO)
            return true;
        else if(Screen->LayerMap(1) != -1 && Screen->LayerScreen(1) != -1 && GetLayerComboT(1, comboLoc) == CT_ICECOMBO)
            return true;
        else if(Screen->LayerMap(2) != -1 && Screen->LayerScreen(2) != -1 && GetLayerComboT(2, comboLoc) == CT_ICECOMBO)
            return true;
        else
            return false;
    }
}

//Returns true, if keyboard input is moving Link.
bool Link_Walking()
{
    if(UsingItem(I_HAMMER)) return false;
    else return (Link->Action == LA_WALKING || Link->Action == LA_CHARGING || Link->Action == LA_SPINNING);
}