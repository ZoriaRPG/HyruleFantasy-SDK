void DrawLayer3()
{
	if (ScreenFlag(SF_VIEW, 5) == 0 && Link->Action != LA_SCROLLING)
	{
		for (int i = 0; i < 176; i++)
		{
			if (Screen->LayerMap(3) > 1 || Screen->LayerScreen(3) > 0)
			{
				int meh = GetLayerComboD(3, i);
				int cset = Game->GetComboCSet(Screen->LayerMap(3), Screen->LayerScreen(3), i);
				if (meh != 0) Screen->FastCombo(3, ComboX(i), ComboY(i), meh, cset, 128);
			}
		}
	}
}