// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Jun 29 2013
// 

import com.mutiny.*;

int width = 1024;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] bg;
Dot[] dots;

float threshold = 0.4;

void setup ()
{
	bg = new Dot[width * height];
	dots = new Dot[width * height];

	size(width, height, P3D);

	noiseDetail(20, 0.6);

	for (int i = 0; i < width * height; i++) {
		float x = (float)(i % width);
		float y = (float)((i - x) / width);

		float fx = x / (float)width;
		float fy = y / (float)height;

		float n1 = noise(fx, fy);
		float n2 = noise(fx * 2, fy * 2);
		float n3 = noise(fx * 5, fy * 5);

		bg[i] = new Dot(n1, n2, n3, 1.0, 1.0);
		dots[i] = new Dot(n3, n2, n1, noise(fx * 10, fy * 10), 1.0);
	}

	thread("update");
}

void update ()
{
	while (true) {
		try {
			for (int i = 0; i < width * height; i++) {
				int x = i % width;
				int y = (i - x) / width;

				int up = y - 1;
				int down = y + 1;
				int left = x - 1;
				int right = x + 1;

				if (up > 0 && down < height && left > 0 && right < width) {

					if (dots[i].a < threshold) {
						continue;
					}

					if (dots[down * width + x].r + dots[down * width + x].g + dots[down * width + x].b >
							dots[i].r + dots[i].g + dots[i].b) {
						Dot d0 = dots[i];
						dots[i] = dots[down * width + x];
						dots[down * width + x] = d0;
						continue;
					}

					if (dots[down * width + x].r + dots[down * width + x].g + dots[down * width + x].b <
							dots[i].r + dots[i].g + dots[i].b) {
						Dot d0 = dots[i];
						dots[i] = dots[up * width + x];
						d0.r -= 0.001;
						d0.g -= 0.001;
						d0.b -= 0.001;
						dots[up * width + x] = d0;
					}

					if (dots[y * width + left].g < dots[i].g) {
						Dot d0 = dots[i];
						dots[i] = dots[y * width + left];
						d0.g += 0.001;
						dots[y * width + left] = d0;
					} else {
						Dot d0 = dots[i];
						dots[i] = dots[down * width + x];
						d0.g -= 0.001;
						dots[down * width + x] = d0;
					}

					if (dots[down * width + x].b < dots[i].b) {
						Dot d0 = dots[i];
						dots[i] = dots[down * width + x];
						d0.b += 0.001;
						dots[down * width + x] = d0;
					} else {
						Dot d0 = dots[i];
						dots[i] = dots[y * width + right];
						d0.b -= 0.001;
						dots[y * width + right] = d0;
					}

					/*
					if (random(1) > 0.99) {
						Dot d0 = dots[i];

						float r = (dots[i].r + bg[i].r) * 0.5;
						float g = (dots[i].g + bg[i].g) * 0.5;
						float b = (dots[i].b + bg[i].b) * 0.5;
						dots[up * width + x].r = (dots[up * width + x].r + r) * 0.5;
						dots[down * width + x].r = (dots[down * width + x].r + r) * 0.5;
						dots[y * width + left].r = (dots[y * width + left].r + r) * 0.5;
						dots[y * width + right].r = (dots[y * width + right].r + r) * 0.5;
						
						dots[up * width + x].g = (dots[up * width + x].g + g) * 0.5;
						dots[down * width + x].g = (dots[down * width + x].g + g) * 0.5;
						dots[y * width + left].g = (dots[y * width + left].g + g) * 0.5;
						dots[y * width + right].g = (dots[y * width + right].g + g) * 0.5;
						
						dots[up * width + x].b = (dots[up * width + x].b + b) * 0.5;
						dots[down * width + x].b = (dots[down * width + x].b + b) * 0.5;
						dots[y * width + left].b = (dots[y * width + left].b + b) * 0.5;
						dots[y * width + right].b = (dots[y * width + right].b + b) * 0.5;

						bg[i] = d0;
					}
					*/

				}
			}
			Thread.sleep(30);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	background(32);
	loadPixels();
	for (int i = 0; i < width * height; i++) {
		if (dots[i].a > threshold) {
			pixels[i] = dots[i].Color();
		} else {
			pixels[i] = bg[i].Color();
		}
	}
	updatePixels();
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

