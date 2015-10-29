int width = 256;
int height = 256;
int tick = 0;

void setup () {
  size(width, height);
}

void draw () {
  tick++;
  drawCircle(width / 2, height / 2, width * 0.75);
}

void drawCircle(float x, float y, float r) {
  if (r < 1.0) {
    return;
  }
  ellipse(x, y, r, r);
  pushMatrix();
  translate(x, y);
  rotate(5.0);
  drawCircle(cos(x) + x, sin(y) + y, r * 0.75);
  popMatrix();  
}
