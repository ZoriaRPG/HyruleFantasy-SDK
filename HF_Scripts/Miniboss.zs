//const int CMB_BLANK        = 1; //ID of a transparent, non-zero combo with no combotype
const int SFX_WARPING    = 105; //Sound effect to play when spinning in the warp
const int CMB_AUTOWARPA    = 3128; //ID of a transparent Autowarp A type combo

const int LI_MINIBOSS    = 0x20;
const int LI_MINIBOSS2    = 0x40;

ffc script MiniBossRoom
{
    void run(int portal)
    {
        int orig = this->Data;
        this->Data = CMB_BLANK;
        Waitframes(4);
        
		int beatables = 0;
		npc enemy;
		for (int i = 1; i <= Screen->NumNPCs(); i++)
		{
			enemy = Screen->LoadNPC(i);
			if ((enemy->MiscFlags & 0x08) == 0)
			{
				beatables++;
			}
		}
        if(beatables > 0)
            MiniBossPause(portal);
        
        Portal(this, orig, portal);
    }
    
    void MiniBossPause(int portal)
    {
        if(GetLevelItem(Game->GetCurLevel(), LI_MINIBOSS) && portal <= 0 || GetLevelItem(Game->GetCurLevel(), LI_MINIBOSS2) && portal > 0)
        {
            npc n;
            for(int i = Screen->NumNPCs(); i > 0; i--)
            {
                n = Screen->LoadNPC(i);
                n->HP = 0; n->X = 512;
            }
            return;
        }
        
		int beatables = 0;
		npc enemy;
		for (int i = 1; i <= Screen->NumNPCs(); i++)
		{
			enemy = Screen->LoadNPC(i);
			if ((enemy->MiscFlags & 0x08) == 0)
			{
				beatables++;
			}
		}
        while (beatables > 0)
		{
			beatables = 0;
			for (int i = 1; i <= Screen->NumNPCs(); i++)
			{
				enemy = Screen->LoadNPC(i);
				if ((enemy->MiscFlags & 0x08) == 0)
				{
					beatables++;
				}
			}
			Waitframe();
		}
        
        if (portal <= 0) SetLevelItem(Game->GetCurLevel(), LI_MINIBOSS, true);
		else SetLevelItem(Game->GetCurLevel(), LI_MINIBOSS2, true);
    }
    
    void Portal(ffc portal, int orig, int port)
    {
        if(!(GetLevelItem(Game->GetCurLevel(), LI_MINIBOSS) && port <= 0) && !(GetLevelItem(Game->GetCurLevel(), LI_MINIBOSS2) && port > 0))
            return;
        
        while(RectCollision(portal->X + 5, portal->Y + 9, portal->X + 10, portal->Y + 14, Link->X + 5, Link->Y + 9, Link->X + 10, Link->Y + 14))
            Waitframe();
        
        portal->Data = orig;
        
        while(!RectCollision(portal->X + 6, portal->Y + 10, portal->X + 9, portal->Y + 13, Link->X + 6, Link->Y + 10, Link->X + 9, Link->Y + 13))
            Waitframe();
        
        Game->PlaySound(SFX_WARPING);
        Link->Dir = DIR_DOWN;
        
        for(int i = 6; i > 0; i--)
        {
            for(int j = 3; j >= 0; j--)
            {
                Link->Dir = SpinDir(j);
                WaitNoAction(i);
            }
        }
        
        if (port <= 0) portal->Data = CMB_AUTOWARPA + 1;
		else portal->Data = CMB_AUTOWARPA + 2;
    }
}