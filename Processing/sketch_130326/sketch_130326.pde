// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Mar 26 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
String inputName = "data/input/" + "8589919433_7da2130919_b.jpg";
int[] startColors;
PImage img;

void setup ()
{
	img = loadImage(inputName);
	img.loadPixels();
	startColors = new int[img.pixels.length];
	for (int i = 0; i < img.pixels.length; i++) {
		startColors[i] = img.pixels[i];
	}

	width = img.width;
	height = img.height;

	size(width, height);
	thread("update");
}

void update () {
	while(true) {
		try{
			tick++;
			img.loadPixels();
			for (int i = 0; i < img.pixels.length; i++) {
				// if y > threshold - modify.
				int x = i % width;
				int y = (i - x) / width;
				float s = (0.5 * sin(tick * 0.1)) + 0.5;

				if ((float)y / (float)height < s) {

					// modify
					int dIndex = 0;
					if (x < width * 0.5) {
						dIndex = (y * width) + (int)lerp(width * 0.5, x, s);
					} else {
						dIndex = (y * width) - (int)lerp(x, width, 1.0 - s);
					}
					if (dIndex > 0 && dIndex < img.pixels.length) {
						img.pixels[i] = img.pixels[dIndex];
					}
				} else {
					img.pixels[i] = startColors[i];
				}

			}
			img.updatePixels();
			Thread.sleep(10);
		} catch (Exception e) {
		}
	}
}

void draw ()
{

	image(img, 0, 0);

	long t = System.currentTimeMillis();
	if (mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

