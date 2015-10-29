// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 29 2013
// 

int width = 512;
int height = 512;

String imageName = "pixelsort";
String outputName = "data/output/" + imageName + "-" + System.currentTimeMillis() + "/";

int[] clr;
int tick = 0;

void setup ()
{
	size(width, height);
	clr = new int[width * height];
	for (int i = 0; i < width * height; i++) {
		clr[i] = color(random(255), random(255), random(255));
	}

	clr = sort(clr);
}

void draw ()
{
	tick++;
	background(32);

	for (int i = 0; i < clr.length; i++) {
		float x = i / width;
		float y = i % width;
		float x1 = (x > 256) ? (width - x) / 256 : (x / 256);
		float y1 = (y > 256) ? (height - y) / 256 : (y / 256);
		float x2 = sin(y * 0.01);
		float y2 = cos(x * 0.01);

		float n1 = noise(x * 0.01, y * 0.01);
		float n2 = noise(x * 0.001, y * 0.001);
		float n3 = noise(x1, y1) * 5;

		stroke(red(clr[i]) * n3, green(clr[i]) * n2, n1 * 255);
		pushMatrix();
		translate(x2 * width, y2 * height);
		point(0, 0);
		popMatrix();
	}

	long t = System.currentTimeMillis();
	if (t % 5 == 0) {
		save(outputName + t + ".jpg");
	}
}

void bsort (int index) {
}

