PImage img;
int res = 32;

void setup () {
  img = loadImage("photo.jpg");
  img.loadPixels();
  size(img.width, img.height);  
}

void draw () {
  for (int x = 0; x < img.width / res; x++) {
     for (int y = 0; y < img.height / res; y++) {
      stroke(img.pixels[(x * res) * (y * res)]);
      fillPoints(x * res, y * res);
     } 
  }
}

void fillPoints (int sx, int sy) {
  for (int x = sx; x < sx + res; x++) {
    for (int y = sy; y < sy + res; y++) {
      point(x, y);
    }
  }
}
