int scale = 512;
int[] data = new int[scale * scale];
boolean pass = false;
int tick = 0;

void setup () {
  size(scale, scale);
  build();
}

void draw () {
  int p = 0;
  tick++;
  
  if (!pass) {
    fill(0, 0, 0, 255);
    pass = true;
  } else {
    fill(0, 0, 0, tan(tick));
  }
  rect(0, 0, scale, scale);
  
  while (p < scale * scale) {
    stroke(data[p]);
    point(p % scale, (p - (p % scale)) / height);
    p++;
  }
  
  p = 0;
  while (p < scale * scale) {
    stroke(data[p]);
    point((p - (p % scale)) / height, p % scale);
    p++;
  }
  
  p = 0;
  while (p < scale * scale) {
    stroke(data[p]);
    point(scale - ((p - (p % scale)) / height), scale - (p % scale));
    p++;
  }
  
  if (random(1) > 0.25) {
    build();
  }
}

void build() {
  data = new int[scale * scale];
  int d = 0;
  for (int x = 0; x < scale; x++) {
    int c = color(random(255), random(255), random(255), 255);
    for (int y = (int)random(scale * sin(x)); y > 0; y--) {
      data[(y * scale) + x] = c;
    }
  }
}



