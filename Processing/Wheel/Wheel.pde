// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Oct 05 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
	size (width, height, P3D);
	colorMode(HSB, 100);
}

void draw ()
{
	float step = TWO_PI / 360;
	float centerX = 256;
	float centerY = 256;

	noStroke();

	for (int gx = 0; gx < width; gx++) {
		for (int gy = 0; gy < height; gy++) {
			if (gx % 16 == 0 && gy % 16 == 0) {
				fill(random(100), random(50) + 50, random(25) + 50);
				rect(gx + 1, gy + 1, 14, 14);
			}
		}
	}

	fill(100, 0, 100);
	ellipse(width * 0.5, height * 0.5, 128, 128);

	noFill();
	for (float i = 0; i < TWO_PI; i += step) {
		for (int s = 100; s > 0; s = s - 10) {
			float offset = (((float)s / 100) * 64) + 32;
			float x = centerX + (sin(i) * offset);
			float y = centerY + (cos(i) * offset);
			float m = (float)((int)(((float)i / TWO_PI) * 20) / 20.0);
			float h = m * 100;
			stroke(h, s, 100);
			strokeWeight(7);
			point(x, y);
		}
		for (int b = 100; b > 0; b = b - 10) {
			float offset = (64 + (((float)b / 100) * 64)) + 32;
			float x = centerX + (sin(i + PI) * offset);
			float y = centerY + (cos(i + PI) * offset);
			float m = (float)((int)(((float)i / TWO_PI) * 20) / 20.0);
			float h = m * 100;
			stroke(h, 100, 100 - b);
			strokeWeight(7 + ((float)b / 100));
			point(x, y);
		}
	}

	long t = System.currentTimeMillis();
	if (t % 2 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

