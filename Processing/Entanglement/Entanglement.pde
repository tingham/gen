// # Entanglement
// **Created By:** + tingham
// **Created On:** + Fri May 17 2013
// 
// Each pixel searches for a suitable mate and attempts to find him in the canvas.

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

float maxR, maxG, maxB = 0;

int maxRIndex, maxGIndex, maxBIndex = 0;


void setup ()
{
	size(width, height, P3D);

	dots = new Dot[width * height];

	for (int i = 0; i < dots.length; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float n1 = noise(
			((float)x / (float)width) * 4,
			((float)y / (float)height) * 4
		);
		float n2 = noise(
			((float)x / (float)width) * 2,
			((float)y / (float)height) * 2
		);
		float n3 = noise(
			((float)x / (float)width),
			((float)y / (float)height)
		);

		if (n1 > maxR && (n1 > n2 && n1 > n3)) { maxR = n1; maxRIndex = i; }
		if (n2 > maxG && (n2 > n1 && n2 > n3)) { maxG = n2; maxGIndex = i; }
		if (n3 > maxB && (n3 > n1 && n3 > n2)) { maxB = n3; maxBIndex = i; }

		dots[i] = new Dot(n1, n2, n3, 1.0);
	}

	thread("update");
}

void update () {
	while (true) {
		try {
			for (int i = 0; i < dots.length; i++) {
				int x = i % width;
				int y = (i - x) / width;

				swap(i, x, y);

			}
			Thread.sleep(5);
		} catch (Exception e) {
		}
	}
}

boolean swap (int index, int x, int y) {

	if (x < 0 || x > width) {
		return false;
	}
	if (y < 0 || y > height) {
		return false;
	}

	int swapWith = -1;

	Dot dl, dr;

	if (x - 3 > 0 && x + 3 < width) {
		dl = dots[y * width + (x - 3)];
		dr = dots[y * width + (x + 3)];

		if (abs(dl.r - dots[index].r) > abs(dr.r - dots[index].r) &&
				abs(dl.g - dots[index].g) < abs(dr.g - dots[index].g) &&
				abs(dl.b - dots[index].b) < abs(dr.b - dots[index].b)) {
			swapWith = y * width + (x - 1);
		}
	}

	if (y - 3 > 0 && y + 3 < height) {
		dl = dots[(y - 3) * width + x];
		dr = dots[(y + 3) * width + x];

		if (abs(dl.g - dots[index].g) > abs(dr.g - dots[index].g) &&
				abs(dl.r - dots[index].r) < abs(dr.r - dots[index].r) &&
				abs(dl.b - dots[index].b) < abs(dr.b - dots[index].b)) {
			swapWith = (y - 1) * width + x;
		}
	
	}

	if (swapWith > -1) {
		Dot d0 = dots[index];
		dots[index] = dots[swapWith];
		dots[swapWith] = d0;
		return true;
	}

	return false;
}

void draw ()
{
	background(0);

	loadPixels();
	for (int i = 0; i < dots.length; i++) {
		pixels[i] = dots[i].Color();
	}
	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "entanglement-01-" + t + ".jpg");
	}
}

