// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Jan 16 2013
// 

PImage input;

float[][] r;
float[][] g;
float[][] b;

float threshold = 1.123;

void setup ()
{
	input = loadImage("data/input/input3.jpg");

	input.loadPixels();
	
	size(input.width, input.height);

	r = new float[input.width][input.height];
	g = new float[input.width][input.height];
	b = new float[input.width][input.height];

	for (int x = 0; x < input.width; x++) {
		for (int y = 0; y < input.height; y++) {
			r[x][y] = red(input.pixels[y * width + x]);
			g[x][y] = green(input.pixels[y * width + x]);
			b[x][y] = blue(input.pixels[y * width + x]);
		}
	}

	thread("update");
}

void update () {
	while (true) {

		for (int x = 0; x < input.width; x++) {
			for (int y = 0; y < input.height; y++) {
				float rscore = nScore(x, y, r);
				float gscore = nScore(x, y, g);
				float bscore = nScore(x, y, b);

				r[x][y] = lerp(r[x][y], rscore, 0.45);
				g[x][y] = lerp(g[x][y], gscore, 0.45);
				b[x][y] = lerp(b[x][y], bscore, 0.45);
			}
		}

		try {
			Thread.sleep(30);
		} catch (Exception e) {

		}
	}
}

float nScore (int x, int y, float[][] cells) {
	int[][] offsets = new int[][] {
		{-1, -1},
		{0, -1},
		{1, -1},
		{-1, 0},
		{1, 0},
		{-1, 1},
		{0, 1},
		{1, 1}
	};

	float score = 0;
	float avgc = 0;
	for (int xo = 0; xo < offsets.length; xo++) {
		int xOffset = x + offsets[xo][0];
		int yOffset = y + offsets[xo][1];
		int t = (int)cells[x][y];
		if (xOffset > 0 &&
			   xOffset < cells.length &&
			   yOffset > 0 &&
			   yOffset < cells[xOffset].length) {

			float c = cells[xOffset][yOffset];
			avgc += c;

			/*
			if (c > (t + threshold)) {
				score += 0.25;
			} else {
				score -= 0.1;
			}
			*/
			if (c > 32) {
				score++;
			}
		}
	}

	avgc = avgc / offsets.length;

	if (score > 3) {
		return avgc;
	} else {
		return 0;
	}

	/*
	if (x == 0 || y == 0 || x == cells.length - 1|| y == cells[x].length - 1) {
		score -= 0.1;
	}
	*/

	// return score;
}

void draw ()
{
	noStroke();
	for (int x = 0; x < input.width; x++) {
		for (int y = 0; y < input.height; y++) {
			if (x % 2 == 0 && y % 2 == 0) {
				fill(r[x][y],	g[x][y], b[x][y]);
				rect(x, y, 2, 2);
			}
		}
	}

	long tm = System.currentTimeMillis();
	if (tm % 30 == 0) {
		save("data/output/cellimage-" + tm + ".jpg");
	}
}

