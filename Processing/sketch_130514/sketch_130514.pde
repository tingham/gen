// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue May 14 2013
// 

int width = 850;
int height = 1100;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots = new Dot[width * height];
int[] offsets = new int[] {-width + 1};
float scanLerp = 0.1;

float highR, highG, highB = 0;

void setup ()
{
	size(width, height);

	noiseDetail(8, 0.5);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;
		
		float n1 = noise(
			((float)x / (float)width) * 2,
			((float)y / (float)height) * 2
		);

		float n2 = noise(
			((float)y / (float)height) * 3,
			((float)x / (float)width) * 3
		);

		float n3 = noise(
			(float)i / (float)(width * height),
			(float)i / (float)(width * height)
		);

		float f = random(0.001, 0.125);
		if (n1 < 0.5) {
			n1 = lerp(n1, 0, f);
		} else {
			n1 = lerp(n1, 1, f);
		}

		if (n2 < 0.5) {
			n2 = lerp(n2, 0, f);
		} else {
			n2 = lerp(n2, 1, f);
		}

		if (n3 < 0.5) {
			n3 = lerp(n3, 0, f);
		} else {
			n3 = lerp(n3, 1, f);
		}

		if (n1 > highR) { highR = n1; }
		if (n2 > highG) { highG = n2; }
		if (n3 > highB) { highB = n3; }

		dots[i] = new Dot(n1, n2, n3);
	}

	thread("update");
	thread("perm");
}

void perm () {
	while (true) {
		try {
			if (random(1) > 0.75) {
				merp();
			} else {
				derp();
			}
			Thread.sleep(30);
		} catch (Exception e)  {
		}
	}
}

void derp () {
	int y = (int)random(0, height);
	float psum = 0;
	for (int x = width; x > 0; x--) {
		int i = y * width + x;
		float b = brightness(pixels[i]);
		psum += b;
		if (x < width) {
			if ((psum / (float)(width - x)) - b > 0.75) {
				dots[i].r = lerp(dots[i].r, 1.0, scanLerp);
				dots[i].g = lerp(dots[i].g, 1.0, scanLerp);
				dots[i].b = lerp(dots[i].b, 1.0, scanLerp);
				
				int r = (int)random(-5, 10);
				if (y + r < height && y + r > 0) {
					y = y + r;
				}

			} else {
				dots[i].r = lerp(dots[i].r, 0.0, scanLerp);
				dots[i].g = lerp(dots[i].g, 0.0, scanLerp);
				dots[i].b = lerp(dots[i].b, 0.0, scanLerp);
				if (y - (int)psum > 0) {
					y -= (int)psum;
				}
			}
		}
	}
}

void merp () {
	int y = (int)random(0, height);
	float psum = 0;
	for (int x = 0; x < width; x++) {
		int i = y * width + x;
		float b = brightness(pixels[i]);
		psum += b;
		if (x > 0) {
			if ((psum / (float)x) - b > 0.75) {
				dots[i].r = lerp(dots[i].r, 1.0, scanLerp);
				dots[i].g = lerp(dots[i].g, 1.0, scanLerp);
				dots[i].b = lerp(dots[i].b, 1.0, scanLerp);

				int o = (int)random(-5, 10);
				if (y + o < height && y + o > 0) {
					y += o;
				}
			} else {
				dots[i].r = lerp(dots[i].r, 0.0, scanLerp);
				dots[i].g = lerp(dots[i].g, 0.0, scanLerp);
				dots[i].b = lerp(dots[i].b, 0.0, scanLerp);

				if (y - (int)psum > 0) {
					y -= (int)psum;
				}
			}
		}
	}
}

void update () {
	while (true) {
		try {
			float f = random(0.25, 0.9);
			boolean t = false; // (random(1) > 0.95) ? true : false;

			for (int i = 0; i < width * height; i++) {
				if (i > width && i < width * height) {

					if (dots[i].r > dots[i - 1].r) {
						if (t) {
							switchdots(i, i - 1);
						} else {
							lerpdots(i, i - 1);
						}
					}
					if (dots[i].g > dots[i - width].g) {
						if (t) {
							switchdots(i, i - 1);
						} else {
							lerpdots(i, i - 1);
						}
					}

					int offset1 = offsets[(int)random(0, offsets.length)];
					if (dots[i].b > dots[i + offset1].b) {
						if (t) {
							switchdots(i, i - 1);
						} else {
							lerpdots(i, i - 1);
						}
					}

					dots[i].r -= 0.0001;
					dots[i].g -= 0.0001;
					dots[i].b -= 0.0001;
				}
			}
			Thread.sleep(5);
		} catch (Exception e) {
		}
	}
}

void lerpdots(int a, int b) {
	Dot d0 = dots[a];
	float l = 0.015;

	dots[a].r = lerp(dots[a].r, dots[b].r, l);
	dots[a].g = lerp(dots[a].g, dots[b].g, l);
	dots[a].b = lerp(dots[a].b, dots[b].b, l);

	dots[b].r = lerp(dots[b].r, d0.r, l);
	dots[b].g = lerp(dots[b].g, d0.g, l);
	dots[b].b = lerp(dots[b].b, d0.b, l);
}

void switchdots(int a, int b) {
	Dot d0 = dots[a];
	dots[a] = dots[b];
	dots[b] = d0;
}

void draw ()
{

	loadPixels();
	for (int i = 0; i < width * height; i++) {
		pixels[i] = color(dots[i].r * 255, dots[i].g * 255, dots[i].b * 255);
	}
	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

class Dot {
	float r, g, b;

	public Dot (float r, float g, float b) {
		this.r = r;
		this.g = g;
		this.b = b;
	}
}
