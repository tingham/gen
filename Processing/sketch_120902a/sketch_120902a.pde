
int width = 128;
int height = 128;
float nScale = .01f;

int tick = 0;

void setup () {
    size(width, height);
    frameRate(15);
}

void draw () {
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            float n = floor(sin(noise((x + tick) * nScale, ((sin(tick * 0.5f) * height) + y) * nScale)) * 2);
            stroke(n * 255);
            point(x, y);
        }
    }
    tick++;
}

