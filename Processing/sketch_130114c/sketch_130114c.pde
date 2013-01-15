// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 14 2013
// 

int width = 1024;
int height = 1024;

ArrayList<MRect> rects = new ArrayList<MRect>();

int tick = 0;

void setup ()
{
	size(width, height);
	prep();
}

void prep () {
	rects = new ArrayList<MRect>();

	MRect fd = new MRect(0, 0, width, height);

	rects.addAll(fd.subdivide());

	for (int i = 0; i < rects.size(); i++) {
		if (random(1) > random(0.25)) {
			divide(i);
		}
		if (i > 16) {
			return;
		}
	}
}

void draw () {
	tick++;

	fill(255);
	rect(0, 0, width, height);

	if (tick % 100 == 0) {
		prep();
		save("data/output/grids-" + System.currentTimeMillis() + ".jpg");
	}

	MRect a = new MRect(0, 0, width, height);

	for (int i = 0; i < rects.size(); i++) {
		MRect r = rects.get(i);
		if (r.w > (width * 0.02)) {
			stroke(0);
			strokeWeight(1);
			noFill();
			rect(r.x + (width * 0.01), r.y + (height * 0.01), r.w - (width * 0.02), r.h - (height * 0.02));
			findHorizontalMatch(r);
		}
	}
}

void findHorizontalMatch (MRect m) {
	for (int i = 0; i < rects.size(); i++) {
		if (m.intersects(rects.get(i))) {
			stroke(255, 0, 0, 255);
			line(m.x, m.y, rects.get(i).x, m.y);
		}
	}
}

void divide (int r) {
	ArrayList<MRect> set = rects.get(r).subdivide();
	rects.remove(r);
	for (int i = 0; i < set.size(); i++) {
		if (random(1) > 0.25) {
			rects.add(set.get(i));
		}
	}
}

class MRect {
	float x;
	float y;
	float w;
	float h;

	public MRect (float x, float y, float w, float h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	public ArrayList<MRect> subdivide () {
		ArrayList<MRect> result = new ArrayList<MRect>();
		result.add(new MRect(this.x, this.y, this.w * 0.5, this.h * 0.5));
		result.add(new MRect(this.x + (this.w * 0.5), this.y, this.w * 0.5, this.h * 0.5));
		result.add(new MRect(this.x, this.y + (this.h * 0.5), this.w * 0.5, this.h * 0.5));
		result.add(new MRect(this.x + (this.w * 0.5), this.y + (this.h * 0.5), this.w * 0.5, this.h * 0.5));
		return result;
	}

	String toString () {
		return "x: " + x + ", y: " + y;
	}

	boolean intersects (MRect b) {
		if ((this.y > b.y && this.y < b.y + b.h) || (b.y > this.y && b.y < this.y + this.h)) {
			return true;
		}
		return false;
	}
}
