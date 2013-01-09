int srcWidth = 256;
int srcHeight = 256;
float oScale = 1.0;

float[][] data;

void setup () {
  size(floor(srcWidth * oScale), floor(srcHeight * oScale));
  data = new float[srcWidth][srcHeight]; 
}

void draw ()
{
  for (int x = 0; x < srcWidth; x++) {
     for (int y = 0; y < srcHeight; y++) {
        stroke(random(0.0, 1.0) * 255, random(0.0, 1.0) * 255, random(0.0, 1.0) * 255);
        point(x, y);
     } 
  }
}

void generate () {
  
}


