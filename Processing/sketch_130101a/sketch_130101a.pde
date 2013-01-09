int width = 512;
int height = 512;
float r = TWO_PI / 360;
int maxLeafs = 10;
int leafs = 0;
int tick = 0;
boolean storeResults = true;

void setup () {
 size(width, height);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  rect(0, 0, width, height); 
}

void draw () {
  tick++;
  float cx = width / 2;
  float cy = height / 2;
  if (leafs == maxLeafs) {
    leafs = 0;
    
  }
  fill(0, 0, 0, 4);
  stroke(0, 0, 0);
  rect(0, 0, width, height); 
  makeArc((int)cx, (int)cy, width / 4);
  if (storeResults) {
    save("fo-" + tick + ".tga");
  }
}

void makeArc (int cx,int cy, float imp) {
  leafs++;
  imp *= 0.675;
  int arcs = (int)random(720);
  int lx = cx;
  int ly = cy;
  float al = 1.0;
  for (int i = int(arcs * 0.5); i < arcs; i++) {
    al *= 0.9;
    float angle = i * r;
    float cosa = cos(angle);
    float sina = sin(angle);
    float x0 = cx + (cosa * imp);
    float y0 = cy + (sina * imp);
    float m = (255 - (255 * (imp / width))) * al;
    fill(0, 0, 0, m * 0.0125);
    stroke(max(random(255), 128) + (sin(tick) * 128), max(random(255), 128), max(random(255), 128), m);
    ellipse(lx, ly, imp * 0.25, imp * 0.25);
    ellipse(x0, y0, imp, imp);
    lx = (int)x0;
    ly = (int)y0;
    if ((random(1) > 0.5 || i >= arcs - 1) && leafs < maxLeafs) {
      makeArc((int)x0, (int)y0, imp);
      arcs *= 0.5;
    }
    imp *= 0.999;
  }
}
