// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Jan 20 2013
// 

int width = 512;
int height = 512;

ArrayList<Mark> marks = new ArrayList<Mark>();
int[] colors = new int[] {
	color(255, 225, 225),
	color(215, 225, 230),
	color(185, 170, 216)
};

class Mark {
	int health;
	PVector offset;

	public Mark (int health, float x, float y) {
		this.health = health;
		this.offset = new PVector(x, y);
	}
}

void setup ()
{
	size(width, height);

	for (int i = 0; i < 50; i++) {
		Mark m = new Mark((int)random(150), random(-4, 4), random(-4, 4));
		marks.add(m);
	}

}

void draw ()
{
	PVector origin = new PVector(random(-width / 2, width * 1.5), random(-height / 2, height * 1.5));

	PVector last = origin;
	beginShape();
	for (Mark m : marks) {
		for (int i = m.health; i > 0; i--) {
			int c = colors[(int)random(colors.length - 1)];
			stroke(red(c) - random(32), green(c) - random(32), blue(c) - random(32), random(128));
			strokeWeight(random(4) + 0.001);
			noFill();
			curveVertex(m.offset.x + last.x, m.offset.y + last.y);
			if (random(1) > 0.5) {
				last = PVector.add(m.offset, last);
			} else if (random(1) > 0.25) {
				last = PVector.add(marks.get((int)random(marks.size() - 1)).offset, last);
			} else {
				continue;
			}
		}
	}
	endShape();

	if (System.currentTimeMillis() % 30 == 0) {
		save("data/output/s-" + System.currentTimeMillis() + ".jpg");
	}
}

