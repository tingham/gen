// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Oct 04 2013
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Face[] faces;
int[] indexesInUse;
PVector[] points;

// So the whole point is that we have this cloud of points and we want to make
// triangles out of it.
void setup ()
{
	size(width, height, P3D);

	points = new PVector[40];

	faces = new Face[points.length / 3];

	indexesInUse = new int[points.length];

	for (int i = 0; i < points.length; i++) {
		points[i] = new PVector(
				random(width),
				random(height)
			);
	}

	int lmp = leftMostPointIndex();

}

int leftMostPointIndex ()
{
	int left = width * height;
	int result = 0;

	for (int i = 0; i < points.length; i++) {
		if (left > p.x) {
			left = p.x;
			result = i;
		}
	}

	return result;
}

void draw ()
{

	for (PVector p : points) {
		stroke(128, 0, 0, 64);
		strokeWeight(10);
		point(p.x, p.y);
	}

	for (Face f : faces) {
		if (f != null) {
			drawFace(f);
		}
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		//save(outputName + "s-" + t + ".jpg");
	}
}

void drawFace (Face face)
{
	stroke(32);
	line(face.p1.x, face.p1.y, face.p2.x, face.p2.y);
	line(face.p2.x, face.p2.y, face.p3.x, face.p3.y);
	line(face.p3.x, face.p3.y, face.p1.x, face.p1.y);
}
