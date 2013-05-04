// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri May 03 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int pointCount = 64;

PVector[] vertices;
PVector[] uvs;

int[] triangles;
int[] normals;
int[] colors;

void setup ()
{
	size(width, height, P3D);

	// generate a set of random points
	vertices = new PVector[pointCount];
	triangles = new int[pointCount * 3];
	for (int i = 0; i < pointCount; i++) {
		vertices[i] = new PVector(random(width), random(height), random(pointCount));
		sortPoints(vertices, 0, i);
	}
	sortPoints(vertices, 0, vertices.length - 1);

	println(vertices);

	// sort points left->right, top->bottom
	
	// iterate points making triangles of the last three points evaluated
}

void sortPoints(PVector[] list, int l, int h) {
	int i = l;
	int j = h;
	PVector p = list[l + (h - l) / 2];
	while (i <= j) {
		while (list[i].x < p.x && list[i].y < p.y) {
			i++;
		}
		while (list[j].x > p.x && list[j].y > p.y) {
			j--;
		}
		if (i <= j) {
			PVector x = list[i];
			list[i] = list[j];
			list[j] = x;
			i++;
			j--;
		}
	}

	if (l < j) {
		sortPoints(list, l, j);
	}

	if (i < h) {
		sortPoints(list, i, h);
	}
}

void draw ()
{
	background(0);

	// iterate triangles drawing lines from(this)->to(next)

	fill(255);
	noStroke();

	for (int i = 0; i < vertices.length; i++) {
		pushMatrix();
		translate(vertices[i].x, vertices[i].y, vertices[i].z);
		sphere(((float)i / (float)pointCount) * 8);
		popMatrix();
	}

	long t = System.currentTimeMillis();
	if (mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}
