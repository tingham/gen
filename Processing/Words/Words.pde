// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Jul 24 2013
// 

import com.mutiny.*;

int width = 1280;
int height = 720;

float scale = random(5);

float redDriver = random(0.5);
float greenDriver = random(0.5);
float blueDriver = random(0.5);

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

void setup ()
{
	size(width, height, P3D);

	dots = new Dot[width * height];

	loadPixels();

	noiseDetail(20, 0.6);

	for (int i = 0; i < dots.length; i++) {

		float x = (float)(i % width);
		float y = (float)(i - x) / width;

		float n1 = lerp(noise((x / width) * scale, (y / height) * scale), 1.0, redDriver);
		float n2 = lerp(noise((x / width) * 2 * scale, (y / height) * 2 * scale), 1.0, greenDriver);
		float n3 = lerp(noise((x / width) * 3 * scale, (y / height) * 3 * scale), 1.0, blueDriver);

		dots[i] = new Dot(n1, n2, n3, 1, 1);
		pixels[i] = dots[i].Color();

	}
	updatePixels();

	putWord("FORM");

	loadPixels();
	for (int i = 0; i < dots.length; i++) {
		dots[i] = new Dot(
			red(pixels[i]) / 255,
			green(pixels[i]) / 255,
			blue(pixels[i]) / 255,
			1,
			1
		);
	}
	updatePixels();

	thread("update");
}

void update ()
{
	while (true) {
		try {
			for (int i = 0; i < dots.length; i++) {
				int x = i % width;
				int y = (i - x) / width;
				int up = max(0, min((y - 1) * width + x, dots.length - 1));
				int down = max(0, min((y + 1) * width + x, dots.length - 1));
				int left = max(0, min(y * width + (x - 1), dots.length - 1));
				int right = max(0, min(y * width + (x + 1), dots.length - 1));

				if (dots[i].r > dots[left].r && dots[i].r >= dots[right].r) {
					Dot d0 = dots[i];
					dots[i] = dots[left];
					dots[left] = d0;
				} else if (dots[i].g > dots[up].g && dots[i].g >= dots[down].g) {
					Dot d0 = dots[i];
					dots[i] = dots[up];
					dots[up] = d0;
				} else if (dots[i].b > dots[right].b && dots[i].b >= dots[left].b) {
					Dot d0 = dots[i];
					dots[i] = dots[right];
					dots[right] = d0;
				}
				if (dots[down].r > dots[up].r && dots[up].g >= dots[down].g) {
					Dot d0 = dots[i];
					dots[i] = dots[up];
					dots[up] = d0;
				} else if (dots[left].g > dots[right].g && dots[right].b >= dots[left].b) {
					Dot d0 = dots[i];
					dots[i] = dots[right];
					dots[right] = d0;
				} else if (dots[up].b > dots[down].b && dots[down].r >= dots[up].r) {
					Dot d0 = dots[i];
					dots[i] = dots[down];
					dots[down] = d0;
				}

				if (dots[down].r == 1 && dots[down].g == 1 && dots[down].b == 1) {
					dots[i].r -= 0.001;
					dots[i].g -= 0.001;
					dots[i].b -= 0.001;
				} else {
					dots[i].r = lerp(dots[i].r, noise((float)x / width, (float)y / height), redDriver);
					dots[i].g = lerp(dots[i].g, noise((float)x / width * 2, (float)y / height * 2), greenDriver);
					dots[i].b = lerp(dots[i].b, noise((float)x / width * 3, (float)y / height * 3), blueDriver);
				}
				
				if (dots[right].r == 1 && dots[right].g == 1 && dots[right].b == 1) {
					dots[i].r -= 0.001;
					dots[i].g -= 0.001;
					dots[i].b -= 0.001;
				} else {
					dots[i].r = lerp(dots[i].r, noise((float)x / width, (float)y / height), redDriver);
					dots[i].g = lerp(dots[i].g, noise((float)x / width * 2, (float)y / height * 2), greenDriver);
					dots[i].b = lerp(dots[i].b, noise((float)x / width * 3, (float)y / height * 3), blueDriver);
				}

				if (dots[left].r == 1 && dots[left].g == 1 && dots[left].b == 1) {
					dots[i].r -= 0.001;
					dots[i].g -= 0.001;
					dots[i].b -= 0.001;
				} else {
					dots[i].r = lerp(dots[i].r, noise((float)x / width, (float)y / height), redDriver);
					dots[i].g = lerp(dots[i].g, noise((float)x / width * 2, (float)y / height * 2), greenDriver);
					dots[i].b = lerp(dots[i].b, noise((float)x / width * 3, (float)y / height * 3), blueDriver);
				}

				if (random(1) > 0.75) {
					if (dots[i].r - dots[left].r > dots[i].r - dots[right].r) {
						Dot d0 = dots[i];
						dots[i] = dots[right];
						dots[right] = d0;
					}

					if (dots[i].g - dots[left].g > dots[i].g - dots[right].g) {
						Dot d0 = dots[i];
						dots[i] = dots[right];
						dots[right] = d0;
					}

					if (dots[i].b - dots[left].b > dots[i].b - dots[right].b) {
						Dot d0 = dots[i];
						dots[i] = dots[right];
						dots[right] = d0;
					}

					if (dots[i].r - dots[up].r > dots[i].r - dots[down].r) {
						Dot d0 = dots[i];
						dots[i] = dots[down];
						dots[down] = d0;
					}

					if (dots[i].g - dots[up].g > dots[i].g - dots[down].g) {
						Dot d0 = dots[i];
						dots[i] = dots[down];
						dots[down] = d0;
					}

					if (dots[i].b - dots[up].b > dots[i].b - dots[down].b) {
						Dot d0 = dots[i];
						dots[i] = dots[down];
						dots[down] = d0;
					}
				}

			}

			Thread.sleep(3);
		} catch (Exception e) {
			println(e);
		}
	}
}

void putWord (String word)
{
	int s = (width > height) ? height : width;

	textAlign(CENTER);
	rectMode(CENTER);
	textSize((s / word.length()) * 1.25);
	text(word, width * 0.5, height * 0.5);

}

void draw ()
{
	background(32);

	loadPixels();

	for (int i = 0; i < dots.length; i++) {
		pixels[i] = dots[i].Color();
	}

	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

