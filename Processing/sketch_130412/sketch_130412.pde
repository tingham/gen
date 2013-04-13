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
}

void draw ()
{
	background(255);

	tick++;

	particles = new ArrayList<Particle>();

	int count = 720;
	for (int i = 0; i < count; i++) {
		float w = ((float)i / (float)count) + tick;
		float n = noise((float)i / (float)count * 2, 0) - 0.5;
		float x = (width * 0.5) + (sin(w) * width * 0.4) + (n * width * 0.25) + ((noise(w, w) * 50) - 25);
		float y = (height * 0.5) + (cos(w) * height * 0.4) + (n * height * 0.25) + ((noise(w, w) * 50) - 25);

		particles.add(
			new Particle(
				x,
				y,
				0
			)
		);
	}

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
