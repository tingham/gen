// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Apr 12 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<Particle> particles;

void setup ()
{
	size(width, height);

	particles = new ArrayList<Particle>();

	int count = 720;
	for (int i = 0; i < count; i++) {
		float w = ((float)i / (float)count) * TWO_PI;
		float n = noise((float)i / (float)count, 0) - 0.5;
		float x = (width * 0.5) + (sin(w) * width * 0.4) + (n * width);
		float y = (height * 0.5) + (cos(w) * height * 0.4) + (n * height);

		particles.add(
			new Particle(
				x,
				y,
				0
			)
		);
	}
}

void draw ()
{
	background(255);

	for (Particle p : particles) {
		stroke(32);
		strokeWeight(2);
		point(p.origin.x, p.origin.y);

	}
	long t = System.currentTimeMillis();
	if (t % 30 == 0 && mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

class Particle {
	PVector origin;
	public Particle (float x, float y, float z) {
		this.origin = new PVector(x, y, z);
	}
}
