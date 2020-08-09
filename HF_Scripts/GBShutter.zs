const int SFX_GBSHUTTER = 9; //Sound that plays when a GBShutter opens/closes

ffc script GBShutter{
	void run(int OneWay){
		int ShutterCombo = this->Data;
		this->Data = FFCS_INVISIBLE_COMBO;
		int ComboPos = ComboAt(this->X+8, this->Y+8);
		int UnderCombo = Screen->ComboD[ComboPos];
		int UnderCSet = Screen->ComboC[ComboPos];
		if((OneWay||(Screen->ComboF[ComboPos]>0||Screen->ComboI[ComboPos]>0))&&(Abs(this->X-Link->X)>6||Abs(this->Y-Link->Y)>6)){
			Game->PlaySound(SFX_GBSHUTTER);
			Screen->ComboD[ComboPos] = ShutterCombo;
			Screen->ComboC[ComboPos] = this->CSet;
		}
		while(true){
			if(Abs(this->X-Link->X)<16&&Abs(this->Y-Link->Y)<16){
				while(Abs(this->X-Link->X)<16&&Abs(this->Y-Link->Y)<16){
					if(!OneWay&&(Screen->ComboF[ComboPos]==0&&Screen->ComboI[ComboPos]==0)){
						Quit();
					}
					Waitframe();
				}
				Game->PlaySound(SFX_GBSHUTTER);
				Screen->ComboD[ComboPos] = ShutterCombo;
				Screen->ComboC[ComboPos] = this->CSet;
			}
			while(Abs(this->X-Link->X)>6||Abs(this->Y-Link->Y)>6){
				if(!OneWay&&(Screen->ComboF[ComboPos]==0&&Screen->ComboI[ComboPos]==0)){
					Quit();
				}
				Waitframe();
			}
			Game->PlaySound(SFX_GBSHUTTER);
			Screen->ComboD[ComboPos] = UnderCombo;
			Screen->ComboC[ComboPos] = UnderCSet;
		}
	}
}

