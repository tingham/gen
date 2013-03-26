// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Mar 23 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int numPoints = 64;
ArrayList<Triangle> map;
ArrayList<PVector> pointToVec;
ArrayList<Integer> outsiders;

void setup ()
{
	size(width, height);

	map = new ArrayList<Triangle>();
	pointToVec = new ArrayList<PVector>();
	outsiders = new ArrayList<Integer>();

	pointToVec.add(new PVector(-width, -height));
	pointToVec.add(new PVector(width, -height));
	pointToVec.add(new PVector(0, -height));
	pointToVec.add(new PVector(0, height));

	int[] pointArray = new int[]{0, 1, 2, 3};
	outsiders.addRange(pointArray);
	map.add(new Triangle(true, pointArray, findCenter(pointArray), findRadius(pointArray)));

	for (int i = 0; i < numPoints; i++) {
		float t = random(1) * TWO_PI;
		pointToVec.add(new PVector(sin(t), cos(t)));
	}

	for (int i = outsiders.size(); i < pointToVec.size() - 1; i++) {
		addPoint(i);
	}
}

void addPoint(int point) {
	ArrayList<ArrayList<Integer>> faces = new ArrayList<ArrayList<Integer>>();
	for (Triangle triangleToDelete : level.
}

void draw ()
{
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

class Triangle {
	int[] vertices;
	boolean isSurrounding;
	PVector circleCenter;
	float circleRadius;

	public Triangle (boolean surround, int[] bounds, PVector center, float radius) {
		if (bounds.length > 4) {

		}
		this.isSurrounding = surround;
		this.vertices = bounds;
		this.circleCenter = center;
		this.circleRadius = radius;
	}
}
