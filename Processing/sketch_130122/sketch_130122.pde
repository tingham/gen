// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 22 2013
// 

int width = 512;
int height = 512;
int tick = 0;

void setup ()
{
	size(width, height);
	smooth();
}

void draw ()
{
	tick++;

	background(255);

	stroke(0);
	strokeWeight(0.125);
	noFill();

	beginShape();

	translate(width / 2, height / 2);

	float y = 0;
	for (int x = 0; x < width; x++) {
		y = tan((x - tick) * 0.05);
		curveVertex(x - (width / 2), y);
	}

	endShape();

	if (System.currentTimeMillis() % 30 == 0) {
		save("data/output/s-" + System.currentTimeMillis() + ".jpg");
	}
}

