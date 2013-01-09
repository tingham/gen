// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 08 2013
// 

ArrayList<Node> points = new ArrayList<Node>();
PImage input;
int width = 1280;
int height = 720;
float imageScaleW = 1;
float scaleFactor = 0.0001;
int pointLimit = (int)(width * height * scaleFactor);
int tick = 0;
float pointSize = 32;

class Node {
	PVector p;
	PVector target;
	color nodeColor;
	color targetColor;
	float speed = 0.01;
	boolean resting;
	int restCount = 0;

	public Node (float x, float y, PVector target, color nodeColor) {
		this.p = new PVector(x, y, 0);
		this.target = target;
		this.nodeColor = nodeColor;
		this.targetColor = color(nodeColor);
		speed = random(0.1);
	}

	public void Move () {
		if (resting) {
			restCount++;
		}
		if (restCount > 120) {
			return;
		}
		this.p.lerp(this.target, speed);
		this.p.y -= random(0, 0.0001);
		this.nodeColor = color(
				lerp(red(this.nodeColor), red(this.targetColor), 0.3),
				lerp(green(this.nodeColor), green(this.targetColor), 0.3),
				lerp(blue(this.nodeColor), blue(this.targetColor), 0.3),
				lerp(alpha(this.nodeColor), alpha(this.targetColor), 0.3)
			);
	}

}
void setup ()
{
	String imageName = "mutiny-logo-box.jpg";

	input = loadImage("data/input/" + imageName);
	input.loadPixels();

	if (input.width != width) {
		imageScaleW = input.width / width;
	}

	for (int i = 0; i < pointLimit; i++) {
		points.add(
			new Node(
				width / 2,
				height / 2,
				new PVector(random(width), random(height), -random(width) * 0.25),
				color(random(255), random(255), random(255), random(50))
			)
		);
	}

	size(width, height, P3D);
	sphereDetail(5);
	clear();

}

void update () {
	while (true) {
		for (int i = 0; i < points.size(); i++) {
			points.get(i).Move();
			if (i % 250 == 0) {
				int r = (int)random(points.size() - 1);
				points.get(r).target = new PVector(random(width), random(height), random(-10000, 10000));
				points.get(r).targetColor =color(random(255), random(255), random(255), random(128));
			}
		}
		try {
			Thread.sleep(80);
		} catch (Exception e) {}
	}
}

void updateToMatchImage () {
	while (true) {
		for (int i = 0; i < points.size(); i++) {
			points.get(i).Move();
		}
		for (int i = 0; i < (int)random(10000); i++) {
			int x = (int)random(input.width);
			int y = (int)random(input.height);
			int p = (int)(y * input.width + x);
			int r = (int)(p * scaleFactor);

			if (r < points.size() - 1 && !points.get(r).resting) {
				points.get(r).target = new PVector(x, y);
				points.get(r).targetColor = color(input.pixels[p]);
				points.get(r).resting = true;
			}

		}
		try {
			Thread.sleep(80);
		} catch (Exception e) {}
	}
}

void clear () {
	/*
	fill(0, 0, 0, random(8));
	noStroke();
	rect(0, 0, width, height);
	*/
}

void draw ()
{
	tick++;

	clear();

	float s1 = 0.5 + sin(tick * 0.01) * 0.5;
	float s2 = 0.5 + sin(tick * (0.01 + random(0.00001))) * 0.5;
	float c1 = 0.5 + cos(tick * 0.01) * 0.5;

	if (tick > 30) {
		translate(width * 0.5 * s1, height * 0.5 * c1);
		rotate(tick * 0.01, 1, 1, -1);
		translate(-width * 0.5 * s2, -height * 0.5 * c1);
	}

	if (tick == 30) {
		thread("update");
	}
	float x = 0;
	float y = 0;
	pushMatrix();
	scale(imageScaleW, imageScaleW);
	for (int i = 0; i < points.size(); i++) {
		color mc = points.get(i).nodeColor;
		float s = (1.0 - brightness(mc)) / 255;
		fill(red(mc), green(mc), blue(mc), alpha(mc) * (0.5001 + sin(tick * (0.01234 + random(0.01))) * 0.5));
		noStroke();
		pushMatrix();
		translate(points.get(i).p.x, points.get(i).p.y, points.get(i).p.z);
		sphere((1.0 - (brightness(mc) / 255)) * pointSize);
		popMatrix();
	}
	popMatrix();

	int rSave = (int)random(200) + 100;
	if (tick % rSave == 0) {
		save("data/output/" + rSave + ".jpg");
	}
}

