// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue May 28 2013
// 

import com.mutiny.*;

int width = 1024;
int height = 1024;
int tick = 0;
int segmentSize = 64;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;
Dot[] blacks;

int[][] offsets = new int[][] {
	{-1, 0}, // left
	{-1, -1}, // top left
	{0, -1}, // top
	{1, -1}, // top right
	{1, 0}, // right
	{1, 1}, // right bottom
	{0, 1}, // bottom
	{-1, 1} // bottom left
};

void setup ()
{
	size(1024, 1024, P3D);
	generate();
	thread("update");
}

void generate ()
{
	dots = new Dot[width * height];
	blacks = new Dot[width * height];

	noiseSeed(1);
	noiseDetail(6,0.5);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float n1 = noise(
			((float)x / (float)width) * 2,
			((float)y / (float)height) * 2
		);
		float n2 = noise(
			((float)x / (float)width) * 4,
			((float)y / (float)height) * 4
		);
		float n3 = noise(
			((float)y / (float)height),
			((float)x / (float)width)
		);
		float n4 = noise(
			((float)y / (float)height) * 0.25,
			((float)x / (float)width) * 0.25
		);

		dots[i] = new Dot(n1, n2, n3, 1.0, n4);
		blacks[i] = new Dot(0, 0, 0, 1.0, 1.0);
	}
}

void update ()
{
	while (true) {
		tick++;
		try {
			Thread.sleep(2);

			if (tick % 16 == 0) {
				drizzle();
			}

			if (tick % 2 == 0) {
				offset();
			}

		} catch (Exception e) {
		}
	}
}

void offset ()
{
	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		int left = y * width + (x - 1);
		int down = (y + 1) * width + x;
		int up = (y - 1) * width + x;
		int right = y * width + (x + 1);

		if (left > 0) {
			if (blacks[i].r > blacks[left].r ||
					(blacks[i].g < blacks[left].g && blacks[i].b < blacks[left].b)) {
				Dot d0 = blacks[i];
				blacks[i] = blacks[left];
				blacks[left] = d0;
			}
		}

		if (right < width * height) {
			if (blacks[i].b > blacks[right].b ||
					(blacks[i].g < blacks[right].g && blacks[i].r < blacks[right].r)) {
				Dot d0 = blacks[i];
				blacks[i] = blacks[right];
				blacks[right] = d0;
			}
		}

		if (down < width * height) {
			if (blacks[i].g < blacks[down].g) {
				Dot d0 = blacks[i];
				blacks[i] = blacks[down];
				blacks[down] = d0;
			}
		}

		if (up > 0) {
			if (blacks[i].b < blacks[up].b) {
				Dot d0 = blacks[i];
				blacks[i] = blacks[up];
				blacks[up] = d0;
			}
		}

	}
}

void drizzle ()
{
	int c = (int)random(0, width * height);
	int x = c % width;
	int y = (c - x) / width;

	int m = (int)random(0, width * height);
	int x2 = m % width;
	int y2 = (m - x2) / width;

	int[] indices = makePath(x, y, x2, y2);

	for (int i = 0; i < indices.length; i++) {
		blacks[indices[i]] = dots[indices[i]];
	}
}

int[] makePath (int x1, int y1, int x2, int y2)
{
	int c = (int)random(1, segmentSize);

	ArrayList<Integer> p = new ArrayList<Integer>();

	while (x1 != x2 && y1 != y2) {
		int dX = min(abs(x1 - x2), segmentSize);
		int dY = min(abs(y1 - y2), segmentSize);

		if (x1 < x2) {
			int r = (int)random(1, dX);
			for (int f = 0; f < r; f++) {
				p.add(y1 * width + (x1++));
			}
		}

		if (x1 > x2) {
			int r = (int)random(1, dX);
			for (int f = 0; f < r; f++) {
				p.add(y1 * width + (x1--));
			}
		}

		if (y1 < y2) {
			int r = (int)random(1, dY);
			for (int f = 0; f < r; f++) {
				p.add((y1++) * width + x1);
			}
		}

		if (y1 > y2) {
			int r = (int)random(1, dY);
			for (int f = 0; f < r; f++) {
				p.add((y1--) * width + x1);
			}
		}

	}

	int[] result = new int[p.size()];
	int i = 0;

	for (Integer r : p) {
		result[i] = r;
		i++;
	}

	return result;

}

int[] makePathFromOrigin (int x, int y) {

	int c = (int)random(segmentSize, width * height);
	int[] p = new int[c];
	for (int i = 0; i < c; i++) {
		int l = -1;
		float f = random(1);

		if (f > 0.75 && l != 2) {
			for (int m = 0; m < width / segmentSize; m++) {
				int left = y * width + (x - 1);
				i++;
				p[i] = left;
				x = p[i] % width;
				y = (p[i] - x) / width;
			}
			l = 0;
		} else if (f > 0.5 && l != 3) {
			for (int m = 0; m < width / segmentSize; m++) {
				int up = (y - 1) * width + x;
				i++;
				p[i] = up;
				x = p[i] % width;
				y = (p[i] - x) / width;
			}
			l = 1;
		} else if (f > 0.25 && l != 0) {
			for (int m = 0; m < width / segmentSize; m++) {
				int right = y * width + (x + 1);
				i++;
				p[i] = right;
				x = p[i] % width;
				y = (p[i] - x) / width;
			}
			l = 2;
		} else {
			for (int m = 0; m < width / segmentSize; m++) {
				int down = (y + 1) * width + x;
				i++;
				p[i] = down;
				x = p[i] % width;
				y = (p[i] - x) / width;
			}
			l = 3;
		}
		x = p[i] % width;
		y = (p[i] - x) / width;

	}
	return p;
}

void draw ()
{
	background(255);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		fill(blacks[i].Color());
		noStroke();
		rect(x, y, 2, 2);
	}

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}