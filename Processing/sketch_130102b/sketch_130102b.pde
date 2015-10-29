PImage img;
int tick = 0;
float r = 0;

void setup () {
  img = loadImage("input-2.jpg");
  size(img.width, img.height);
  img.loadPixels();
  image(img, 0, 0);
}

void draw () {
  tick++;
  // image(img, 0, 0);
  if (tick % 2 == 0) {
    process();
  }
  if (tick % 10 == 0) {
    save("data/photo-distortion-" + tick + ".tif");
  }
}

void process () {
  int index = 0;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      if (random(1) > 0.99) {
        color c = img.pixels[index];
        float impl = (green(c) + red(c) + blue(c) / 3);
        stroke(green(c) * 0.5, red(c) * 0.5, blue(c) * 0.5, 16);
        fill(red(c), green(c), blue(c), 32);
        r = (r + r + random(impl + (sin(tick * 0.075) * impl))) / 3;
        rect(x, y, r, r);
        stroke(255, 255, 255, 16);
        rect(x, y, 1, r);
        stroke(green(c) * 0.5, red(c) * 0.5, blue(c) * 0.5, 2);
        fill(red(c), green(c), blue(c), 4);
        rect(x, y, -r, r);
        
      }
      index++;
    } 
  }
}
