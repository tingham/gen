// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Oct 01 2013
// 

int width = 1280;
int height = 720;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
String inputName = "";

void setup ()
{
	size(width, height, P3D);
}

void gridDots (int ivx, int ivy)
{
	int pivx = ivx;
	int pivy = ivy;

	for (int x = -width; x < width; x++) {
		for (int y = -height; y < height; y++) {

			if (x % ivx == 0 && y % ivy == 0) {
				if (ivx == pivx) {
					ivx = (int)(pivx * 1.5);
				}
				else {
					ivx = pivx;
				}

				if (ivy == pivy) {
					ivy = (int)(pivy * 1.5);
				}
				else {
					ivy = pivy;
				}

				if (random(1) > 0.99) {
					noStroke();
					fill(random(255), random(255), random(255), random(255));
					rect(x, y, ivx, ivy);
				}

				stroke(200);
				fill(230);
				line(
					x,
					-height * 2,
					x,
					height * 2
				);
				line(
					-width * 2,
					y,
					width * 2,
					y
				);

				ellipse(x, y, ivx * 0.15, ivy * 0.15);
			}

		}
	}
}

void draw ()
{
	fill(32, 32, 32, 8);
	rect(0, 0, width, height);
	tick++;

	int s = (int)((32 + sin(tick * 0.01) * 32) + 32);
	int c = (int)((32 + cos(tick * 0.01) * 32) + 32);

	translate(width * 0.5, height * 0.5);
	scale(1.0, 0.75, 1.0);
	rotateZ(tick * 0.007);
	gridDots(32, 32);

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

