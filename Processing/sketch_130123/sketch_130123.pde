// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Jan 23 2013
// 

ArrayList<PImage> imgs = new ArrayList<PImage>();

int width = 512;
int height = 512;

int tilesize = 64;
int tick = 0;

void setup ()
{
	size(width, height);
	imgs.add(loadImage("data/input/legs.jpg"));
	imgs.add(loadImage("data/input/daffodils.jpg"));
	prepare();
}

void prepare ()
{
	tick++;

	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			if (x % tilesize == 0 && y % tilesize == 0) {
				PImage drop = imgs.get((int)random(imgs.size()));
				int rx = (int)(random(drop.width - (tilesize * 2)));
				int ry = (int)(random(drop.height - (tilesize * 2)));

				blend(drop, rx, ry, tilesize * 2, tilesize * 2, x, y, tilesize, tilesize, BLEND);
				noFill();
				stroke(32);
				rect(x, y, tilesize, tilesize);
			}
		}
	}
	loadPixels();
}

void draw () {
	tick++;

	strokeWeight(0.6);

	for (int i = 0; i < pixels.length; i++) {
		int x = (int)(i / width);
		int y = (int)(i % width);
		color mc = pixels[i];
		pushMatrix();
		translate(x, y);
		rotate(random(TWO_PI));
		if (red(mc) > 200) {
			stroke(red(mc) + 16, green(mc) + 16, blue(mc) + 16, 4);
			line(x, y, x + tilesize + (red(mc) - 200), y);
		}
		if (blue(mc) > 200) {
			stroke(red(mc) - 32, green(mc) - 32, blue(mc) - 32, 4);
			line(x, y, x, y + tilesize + (red(mc) - 200));
		}
		popMatrix();
	}

	if (System.currentTimeMillis() % 10 == 0) {
		save("data/output/j-" + System.currentTimeMillis() + ".jpg");
	}
}

