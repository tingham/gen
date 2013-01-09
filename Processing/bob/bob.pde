// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jan 04 2013
// 

import processing.video.*;
Capture cam;
int tick = 0;

ArrayList<PImage> filterPixels = new ArrayList<PImage>();
PImage prevFrame;

void setup ()
{
	size( 480, 360);
	cam = new Capture(this, 480, 360, 25);
	cam.start();
}

void captureEvent(Capture cam)
{
	if (cam.available()) {
		prevFrame = createImage(cam.width, cam.height, RGB);
		prevFrame.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
		prevFrame.updatePixels();
		prevFrame.loadPixels();
		cam.read();
		cam.loadPixels();
	}
}

void draw ()
{
	tick++;
	float s = 0.5 + sin(tick * 0.1) * 0.5;

	if (random(1) > 0.75) {
		image(cam, 0, 0);
	}

	for (int c = 0; c < 200; c++) {
		if (prevFrame != null) {
			int x = (int)random(prevFrame.width); 
			int y = (int)random(prevFrame.height);
			int index = y * width + x;
			if (index > 1 && index < prevFrame.pixels.length - 1) {
				color mc = prevFrame.pixels[index];
				color pc = prevFrame.pixels[index - 1];
				color nc = prevFrame.pixels[index + 1];
				int bright = (int)((brightness(mc) + brightness(pc) + brightness(nc)) / 3);
				stroke(red(mc), green(pc), blue(nc), 128);

				strokeWeight(bright * 0.25);
				point(x, y);
			}
		}
	}

	if (prevFrame != null && random(1) > 0.999) {
		PImage n = createImage(prevFrame.width, prevFrame.height, RGB);
		n.copy(prevFrame, 0, 0, prevFrame.width, prevFrame.height, 0, 0, prevFrame.width, prevFrame.height);
		if (filterPixels.size() > 10) {
			filterPixels.set((int)random(filterPixels.size() - 1), n);
		} else {
			filterPixels.add(n);
		}
	}

	if (prevFrame != null && filterPixels.size() > 0) {
		int sw = (int)random(prevFrame.width);
		int sh = (int)random(prevFrame.height);

		blend(
			filterPixels.get((int)random(filterPixels.size())),
			(int)(sw * 0.5),
			(int)(sh * 0.5),
			sw,
			sh,
			(int)(sw * 0.5),
			(int)(sh * 0.5),
			sw,
			sh,
			BLEND
		);
	}

	if (tick % 5 == 0 && tick < 100) {
		String t = "" + tick;
		while (t.length() < 8) {
			t = "0" + t;
		}
		loadPixels();
		save("output/video-play-" + t + ".tga");
	}
}

