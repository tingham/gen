// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 07 2013
// 

PImage image;
PFont fell;
String[] letters = new String[] {"J", "O", "S", "E", "P", "H", "I", "N", "E", "o", "s", "e", "p", "h", "i", "n", "e"};
int tick = 0;

void setup ()
{
	image = loadImage("data/input/josie.jpg");
	image.loadPixels();
	fell = loadFont("/Users/tingham/Dropbox/Processing/Fonts/IM_FELL_English_Roman-72.vlw");
	size(image.width, image.height);

	int totalr = 0;
	int totalg = 0;
	int totalb = 0;
	for (int i = 0; i < image.pixels.length; i++) {
		color mc = image.pixels[i];
		totalr += red(mc);
		totalg += green(mc);
		totalb += blue(mc);
	}

	fill(totalr / image.pixels.length, totalg / image.pixels.length, totalb / image.pixels.length);
	rect(0, 0, width, height);
}

void draw ()
{
	tick++;

	for (int x = 0; x < image.width; x++) {
		for (int y = 0; y < image.height; y++) {
			if (random(1) > 0.9999) {
				color mc = image.pixels[y * width + x];
				float imp = brightness(mc) / 255;
				if (random(1) > 0.99999) {
					fill(green(mc), blue(mc), red(mc), (imp * 128));
				} else {
					fill(red(mc), green(mc), blue(mc), (imp * 255));
				}
				noStroke();
				textFont(fell, ((1.0 - imp) * 72) + random(144 - min(tick, 144)) + 0.0001);
				pushMatrix();
				translate(x, y);
				rotate(PI * random(-0.1, 0.1));
				text(letters[(int)(random(1) * letters.length)], 0, 0);
				popMatrix();
			} else if (random(1) > 0.99999) {
				color mc = image.pixels[y * width + x];
				float imp = brightness(mc) / 255;
				fill(red(mc), green(mc), blue(mc), ((1.0 - imp) * 128));
				noStroke();
				ellipse(x, y, 32, 32);
			}
		}
	}

	if (tick < 300) {
		String t = "" + tick;
		while (t.length() < 4) {
			t = "0" + t;
		}
		save("data/output/text-pixels-" + t + ".tif");
	}
}

