// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Feb 01 2013
// 

int width = 512;
int height = 512;
int tick = 0;
float edgeThreshold = 0.75;
float spreadRadius = 2.0;

String inputName = "2913559033_2101d1d7a6_b.jpg";
String outputName = "data/output/" + inputName + "." + System.currentTimeMillis() + "/";
PImage input;

color[] edgePixels = new color[width * height];

void setup ()
{
	input = loadImage("data/input/" + inputName);	
	input.loadPixels();

	size(width, height);

	float sc = 1.0;
	if (input.width < width) {
		sc = ((float)input.width / (float)width);
	} else {
		sc = ((float)width / (float)input.width);
	}

	translate(width / 2, height / 2);
	scale(sc);
	imageMode(CENTER);
	image(input, 0, 0);

	loadPixels();

	processEdges();
}

void processEdges () {
	for (int i = 0; i < edgePixels.length; i++) {
		int x = i % width;
		int y = i / height;

		int left = (y * width + (x - 1));
		int right = (y * width + (x + 1));
		int up = ((y - 1) * width + x);
		int down = ((y + 1) * width + x);

		if (left < 0 || right < 0 || up < 0 || down < 0 ||
			left >= pixels.length || right >= pixels.length || up >= pixels.length || down >= pixels.length) {
			edgePixels[i] = 0;
			continue;
		} else {
			float source = brightness(pixels[i]);
			float dl = brightness(pixels[left]);
			float dr = brightness(pixels[right]);
			float du = brightness(pixels[up]);
			float dd = brightness(pixels[down]);

			float lDiff = 0;
			float rDiff = 0;
			float uDiff = 0;
			float dDiff = 0;

			if (dl > source) {
				lDiff = source / dl;
			} else {
				lDiff = dl / source;
			}

			if (dr > source) {
				rDiff = source / dr;
			} else {
				rDiff = dr / source;
			}

			if (du > source) {
				uDiff = source / du;
			} else {
				uDiff = du / source;
			}

			if (dd > source) {
				dDiff = source / dd;
			} else {
				dDiff = dd / source;
			}

			if ((lDiff < edgeThreshold && rDiff < edgeThreshold) ||
				(uDiff < edgeThreshold && dDiff < edgeThreshold)) {
				edgePixels[i] = 255;
			} else {
				edgePixels[i] = 0;
			}
		}
	}
}

void draw ()
{
	loadPixels();
	for (int i = 0; i < edgePixels.length; i++) {
		int x = i % width;
		int y = i / width;
		color mc = pixels[i];
		color me = edgePixels[i];
		if (me > 0) {
			x += (int)(random(-spreadRadius, spreadRadius) + (red(mc) / 255.0));
			y += (int)(random(-spreadRadius, spreadRadius) + (green(mc) / 255.0));
			if (y * width + x < pixels.length) {
				color p = pixels[y * width + x];
				pixels[y * width + x] = color(
					lerp(red(p), red(p) * 2, 0.01),
					lerp(green(p), green(p) * 2, 0.01),
					lerp(blue(p), blue(p) * 2, 0.01)
				);
			}
		}
	}
	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 90 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

