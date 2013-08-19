// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Aug 17 2013
// 

int width = 512;
int height = 512;

int rWidth = 32;
int rHeight = 32;

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

PVector[] points;

void setup ()
{
	size(width, height, P3D);

	points = new PVector[rWidth * rHeight];

	for (int i = 0; i < points.length; i++) {
		int x = i % rWidth;
		int y = (i - x) / rWidth;

		float n1 = noise(
			((float)x / (float)rWidth) * 3,
			((float)y / (float)rHeight) * 2
		);
		float n2 = noise(
			((float)x / (float)rWidth) * 4,
			((float)y / (float)rHeight) * 3
		);
		float n3 = noise(
			((float)x / (float)rWidth) * 5,
			((float)y / (float)rHeight) * 4
		);

		points[i] = new PVector(n1, n2, n3);
	}
	println(points.length);
	render();
}

void render ()
{
	background(32);
	lights();
	for (int i = 0; i < points.length; i++) {
		pushMatrix();
		translate(
				points[i].x * width * 0.5,
				points[i].y * height * 0.5,
				points[i].z * -width
			);
		sphere(2);
		popMatrix();
	}
}

void draw ()
{
	tick++;
	pushMatrix();
	translate(width * 0.5, height * 0.5, 0);
	rotateY(radians(tick));
	render();
	popMatrix();
	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

