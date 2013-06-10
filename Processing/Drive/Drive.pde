// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Jun 08 2013
// 

import com.mutiny.*;

int resolution = 32;
int width = (int)(8.5 * resolution);
int height = (int)(10.0 * resolution);

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

void setup ()
{
	size(width, height, P3D);

	dots = new Dot[width * height];

	noiseSeed(1234);
	noiseDetail(12, 0.6);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float fx = (float)x / (float)width;
		float fy = (float)y / (float)height;

		float n1 = noise(
			fx, fy
		);
		float n2 = noise(
			fx + width, fy
		);
		float n3 = noise(
			fx + height + width, fy
		);

		dots[i] = new Dot(n1, n2, n3, 1.0, 1.0);
	}

	thread("update");
}

void update ()
{
	while (true) {
		try {
			int bx = (int)random(width);
			int by = (int)random(height);
			int bw = (int)(width * 0.125);
			int bh = (int)(height * 0.125);

			for (int sx = bx; sx < bx + bw; sx++) {
				for (int sy = by; sy < by + bh; sy++) {

					int x = sx;
					int y = sy;
					int i = y * width + x;

					int up = (y - 1) * width + x;
					int down = (y + 1) * width + x;
					int left = y * width + (x - 1);
					int right = y * width + (x + 1);

					if (up > 0 &&
						down < dots.length &&
						left > 0 &&
						right < dots.length) {

						float rgb1 = (dots[up].r + dots[up].g + dots[up].b) * 0.333;
						float rgb2 = dots[down].r + dots[down].g + dots[down].b;

						if (rgb1 < 0.5) {
							Dot d0 = dots[up];
							dots[up] = dots[down];
							dots[down] = d0;
						}

						if (dots[i].r > dots[right].r) {
							Dot d0 = dots[i];
							dots[i] = dots[right];
							dots[right] = d0;
						} else if (dots[i].r > dots[left].r) {
							Dot d0 = dots[i];
							dots[i] = dots[left];
							dots[left] = d0;
						}

						if (dots[i].g > dots[up].g) {
							Dot d0 = dots[i];
							dots[i] = dots[up];
							dots[up] = d0;
						} else if (dots[i].g > dots[down].g) {
							Dot d0 = dots[i];
							dots[i] = dots[down];
							dots[down] = d0;
						}

						if (dots[i].b > dots[right].b) {
							Dot d0 = dots[i];
							dots[i] = dots[right];
							dots[right] = d0;
						} else if (dots[i].b > dots[left].b) {
							Dot d0 = dots[i];
							dots[i] = dots[left];
							dots[left] = d0;
						}

					}
				}
			}
			// Thread.sleep(10);
		} catch (Exception e) {

		}
	}
}

void draw ()
{
	background(0);

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

