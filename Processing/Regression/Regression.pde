// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Aug 29 2013
// 

int width = 512;
int height = 512;
int tick = 0;
int sqSize = 16;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

float[] data = new float[width * height * width];
int layer = 0;
int lastmouse = 0;

void setup ()
{
	size (width, height, P3D);
	noiseSeed((int)random(width));

	for (int i = 0; i < width * height * width; i++) {
		float x = i / (width * width);
		float y = (i / width) % width;
		float z = i % width;

		if ((int)x % sqSize == 0 && (int)y % sqSize == 0) {
			float cx = x / width;
			float cy = y / height;
			float cz = z / width;
			float n2 = noise(
				(cx + cz) * 2,
				(cy + cz) * 2
			);
			data[i] = n2;
		}
	}
}

void mouseDragged ()
{
	lastmouse = lastmouse - mouseX;
}

void draw ()
{
	tick++;

	layer = (int)((0.5 + sin(tick * 0.1) * 0.5) * width);

	background(64);

	stroke(32);
	fill(200);

	translate(width * 0.25, height * 0.25, 0);
	rotateX(lastmouse);

	int start = layer;
	int end = (width * height) * (layer + 1);

	pushMatrix();
	translate(0, 0, -width);
	box(width, height, 1);
	popMatrix();


	for (int i = start; i < end; i++) {
		float x = i / (width * width);
		float y = (i / width) % width;
		float z = i % width;

		float n2 = data[i];

		if (n2 > 0.5) {
			boxAtPoint(x, y, -z * 0.5, n2);
		}
	}

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		println("Saving file." + t);
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

void boxAtPoint(float x, float y, float z, float n)
{
	fill (200 * ((n * 2) - 1));

	beginShape(TRIANGLES);

	vertex(x, y, z);
	vertex(x + sqSize, y, z);
	vertex(x, y + sqSize, z);

	vertex(x + sqSize, y, z);
	vertex(x + sqSize, y + sqSize, z);
	vertex(x, y + sqSize, z);

	endShape();
}
