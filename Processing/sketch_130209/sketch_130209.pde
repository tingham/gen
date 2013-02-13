// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Feb 09 2013
// 

int width = 512;
int height = 512;
float tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<Point> points = new ArrayList<Point>();
int pointcount = 1000;

void setup ()
{
	size(width, height, P3D);

	for (int i = 0; i < pointcount; i++) {
		Point p = new Point(random(width), random(height), random(-height / 2, height / 2));
		points.add(p);
	}

	for (int i = 0; i < pointcount; i++) {
		points.get(i).setFriends(points);
	}
}

void draw ()
{
	tick += 0.0015;

	background(220);

	translate(width / 2, 0, 0);
	rotate(PI * tick, 0, 0.01, 0);

	for (Point p : points) {
		p.update();
		p.draw();
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

class Point {
	PVector origin;
	PVector _origin;
	ArrayList<Point> friends;
	boolean isFriended;

	public Point (float x, float y, float z) {
		this.origin = new PVector(x, y, z);
		this._origin  = new PVector(x, y, z);
		this.friends = new ArrayList<Point>();
	}

	public void setFriends (ArrayList<Point> pts) {
		int limit = (int)random(20) + 1;
		for (Point p : pts) {
			if (limit < 0) {
				break;
			}
			if (p != this && p.isFriended == false) {
				limit--;
				p.isFriended = true;
				this.friends.add(p);
				p.friends.add(this);
			}
		}
	}

	public void update () {
		if (this.friends.size() > 0) {
			for (int i = 0; i < (int)random(1, this.friends.size() - 1); i++) {
				int r = (int)random(0, this.friends.size() - 1);
				if (this.friends.get(r) != null) {
					this.friends.get(r).origin.lerp(this.origin, 0.1);
					this.friends.get(r).origin.lerp(this._origin, 0.05);
				}
			}
		}
		this.origin.lerp(this._origin, 0.015);
	}

	public void draw () {
		float ox = width / 2;

		for (int i = 0; i < this.friends.size(); i++) {
			stroke(32);
			strokeWeight(1.0);
			beginShape();
			vertex(this.origin.x - ox, this.origin.y, this.origin.z);
			vertex(this.friends.get(i).origin.x - ox, this.friends.get(i).origin.y, this.friends.get(i).origin.z);
			endShape();
		}

	}
}
