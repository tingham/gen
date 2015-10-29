// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat May 04 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int[] cInput = new int[width * height];

void setup ()
{
	size(width, height);
	thread("update");
}

void fillColors () {
	for (int i = 0; i < width * height; i++) {
		float x = i % width;
		float y = (i - x) / width;
		float s = (0.5 * sin(tick) + 0.51);
		float c = noise(s, 0) * 5;
		float n1 = noise(
			((x / (float)width) + (tick / (float)width)) * c,
			(y / (float)height) * c
		);
		float n2 = noise(
			(y / (float)height) * c,
			((x / (float)width) + (tick / (float)width)) * c
		);
		cInput[i] = color(
				n1 * 255,
				n2 * 255,
				s * 255
			);
	}
}

void update () {

	while (true) {
		try {

			if (random(1) > 0.5) {
				fillColors();
			}
			Thread.sleep(30);
		} catch (Exception e) {
		}

	}
}

void draw ()
{
	translate(width * 0.5, height * 0.5);
	rotate(sin(tick * 0.001) * TWO_PI);
	int r = (int)random(8, 128);
	loadPixels();
	for (int i = 0; i < pixels.length; i++) {
		if (i % r == 0 && tick % r * 8 == 0) {
			for (int m = 0; m < r; m++) {
				if (i+m < pixels.length) {
					pixels[i+m] = cInput[i];
				}
			}
		}
	}
	updatePixels();

	long t = System.currentTimeMillis();
	if (mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
	tick++;
}

