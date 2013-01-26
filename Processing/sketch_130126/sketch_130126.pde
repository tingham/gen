// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Jan 26 2013
// 
int width = 1024;
int height = 1024;

float seedSize = 64;

String outputName = "data/output/c-" + System.currentTimeMillis();

ArrayList<Node> nodes = new ArrayList<Node>();

void setup ()
{
	size(width, height, P3D);

	for (int i = 0; i < 1024; i++) {
		float x = random(width);
		float y = random(height);
		Node n = new Node(random(x * 0.5, x), random(y * 0.5, y), color(random(255), random(255), random(255), 255));
		nodes.add(n);
	}

	thread("update");
}

void update () {
	while (true) {

		Node rmNodeA = null;
		Node rmNodeB = null;
		Node naa = null;
		Node nab = null;
		Node nba = null;
		Node nbb = null;
		for (Node n : nodes) {
			for (Node nt : nodes) {
				if (n != nt && n.collides(nt)) {
					if (n.s > 0.1) {
						naa = new Node(n.pos.x + random(1), n.pos.y + random(1), n.c);
						nab = new Node(n.pos.x + random(1), n.pos.y + random(1), n.c);
						nba = new Node(nt.pos.x + random(1), nt.pos.y + random(1), nt.c);
						nbb = new Node(nt.pos.x + random(1), nt.pos.y + random(1), nt.c);

						naa.pos.z += random(5);
						nab.pos.z += random(5);
						nba.pos.z += random(5);
						nbb.pos.z += random(5);

						naa.s = n.s;
						nab.s = n.s;
						nba.s = n.s;
						nbb.s = n.s;

						naa.invert();
						nab.invert();
						nba.invert();
						nbb.invert();
					}
					rmNodeA = n;
					rmNodeB = nt;
					break;
				}
			}
		}

		if (rmNodeA != null) {
			nodes.remove(rmNodeA);
		}
		if (rmNodeB != null) {
			nodes.remove(rmNodeB);
		}

		if (naa != null) {
			nodes.add(naa);
			nodes.add(nab);
			nodes.add(nba);
			nodes.add(nbb);
		}

		if (nodes.size() < 1000) {
			println(nodes.size());
		}
		try {
			Thread.sleep(30);
		} catch (Exception e) {
		}

	}
}

void removeNode (Node n) {
	nodes.remove(n);
}

float mr = 0;

void draw ()
{
	mr += 0.0005;

	// background(220, 220, 220);
	rectMode(CENTER);

	scale(0.25);
	translate(width, height);
	rotate(TWO_PI * mr, 0, 1, 0);

	float rot = 0;
	for (int i = 0; i < nodes.size(); i++) {
		Node n = nodes.get(i);
		if (n != null) {
			pushMatrix();
			translate(n.pos.x, n.pos.y, n.pos.z);
			rot = lerp(rot, TWO_PI * ((float)i / (float)nodes.size()), 0.015);
			rotate(rot, 0, 0, 1);
			fill(n.c);
			stroke(red(n.c) * 0.5, green(n.c) * 0.5, blue(n.c) * 0.5, alpha(n.c));
			rect(sin(n.pos.x) * seedSize * n.s, cos(n.pos.y) * seedSize * n.s, seedSize * n.s, seedSize * n.s);
			popMatrix();
			n.update();
		}
	}

	long t = System.currentTimeMillis();
	if (t % 90 == 0) {
		save(outputName + "-" + t + ".jpg");
	}
}

public class Node {
	color c;
	PVector pos;
	PVector origin;
	float s = 1;

	public Node (float x, float y, color c) {
		this.pos = new PVector(x, y, random(-5, 5));
		this.origin = new PVector(x, y, this.pos.z);
		this.c = c;
	}

	public void invert () {
		this.c = color(255 - red(c), 255 - green(c), 255 - blue(c), brightness(c));
	}

	public boolean collides (Node n) {
		if (n.pos.dist(this.pos) < (seedSize * n.s)) {
			s = max(s - 0.015, 0);
			return true;
		}
		if (n.pos.x - (this.s * seedSize) < 0 || n.pos.x + (this.s * seedSize) < width || n.pos.y - (this.s * seedSize) < 0 || n.pos.y + (this.s * seedSize) > height) {
			s = max(s - 0.0015, 0);
			return true;
		}
		return false;
	}

	public void update () {
		float r = red(this.c);
		float g = green(this.c);
		float b = blue(this.c);

		PVector np = new PVector(pos.x, pos.y);
		float offset = seedSize * this.s;
		if (r > g && r > b) {
			np.x -= offset * ((r - g) / 255);
		} else {
			np.x += offset * ((g - r) / 255);
		}

		if (g > r && g > b) {
			np.y += offset * ((g - b) / 255);
		} else {
			np.y -= offset * ((b - g) / 255);
		}

		if (b > r && b > g) {
			np.z -= offset;
		} else {
			np.z += offset;
		}

		// this.c = color(r, g, b, (this.pos.dist(this.origin) / width) * 255);

		this.pos.lerp(np, 0.015);
	}
}
