// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jan 17 2013
// 
int width = 512;
int height = 512;
int cellSize = 8;
Map map;
ArrayList<PVector> currentPath;

void setup ()
{
	size(width, height);

	map = new Map(width * height);

	thread("update");
}

void update () {
	while (true) {

		try {
			Thread.sleep(90);
		} catch (Exception e) {}
	}
}

void draw ()
{
	if (currentPath == null) {
		return;
	}

}

class Map {
	int width;
	int height;
	CellType[] cells;

	public Map (int width, int height) {
		this.width = width;
		this.height = height;
		this.cells = new CellType[width * height];
		for (int i = 0; i < this.cells.length; i++) {
			this.cells[i] = CellType.OPEN;
		}
	}

	public ArrayList<PVector> path (PVector a, PVector b) {
		ArrayList<PVector> result = new ArrayList<PVector>();

		return result;
	}

	public CellType typeForCell (PVector p) {
		int indice = (int)(p.y * this.width + p.x);
		if (indice < this.cells.length - 1 && indice > 0) {
			return this.cells[indice];
		}
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

