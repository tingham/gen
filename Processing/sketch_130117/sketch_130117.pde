// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jan 17 2013
// 
// Problem: Paths currently will terminate wihtout reaching their destination.
// This is likely because we're either hitting the evaluation limit, or the
// distance check for each neighbor is incorrect.

int width = 512;
int height = 512;
int cellSize = 8;

Map map;

ArrayList<PVector> currentPath;

PVector start = new PVector(20, 20);
PVector end = new PVector(200, 200);
PVector startTarget = new PVector(20, 20);
PVector endTarget = new PVector(200, 200);

int tick = 0;

void setup ()
{
	size(width, height);

	map = new Map(width, height);
	
	startTarget = new PVector(random(width), random(height));
	endTarget = new PVector(random(width), random(height));

	currentPath = map.path(start, end);
	thread("update");
}

void update () {

	while (true) {

		while (map.typeForCell(startTarget) == CellType.BLOCKED) {
			startTarget = new PVector(random(width), random(height));
		}

		endTarget = new PVector(random(width), random(height));

		/*
		currentPath = map.path(start, end);
		*/

		try {
			Thread.sleep(90);
		} catch (Exception e) {}

	}

}

void draw ()
{
	tick++;

	background(255);

	stroke(128);
	strokeWeight(1);
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			if (map.cells[y * width + x] == CellType.BLOCKED) {
				point(x, y);
			}
		}
	}

	map.offsetMap(new PVector(tick, tick));
	currentPath = map.path(start, end);

	start.lerp(startTarget, 0.02);
	end.lerp(new PVector(width / 2 * sin(tick * 0.01) + width / 2, height / 2 * cos(tick * 0.01) + width / 2), 0.15);

	if (currentPath == null) {
		return;
	}

	noStroke();

	fill(0, 255, 0);
	ellipse(start.x, start.y, 5, 5);

	fill(255, 0, 0);
	ellipse(end.x, end.y, 5, 5);

	for (PVector p : currentPath) {
		fill(0);
		rect(p.x, p.y, 1, 1);
	}
}

class Map {
	int width;
	int height;
	CellType[] cells;

	public Map (int width, int height) {
		this.width = width;
		this.height = height;
		this.cells = new CellType[this.width * this.height];
		this.offsetMap(new PVector(0, 0));
	}

	public void offsetMap (PVector offset) {
		for (int i = 0; i < this.cells.length; i++) {
			float y = (i / this.width);
			float x = (i % this.width);
			float n = noise((x + offset.x) / this.width * 8, (y + offset.y) / this.height * 8);
			if (n > 0.65) {
				this.cells[i] = CellType.BLOCKED;
			} else {
				this.cells[i] = CellType.OPEN;
			}
		}
	}

	public ArrayList<PVector> path (PVector a, PVector b) {
		ArrayList<PVector> result = new ArrayList<PVector>();

		int cellCount = 0;

		while (cellCount < cells.length) {

			ArrayList<PVector> neighbors = this.neighbors(a);
			PVector nextCell = new PVector();
			float thisDistance = a.dist(b);
			float evalDistance = 0;
			for (int i = 0; i < neighbors.size(); i++) {
				if (this.typeForCell(neighbors.get(i)) != CellType.BLOCKED) {
					nextCell = neighbors.get(i);
					if (nextCell.dist(b) < a.dist(b)) {
						break;
					}
				}
				cellCount++;
			}
			result.add(a);
			a = nextCell;
			if (a.dist(b) < 1) {
				break;
			}
		}

		return result;
	}

	public CellType typeForCell (PVector p) {
		int indice = (int)(p.y * this.width + p.x);
		if (indice < this.cells.length - 1 && indice > 0) {
			return this.cells[indice];
		}
		return CellType.BLOCKED;
	}

	public ArrayList<PVector> neighbors (PVector p) {
		ArrayList<PVector> result = new ArrayList<PVector>();
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

		for (int i = 0; i < offsets.length; i++) {
			int xo = (int)(p.x + offsets[i][0]);
			int yo = (int)(p.y + offsets[i][1]);
			int indice = yo * width + xo;
			if (indice > 0 && indice < cells.length - 1) {
				result.add(new PVector(xo, yo));
			}
		}

		return result;
	}
}

