// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jul 25 2013
// 

import com.mutiny.*;

int width = 1024;
int height = 1024;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

// Input point
PVector a;
PImage bgImage;

ArrayList<LineSegment> lines;

void setup ()
{
	size(width, height, P3D);
	lines = new ArrayList<LineSegment>();
	bgImage = loadImage("data/input/building.jpg");
	bgImage.loadPixels();
}

void mouseClicked () {
	if (a == null) {
		a = new PVector(mouseX, mouseY);
	} else {
		LineSegment newLine = new LineSegment(a, new PVector(mouseX, mouseY));
		lines.add(newLine);
		a = null;
	}
}

PVector calculateExtensions (PVector pointA, PVector pointB)
{
	float projection = (pointB.y - pointA.y) / (pointB.x - pointA.x);

	float offset = pointA.y - (projection * pointA.x);

	PVector extend = new PVector(
			pointB.x < pointA.x ? width : 0.0,
			pointB.y < pointA.y ? height : 0.0
		);

	return new PVector(
			(projection * extend.y + extend.x - projection * offset) / (projection * projection + 1),
			(projection * projection * extend.y + projection * extend.x + offset) / (projection * projection + 1)
		);
}

void draw ()
{

	background(64);

	if (bgImage != null) {
		pushMatrix();
		scale(2, 2);
		image(
			bgImage,
			(width * 0.125) - (bgImage.width * 0.125),
			(height * 0.125) - (bgImage.height * 0.125)
		);
		popMatrix();
	}


	if (a != null) {
		strokeWeight(5);
		stroke(205);
		point(a.x, a.y);
	}

	for (int i = 0; i < lines.size(); i++) {
		LineSegment l = lines.get(i);

		stroke(
				l.dot.Color()
			);

		strokeWeight(4);

		point(l.start.x, l.start.y);
		point(l.end.x, l.end.y);

		strokeWeight(2);
		line(l.start.x, l.start.y, l.end.x, l.end.y);

		stroke(
			l.dot.r * 192,
			l.dot.g * 255,
			l.dot.b * 192,
			255
		);

		line (l.head.x, l.head.y, l.start.x, l.start.y);

		stroke(
			l.dot.r * 255,
			l.dot.g * 192,
			l.dot.b * 192,
			255
		);

		line(l.foot.x, l.foot.y, l.end.x, l.end.y);

		if (i % 2 != 0) {
			LineSegment otherLine = lines.get(i - 1);
			PVector intersection = l.intersection(otherLine);
			if (intersection != null) {
				stroke(255, 128, 0, 255);
				strokeWeight(32);
				point(intersection.x, intersection.y);

				strokeWeight(1);

				float rads = PI * 2 / 128;
				for (int spoke = 0; spoke < 128; spoke++) {
					float angle = rads * spoke;
					float cosa = cos(angle);
					float sina = sin(angle);
					PVector p1 = calculateExtensions(
							intersection,
							new PVector(
								intersection.x + cosa,
								intersection.y + sina
							)
						);

					if (spoke % 4 == 0) {
						stroke(
							l.dot.r * 128,
							l.dot.g * 128,
							l.dot.b * 128,
							255
						);
					} else {
						stroke(
							l.dot.r * 128,
							l.dot.g * 128,
							l.dot.b * 128,
							192	
						);
					}

					line(intersection.x, intersection.y, p1.x, p1.y);
				}
			}
		}
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

public class LineSegment
{
	public PVector start;
	public PVector end;
	public PVector head;
	public PVector foot;
	public Dot dot;

	public LineSegment (PVector s, PVector e)
	{
		this.start = s;
		this.end = e;
		this.head = this.extend(this.start, this.end);
		this.foot = this.extend(this.end, this.start);
		this.dot = new Dot(random(0.5, 1), random(0.5, 1), random(0.5, 1), 1, 1);
	}

	public PVector extend (PVector pointA, PVector pointB)
	{
		float projection = (pointB.y - pointA.y) / (pointB.x - pointA.x);

		float offset = pointA.y - (projection * pointA.x);

		PVector extend = new PVector(
				pointB.x < pointA.x ? width : 0.0,
				pointB.y < pointA.y ? height : 0.0
			);

		return new PVector(
				(projection * extend.y + extend.x - projection * offset) / (projection * projection + 1),
				(projection * projection * extend.y + projection * extend.x + offset) / (projection * projection + 1)
			);
	}

	public PVector intersection (LineSegment b)
	{
		float parallel = (this.start.x - this.end.x) * (b.start.y - b.end.y) - (this.start.y - this.end.y) * (b.start.x - b.end.x);

		if (parallel == 0) {
			return null;
		}

		float x = ((b.start.x - b.end.x) * (this.start.x * this.end.y - this.start.y * this.end.x) - (this.start.x - this.end.x) * (b.start.x * b.end.y - b.start.y * b.end.x)) / parallel;
		float y = ((b.start.y - b.end.y) * (this.start.x * this.end.y - this.start.y * this.end.x) - (this.start.y - this.end.y) * (b.start.x * b.end.y - b.start.y * b.end.x)) / parallel; 

		return new PVector(x, y);
	}
}
