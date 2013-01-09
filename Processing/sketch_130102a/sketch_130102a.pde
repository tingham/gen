int height = 256;
int width = 256;
int subdivisions = width * height;
int divisions = 0;
float fscale = 1.0;
float roughness = 0.0;
int tick = 0;
float c1, c2, c3, c4;
String slug = "box-green";

void setup () {
  size(width, height);
  fill(0);
  rect(0, 0, width, height);
}

void draw () {
  tick++;
  roughness = 0.5 * sin(tick * 0.13) + 0.5;
  fscale = (0.5 * cos(tick * 0.05) + 0.5) * 50.0; 
  
  c1 = cos(c1 + random(1) / 2);
  c2 = cos(c2 + random(1) / 2);
  c3 = cos(c3 + random(1) / 2);
  c4 = cos(c4 + random(1) / 2);
  
  divide(0, 0, width, height, c1, c2, c3, c4);
  if (tick > 30 && tick < 120) {
    if (tick % 2 == 0) {
      save("data/" + slug + "-" + tick + ".tga");
    }
  }
}

void divide (int x0,int y0,int w0,int h0,float c1, float c2, float c3, float c4) {
  
  if (divisions > subdivisions) {
    divisions = 0;
    return;
  }
  divisions++;
  
  int w = w0 / 2;
  int h = h0 / 2;
  int x = 0;
  int y = 0;
  float middle, c, e1, e2, e3, e4;
  
  if (w >= 1 && h >= 1) {
    if (x0 == 0 && y0 == 0 && w0 == width && h0 == height) {
      middle = random(0.75, 1.0);
    } else {
      middle = max(0, min(1, ((c1 + c2 + c3 + c4) * 0.25) + displace(w + h)));
    }
    e1 = max(0, min(1, (c1 + c2) * 0.5));
    e2 = max(0, min(1, (c2 + c3) * 0.5));
    e3 = max(0, min(1, (c3 + c4) * 0.5));
    e4 = max(0, min(1, (c4 + c1) * 0.5));

    divide(x0, y0, w, h, c1, e1, middle, e4);
    divide(x0 + w, y0, w0 - w, h, e1, c2, e2, middle);
    divide(x0 + w, y0 + h, w0 - w, h0 - h, middle, e2, c3, e3);
    divide(x0, y0 + h, w, h0 - h, e4, middle, e3, c4);    
  } else {
    c = (c1 + c2 + c3 + c4) * 0.25;
    x = (int)floor(x0);
    y = (int)floor(y0);
    
    float fr = random(c);
    //stroke((c + fr) * 255, (c + sqrt(fr)) * 255, c * 255, 255);
    stroke(c * 255);
    point(x, y);
  }
}

float displace(float s) {
  float fMax = (s / fscale) * roughness;
  return (random(0.0, 1.0) - 0.5) * fMax;
}
