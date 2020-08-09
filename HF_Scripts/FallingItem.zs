ffc script fallingitem
{
	void run()
	{
		if (Screen->State[ST_ITEM] || Screen->State[ST_SPECIALITEM])
		{
			this->Data = 0;
			Quit();
		}
		
		while (true)
		{
			if (Screen->State[ST_ITEM] || Screen->State[ST_SPECIALITEM] || Link->Action == HOLD1WATER || Link->Action == HOLD2WATER)
			{
				this->Data = 0;
				Quit();
			}
			Waitframe();
		}
	}
}