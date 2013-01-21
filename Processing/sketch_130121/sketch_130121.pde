// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 21 2013
// 
int width = 512;
int height = 512;
int tick = 0;
int offset = 512;

void setup ()
{
	size(width, height);
}

void draw ()
{
	tick++;

	noStroke();
	fill(255);
	rect(0, 0, width, height);

	pushMatrix();
	translate(0, height / 2);
	beginShape();
	for (int x = 0; x < width; x++) {
		float fn = noise(((float)x / (float)width) + (tick * 0.01), tick * 0.01);
		vertex(x, (fn * offset) - (offset * 0.5));
		if (random(1) > 0.67) {
			stroke(random(255), random(128), random(128));
		} else if (random(1) > 0.5) {
			stroke(random(128), random(255), random(128));
		} else {
			stroke(random(128), random(128), random(255));
		}
		if (x % 14 == 0) {
			strokeWeight(16);
			line(x, (fn * offset) - (offset * 0.5) + 1, x, height - 1);
		}
	}
	stroke(0);
	strokeWeight(16);
	noFill();
	endShape();
	popMatrix();

	long m = System.currentTimeMillis();
	if (m % 90 == 0) {
		save("data/output/r-" + m + ".jpg");
	}
}

