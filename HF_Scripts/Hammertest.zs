ffc script HammerTimeAction
{
	void run()
	{
		while(true)
		{
			if (Link->Action != 0) Trace(Link->Action);
			Waitframe();
		}
	}
}