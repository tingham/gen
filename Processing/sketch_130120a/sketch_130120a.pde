// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Jan 20 2013
// 
int width = 512;
int height = 512;

class Bubble {
	PVector pos;
	float size;

	public Bubble (float x, float y, float size) {
		this.pos = new PVector(x, y);
		this.size = size;
	}
}

ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
int tick = 1;

PVector offset;

void setup ()
{
	size(width, height);

	for (int i = 0; i < 50; i++) {
		Bubble b = new Bubble(random(width), random(height), random(10) + 0.01);
		bubbles.add(b);
	}

	float r = random(1);
	offset = new PVector(width * r, height * r);
	thread("update");
}

void update () {
	while (true) {
		float r = random(1);
		offset = new PVector(width * r, height * r);

		try {
			Thread.sleep(3000);
		} catch (Exception e) {

		}
	}
}

void draw ()
{
	tick++;

	fill(255, 255, 255, 1);
	noStroke();
	rect(0, 0, width, height);

	translate(offset.x, offset.y);
	scale(sin(tick) + 0.01);
	rotate(TWO_PI * (sin(tick) * 0.125));

	PVector last = bubbles.get(0).pos;
	float size = 1;
	for (Bubble b : bubbles) {
		for (int i = 0; i < 100; i++) {
			size = lerp(size, b.size, (float)i / (float)100);
			stroke(0);
			strokeWeight(size * 0.125);
			PVector n = PVector.lerp(last, b.pos, (float)i / (float)100);
			point(n.x, n.y);
		}
		last = b.pos;
	}

	if (System.currentTimeMillis() % 30 == 0) {
		save("data/output/s-" + System.currentTimeMillis() + ".jpg");
	}
}

