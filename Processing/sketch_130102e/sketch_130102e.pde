int height = 256;
int width = 256;
int tick = 0;

void setup () {
  size(width, height);
  fill(32);
  stroke(0, 0, 0, 0);
  rect(0, 0, width, height);
  paint();
  
}

void draw () {
  tick++;
  paint();
  if (tick > 60 && tick < 100) {
    save("data/triangle-recursion-" + tick + ".tga");
  }
}
void paint () {
  stroke(random(255));
  triangleAt(width / 2, height / 2, (width * sin(tick)) + 1,  (height * cos(tick)) + 1);
}

void triangleAt (float x, float y, float rx, float ry) {
  if (rx < 1.0) {
    return;
  }
  strokeWeight(rx / width);
  line(x - (rx / 2), y + (ry / 2), x + (rx / 2), y + (ry / 2));
  line(x + (rx / 2), y + (ry / 2), x, y - (ry / 2));
  line(x, y - (ry / 2), x - (rx / 2), y + (ry / 2));
  triangleAt(x - (rx / 2), y + (ry / 2), rx * 0.55,  ry * 0.55);
  triangleAt(x + (rx / 2), y + (ry / 2), rx * 0.55,  ry * 0.55);
  triangleAt(x, y - (ry / 2), rx * 0.55,  ry * 0.55);
}
