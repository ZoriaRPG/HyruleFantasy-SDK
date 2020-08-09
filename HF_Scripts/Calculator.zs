ffc script Calculator
{
	
	void run()
	{
		int dist = Distance(0, 7, 2, 11);
		int ang = Angle(0, 7, 2, 11);
		Trace(VectorX(dist, ang - 60));
		Trace(VectorY(dist, ang - 60));
		Trace(VectorX(dist, ang + 60));
		Trace(VectorY(dist, ang + 60));
	}
}