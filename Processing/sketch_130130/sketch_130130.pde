// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Jan 30 2013
// 

int width = 1024;
int height = 1024;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

color[] cache = new color[width * height];
boolean firstFrame = true;

// http://www.flickr.com/photos/klearchos/2796627203/sizes/l/in/photostream/
// String inputName = "data/input/2796627203_d2c5359ec9_b.jpg";
// http://www.flickr.com/photos/alpacaknitter/5477971360/sizes/o/in/photostream/
String inputName = "data/input/5477971360_5381557d06_o.jpg";

PImage input;

ArrayList<PVector> points = new ArrayList<PVector>();

void setup ()
{
	size(width, height);
	input = loadImage(inputName);
	input.loadPixels();

	image(input, (width / 2) -(input.width / 2), (height / 2) - (input.height / 2));

	for (int i = 0; i < 10; i++) {
		points.add(new PVector(random(-1, 1), random(-1, 1)));
	}
}

void renderNoise () {
	for (int i = 0; i < cache.length; i++) {
		stroke(
			color(random(255), random(255), random(255), 255)
		);
		strokeWeight(2);
		point(i / width, i % width);
	}
}

void draw ()
{
	tick++;
	float s1 = sin(tick * 0.1) * 4;

	if (firstFrame) {
		firstFrame = false;
	} else {
		for (int i = 0; i < cache.length; i++) {
			int x = i / width;
			int y = i % width;
			if (x % (int)(16 + s1) == 0 && y % (int)(16 + s1) == 0) {
				drawSquarePixels(cache, (int)x, (int)y, (int)(8 + (s1 / 2)));
			}
		}
	}

	/*
	for (int i = 0; i < points.size(); i++) {
		drawVectorCircles(points.get(i));
	}
	*/

	loadPixels();

	for (int i = 0; i < pixels.length; i++) {
		cache[i] = color(red(pixels[i]), green(pixels[i]), blue(pixels[i]), 255);
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

void drawVectorCircles (PVector origin) {
	int count = (int)random(10) + 1;
	for (int i = 0; i < count; i++) {
		float fi = (float)i / (float)count;
		float x = ((width / 2) + origin.x) + (sin(fi * TWO_PI) * (width * 0.25));
		float y = ((height / 2) + origin.y) + (cos(fi * TWO_PI) * (height * 0.25));
		if (random(1) > 0.5) {
			x *= -1;
		}
		if (random(1) > 0.5) {
			y *= -1;
		}
		stroke(32);
		noFill();
		ellipse(x, y, 32, 32);
	}
}

void drawSquarePixels (color[] parray, int x, int y, int r) {
	for (int ix = x; ix < x + r; ix++) {
		for (int iy = y; iy < y + r; iy++) {
			int indice = iy * width + ix;
			if (indice < parray.length) {
				// color mc = color(255 - red(parray[indice]), 255 - green(parray[indice]), 255 - blue(parray[indice]), 255);
				color mc = parray[indice];
				stroke(mc);
				float fx = ((brightness(mc) / 255) * r);
				float fy = ((brightness(mc) / 255) * r);
				if (random(1) > 0.5) {
					fx *= random(-1.5, -1);
				}
				if (random(1) > 0.5) {
					fy *= random(-1.5, -1);
				}
				point(ix - fx, iy - fy);
			}
		}
	}
}

