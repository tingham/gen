// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Nov 01 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<PVector> steps;

void setup ()
{
	size(width, height, P3D);

	steps = new ArrayList<PVector>();

	steps.add(new PVector(width / 2, height / 2));
}

PVector takeStep ()
{
	PVector result = new PVector();
	int r = (int)random(4);
	switch (r) {
		case 0:
			result.x = -1;
			result.y = 0;
		break;
		case 1:
			result.x = 1;
			result.y = 0;
		break;
		case 2:
			result.x = 0;
			result.y = -1;
		break;
		case 3:
			result.x = 0;
			result.y = 1;
		break;
	}

	if (steps.size() == 0) {
		return result;
	}

	PVector test = new PVector(
		steps.get(steps.size() - 1).x + result.x,
		steps.get(steps.size() - 1).y + result.y
	);

	for (PVector p : steps) {

		if ((int)p.x == (int)test.x && (int)p.y == (int)test.y) {
			return takeStep();
		}

	}

	if (test.x < 0 || test.x > width || test.y < 0 || test.y > height) {
		return takeStep();
	}

	return test;
}

void draw ()
{
	tick++;

	if (tick % (int)(random(5) + 5) == 0) {
		PVector p = takeStep();
		steps.add(p);
	}

	for (PVector p : steps) {
		noStroke();
		fill(32);
		rect(p.x, p.y, 1, 1);
	}

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

