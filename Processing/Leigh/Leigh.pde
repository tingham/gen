// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Oct 30 2014
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

// Create random black and drift at a speed generated from a noise map.

float[] noise;

void setup ()
{
    size(width, height, P2D);

    noise = new float[width * height];

    loadPixels();
    for (int i = 0; i < width * height; i++) {
        float x = (float)(i % width);
        float y = (i - x) / width;

        noise[i] = n(x, y, 5);
        pixels[i] = color(int(noise[i] * 255));
    }
    updatePixels();
}

float n (float x, float y, float s) {
    return noise(
        (x / width) * s,
        (y / height) * s
    );
}

void draw ()
{
    tick++;


	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

