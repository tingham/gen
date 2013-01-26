// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jan 25 2013
// 

int width = 1024;
int height = 1024;
int cellSize = 22;
float offsetScale = 5;
int cellCount = 512;

ArrayList<Node> nodes;

String outputName = "data/output/c-" + System.currentTimeMillis();

void setup ()
{
	size(width, height);

	nodes = new ArrayList<Node>();

	for (int i = 0; i < cellCount; i++) {
		Node node = new Node((int)random(2, cellSize), new PVector(random(width), random(height)));
		for (Node n : nodes) {
			while(node.pos.dist(n.pos) <= (node.radius + n.radius) * 2) {
				node.pos = new PVector(random(width), random(height));
			}
		}
		nodes.add(node);
	}

	thread("update");
}

void update () {

	while (true) {
		long t = System.currentTimeMillis();

		// Two passes on nodes so we can compare and lerp for a single item.
		for (Node n : nodes) {
			for (Node nt : nodes) {
				if (n == nt) {
					continue;
				}
				if (abs(n.radius - nt.radius) < 0.1 &&
					n.pos.dist(nt.pos) > (n.radius + nt.radius) &&
					nt.score < n.score) {
					nt.nlerp(PVector.lerp(nt.pos, n.pos, 0.5));
					/*
					nt.nlerp(n.pos);
					if (nt.lastPair == null || nt.lastPair.pos.dist(nt.pos) > n.pos.dist(nt.pos)) {
						nt.lastPair = n;
					}
					*/
				} else if (n.pos.dist(nt.pos) < (n.radius + nt.radius)) {
					nt.moveAway(n.pos);
				}
			}
			if (System.currentTimeMillis() - t > 15) {
				continue;
			}

			PVector adjust = new PVector(n.pos.x, n.pos.y);
			if (n.pos.x + n.radius > width) {
				adjust.x -= random(n.radius * 3);
			}
			if (n.pos.x - n.radius < 0) {
				adjust.x += random(n.radius * 3);
			}
			if (n.pos.y + n.radius > height) {
				adjust.y -= random(n.radius * 3);
			}
			if (n.pos.y - n.radius < 0) {
				adjust.y += random(n.radius * 3);
			}
			n.pos = adjust;
		}

		try {
			Thread.sleep(15);
		} catch (Exception e) {
		}

	}
}

void draw ()
{
	fill(220, 220, 220, 128);
	rect(0, 0, width, height);
	for (Node n : nodes) {
		n.draw();
	}

	long s = System.currentTimeMillis();
	if (s % 60 == 0) {
		save(outputName + "-" + s + ".jpg");
	}
}

public class Node {
	PVector pos;
	float radius;
	int score;
	Node lastPair;

	public Node (float radius, PVector pos) {
		this.radius = radius;
		this.pos = pos;
		this.score = (int)random(220);
	}

	public void moveAway (PVector fromNode) {
		PVector diff = PVector.sub(this.pos, fromNode);
		diff.normalize();
		float offset = this.pos.dist(fromNode) * 2;
		diff.mult(this.radius * offset);
		diff = PVector.add(this.pos, diff);
		this.pos.lerp(diff, 0.015);// random(0.015, 0.05));
	}

	public void nlerp (PVector toNode) {
		this.pos.lerp(toNode, this.delta());
	}

	public float delta () {
		float n = (noise((this.pos.x / width) * 5, (this.pos.y / height) * 5));
		n *= ((255 - this.score) / 255) + 0.001;
		return n;
	}

	public void draw () {
		stroke(32);
		fill((this.radius / (float)cellSize) * 255);
		ellipse(this.pos.x, this.pos.y, radius * 2, radius * 2);
		if (this.lastPair != null) {
			beginShape();
			stroke(32, 32, 32, 128);
			noFill();
			curveVertex(this.pos.x, this.pos.y);
			curveVertex(this.pos.x, this.pos.y);
			curveVertex(lerp(this.pos.x, this.lastPair.pos.x, 0.3), lerp(this.pos.y, this.lastPair.pos.y, 0.7));
			curveVertex(lerp(this.pos.x, this.lastPair.pos.x, 0.7), lerp(this.pos.y, this.lastPair.pos.y, 0.3));
			curveVertex(this.lastPair.pos.x, this.lastPair.pos.y);
			curveVertex(this.lastPair.pos.x, this.lastPair.pos.y);
			endShape();
		}
	}

}
