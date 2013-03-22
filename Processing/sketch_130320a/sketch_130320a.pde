// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Mar 20 2013
// 

int width = 512;
int height = 512;
int tick = 0;

String outputName = "data/output/" + System.currentTimeMillis() + "/";
String inputName = "data/input/" + "5094395053_1e3df21bcf_b.jpg";
PImage img;
int currentAverage;
int[] pColors;

void setup ()
{
	img = loadImage(inputName);
	img.loadPixels();
	pColors = new int[width * height];
	for (int i = 0; i < width * height; i++) {
		pColors[i] = img.pixels[i];
	}

	width = img.width;
	height = img.height;

	size(width, height);

	thread("update");
}

void update () {
	while (true) {
		try {
			img.loadPixels();
			int[] pixels = img.pixels;
			int l = 0; // (int)random(width * height);
			int h = width * height; //(l + width > width * height) ? l - width : l + width;
			for (int i = l; i < h; i++) {
				processAt(i, pixels);
			}
			img.updatePixels();
			Thread.sleep(10);
		} catch (Exception e) {
		}
	}
}

void processAt (int pixelIndex, int[] pixels) {
	int[] neighbors = neighborOffsets();
	int newColor = pixels[pixelIndex];
	int count = 0;
	for (int i = 0; i < neighbors.length; i++) {
		int indexA = pixelIndex;
		int x = (pixelIndex + neighbors[i]) % width;
		int y = (pixelIndex + neighbors[i]) / height;
		if (pixelIndex + neighbors[i] > 0 && pixelIndex + neighbors[i] < width * height) {
			indexA = pixelIndex + neighbors[i];
			newColor = mixColor(
				newColor,
				img.pixels[indexA],
				noise(
					(float)x / (float)width,
					(float)y / (float)height
				)
			);
			count++;
		}
	}
	img.pixels[pixelIndex] = newColor;
}

int[] neighborOffsets () {
	return new int[] {
		-1,
		-(width + 1),
		-(width),
		-(width - 1),
		width - 1,
		width,
		width + 1
	};
}

int averageColor (int colorA, int colorB) {
	float ra, rb;
	float ga, gb;
	float ba, bb;
	int divisor = 2;

	ra = red(colorA);
	rb = red(colorB);
	ga = green(colorA);
	gb = green(colorB);
	ba = blue(colorA);
	bb = blue(colorB);

	return color(ra + rb / divisor, ga + gb / divisor, ba + bb / divisor);
}

int mixColor (int colorA, int colorB, float d) {
	float r = red(colorA),
		g = green(colorA),
		b = blue(colorA);

	int di = (int)(d * 100);
	d = (float)(di / 100.0);
	r = lerp(r, red(colorB), d);
	g = lerp(g, green(colorB), d);
	b = lerp(b, blue(colorB), d);

	return color(r, g, b);
}

void draw ()
{
	image(img, 0, 0);
	long t = System.currentTimeMillis();
	if (t % 30 == 0 && mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

