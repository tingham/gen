// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue May 14 2013
// 

int width = 850;
int height = 1100;
int tick = 0;

String inputFile = "data/input/tingham.jpeg";
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;
int[] offsets;
float powerDepletion = 0.01;
PImage base;

void setup ()
{
	base = loadImage(inputFile);
	width = base.width;
	height = base.height;
	base.loadPixels();
	/*
	for (int i = 0; i < base.pixels.length; i++) {
		float b = brightness(base.pixels[i]);
		if (brightness(base.pixels[i]) < 128) {
				base.pixels[i] = color(lerp(b, 0, 0.15));
		} else {
				base.pixels[i] = color(lerp(b, 255, 0.15));
		}
	}
	*/
	base.updatePixels();

	offsets = new int[] {-2, -(width + 1), 2};
	dots = new Dot[width * height];
	size(width, height, P3D);

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
			((float)y / (float)height) * 3,
			((float)y / (float)height) * 2
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

		dots[i] = new Dot(n1, n2, n3, 1.0);
	}

	thread("update");
}

void update () {
	while (true) {
		try {
			float f = random(0.25, 0.9);
			for (int i = 0; i < width * height; i++) {
				if (i > width + 1 && i < width * height - 1) {
                        float pd = ((float)brightness(base.pixels[i]) / (float)255) * powerDepletion;
						float cr, cg, cb;
						cr = red(base.pixels[i]) / 255;
						cg = green(base.pixels[i]) / 255;
						cb = green(base.pixels[i]) / 255;
						if (dots[i].power < 0) {
								/*
								dots[i].r = lerp(dots[i].r, cr, pd);
								dots[i].g = lerp(dots[i].g, cg, pd);
								dots[i].b = lerp(dots[i].b, cb, pd);
								*/
								// dots[i] = new Dot(cr, cg, cb, 1.0);
								if (dots[i].r > cr || dots[i].g > cg || dots[i].b > cb) {
										dots[i].power = 0.1;
								} else {
										dots[i].r = lerp(dots[i].r, cr, 0.015);
										dots[i].g = lerp(dots[i].g, cg, 0.015);
										dots[i].b = lerp(dots[i].b, cb, 0.015);
										continue;
								}
						}
						       
						if (dots[i].r < dots[i - 1].r && dots[i].r < cr) {
								Dot p = new Dot(dots[i].r, dots[i].g, dots[i].b, dots[i].power);
								dots[i] = dots[i - 1];
								dots[i - 1] = p;
								dots[i].power -= pd;
								dots[i - 1].power -= pd;
						}

						if (dots[i].g < dots[i - width].g && dots[i].g < cg) {
								Dot u = new Dot(dots[i].r, dots[i].g, dots[i].b, dots[i].power);
								dots[i] = dots[i - width];
								dots[i - width] = u;
								dots[i].power -= pd;
								dots[i - width].power -= pd;
						}

						int offset1 = offsets[(int)random(0, offsets.length)];

						if (dots[i].b > dots[i + offset1].b && dots[i].b > cb) {
								Dot ul = new Dot(dots[i].r, dots[i].g, dots[i].b, dots[i].power);
								dots[i] = dots[i + offset1];
								dots[i + offset1] = ul;
								dots[i].power -= pd;
								dots[i + offset1].power -= pd;
						}
				}
			}
			Thread.sleep(15);
		} catch (Exception e) {
		}
	}
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
        float power;

	public Dot (float r, float g, float b, float power) {
		this.r = r;
		this.g = g;
		this.b = b;
                this.power = power;
	}
}

