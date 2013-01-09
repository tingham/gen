// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Jan 06 2013
// 

int height = 2048;
int width = height;
int rectSize = 32;

void setup ()
{
	rectMode(CENTER);
	size(width, height);
	fill(230);
	noStroke();
	rect(width / 2, width / 2, width, height);

	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			if (x % rectSize == 0 && y % rectSize == 0) {
				pushMatrix();
				translate(x, y);
				drawSquare();
				popMatrix();
			}
		}
	}

	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			stroke(random(128), random(128), random(128), random(16));
			strokeWeight(random(2));
			point(x, y);
		}
	}

	save("data/output/diamond-background-" + width + "-" + height + ".tif");
}

void drawSquare () {
	pushMatrix();
	scale(1.0, 2.1);
	rotate(PI / 4);
	stroke(225);
	strokeWeight(1.0);
	noFill();
	rect(width * 0.05, height * 0.05, width * 0.05, height * 0.05);
	popMatrix();
}

