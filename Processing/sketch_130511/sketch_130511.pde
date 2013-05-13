// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat May 11 2013
// 

int width = 850;
int height = 1100;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

float[] noiseVals = new float[width * height];
float scale = 3;
int r = (int)random(192, 255);
int g = (int)random(128, 255);
int b = (int)random(128, 255);

void setup ()
{
	size(width, height);
	for (int i = 0; i < width * height; i++) {
		int x = (i % width);
		int y = (i - x) / width;
		noiseVals[i] = noise(
			((float)x / (float)width) * scale,
			((float)y / (float)height) * scale
		);
	}

	thread("update");
}

void update ()
{
	while (true) {
		try {
			loadPixels();
			for (int i = 0; i < (int)random(2048); i++) {
				int p = (int)random(0, noiseVals.length);
				int x = p % width;
				int y = (p - x) / width;
				if (x > 0 && y > 0) {
					int up = y - 1;
					int down = y + 1;
					int left = x - 1;
					int right = x + 1;

					int ui = (up * width) + x;
					int di = (down * width) + x;
					int li = (y * width) + left;
					int ri = (y * width) + right;

					float un = pixels[ui];
					float dn = pixels[di];
					float pn = pixels[p];

					if (un > pn) {
						pixels[ui] = (int)pn;
						pixels[di] = (int)un;
						pixels[p] = (int)dn;
						pixels[ri] = (int)un;
						pixels[li] = (int)dn;
					}
				}
			}
			updatePixels();
			Thread.sleep(1);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	loadPixels();
	for (int i = 0; i < pixels.length; i++) {
		int x = i % width;
		int y = (i - x) / width;
		float n1 = noise((float)x / (float)width, (float)y / (float)height);
		float n2 = noise((float)y / (float)height, (float)x / (float)width);
		float n3 = noiseVals[i];

		pixels[i] = color(r * n3, g * lerp(n3, n2, 0.5), lerp(n1, n3, 0.5) * b);
	}
	updatePixels();
	long t = System.currentTimeMillis();
	if (mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

