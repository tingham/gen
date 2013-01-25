// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jan 25 2013
// 
int width = 512;
int height = 512;

PVector p = new PVector(random(width), random(height));
PVector target = new PVector(random(width), random(height));

float r = 0;

void setup ()
{
	size(width, height);
	noStroke();
	fill(255);
	rect(0, 0, width, height);
}

void draw ()
{
	if (p.dist(target) < width * 0.125) {
		target = new PVector(random(width), random(height));
	}
	p.lerp(target, 0.025);

	noFill();
	stroke((p.y / height) * 255);
	strokeWeight(1.1);
	pushMatrix();
	translate(p.x, p.y);
	r += PI * 0.0015;
	rotate(r);
	scale(random(5) + 0.001);
	rect(sin(p.x * 0.5) * 5, cos(p.y * 0.5) * 5, sin(p.x * 0.5) * -5, cos(p.y * 0.5) * -5);
	popMatrix();

	if (System.currentTimeMillis() % 30 == 0) {
		save("data/output/squares-" + System.currentTimeMillis() + ".jpg");
	}
}

