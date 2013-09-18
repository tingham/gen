// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Sep 17 2013
// 

int width = 512;
int height = 512;
int tick = 0;
int weight = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
	size(width, height, P3D);
	background(32);
}

void draw ()
{
	tick++;

	weight = (int)random(64);


	translate(width * 0.5, height * 0.5);

	for (int i = 1; i < width; i += 5) {
		drawCircle((float)i);
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

void drawCircle (float radius)
{
	int count = (int)(radius * 0.125);
	int start = (int)(random(count * 0.75) - count);
	int length = (int)(random(count * 0.75));

	float angleIncrement = PI * 2 / count;
	float angle = 0;

	noiseSeed(100);
	noiseDetail(20, 0.5);

	float fx = noise(
		(radius / width * 10) + tick,
		0
	);
	float fy = noise(
		width + tick,
		radius / width * 10
	);
	float fz = noise(
		(radius / width * 10) + tick,
		radius / width * 10
	);

	float mr = random(32);

	float r = (fx * 200) + mr;
	float g = (fy * 200) + mr;
	float b = (fz * 200) + mr;

	stroke(r, g, b, (3.0 - (fx + fy + fz)) * (255 / 12));
	strokeWeight(
		(fx + fy + fz) * weight
	);

	for (int i = start; i < length; i++) {
		float f = (float)start / (float)count;
		float x = sin(angle + ((tick * 0.1) * f)) * (radius);
		float y = cos(angle + ((tick * 0.1) * f)) * (radius);

		point(x, y);
		angle += angleIncrement;
	}

}

