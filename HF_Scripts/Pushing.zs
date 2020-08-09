const int LTM_PUSHING = 160; // LTM for Link pushing a block with the Power Bracelet

bool NoPush = false;

void PushAnimation()
{
	if (((!CanWalk(Link->X, Link->Y, Link->Dir, 1, false) || pushing ||
	(Link->Dir == AngleDir4(Angle(Link->X + 7, Link->Y + 11, Screen->MovingBlockX + 7, Screen->MovingBlockY + 7)) 
	&& Screen->MovingBlockX > -1 && Screen->MovingBlockY > -1 
	&& RectCollision(Link->X, Link->Y + 8, Link->X + 15, Link->Y + 15, 
	Screen->MovingBlockX - 2, Screen->MovingBlockY - 2, Screen->MovingBlockX + 16, Screen->MovingBlockY + 16)))
	&& Link->Action == LA_WALKING && powerBracelet[HOLDING_BLOCK] <= 0 && holding_bomb <= 0) && !NoPush)
	{
		if(Link->Item[LTM_PULLING]) Link->Item[LTM_PULLING] = false;
		if(Link->Item[LTM_CATCHING]) Link->Item[LTM_CATCHING] = false;
		if(Link->Item[LTM_HOLDING]) Link->Item[LTM_HOLDING] = false;
		if(!Link->Item[LTM_PUSHING]) Link->Item[LTM_PUSHING] = true;
	}
	else
	{
		if(Link->Item[LTM_PUSHING]) Link->Item[LTM_PUSHING] = false;
	}
	NoPush = false;
}