int width = 128;
int height = 128;
float tick = 0;
float lastf = 0;
color[] data = new color[width * height];

void setup () {
  size(width, height);
  build();
}

void draw () {
  int p = 0;
  fill(0);
  rect(0, 0, width, height);
  
  while (p < (width * height)) {
    stroke(data[p]);
    point(p % width, (p - (p % width)) / height);
    p++;
  }
}

void build () {
  int v = (int)random(255);
  int p = 0;
  while (p < (width * height)) {
      v = 255;
      if (random(1.0) > 0.5) {
        v = 0;
      }
      data[p] = color(v, v, v, 255);
      p++;
  }
}
