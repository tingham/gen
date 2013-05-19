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
				Dot d0 = dots[i];
				int x, y, tX, tY, repIndex;

				if (d0.r > d0.g && d0.r > d0.b) {
					x = i % width;
					y = (i - x) / width;
					tX = maxRIndex % width;
					tY = (maxRIndex - tX) / width;

					if (x < tX) {
						x--;
					} else {
						x++;
					}

					if (y < tY) {
						y--;
					} else {
						y++;
					}

					repIndex = y * width + x;
					if (repIndex > 0 && repIndex < dots.length) {
						dots[i] = dots[repIndex];
						dots[repIndex] = d0;

						if (d0.r == maxR) {
							maxRIndex = repIndex;
							break;
						}
					}
				}
				if (d0.g > d0.r && d0.g > d0.b) {
					x = i % width;
					y = (i - x) / width;
					tX = maxGIndex % width;
					tY = (maxGIndex - tX) / width;

					if (x < tX) {
						x--;
					} else {
						x++;
					}

					if (y < tY) {
						y--;
					} else {
						y++;
					}

					repIndex = y * width + x;
					if (repIndex > 0 && repIndex < dots.length) {
						dots[i] = dots[repIndex];
						dots[repIndex] = d0;

						if (d0.g == maxG) {
							maxGIndex = repIndex;
							break;
						}
					}
				}
				if (d0.g > d0.r && d0.g > d0.b) {
					x = i % width;
					y = (i - x) / width;
					tX = maxBIndex % width;
					tY = (maxBIndex - tX) / width;

					if (x < tX) {
						x--;
					} else {
						x++;
					}

					if (y < tY) {
						y--;
					} else {
						y++;
					}

					repIndex = y * width + x;
					if (repIndex > 0 && repIndex < dots.length) {
						dots[i] = dots[repIndex];
						dots[repIndex] = d0;

						if (d0.b == maxB) {
							maxBIndex = repIndex;
							break;
						}
					}
				}
			}
			Thread.sleep(30);
		} catch (Exception e) {
		}
	}
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

