// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Apr 11 2013
// 

int width = 512;
int height = 512;
float tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
ArrayList<Particle> particles;

void setup ()
{
	size(width, height, P3D);
	buildGraph();
}

void buildGraph ()
{
	particles = new ArrayList<Particle>();
	int dim = (width * height) / 2;

	for (int i = 0; i < dim; i++) {
		float x = i % width;
		float z = (i - x) / width;
		float y = noise(x / width, z / height);
		float s = noise((x / width) + y, (z / height) + y);
		Particle p = new Particle(x * 2, y, z * 2, s);
		particles.add(p);
	}
}

void draw ()
{
	tick += 0.015;

	background(20);

	for (Particle p : particles) {
		pushMatrix();
		translate(p.origin.x, (p.origin.y * height) + (height * 0.25), p.origin.z);
		stroke(225 * p.size);
		strokeWeight(0.5);
		box(p.size);
		popMatrix();
	}

	long t = System.currentTimeMillis();
	if (t % 10 == 0 && mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

class Particle {
	PVector origin;
	float size;

	public Particle (float x, float y, float z, float s) {
		this.origin = new PVector(x, y, z);
		this.size = s;
	}
}
