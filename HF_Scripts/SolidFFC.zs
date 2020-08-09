const int MAX_SOLIDOBJ = 32; //Maximum number of solid objects

const int __SOLIDOBJ_COUNT = 0; //Array index keeping track of the number of solid objects

//Array indices (1+4*y+x) for various attributes of each object 
//where y is the object ID and x is the property
const int SOLIDOBJ_X = 0;
const int SOLIDOBJ_Y = 1;
const int SOLIDOBJ_WIDTH = 2;
const int SOLIDOBJ_HEIGHT = 3;

int solidObjects[129]; //Buffer for the solid object. Size should be 1+MAX_SOLIDOBJ*4

void SolidObjects_Add(int x, int y, int width, int height){
	int i = 1+solidObjects[__SOLIDOBJ_COUNT]*4; //Get the starting index of the object
	
	//Set all the object's attributes
	solidObjects[i+SOLIDOBJ_X] = x;
	solidObjects[i+SOLIDOBJ_Y] = y;
	solidObjects[i+SOLIDOBJ_WIDTH] = width;
	solidObjects[i+SOLIDOBJ_HEIGHT] = height;
	
	//Increment the count so the script knows where to add the next object
	solidObjects[__SOLIDOBJ_COUNT] = Min(solidObjects[__SOLIDOBJ_COUNT]+1, MAX_SOLIDOBJ);
}

void SolidObjects_Update(){
	int totalUp;
	int totalDown;
	int totalLeft;
	int totalRight;
	
	int tempVx;
	int tempVy;
	
	int x; int y; int width; int height;
	int linkX = Link->X+3;
	int linkY = Link->Y+8;
	int linkWidth = 10;
	int linkHeight = 8;
	
	for(int i=0; i<MAX_SOLIDOBJ; i++){ //Cycle through all possible objects
		x = solidObjects[1+i*4+SOLIDOBJ_X];
		y = solidObjects[1+i*4+SOLIDOBJ_Y];
		width = solidObjects[1+i*4+SOLIDOBJ_WIDTH];
		height = solidObjects[1+i*4+SOLIDOBJ_HEIGHT];
		if(width>0){ //Check if there's a solid object at the current index
			//Screen->Rectangle(2, x, y, x+width-1, y+height-1, 0x01, 1, 0, 0, 0, true, 64);
			if(RectCollision(x, y, x+width-1, y+height-1, linkX, linkY, linkX+linkWidth-1, linkY+linkHeight-1)){
				//Screen->DrawInteger(6, 8, 48, FONT_Z1, 0x01, 0x0F, -1, -1, 1, 0, 128);
				
				//Find Link and the object's center points
				int cx1 = x+width/2;
				int cy1 = y+height/2;
				int cx2 = linkX+linkWidth/2;
				int cy2 = linkY+linkHeight/2;
				
				if(cy2<cy1){ //Link is above the object
					tempVy = cy1-cy2-(height+linkHeight)/2;
				}
				else{ //Link is below the object
					tempVy = cy1-cy2+(height+linkHeight)/2;
				}
				
				if(cx2<cx1){ //Link is left of the object
					tempVx = cx1-cx2-(width+linkWidth)/2;
				}
				else{
					tempVx = cx1-cx2+(width+linkWidth)/2;
				}
				
				if(Abs(tempVy)<Abs(tempVx)){ //Find out which push would take less effort
					if(tempVy<0){ //If it's an upwards push
						if(totalUp>tempVy) //If it's larger than the current max
							totalUp = tempVy; //Update the current max
					}
					else if(tempVy>0){ //If it's a downwards push
						if(totalDown<tempVy) //If it's larger than the current max
							totalDown = tempVy; //Update the current max
					}
				}
				else{
					if(tempVx<0){ //If it's a left push
						if(totalLeft>tempVx) //If it's larger than the current max
							totalLeft = tempVx; //Update the current max
					}
					else if(tempVx>0){ //If it's a right push
						if(totalRight<tempVx) //If it's larger than the current max
							totalRight = tempVx; //Update the current max
					}
				}
			}
			
			//Clear the properties when done
			solidObjects[1+i*4+SOLIDOBJ_X] = 0;
			solidObjects[1+i*4+SOLIDOBJ_Y] = 0;
			solidObjects[1+i*4+SOLIDOBJ_WIDTH] = 0;
			solidObjects[1+i*4+SOLIDOBJ_HEIGHT] = 0;
		}
	}
	
	//Reset the count
	solidObjects[__SOLIDOBJ_COUNT] = 0;
	
	// Screen->DrawInteger(6, 8, 8, FONT_Z1, 0x01, 0x0F, -1, -1, totalUp, 0, 128);
	// Screen->DrawInteger(6, 8, 16, FONT_Z1, 0x01, 0x0F, -1, -1, totalDown, 0, 128);
	// Screen->DrawInteger(6, 8, 24, FONT_Z1, 0x01, 0x0F, -1, -1, totalLeft, 0, 128);
	// Screen->DrawInteger(6, 8, 32, FONT_Z1, 0x01, 0x0F, -1, -1, totalRight, 0, 128);
	
	LinkMovement_Push2NoEdge(totalLeft+totalRight, totalUp+totalDown); //Move Link by the combination of strongest inputs. Opposing Left/Right, Up/Down should cancel out
}