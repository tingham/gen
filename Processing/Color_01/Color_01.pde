// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat May 18 2013
// 

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

boolean building = false;

void setup ()
{
	size(width, height, P3D);

	dots = new Dot[width * height];
	generateNoise();

	thread("update");
}

void generateNoise () {
	building = true;
	tick++;
	noiseSeed(0);
	noiseDetail(8, 0.6);

	for (int i = 0; i < dots.length; i++) {
		int x = (i % width);
		int y = (i - x) / width;
		float n1 = noise(
			((float)x / (float)width) + (tick * 0.2),
			(float)y / (float)height
		);

		float n2 = noise(
			((float)y / (float)height) + (tick * 0.2),
			(float)x / (float)width
		);

		float n3 = noise(
			(float)x / (float)width * 5,
			(float)y / (float)height * 5
		);

		colorMode(HSB, 1.0);
		color c = color(n1, n2, n3);
		colorMode(RGB, 1.0);

		dots[i] = new Dot(red(c), green(c), blue(c), 1.0);
	}
	building = false;
}

void update () {

	while (true) {
		try {

			generateNoise();
			Thread.sleep(30);
		} catch (Exception e) {

		}
	}
}

void draw ()
{
	if (building) {
		return;
	}
	colorMode(RGB, 255);
	if (dots[0] == null) {
		return;
	}
	loadPixels();
	for (int i = 0; i < dots.length; i++) {
		pixels[i] = dots[i].Color();
	}
	updatePixels();
	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

