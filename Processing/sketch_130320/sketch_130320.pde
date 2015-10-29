// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Mar 20 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
String inputName = "data/input/" + "109216612_2d7fa7c7d1_b.jpg";
PImage img;


void setup ()
{
	img = loadImage(inputName);
	img.loadPixels();
	width = img.width;
	height = img.height;
	size(width, height);

	thread("update");
}

void update () {
	while (true) {
		try {
			int l = 0; //(int)random(0, width * height);
			int h = width * height; //(int)random(l, width * height);
			img.loadPixels();
			for (int i = l; i < h; i++) {
				int topIndex = (i - width > 0) ? i - width : i;
				int topColor = img.pixels[topIndex];
				int bottomIndex = (i + width < width * height) ? i + width : i;
				int bottomColor = img.pixels[bottomIndex];
				int leftIndex = (i - 1 > 0) ? i - 1 : i + (width - 1);
				int leftColor = img.pixels[leftIndex];
				int rightIndex = (i + 1 < width * height) ? i + 1 : (i - (width + 1));
				int rightColor = img.pixels[rightIndex];
				int tc = img.pixels[i];

				/*
				img.pixels[leftIndex] = rightColor;
				img.pixels[topIndex] = bottomColor;
				img.pixels[rightIndex] = leftColor;
				img.pixels[bottomIndex] = topColor;
				*/

				if (random(1.0) > 0.5) {
					float r = random(1.0);
					if (r > 0.75) {
						img.pixels[i] = topColor;
						img.pixels[leftIndex] = rightColor;
					} else if (r > 0.5) {
						img.pixels[i] = rightColor;
						img.pixels[topIndex] = bottomColor;
					} else if (r > 0.25) {
						img.pixels[i] = bottomColor;
						img.pixels[rightIndex] = leftColor;
					} else {
						img.pixels[i] = leftColor;
						img.pixels[bottomIndex] = topColor;
					}
				}
			}
			img.updatePixels();
			Thread.sleep(2);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	image(img, 0, 0);
	long t = System.currentTimeMillis();
	if (t % 30 == 0 && mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

