// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Aug 26 2013
// 
import java.util.*;

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] foodDots;
List lines;
int seed;

void setup ()
{
	size(width, height, P3D);

	foodDots = new Dot[width * 2];
	lines = Collections.synchronizedList(new ArrayList());

	for (int f = 0; f < foodDots.length; f++) {
		float x = random(0, width);
		float y = random(0, height);
		foodDots[f] = new Dot(1, 0.5, 0.25, 1, noise((x / (float)width) * 4, (y / (float)height) * 4) * 2);
		foodDots[f].x = x;
		foodDots[f].y = y;
	}

	seed = (int)random(foodDots.length);

}

void update ()
{
	tick++;

/*
	while (true) {
		try {
*/
			// take seed point and cast a net
			// evaluate point in returned food sources with the most power
			// make a line to that food point
			// update seed to be this point
			Dot evalDot = foodDots[seed];

			float mPower = 0;
			int mIndex = -1;
			float sumPower = 0;
			ArrayList<Dot> pDots = nearbyDots(evalDot);
			for (int i = 0; i < pDots.size(); i++) {
				Dot tDot = pDots.get(i);
				if (tDot.power > mPower) {
					mPower = tDot.power;
					mIndex = i;
				}
				sumPower += tDot.power;
			}

			if (mIndex == -1 || sumPower < (pDots.size() * 0.5)) {
				// no food source found
				for (int i = 0; i < lines.size(); i++) {
					Line line = (Line)lines.get(i);
					if (line.b.power > 0.25) {
						for (int d = 0; d < foodDots.length; d++) {
							if (foodDots[d].x == line.b.x && foodDots[d].y == line.b.y) {
								seed = d;
							}
						}
					}
				}
			}
			else {
				Line l = new Line(evalDot, pDots.get(mIndex));
				evalDot.power *= 0.5;
				lines.add(l);
				for (int i = 0; i < foodDots.length; i++) {
					if (foodDots[i] == pDots.get(mIndex)) {
						seed = i;
					}
				}
			}

/*
			Thread.sleep(10);
		} catch (Exception e) {
		}
	}
*/
}

boolean inUse (Dot dot) {
	for (int i = 0; i < lines.size(); i++) {
		Line l = (Line)lines.get(i);
		if ((l.a.x == dot.x && l.a.y == dot.y) ||
			(l.b.x == dot.x && l.b.y == dot.y)) {
			return true;
		}
	}
	return false;
}

ArrayList<Dot> nearbyDots (Dot toDot)
{
	ArrayList<Dot> result = new ArrayList<Dot>();
	for (int i = 0; i < foodDots.length; i++) {
		float r = 64 * (1 + toDot.power + foodDots[i].power);
		if (toDot != foodDots[i] &&
			distance(toDot, foodDots[i]) < r) {
			stroke(200, 64, 64);
			strokeWeight(1.5);
			noFill();
			ellipse(toDot.x, toDot.y, r * 0.5, r * 0.5);
			boolean hasIntersection = false;
			for (int l = 0; l < lines.size(); l++) {
				Line line = (Line)lines.get(l);
				Line test = new Line(toDot, foodDots[i]);
				if (line.intersects(test)) {
					hasIntersection = true;
				}
			}
			if (!hasIntersection) {
				result.add(foodDots[i]);
			}
		}
	}
	println("Near: " + result.size());
	return result;
}

float distance (Dot a, Dot b) {
	return sqrt(((b.x - a.x) * (b.x - a.x)) + ((b.y - a.y) * (b.y - a.y)));
}

void draw ()
{
	background(64);
	update();

	for (int f = 0; f < foodDots.length; f++) {
		if (foodDots[f].power > 0) {
			stroke(foodDots[f].Color());
			strokeWeight(10.0 * foodDots[f].power);
			point(foodDots[f].x, foodDots[f].y);
		}
	}

	for (int i = 0; i < lines.size(); i++) {
		stroke(200);
		strokeWeight(2.0);
		noFill();

		if (i == 0) {
			Line dotLine = (Line)lines.get(i);
			line(
					dotLine.a.x, dotLine.a.y,
					dotLine.b.x, dotLine.b.y
				);
		}
		else {
			Line l1 = (Line)lines.get(i - 1);
			Line l2 = (Line)lines.get(i);
			curve(l1.a.x, l1.a.y, l2.a.x, l2.a.y, l2.b.x, l2.b.y, l2.b.x, l2.b.y);
		}
	}

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

boolean CCW(Dot d1, Dot d2, Dot d3) {
	float a = d1.x;
	float b = d1.y; 
	float c = d2.x;
	float d = d2.y;
	float e = d3.x;
	float f = d3.y;
	return (f - b) * (c - a) > (d - b) * (e - a);
}

/*
boolean isIntersect(p1, p2, p3, p4) {
	return (CCW(p1, p3, p4) != CCW(p2, p3, p4)) && (CCW(p1, p2, p3) != CCW(p1, p2, p4));
}
*/

public class Line {
	Dot a;
	Dot b;

	public Line(Dot a, Dot b) {
		this.a = a;
		this.b = b;
	}

	public float Power ()
	{
		return a.power + b.power;
	}

	public boolean intersects (Line other) {
		Dot p1 = this.a;
		Dot p2 = this.b;
		Dot p3 = other.a;
		Dot p4 = other.b;
		return (
			CCW(p1, p3, p4) != CCW(p2, p3, p4)) && (CCW(p1, p2, p3) != CCW(p1, p2, p4)
		);
	}

}
