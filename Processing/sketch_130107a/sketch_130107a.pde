// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 07 2013
// Process an image to offset pixels vertically scaled toward the center as the X position increases.
// 

import java.util.Date;

PImage image;
int sample = 8;
float scaleEffector = 0.5;

int tick = 0;

boolean saving = true;

void setup ()
{
	image = loadImage("data/input/mutiny-logo-box.jpg");
	loadPixels();

	size(image.width, image.height);

	clear();
}

void render () {
	for (int x = 0; x < image.width; x++) {
		for (int y = 0; y < image.height; y++) {
			if (x % sample == 0 && y % sample == 0) {
				color mc = image.pixels[y * width + x];
				fill(red(mc), green(mc), blue(mc), random(255));
				stroke(0);
				strokeWeight(1);
				rectMode(CENTER);
				float s = ((float)x / (float)image.width);
				pushMatrix();
				translate(x, (y * (1.0 - s)) + (image.height * (s * scaleEffector))); // (image.height - y) / 2);
				scale((1.0 - s) + 0.00001, (1.0 - s) + 0.00001);
				rect(0, 0, sample, sample);
				popMatrix();
			}
		}
	}

	if (saving) {
		String t = "" + tick;
		while (t.length() < 12) {
			t = "0" + t;
		}
		save("data/output/" + t + ".tif");
	}
}

void clear () {
	fill(0);
	noStroke();
	rect(0, 0, width, height);
}

void draw ()
{
	tick++;
	scaleEffector = 0.5 + (sin(tick * 0.1)) * 0.5;
	render();
}

String mydate()
{ 
	Date d = new Date();
	long timestamp = d.getTime();
	String date = new java.text.SimpleDateFormat("yyyyMMddhmsS").format(timestamp); 
	return date;
}
