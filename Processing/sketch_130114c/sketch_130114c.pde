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

	// background(0);
	fill(0, 0, 0, 2);
	noStroke();
	rect(0, 0, width, height);

	MRect a = new MRect(0, 0, width, height);

	for (int i = 0; i < rects.size(); i++) {
		MRect r = rects.get(i);
		if (r.w > (width * 0.02)) {
			fill(255, 255, 255, 2);
			noStroke();
			rect(r.x + (width * 0.01), r.y + (height * 0.01), r.w - (width * 0.02), r.h - (height * 0.02));
			intersections(i);
		}
	}

	if (tick % 30 == 0) {
		save("data/output/grids-" + tick + ".jpg");
		prep();
	}

}

void intersections (int index) {
	float dSize = width * 0.0075;
	float oSize = dSize * 0.5;

	MRect r = rects.get(index);

	for (int i = 0; i < rects.size(); i++) {
		if (i != index && r.w < width && r.h < height) {

			if (r.intersectsY(rects.get(i))) {
				fill(255, 255, 255, 2);
				noStroke();
				rect(
					r.x + (r.w * 0.5) - oSize, 
					r.y + (r.h * 0.5) - oSize,
				   	rects.get(i).x + (rects.get(i).w * 0.5),
					dSize
				);
			}

			if (r.intersectsX(rects.get(i))) {
				fill(255);
				noStroke();
				rect(
					(r.x + (r.w * 0.5)) - oSize,
					r.y + (r.h * 0.5) - oSize,
					dSize,		
					rects.get(i).y + (rects.get(i).h * 0.5)
				);
			}

		}
	}
}

void divide (int r) {
	ArrayList<MRect> set = rects.get(r).subdivide();
	float test = random(1);
	if (test > 0.125) {
		rects.remove(r);
	}
	for (int i = 0; i < set.size(); i++) {
		if (test > 0.125) {
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
		float r = random(1);
		if (r > 0.75) {
			result.add(new MRect(this.x, this.y, this.w * 0.5, this.h * 0.5));
			result.add(new MRect(this.x + (this.w * 0.5), this.y, this.w * 0.5, this.h * 0.5));
			result.add(new MRect(this.x, this.y + (this.h * 0.5), this.w * 0.5, this.h * 0.5));
			result.add(new MRect(this.x + (this.w * 0.5), this.y + (this.h * 0.5), this.w * 0.5, this.h * 0.5));
		} else if (r > 0.5) {
			result.add(new MRect(this.x, this.y, this.w * 0.5, this.h));
			result.add(new MRect(this.x + (this.w * 0.5), this.y, this.w * 0.5, this.h));
		} else {
			result.add(new MRect(this.x, this.y, this.w, this.h * 0.5));
			result.add(new MRect(this.x, this.y + (this.h * 0.5), this.w, this.h * 0.5));
		}
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

	boolean intersectsY (MRect b) {
		if (this.y > b.y && this.y < b.y + b.h) {
			return true;
		}
		if (b.y > this.y && b.y < this.y + b.h) {
			return true;
		}
		return false;
	}

	boolean intersectsX (MRect b) {
		if (this.x > b.x && this.x < b.x + b.w) {
			return true;
		}
		if (b.x > this.x && b.x < this.x + b.w) {
			return true;
		}
		return false;
	}
}
