ffc script Lever{
	void run(int lifted, int trap, int count){
		int pullcount = 0;
		while(true){
			if(this->InitD[0]==0){
				SolidObjects_Add(this->X, this->Y, 16, 16);
			}
			else if (pullcount <= 16)
			{
				if ((pullcount % 3) == 0 || (pullcount % 3) == 2) this->Y++;
				else this->Y--;
				if (pullcount == 16)
				{
					powerBracelet[LINK_CATCHING] = 0;
					if (trap > 0)
					{
						Game->PlaySound(SFX_SWITCH_ERROR);
						for(int i=0; i<count; i++){
							int pos = Switch_GetSpawnPos();
							npc n = CreateNPCAt(trap, ComboX(pos), ComboY(pos));
							Game->PlaySound(SFX_FALL);
							n->Z = 176;
							Waitframes(20);
						}
					}
					else
					{
						Game->PlaySound(SFX_SECRET);
						Screen->TriggerSecrets();
						if(count > 0)
							Screen->State[ST_SECRET] = true;
					}
				}
				pullcount++;
			}
			else 
			{
				SolidObjects_Add(this->X, this->Y, 16, 16);
			}
			Waitframe();
		}
	}
	int Switch_GetSpawnPos(){
		int pos;
		bool invalid = true;
		int failSafe = 0;
		while(invalid&&failSafe<512){
			pos = Rand(176);
			if(Switch_ValidSpawn(pos))
				return pos;
		}
		for(int i=0; i<176; i++){
			pos = i;
			if(Switch_ValidSpawn(pos))
				return pos;
		}
	}
	bool Switch_ValidSpawn(int pos){
		int x = ComboX(pos);
		int y = ComboY(pos);
		if(Screen->isSolid(x+4, y+4)||
			Screen->isSolid(x+12, y+4)||
			Screen->isSolid(x+4, y+12)||
			Screen->isSolid(x+12, y+12)){
			return false;
		
		}
		if(ComboFI(pos, CF_NOENEMY)||ComboFI(pos, CF_NOGROUNDENEMY))
			return false;
		int ct = Screen->ComboT[pos];
		if(ct==CT_NOENEMY||ct==CT_NOGROUNDENEMY||ct==CT_NOJUMPZONE)
			return false;
		if(ct==CT_WATER||ct==CT_LADDERONLY||ct==CT_HOOKSHOTONLY||ct==CT_LADDERHOOKSHOT)
			return false;
		if(ct==CT_PIT||ct==CT_PITB||ct==CT_PITC||ct==CT_PITD||ct==CT_PITR)
			return false;
		return true;
	}
}