// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jan 25 2013
// 
int width = 512;
int height = 512;

PVector seed = new PVector(width / 2, height * 0.75);
Branch root = new Branch(seed, new PVector(width / 2, height * 0.25), 0);

void setup ()
{
	size(width, height);

	for (int i = 0; i < 20; i++) {
		Branch b = new Branch(seed, new PVector(random(width), random(height * 0.5)), random(1));
		root.children.add(b);
	}
}

void update () {
	
}

void draw ()
{

	stroke(32);
	noFill();
	root.draw();

}

public class Branch {
	ArrayList<Branch> children;
	PVector root;
	PVector tip;
	float pos;

	public Branch (PVector root, PVector tip, float pos) {
		this.root = root;
		this.tip = tip;
		this.pos = pos;
		this.children = new ArrayList<Branch>();
	}

	public void draw () {
		beginShape();
		vertex(root.x, root.y);
		vertex(tip.x, tip.y);
		endShape();

		for (Branch b : children) {
			b.draw();
		}
	}
}
