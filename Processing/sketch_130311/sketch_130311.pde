// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Mar 11 2013
// 

int width = 1024;
int height = 1024;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

PVector root;

void setup ()
{
	size(width, height);
	int r = (int)random(width);
	
	root = new PVector(random(width), random(height));
	elp(
		root,
		noise(((float)r / (float)width) * 32, 32) * width
	);

	background(33);
}

void draw ()
{
	flood();

	int r = (int)random(width);

	elp(
		root,
		noise(((float)r / (float)width) * 32, 32) * width
	);

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}

	if (mousePressed) {
		root = new PVector(mouseX, mouseY);
	}
}

void flood ()
{
	noStroke();
	for (int i = 0; i < width * height; i++) {
		int y = i / height;
		int x = i % height;
		if (x % 16 == 0 && y % 16 == 0) {
			float f = noise(sin((float)x / (float)width), cos((float)y / (float)height)) * 16;
			fill(33, 33, 33, f); 
			rect(x, y, 16, 16);
		}
	}
}

void elp (PVector mid, float mf)
{
	noFill();
	stroke(205);
	strokeWeight(1);

	int dots = (int)random(16);

	ellipse(mid.x, mid.y, mf, mf);

	for (int d = 0; d < dots; d++) {

		PVector dst = new PVector(random(-width * 0.5, width * 1.5), random(-height * 0.5, height * 1.5));

		line(mid.x, mid.y, dst.x, dst.y);

		int r = (int)random(width / 4);
		float f = 1;
		for (int i = 0; i < r; i += (int)f) {
			f = noise((float)i / (float)r * 64, 0) * 16;
			if (f > 4) {
				PVector p = PVector.lerp(mid, dst, (float)i / (float)r);
				dot(p, f);
			}
		}
	}

}

void dot (PVector p, float f)
{
	fill(185);
	noStroke();
	ellipse(p.x, p.y, f, f);
}

