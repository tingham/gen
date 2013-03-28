// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Mar 27 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
int[] pArray;

void setup ()
{
	size(width, height);
	pArray = new int[width * height];
	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;
		float n = noise((float)x / (float)width, (float)y / (float)height);
		pArray[i] = color(n * 255);
	}
}

void draw ()
{
	background(225);
	for (int i = 0; i < pArray.length; i++) {
		int x = i % width;
		int y = (i - x) / width;
		if (y % 3 == 0) {
			drawDot(x, y, 1, pArray[i]);
		}
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

void drawDot (int x, int y, float r, int c) {
	fill(c);
	stroke(red(c), green(c), blue(c), alpha(c) * 0.5);
	strokeWeight(1);
	ellipse(x, y, r, r);
}
