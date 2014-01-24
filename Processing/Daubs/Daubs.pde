// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 21 2014
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots = new Dot[width];

void setup ()
{
	size(width, height, P3D);

	for (int i = 0; i < dots.length; i++) {
		Dot d = new Dot(
				random(1),
				random(1),
				random(1),
				random(1),
				random(1),
				random(1),
				1,
				random(1)
			);
		dots[i] = d;
	}
}

void update () {
	for (int i = 0; i < dots.length; i++) {
		Dot preDot = null,
			postDot = null,
			rDot = null,
			thisDot = null;
		// some random one.
		int r = (int)random(dots.length - 1),
			score = 0;

		if (i > 0) {
			preDot = dots[i - 1];
		}

		rDot = dots[r];

		if (i < dots.length - 1) {
			postDot = dots[i + 1];
		}

		thisDot = dots[i];

		if (preDot != null && postDot != null) {
			// if preDot has less in common with this than post move it to r.
			if (Math.abs(preDot.r - thisDot.r) < 0.05) {
				score++;
			}
			if (Math.abs(preDot.g - thisDot.g) < 0.05) {
				score++;
			}
			if (Math.abs(preDot.b - thisDot.b) < 0.05) {
				score++;
			}
		}

		if (score > 2 && r != i) {
			swapDot(i - 1, r);
		} else if (score > 1 && r != i) {
			swapDot(i + 1, r);
		}

		if (i > 0 && i < dots.length - 1) {
			dots[i + 1].x = lerp(dots[i + 1].x, dots[i - 1].x, dots[i].power * dots[i - 1].power * 0.001);
			dots[i + 1].y = lerp(dots[i + 1].y, dots[i - 1].y, dots[i].power * dots[i - 1].power * 0.001);
			dots[i + 1].z = lerp(dots[i + 1].z, dots[i - 1].z, dots[i].power * dots[i - 1].power * 0.001);

			dots[i - 1].x = lerp(dots[i - 1].x, dots[i + 1].x, dots[i].power * dots[i + 1].power * 0.001);
			dots[i - 1].y = lerp(dots[i - 1].y, dots[i + 1].y, dots[i].power * dots[i + 1].power * 0.001);
			dots[i - 1].z = lerp(dots[i - 1].z, dots[i + 1].z, dots[i].power * dots[i + 1].power * 0.001);
		}

	}
}

void swapDot (int a, int b) {
	try {
		Dot d0 = dots[a];
		dots[a] = dots[b];
		dots[b] = d0;
	} catch (Exception e) {
		// println(a + " " + b);
	}
}

void draw ()
{
	update();

	tick++;

	background(32);

	noStroke();

	pushMatrix();
	translate(0, 0, -width);
	for (int i = 0; i < dots.length; i++) {
		fill(dots[i].Color());
		pushMatrix();
		translate(dots[i].x * width, dots[i].y * height, dots[i].z * width);
		sphere(dots[i].power * 10);
		popMatrix();
	}
	popMatrix();

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

