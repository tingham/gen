// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Sep 20 2013
// 
import com.mutiny.*;

int width = 1920;
int height = 1080;
int tick = 0;
String outputName= "data/output/" + System.currentTimeMillis() + "/";
String chuck = "data/input/6625777763_1c52f810de_o.jpg";
PImage chuckImage;

Dot[] chuckPixels;
Dot[] imagePixels;

void setup ()
{
	size(width, height, P3D);

	chuckImage = loadImage(chuck);
	chuckImage.loadPixels();

	chuckPixels = new Dot[width * height];
	imagePixels = new Dot[chuckImage.pixels.length];

	for (int i = 0; i < chuckImage.pixels.length; i++) {
		chuckPixels[i] = new Dot((int)chuckImage.pixels[i]);
	}
}

void cachePixels ()
{
	loadPixels();
	for (int i = 0; i < pixels.length; i++) {
		Dot d = new Dot(pixels[i]);
		Dot r = imagePixels[i];
		if (r != null) {
			r.r = lerp(d.r, r.r, 0.5);
		}
		else {
			r = new Dot(0.75, 0.75, 0.72, 1.0, 1.0);
		}
		imagePixels[i] = r;
	}
}

void accumulateEdging ()
{
	PVector a = new PVector(width * 0.5, height * 0.5);
	for (int i = 0; i < imagePixels.length; i++) {

		if (random(1) > 0.25) {
			continue;
		}

		float x = (float)i % width;
		float y = (float)(i - x) / width;
		PVector b = new PVector(x, y);
		float f = PVector.dist(a, b) / width;
		Dot d = imagePixels[i];
		d.r = lerp(d.r, 0.25, f);
		d.g = lerp(d.g, 0.25, f);
		d.b = lerp(d.b, 0.23, f);
		d.power = lerp(d.power, 1, (1 - f) * 0.005);
		imagePixels[i] = d;
	}
}

void injectSampledImage ()
{
	PVector a = new PVector(width * 0.5, height * 0.5);
	for (int i = 0; i < imagePixels.length; i++) {
		if (random(1) > 0.6) {
			continue;
		}

		float x = (float)i % width;
		float y = (float)(i - x) / width;
		PVector b = new PVector(x, y);
		float f = (PVector.dist(a, b) / ((float)height * 0.45));

		if (f < 0.0) { f = 0.0; }
		if (f > 1.0) { f = 1.0; }

		Dot d = imagePixels[i];
		Dot c = chuckPixels[i];
		d.r = lerp(d.r, c.r, (1.0 - f) * random(0.001, 0.01));
		d.g = lerp(d.g, c.g, (1.0 - f) * random(0.001, 0.01));
		d.b = lerp(d.b, c.b, (1.0 - f) * random(0.001, 0.01));
		imagePixels[i] = d;
	}
}

void drawPixels ()
{
	loadPixels();
	for (int i = 0; i < imagePixels.length; i++) {
		pixels[i] = imagePixels[i].Color();
	}
	updatePixels();
}

void flowPixels ()
{
	for (int i = 0; i < imagePixels.length; i++) {
		Dot d0 = imagePixels[i];
		float x = (float)i % width;
		float y = (float)(i - x) / width;
		int up = (int)((y + 1) * width + x);
		int right = (int)(y * width + (x + 1));
		int left = (int)(y * width + (x - 1));

		if (up > 0 && up < imagePixels.length && right > 0 && right < imagePixels.length && left > 0 && left < imagePixels.length) {

			if (d0.r < imagePixels[up].r &&
				d0.g > imagePixels[right].g &&
				d0.b > imagePixels[left].b) {
				imagePixels[i] = imagePixels[up];
				imagePixels[up] = d0;
			}

			if (d0.g < imagePixels[right].g &&
				d0.b > imagePixels[left].b &&
				d0.r > imagePixels[up].r) {
				imagePixels[i] = imagePixels[right];
				imagePixels[up] = d0;
			}

			if (d0.b < imagePixels[left].b &&
				d0.r > imagePixels[up].r &&
				d0.g > imagePixels[right].g) {
				imagePixels[i] = imagePixels[left];
				imagePixels[left] = d0;
			}

			if (d0.g < imagePixels[right].g && d0.b < imagePixels[left].b) {
				imagePixels[i] = imagePixels[up];
				imagePixels[up] = d0;
			}

			if (d0.g < imagePixels[up].g && d0.b < imagePixels[right].b) {
				imagePixels[i] = imagePixels[left];
				imagePixels[left] = d0;
			}

			if (d0.r < imagePixels[left].b && d0.b < imagePixels[up].g && imagePixels[i].power > 0.5) {
				Dot d1 = imagePixels[left];
				imagePixels[left] = imagePixels[right];
				imagePixels[right] = d1;
			}

			if (d0.g < imagePixels[left].r && d0.r < imagePixels[up].b && imagePixels[i].power > 0.5) {
				Dot d1 = imagePixels[right];
				imagePixels[right] = imagePixels[left];
				imagePixels[left] = d1;
			}

			if (tick > 250 && d0.r + d0.g + d0.b < random(1.5) && ((y - 2) * width + x) > 0) {
				int down = (int)((y - 2) * width + x);
				Dot d1 = imagePixels[i];
				Dot d2 = imagePixels[down];
				imagePixels[down] = d1;
				imagePixels[i] = d2;
				break;
			}

			if (tick > 160 && d0.r < d0.g + d0.b && random(1) > 0.999) {
				Dot d1 = imagePixels[i];
				Dot d2 = chuckPixels[i];

				d1.r = lerp(d1.r, d2.r, 0.01);
				d1.g = lerp(d1.g, d2.g, 0.01);
				d1.b = lerp(d1.b, d2.b, 0.01);

				imagePixels[i] = d1;
			}

		}
	}
}

void draw ()
{
	int stopAccum = 100;
	int startInject = 60;
	int injectLength = 200;

	tick++;

	cachePixels();

	if (tick < stopAccum) {
		accumulateEdging();
	}

	if (tick > startInject && tick < startInject + injectLength) {
		injectSampledImage();
	}
	else if (tick % (int)(random(1000) + 1) == 0) {
		accumulateEdging();
		injectSampledImage();
	}

	int lapse = injectLength / 3;

	if (tick < (startInject + lapse)  || tick > injectLength - lapse) {
		flowPixels();
	}

	drawPixels();

	long t = System.currentTimeMillis();
	if (t % 2 == 0 && tick < 3000) {
		save(outputName + "s-" + t + ".jpg");
	}
}

