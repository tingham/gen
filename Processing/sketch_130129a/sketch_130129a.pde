// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 29 2013
// 

int width = 128;
int height = 128;

int[] clrA = new int[width * height];
int[] clrB = new int[width * height];

int increment = 5;
int tick = 0;

void setup ()
{
	size(width, height);
	for (int i = 0; i < clrA.length; i++) {
		color c = color(random(255), random(255), random(255));
		clrA[i] = c;
		clrB[i] = c;
	}

	for (int x = 0; x < width; x++) {
		bsort(clrA);
		for (int y = 0; y < height; y++) {
			if (y % 8 == 0) {
				bsort(clrA);
			}
		}
	}
}

void draw () {
	tick++;
	for (int i = 0; i < width * height; i++) {
		int x = i / width;
		int y = i % width;

		stroke(clrA[i]);
		point(x, y);
	}
}

void bsort (int[] clrs) {
	for (int i = 0; i < clrs.length - 1; i++) {
		int c1 = clrs[i];
		int c2 = clrs[i + 1];
		int h1 = (int)hue(clrs[i]);
		int h2 = (int)hue(clrs[i + 1]);
		if (h1 > h2) {
			clrs[i + 1] = c1;
			clrs[i] = c2;
		}
	}

}
