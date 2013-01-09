int width = 128;

int slip = 0;

float res = sqrt(width) * 5;

void setup (){
  size(width, width);
}


void draw () {
  fill(0);
  rect(0, 0, width, width);
  float cx, cy;
  cx = width * 0.5;
  cy = width * 0.5;
  
  for (int i = slip; i < 360 - slip; i++) {
    if (random(1) > 0.5) {
      continue;
    }
    float angle = i * (TWO_PI / 360);
    float x = cx + sin(angle) * (cx * 0.9);
    float y = cy + cos(angle) * (cy * 0.9);
    float x2 = cx + sin(angle) * (cx * 0.5);
    float y2 = cy + cos(angle) * (cy * 0.5);
    point(x, y);
    DrawLine(x, y, x2, y2);
  }
  slip--;
}

void DrawLine (float fx, float fy, float tx, float ty){
  // make points from fx to tx
  float r = 0, g = 0, b = 0, a = 0;
  
  for (int i = 0; i < res; i++) {
    float x = lerp(fx, tx, i / res);
    float y = lerp(fy, ty, i / res);
    r = (0.5 + sin(i / res * 5) * 0.5);
    g = (0.5 + sin(i / res * 2) * 0.5);
    b = (0.5 + sin(i / res) * 0.5);
    a = (0.5 + sin(i / res) * 0.5);
    stroke(r * 255, g * 255, b * 255, a * 255);
    rect (x, y, 1, 1);
  }  
}
