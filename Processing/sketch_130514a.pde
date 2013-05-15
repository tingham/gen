// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue May 14 2013
// 

int width = 850;
int height = 1100;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots = new Dot[width * height];
int[] offsets = new int[] {-1, -width, -width + 1};

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

		dots[i] = new Dot(n1, n2, n3);
	}

	thread("update");
}

void update () {
	while (true) {
		try {
			float f = random(0.25, 0.9);
			for (int i = 0; i < width * height; i++) {
				if (i > width && i < width * height) {
					if (dots[i].r > dots[i - 1].r) {
						Dot p = new Dot(dots[i].r, dots[i].g, dots[i].b);
						dots[i].r = lerp(dots[i].r, dots[i - 1].r, random(f));
						dots[i - 1].r = lerp(dots[i - 1].r, p.r, random(f));
					}
					if (dots[i].g > dots[i - width].g) {
						Dot u = new Dot(dots[i].r, dots[i].g, dots[i].b);
						dots[i].b = lerp(dots[i].b, dots[i - width].b, random(f));
						dots[i - width].g = lerp(dots[i - width].g, u.g, random(f));
					}

					int offset1 = offsets[(int)random(0, offsets.length)];

					if (dots[i].b > dots[i + offset1].b) {
						Dot ul = new Dot(dots[i].r, dots[i].g, dots[i].b);
						dots[i].b = lerp(dots[i].b, dots[i + offset1].b, random(f));
						dots[i + offset1].b = lerp(dots[i + offset1].b, ul.b, random(f));
					}
				}
			}
			Thread.sleep(5);
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

	public Dot (float r, float g, float b) {
		this.r = r;
		this.g = g;
		this.b = b;
	}
}
