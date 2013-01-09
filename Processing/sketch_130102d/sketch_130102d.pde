PImage canvas;
PImage watercolor;
PImage source;

int height = 512;
int width = 512;

int tick = 0;

void setup () {
  size(width, height);
  
  canvas = loadImage("canvas.jpg");
  watercolor = loadImage("watercolor.jpg");
  source = loadImage("input.jpg");
  
  canvas.loadPixels();
  watercolor.loadPixels();
  source.loadPixels();
  
}

void draw () {
  tick++;
  paint();
}

void paint () {
  int index = 0;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      stroke(fetchColor(x, y));
      strokeWeight(1.2);
      point(x, y);
    }
  }
}

color fetchColor (int x, int y) {
  color ai, bi, ci;
  
  ai = source.pixels[y * width + x];
  
  int cBx = x % 64;
  int cBy = y % 64;
  bi = canvas.pixels[cBy * 64 + cBx];
  
  int wBx = x % 128;
  int wBy = y % 128;
  ci = watercolor.pixels[wBy * 128 + wBx];
  
  float r = (red(ai) + brightness(bi) / 2) * ((brightness(ci) / 255) * 0.75);
  float g = (green(ai) + brightness(bi) / 2) * ((brightness(ci) / 255) * 0.5);
  float b = (blue(ai) + brightness(bi) / 2) * ((brightness(ci) / 255) * 0.25);
  
  return color(
  r, g, b,
  255
  );
}
