// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed May 15 2013
// 

import com.mutiny.*;

int width = 512;
int height = 512;
int pointCount = width * height;

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Rect m;
Dot[] dots;
float nScale = 2;

void setup ()
{
	size(width, height, P3D);

	dots = new Dot[width * height];
	for (int i = 0; i < pointCount; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float n1 = noise(
			((float)x / (float)width) * nScale,
			(float)y / (float)height * nScale
		);

		float n2 = noise(
			(float)y / (float)height * nScale,
			((float)x / (float)width) * nScale
		);

		float n3 = noise(
			n1 * nScale,
			n2 * nScale
		);

		dots[i] = new Dot(n1, n2, n3, 1.0);
	}

	thread("update");
}

void update () {
	while (true) {
		try {
			displace();
			Thread.sleep(5);
		} catch (Exception e) {
		}
	}
}

void displace () {
	int ri = pointCount; // (int)random(pointCount);
	int li = 0; //(int)random(ri * 0.5);

	for (int i = li; i < ri; i++) {
		Dot d0 = dots[i];
		int x = i % width;
		int y = (i - x) / width;
		
		int[] evals = makeEvals(x, y);

		for (int r = 0; r < evals.length; r++) {
			if (evals[r] > 0 &&
					evals[r] < pointCount) {
				if (dots[i].r > dots[evals[r]].r ||
						dots[i].g > dots[evals[r]].g ||
						dots[i].b > dots[evals[r]].b) {
					swapDots(i, evals[r]);
				}
			}
		}


	}
}

int[] makeEvals (int x, int y) {
	int[] evals = new int[] {
		(y - 1) * width + x, // t
		(y - 1) * width + (x + 1), // ur
		y * width + (x + 1), // right
		(y + 1) * width + (x + 1), // dr
		(y + 1) * width + x, // b
		(y + 1) * width + (x - 1), // dl
		y * width + (x - 1), // left
		(y - 1) * width + (x - 1) // ul
	};
	return evals;
}

void smudgeDot (int index, float amt) {
	int x = index % width;
	int y = index - x / width;
	int[] evals = makeEvals(x, y);
	for (int i = 0; i < evals.length; i++) {
		if (evals[i] > 0 && evals[i] < pointCount) {
			dots[evals[i]].r = lerp(dots[evals[i]].r, dots[index].r, amt);
			dots[evals[i]].g = lerp(dots[evals[i]].g, dots[index].g, amt);
			dots[evals[i]].b = lerp(dots[evals[i]].b, dots[index].b, amt);
			dots[evals[i]].a = lerp(dots[evals[i]].a, dots[index].a, amt);
		}
	}
}

void swapDots (int a, int b) {
	Dot _d = dots[a];
	dots[a] = dots[b];
	dots[b] = _d;
}

void draw ()
{
	background(255);

	loadPixels();
	for (int i = 0; i < pointCount; i++) {
		int x = i % width;
		int y = (i - x) / width;
		pixels[i] = (int)dots[i].Color();
	}
	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 50 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

