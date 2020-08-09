ffc script CircularMotion{
    void run(int radius, int speed, int angle, int radius2){
        if(radius2 == 0) radius2 = radius;
        int x = this->X; int y = this->Y;
        for(;true;angle++){
            this->X = x + radius*Cos(angle*speed);
            this->Y = y + radius2*Sin(angle*speed);
            angle %= 360;
            Waitframe();
        }
    }
}