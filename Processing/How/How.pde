// # How
// **Created By:** + tingham
// **Created On:** + Wed May 22 2013
// A simple demonstration of intensity based pixel sorting over time.

import com.mutiny.*;

int width = 768;
int height = 1024;
int div = 2;

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

float colorSnap = 16;

void setup ()
{
	size (width, height, P3D);

	generate();

	thread("update");
}

void update () {

	while (true) {
		try {
			int count = (width * height) / div;

			for (int i = 0; i < count; i++) {
				int x = i % (width / div);
				int y = (i - x) / (width / div);

				int up = (y - 1) * (width / div) + x;
				int down = (y + 1) * (width / div) + x;
				int left = y * (width / div) + (x - 1);
				int right = y * (width / div) + (x + 1);

				if (i > 0 && i < count && up > 0 && down < count && left > 0 && right < count) {

					Dot d0 = dots[i]; // new Dot(dots[i].r, dots[i].g, dots[i].b, 1.0);

					if (dots[up].r > dots[i].r) {
						dots[i] = dots[up];
						dots[up] = d0;
						continue;
					} else if (dots[up].g > dots[i].g &&
						dots[up].b > dots[i].b) {
						dots[i] = dots[left];
						dots[left] = d0;
						continue;
					}

					if (dots[right].g > dots[i].g) {
						dots[i] = dots[right];
						dots[right] = d0;
						continue;
					} else if (dots[right].r > dots[i].r &&
						dots[right].b > dots[i].b) {
						dots[i] = dots[up];
						dots[up] = d0;
						continue;
					}

					if (dots[down].b > dots[i].b) {
						dots[i] = dots[down];
						dots[down] = d0;
						continue;
					} else if (dots[down].r > dots[i].r &&
						dots[down].b > dots[i].b) {
						dots[i] = dots[right];
						dots[right] = d0;
						continue;
					}
				}
			}
			Thread.sleep(15);
		} catch (Exception e) {
			println(e);
		}
	}
}

void evaluate () {
}

void generate () {

	dots = new Dot[(width * height) / div];
	for (int i = 0; i < (width * height) / div; i++) {
		int x = i % (width / div);
		int y = (i - x) / (width / div);

		float n1 = (float)((int)(noise(
			(float)x / (float)(width / div),
			(float)y / (float)(height / div)
		) * colorSnap)) / colorSnap;

		float n2 = (float)((int)(noise(
			(float)y / (float)(height / div),
			(float)x / (float)(width / div)
		) * colorSnap)) / colorSnap;

		float n3 = (float)((int)(noise(
			n1 * 2,
			n2 * 2
		) * colorSnap)) / colorSnap;

		dots[i] = new Dot(n1, n2, n3, 1.0);
	}
}

void draw ()
{
	background(0);

	translate(0, 0, width * -0.866);
	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		if (x % div == 0 && y % div == 0) {
			noStroke();
			fill(dots[i / div].Color());
			pushMatrix();
			translate(x, y, (brightness(dots[i / div].Color()) / 255) * width);
			rect(0, 0, div, div);
			popMatrix();
		}
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

