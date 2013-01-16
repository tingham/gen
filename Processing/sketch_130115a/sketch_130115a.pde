// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 15 2013
// 
int width = 1024;
int height = 1024;

int cellSize = 32;
int cellX = (int)(width / cellSize);
int cellY = (int)(height / cellSize);

float[][] gridCells = new float[cellX][cellY];

int t = (int)System.currentTimeMillis();

int tick = 0;

void setup ()
{
	size(width, height);
	initCells();
	thread("update");
}

void update () {
	while (true) {
		tick++;

		if (tick < 130) {
			for (int x = 0; x < gridCells.length; x++) {
				for (int y = 0; y < gridCells[x].length; y++) {
					float score = nScore(x, y, gridCells);
					gridCells[x][y] += score;
				}
			}
		}

		if (tick % 30 == 0 && tick < 121) {
			int oldCellSize = (int)cellSize;
			int oldCellX = (int)cellX;
			int oldCellY = (int)cellY;

			cellSize = (int)(cellSize / 2);
			cellX = (int)(width / cellSize);
			cellY = (int)(height / cellSize);

			float[][] newCells = new float[cellX][cellY];
			for (int x = 0; x < gridCells.length; x++) {
				for (int y = 0; y < gridCells[x].length; y++) {
					for (int fx = 0; fx < cellSize; fx++) {
						for (int fy = 0; fy < cellSize; fy++) {
							int px = (x * (oldCellSize / cellSize)) + fx;
							int py = (y * (oldCellSize / cellSize)) + fy;
							if (px < newCells.length && py < newCells[px].length) {
								newCells[px][py] = gridCells[x][y];
							}
						}
					}
				}
			}
			gridCells = newCells;
		}

		try {
			Thread.sleep(100);
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
	for (int xo = 0; xo < offsets.length; xo++) {
		int xOffset = x + offsets[xo][0];
		int yOffset = y + offsets[xo][1];
		if (xOffset > 0 && xOffset < cells.length && yOffset > 0 && yOffset < cells[xOffset].length) {
			if (cells[xOffset][yOffset] > 0.3) {
				score += 0.01;
			} else {
				score -= 0.01;
			}
		}
	}

	if (x == 0 || y == 0 || x == cells.length - 1|| y == cells[x].length - 1) {
		score -= 0.1;
	}

	return score;
}

void draw ()
{
	for (int x = 0; x < gridCells.length; x++) {
		for (int y = 0; y < gridCells[x].length; y++) {
			noStroke();
			fill(gridCells[x][y] * 255);
			rect((float)x * cellSize, (float)y * cellSize, cellSize, cellSize);
		}
	}

	if (System.currentTimeMillis() % 90 == 0) {
		save("data/output/c-" + t + "-" + System.currentTimeMillis() + ".jpg");
	}
}

void initCells () {
	for (int x = 0; x < gridCells.length; x++) {
		for (int y = 0; y < gridCells[x].length; y++) {
			if (x < 2 || y < 2 || x > gridCells.length - 2 || y > gridCells[x].length - 2) {
				gridCells[x][y] = 0;
			} else {
				gridCells[x][y] = random(1) > 0.5 ? 1 : 0;
			}
		}
	}
}

