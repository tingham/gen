// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri May 24 2013
// 

import com.mutiny.*;

int width = (int)(8.5 * 64);
int height = (int)(11.0 * 64);

int tick = 0;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

float alpha = 0.25;

int[] colors = new int[] {
	color(255, 0, 0, alpha),
	color(0, 255, 0, alpha),
	color(0, 0, 255, alpha),
	color(128, 128, 0, alpha),
	color(128, 0, 128, alpha),
	color(0, 128, 128, alpha)
};

void setup ()
{
	size(width, height, P3D);

	generate();

	thread("update");
}

void generate ()
{
	background(240);
	for (int i = 0; i < colors.length; i++) {
		fill(colors[i]);
		float r = random(32, 128);
		ellipse(random(width), random(height), r, r);
	}
}

void update ()
{
	while (true) {
		try {
			Thread.sleep(10);
		} catch (Exception e) {

		}
	}
}

void draw ()
{

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

