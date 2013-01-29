// # Attraction Operators
// **Created By:** + tingham
// **Created On:** + Fri Jan 25 2013
// 
// ## Dimensions
int width = 1024;
int height = 1024;

// ## Cell Size
// A guide for random selection of cell sizes.
int cellSizeMin = 4;
int cellSizeMax = 32;

// ## Cell Count
// The number of cells to make, dummy.
int cellCount = 256;

// ## Collision Margin
// A buffer to provide some space between cells.
float collisionMargin = 5;
float collisionMarginMax = 20;

// ## Nodes
// The collection of all node items.
ArrayList<Node> nodes;

// ## Remove Node
// Set this node to have it removed from the list.
Node rmNode = null;
Node addNode = null;

// ## Output Name
// Template name for saving files.
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
	size(width, height);

	nodes = new ArrayList<Node>();

	for (int i = 0; i < cellCount; i++) {
		generateNode(null);
	}

	frameRate(15);

	thread("update");
}

void generateNode (Node fromNode) {
	if (fromNode == null) {
		Node node = new Node((int)random(cellSizeMin, cellSizeMax), new PVector(random(width), random(height)));
		nodes.add(node);
	} else if (fromNode.radius > cellSizeMin * 2) {
		Node nodea = new Node((int)fromNode.radius * 0.75, new PVector(random(fromNode.pos.x - fromNode.radius, fromNode.pos.x + fromNode.radius), random(fromNode.pos.y - fromNode.radius, fromNode.pos.y + fromNode.radius)));
		Node nodeb = new Node((int)fromNode.radius * 0.75, new PVector(random(fromNode.pos.x - fromNode.radius, fromNode.pos.x + fromNode.radius), random(fromNode.pos.y - fromNode.radius, fromNode.pos.y + fromNode.radius)));
		nodes.add(nodea);
		nodes.add(nodeb);
		rmNode = fromNode;
	} else {
		fromNode.score--;
	}
}

void joinNode (Node[] fromNodes) {
	if (addNode != null) {
		return;
	}
	int avgScore = 0;
	int avgRadius = 0;

	for (Node n : fromNodes) {
		avgScore += n.score;
		avgRadius += n.radius;
		n.radius = 0;
		n.score = 0;
	}

	Node node = new Node(avgRadius / fromNodes.length, new PVector(fromNodes[0].pos.x, fromNodes[fromNodes.length - 1].pos.y));
	node.score = avgScore;
	addNode = node;
}

void update () {

	while (true) {
		long t = System.currentTimeMillis();

		if (rmNode != null) {
			nodes.remove(rmNode);
			rmNode = null;
			continue;
		}
		if (addNode != null) {
			generateNode(addNode);
			addNode = null;
			continue;
		}

		try {
			// Two passes on nodes so we can compare and lerp for a single item.
			for (Node n : nodes) {
				for (Node nt : nodes) {
					nt.collide(n);
					if (n != nt && n.radius == nt.radius && n.score > nt.score) {
						nt.nlerp(n);
					}
				}
				if (n.radius == 0) {
					rmNode = n;
				}

				n.split();
			}
		} catch (Exception e) {

		}

		try {
			Thread.sleep(15);
		} catch (Exception e) {
		}

	}
}

void draw ()
{
	float s1 = 0.5 * sin(System.currentTimeMillis() * 0.1) + 0.5;
	collisionMargin = (int)(collisionMarginMax * s1) + 1;

	fill(16, 16, 16, 64);
	rect(0, 0, width, height);

	try {

		for (int i = 0; i < nodes.size(); i++) {
			Node n = nodes.get(i);
			stroke(32, 32, 32, 255);
			strokeWeight(0.5);
			noFill();
			n.drawCurves();
		}

		for (int i = 0; i < nodes.size(); i++) {
			Node n = nodes.get(i);
			if (n != null) {
				n.draw();
			}
		}
	} catch (Exception e) {
		println(e);
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
	Node lastOverlap;
	int overlapCount = 0;
	ArrayList<PVector> path;

	public Node (float radius, PVector pos) {
		this.radius = radius;
		this.pos = pos;
		this.score = (int)random(255);
		this.path = new ArrayList<PVector>();
	}

	public void split () {
		if (this.overlapCount > this.score) {
			if (random(1) > 0.25) {
				addNode = this;
			} else if (this.lastOverlap != null) {
				joinNode(new Node[] {this, this.lastOverlap});
			} else {
				this.score--;
			}
		}
	}

	public void collide (Node withNode) {
		float distance = this.pos.dist(withNode.pos);
		float range = this.radius + withNode.radius + collisionMargin;
		PVector target = new PVector(this.pos.x, this.pos.y);

		if (distance < this.radius) {
			if (this.lastOverlap == null) {
				this.lastOverlap = withNode;
			}
			if (this.lastOverlap == withNode) {
				this.overlapCount++;
			}
		}

		if (distance < range && this.score < withNode.score) {

			if (target.x < withNode.pos.x) {
				target.x -= this.radius + collisionMargin;
			} else {
				target.x += this.radius + collisionMargin;
			}

			if (target.y < withNode.pos.y) {
				target.y -= this.radius + collisionMargin;
			} else {
				target.y += this.radius + collisionMargin;
			}

			this.pos.lerp(target, this.delta());
			target = new PVector(this.pos.x, this.pos.y);

		}

		if (target.x < 0) {
			target.x += random(this.radius + collisionMargin);
		}
		if (target.x > width) {
			target.x -= random(this.radius + collisionMargin);
		}

		if (target.y < 0) {
			target.y += random(this.radius + collisionMargin);
		}
		if (target.y > height) {
			target.y -= random(this.radius + collisionMargin);
		}
		
		this.pos.lerp(target, this.delta() * random(1, 10));
	}

	public void nlerp (Node toNode) {
		PVector target = new PVector(this.pos.x, this.pos.y);
		target.lerp(toNode.pos, this.delta());
		this.pos.lerp(target, this.delta());
		if (((int)this.pos.x) % 8 == 0 && ((int)this.pos.y) % 8 == 0) {
			this.path.add(new PVector(this.pos.x, this.pos.y));
		}
	}

	public float delta () {
		float n = (float)((float)this.score / 255) * 0.1;
		return n;
	}

	public void drawCurves () {
		if (this.path.size() > 0) {
			beginShape();
			curveVertex(this.path.get(0).x, this.path.get(0).y);
			for (PVector p : this.path) {
				curveVertex(p.x, p.y);
			}
			curveVertex(this.path.get(this.path.size() - 1).x, this.path.get(this.path.size() - 1).y);
			endShape();
		}

	}
	public void draw () {
		stroke(32, 32, 32, 255);
		strokeWeight(2);
		fill((this.score / 255) * 255, (this.radius / (float)cellSizeMax) * 255, (this.overlapCount / 255) * 255);
		ellipse(this.pos.x, this.pos.y, radius * random(1.9, 2.1), radius * random(1.9, 2.1));
	}

}
