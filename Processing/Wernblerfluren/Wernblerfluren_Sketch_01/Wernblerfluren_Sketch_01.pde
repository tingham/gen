int tick = 0;

void setup () {
  size(768, 512, P2D);
  frameRate(10);
}

void draw () {
    tick = tick + 1;

    float x = noise(tick / 1000f, 0); 
    float y = noise(0, tick / 1000f);

    rect(x * 256, y * 256, x * 512, y * 128);
}
