// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Jun 12 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Lint l;
float k;

void setup ()
{
	size(width, height, P3D);
	thread("update");
}

void update ()
{
	while (true) {
		try {
			tick++;

			if (tick % 4 == 0) {
				l = new Lint(
					random(0, width * 0.5),
					random(0, height * 0.5),
					random(width * 0.5, width),
					random(height * 0.5, height),
					32.0
				);
			}

			if (tick % 2 == 0) {
				k = random(10);
			}

			Thread.sleep(2000);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	background(32);

	if (l == null) {
		return;
	}

	for (int i = 0; i < sqrt(width * height); i++) {
		float t = (float)i / sqrt(width * height);
		float[] p = l.Plot(t, k);
		stroke(0);
		point(p[0], p[1] + 1);
		stroke(230);
		point(p[0], p[1]);
	}

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

class Lint
{
	float x1, x2, y1, y2;
	float displacement;

	public Lint (float x1, float y1, float x2, float y2, float displacement)
	{
		this.x1 = x1;
		this.x2 = x2;
		this.y1 = y1;
		this.y2 = y2;
		this.displacement = displacement;
	}

	public float[] Plot (float t, float kink)
	{
		float[] r = new float[2];

		float nx = (0.5 - (noise(
			t * kink,
			0
		) * 2)) * this.displacement;

		float ny = (0.5 - (noise(
			0,
			(1.0 - t) * kink
		) * 2)) * this.displacement;

		r[0] = (this.x1 + (this.x2 - this.x1) * t) + nx;
		r[1] = (this.y1 + (this.y2 - this.y1) * t) + ny;

		return r;
	}
}
