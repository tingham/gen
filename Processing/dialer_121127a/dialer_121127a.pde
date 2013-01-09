int width = 128;
int height = 128;

float startAngle = -90;
float spokes = 0;
float res = sqrt(width) * 5;

boolean storeResults = true;

void setup () {
  size(width, height);
  spokes = startAngle;
}

void draw () {
  fill(0, 0, 0);
  rect(0, 0, width, height);
  
  stroke(255, 255, 255, 128);
  fill(255, 255, 255, 128);
  
  float cx, cy;
  cx = width * 0.5;
  cy = height * 0.5;
  
  int i = (int)startAngle;
  float r = TWO_PI / 360;
  
  while (i <= spokes) {
      float angle = i * r;
      float cosa = cos(angle);
      float sina = sin(angle);
      float x = cx + cosa * (cx * 0.9);
      float y = cy + sina * (cy * 0.9);
      float x2 = cx + cosa * (cx * 0.1);
      float y2 = cy + sina * (cy * 0.1);
      point(x, y);
      DrawLine(x, y, x2, y2);
      i++;
  }
  if (spokes < startAngle + (359.0)) {
    spokes = spokes + 1.0;
  }
}

void DrawLine (float fx, float fy, float tx, float ty){
  // make points from fx to tx
  for (int i = 0; i < res; i++) {
    float x = lerp(fx, tx, i / res);
    float y = lerp(fy, ty, i / res);
    rect (x, y, 1, 1);
  }  
}


