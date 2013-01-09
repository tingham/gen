// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 08 2013
// 
PVector p;
ArrayList<PVector> children = new ArrayList<PVector>();

PVector target;
ArrayList<PVector> childTargets = new ArrayList<PVector>();

PVector nTarget;
ArrayList<PVector> childNTargets = new ArrayList<PVector>();

int width = 1280;
int height = 720;
float tick = 0;

void setup ()
{
	p = new PVector(random(width), random(height));
	target = new PVector(random(width), random(height));
	nTarget = new PVector(random(width), random(height));

	for (int i = 0; i < 10; i++) {
		children.add(p);
		childTargets.add(target);
		childNTargets.add(target);
	}
	size(width, height);
}

void draw ()
{
	fill(0, 0, 0, 2);
	rect(0, 0, width, height);

	float delta = 1.0 / 30;
	tick += delta;

	float s1 = 0.5 + sin(tick) * 0.5;
	float c1 = 0.5 + sin(tick) * 0.5;

	float s2 = sin(tick);
	float c2 = cos(tick);

	target.lerp(nTarget, delta);
	p.lerp(target, delta);

	pushMatrix();
	translate(p.x, p.y);
	fill(255, 255, 255, 16);
	noStroke();
	float dotScale = (s1 * 8) + 24;
	ellipse(0, 0, dotScale * 0.75, dotScale * 0.75);
	ellipse(0, 0, dotScale, dotScale);
	ellipse(0, 0, dotScale * 1.25, dotScale * 1.25);
	popMatrix();

	if ((int)tick % 3 == 0) {
		if (random(1) > 0.25) {
			nTarget = new PVector(random(width), random(height));
		}
	}
}

