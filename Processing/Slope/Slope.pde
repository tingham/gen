// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jun 13 2013
// 

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

void setup ()
{
	size (width, height, P3D);
	dots = new Dot[width * height];

	for (int i = 0; i < width * height; i++) {
		dots[i] = new Dot(0.5, 0.5, 0.5, 0.0, 1.0);
	}

	for (int c = 0; c < 50; c++) {
		float r = random(0, width * 0.25);
		float x = random(width * 0.25, width * 0.75); 
		float y = random(height * 0.25, height * 0.75);

		for (int _x = (int)(x - (r * 0.5)); _x < x + (r * 0.5); _x++) {
			for (int _y = (int)(y - (r * 0.5)); _y < y + (r * 0.5); _y++) {
				if (_x > 0 && _x < width && _y > 0 && _y < height) {

					float n1 = noise(_x / (float)width, _y / (float)height);
					float n2 = noise((_x / (float)width) * 2, (_y / (float)height) * 2);
					float n3 = noise((_x / (float)width) * 5, (_y / (float)height) * 5);

					int p = (int)_y * width + _x;
					dots[p].r = lerp(dots[p].r, n1, 0.75);
					dots[p].g = lerp(dots[p].g, n2, 0.75);
					dots[p].b = lerp(dots[p].b, n3, 0.75);
					dots[p].a = 1.0;
				}
			}
		}
	}

	println("done drawing");

	/*
	loadPixels();

	for (int i = 0; i < pixels.length; i++) {
		if (alpha(pixels[i]) > 0) {
			dots[i].r = (float)red(pixels[i]) / (float)255;
			dots[i].g = (float)green(pixels[i]) / (float)255;
			dots[i].b = (float)blue(pixels[i]) / (float)255;
		}
	}

	updatePixels();
	*/

	thread("update");
}

void update ()
{
	while (true) {
		try {
			for (int i = 0; i < dots.length; i++) {
				float x = (float)(i % width);
				float y = (float)((i - x) / width);
				int left = (int)(y * width + (x - 1));
				int right = (int)(y * width + (x + 1));
				int up = (int)((y - 1) * width + x);
				int down = (int)((y + 1) * width + x);
				int ul = (int)((y - 1) * width + (x - 1));
				int ur = (int)((y - 1) * width + (x + 1));
				int dl = (int)((y + 1) * width + (x - 1));
				int dr = (int)((y + 1) * width + (x + 1));

				if (left < 0 || right > width * height || up < 0 || down > width * height || ul < 0 || ur > width * height || dl < 0 || dl > width * height || dr < 0 || dr > width * height || dots[i].a == 0) {
					continue;
				}

				if (x > width * 0.5) {
					if (dots[left].r < dots[i].r) {
						Dot d0 = dots[i];
						dots[i] = dots[left];
						dots[left] = d0;
					} else if (dots[left].g < dots[i].g) {
						Dot d0 = dots[i];
						dots[i] = dots[ul];
						dots[ul] = d0;
					} else if (dots[left].b < dots[i].b) {
						Dot d0 = dots[i];
						dots[i] = dots[dl];
						dots[dl] = d0;
					}
				} else {
					if (dots[right].r > dots[i].r) {
						Dot d0 = dots[i];
						dots[i] = dots[right];
						dots[right] = d0;
					} else if (dots[right].g > dots[i].g) {
						Dot d0 = dots[i];
						dots[i] = dots[ur];
						dots[ur] = d0;
					} else if (dots[right].b > dots[i].b) {
						Dot d0 = dots[i];
						dots[i] = dots[dr];
						dots[dr] = d0;
					}
				}

				if (y > height * 0.5) {
					if (dots[down].r > dots[i].r) {
						Dot d0 = dots[i];
						dots[i] = dots[down];
						dots[down] = d0;
					} else if (dots[down].g > dots[i].g) {
						Dot d0 = dots[i];
						dots[i] = dots[dr];
						dots[dr] = d0;
					} else if (dots[down].b > dots[i].b) {
						Dot d0 = dots[i];
						dots[i] = dots[dl];
						dots[dl] = d0;
					}
				} else {
					if (dots[up].r > dots[i].r) {
						Dot d0 = dots[i];
						dots[i] = dots[up];
						dots[up] = d0;
					} else if (dots[up].g > dots[i].g) {
						Dot d0 = dots[i];
						dots[i] = dots[ul];
						dots[ul] = d0;
					} else if (dots[up].b > dots[i].b) {
						Dot d0 = dots[i];
						dots[i] = dots[ur];
						dots[ur] = d0;
					}
				}
			}
			Thread.sleep(10);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	background(32);
	fill(220);
	ellipse(width * 0.5, height * 0.5, width * 0.9, height * 0.9);

	loadPixels();
	for (int i = 0; i < dots.length; i++) {
		if (dots[i].a > 0) {
			pixels[i] = dots[i].Color();
		}
	}
	updatePixels();
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

