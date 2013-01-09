int width = 500;
int height = 500;
float r = TWO_PI / 360;
int index = 0;
int tick = 0;
color[] parray = new color[width * height];
int w = 0;
int h = 0;

void setup () {
  size(width, height);
  build();
  clobber();
}

void clobber () {
  stroke(0, 0, 0, 0);
  fill(0, 0, 0, 5);
  ellipse(width / 2, (height / 2), width, height);
  if (random(1) > 0.5) {
    return;
  }
  fill(0, 0, 0, 4);
  ellipse(width / 2, (height / 2), width * 0.8, height * 0.8);
  if (random(1) > 0.6) {
    return;
  }
  fill(0, 0, 0, 3);
  ellipse(width / 2, (height / 2), width * 0.6, height * 0.6);
  if (random(1) > 0.7) {
    return;
  }
  fill(0, 0, 0, 2);
  ellipse(width / 2, (height / 2), width * 0.4, height * 0.4);
  if (random(1) > 0.8) {
    return;
  }
  fill(0, 0, 0, 1);
  ellipse(width / 2, (height / 2), width * 0.2, height * 0.2);
}

void draw () {
  tick++;
  
  float masterAlpha = 0.5 * sin(tick) + 0.5;
  
  if (tick % 10 == 0) {
    build();
  }
  if (tick % 2 == 0) {
    clobber();
  }
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(PI);
  
  w = (int)random(width);
  for (int x = (int)(w * 0.5); x < w; x++) {
    h = (int)random(height);
    float rot = x;
    for (int y = (int)(h * 0.5); y < h; y++) {
      index = ((x * width) + height);
      index = min(index, parray.length - 1);
      index = max(index, 0);
      
      color c = parray[index];
      float dr = (float)y / (float)h;
      
      fill(red(c), green(c), blue(c), y * masterAlpha * 0.5);
      stroke(red(c), green(c), blue(c), (y * masterAlpha) * 0.125);
      
      rotate(masterAlpha * 0.1234567 * dr);
      
      float ew = random(10);
      ellipse(x, y, dr * ew, dr * ew);
      
      if (random(1) > 0.999999) {
        popMatrix();
        return;
      }
    }
    // rotate(x);
    rotate(rot);
  }
  popMatrix();
  if (tick > 100) {
    save("data/spiral-" + tick + ".tga");
  }
}

void build () {
  float cx = width / 2;
  float cy = height / 2;
  for (int i = 0; i < width * height; i++) {
    float t = tan(i);
    float s = sin(i);
    float c = cos(i);
    if (s > 0) {
      int r = (int)(255 * s);
      int g = (int)(255 * c);
      int b = (int)(255 * t);
      parray[i] = color(r, g, b, sin(tick) * 255);
      //tick++;
    }
  }
}
