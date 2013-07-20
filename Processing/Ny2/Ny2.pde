// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jul 12 2013
// 

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots = new Dot[(width * height)];

void setup ()
{
	size(width, height, P3D);
	thread("update");

	for (int i = 0; i < width * height; i++) {
		float x = (float)(i % width);
		float y = (float)((i - x) / width);
		dots[i] = new Dot(x, y, 0, 0, 0, 1, 1);
	}

	for (int i = 0; i < (int)random(width); i++) {
		float r = random(1);
		float g = random(1);
		float b = random(1);

		dots[(int)random(width * height)] = new Dot(random(width), random(height), r, g, b, 1, 1);
	}
}

void update ()
{
	while (true) {
		tick++;
		try {
			if (tick % 90 == 0) {
				int d = (int)random(dots.length);
			}
			Thread.sleep(30);
		} catch (Exception e) {
		}
	}
}

void draw ()
{

	loadPixels();
	for (int i = 0; i < width * height; i++) {
		pixels[i] = dots[i].Color();
	}
	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

