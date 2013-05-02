// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed May 01 2013
// 

int width = 512;
int height = 512;

int ra = 0;
int ga = 0;
int ba = 0;
int rb = 255;
int gb = 255;
int bb = 255;

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<Pod> pods = new ArrayList<Pod>();

void setup ()
{
	size(width, height);

	noiseDetail(8, 0.65);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		Pod p = new Pod(new PVector(x, y));
		p.r = noise(((float)x / width) * 2, ((float)y / height) * 2);
		p.b = noise(((float)y / height) * 2, ((float)x / width) * 2);
		p.g = noise(p.r, p.b);
		pods.add(p);
	}
}

void draw ()
{
	background(0);

	for (Pod p : pods) {
		pushMatrix();
		translate(p.position.x, p.position.y);
		rotate(TWO_PI * p.r);
		stroke(lerp(ra, rb, p.r), lerp(ga, gb, p.g), lerp(ba, bb, p.b), p.g * 255);
		line(-32 * p.r, -32 * p.r, 32 * p.r, 32 * p.r);
		// fill(lerp(ra, rb, p.r), lerp(ga, gb, p.r), lerp(ba, bb, p.r));
		// noStroke();
		// ellipse(0, 0, (p.r * width) * (1.0 - ((float)p.position.x / (float)width)), (p.r * 64) * (1.0 - ((float)p.position.y / (float)height)));
		// ellipse(0, 0, p.r * 64, p.r * 64);
		popMatrix();
	}

	long t = System.currentTimeMillis();
	if (/*t % 10 == 0 && */mousePressed) {
		save(outputName + "s-" + t + ".jpg");
		println("saved");
	}
}

class Pod {
	PVector position;
	float r;
	float g;
	float b;

	public Pod (PVector _position) {
		this.position = _position;
		this.r = 0f;
		this.g = 0f;
		this.b = 0f;
	}

}
