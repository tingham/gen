// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri May 24 2013
// 

import com.mutiny.*;

int width = (int)(8.5 * 64);
int height = (int)(11.0 * 64);

int tick = 0;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

float alpha = 32;

int[] colors = new int[] {
	color(255, 0, 0, alpha),
	color(0, 255, 0, alpha),
	color(0, 0, 255, alpha),
	color(255, 0, 255, alpha),
	color(255, 255, 0, alpha),
	color(0, 255, 255, alpha),
	color(255, 128, 0, alpha),
	color(128, 0, 255, alpha),
	color(0, 255, 128, alpha),
	color(255, 128, 128, alpha),
	color(128, 128, 255, alpha),
	color(128, 255, 128, alpha)
};

float c;
float s;
float nx, ny;

int radialEvals = 0;
int noiseEvals = 0;
int colorEvals = 2;
int levelsEvals = 129;
int intensityEvals = 0;
int blurEvals = 128;

int minCircles = 255;
int maxCircles = 255;

int breaking = 0;
int usePower = 0;

void setup ()
{
	size(width, height, P3D);

	generate();

	thread("update");
}

void generate ()
{
	background(128);
	noStroke();
	for (int i = 0; i < random(minCircles, maxCircles); i++) {
		fill(colors[(int)random(colors.length)]);
		float x = random(width * 0.25, width * 0.75);
		float y = random(height * 0.25, height * 0.75);
		float r = random(64, 256);
		for (int m = 0; m < (int)random(10); m++) {
			ellipse(x, y, r, r);
			r *= 0.75;
		}
	}

	loadPixels();
	dots = new Dot[width * height];

	for (int i = 0; i < pixels.length; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float ni = (float)((int)(noise(
			((float)x / (float)width) * 8,
			((float)y / (float)height) * 8
		) * 100)) / 100;

		dots[i] = new Dot(red(pixels[i]) / 255, green(pixels[i]) / 255, blue(pixels[i]) / 255, 1.0, ni);
	}

}

void update ()
{
	while (true) {
		try {
			tick++;

			c = 0.5 * cos(tick * 0.01) + 0.5;
			s = 0.5 * sin(tick * 0.01) + 0.5;

			nx = noise((float)tick / (float)width * 4, 0);
			ny = noise(0, (float)tick / (float)height * 4);

			if (noiseEvals > 0) {
				if (tick % noiseEvals == 0) {
					evalToNoise();
				}
			}

			if (radialEvals > 0) {
				if (tick % radialEvals == 0) {
					evalToRadial();
				}
			}

			if (colorEvals > 0) {
				if (tick % colorEvals == 0) {
					evalToColor();
				}
			}

			if (intensityEvals > 0) {
				if (tick % intensityEvals == 0) {
					evalToIntensity();
				}
			}

			if (blurEvals > 0) {
				if (tick % blurEvals == 0) {
					blur();
				}
			}

			if (levelsEvals > 0) {
				if (tick % levelsEvals == 0) {
					levels();
				}
			}

			Thread.sleep(10);
		} catch (Exception e) {

		}
	}
}


void levels () {
	for (int i = 0; i < dots.length; i++) {

		if (usePower > 0 && dots[i].power == 0) {
			continue;
		}
		dots[i].power = max(dots[i].power - (0.001 / (float)usePower + 0.001), 0);

		int x = i % width;
		int y = (i - x) / width;
		int left = y * width + (x - 1);
		int right = y * width + (x + 1);
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;
		int ul = (y - 1) * width + (x - 1);
		int ur = (y - 1) * width + (x + 1);
		int dl = (y + 1) * width + (x - 1);
		int dr = (y + 1) * width + (x + 1);

		if (left > 0 && left < dots.length
				&& right > 0 && right < dots.length
				&& up > 0 && up < dots.length
				&& down > 0 && down < dots.length
				&& ul > 0 && ul < dots.length
				&& ur > 0 && ur < dots.length
				&& dl > 0 && dl < dots.length
				&& dr > 0 && dr < dots.length) {
			float r, g, b, l;
			r = (dots[left].r + dots[up].r + dots[right].r + dots[down].r + dots[ul].r + dots[ur].r + dots[dl].r + dots[dr].r) / 8;
			g = (dots[left].g + dots[up].g + dots[right].g + dots[down].g + dots[ul].g + dots[ur].g + dots[dl].g + dots[dr].g) / 8;
			b = (dots[left].b + dots[up].b + dots[right].b + dots[down].b + dots[ul].b + dots[ur].b + dots[dl].b + dots[dr].b) / 8;

			if (usePower > 0) {
				l = dots[i].power * 0.1;
			} else {
				l = 0.01;
			}
			if (dots[i].r > r) {
				dots[i].r = lerp(dots[i].r, 1.0, l);
			} else {
				dots[i].r = lerp(dots[i].r, 0.0, l);
			}

			if (dots[i].g > g) {
				dots[i].g = lerp(dots[i].g, 1.0, l);
			} else {
				dots[i].g = lerp(dots[i].g, 0.0, l);
			}

			if (dots[i].b > b) {
				dots[i].b = lerp(dots[i].b, 1.0, l);
			} else {
				dots[i].b = lerp(dots[i].b, 0.0, l);
			}
		}
	}
}

void evalToIntensity () {
	for (int i = 0; i < dots.length; i++) {

		if (usePower > 0 && dots[i].power == 0) {
			continue;
		}
		dots[i].power = max(dots[i].power - (0.001 / (float)usePower + 0.001), 0);

		int x = i % width;
		int y = (i - x) / width;
		int left = y * width + (x - 1);
		int right = y * width + (x + 1);
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;

		if (down > 0 && down < dots.length && up > 0 && up < dots.length) {

			if (dots[i].r + dots[i].g + dots[i].b > dots[down].r + dots[down].g + dots[down].b) {
				Dot d0 = dots[i];
				dots[i] = dots[down];
				dots[down] = d0;
				if (breaking > 0) continue;
			} else {
				Dot d0 = dots[i];
				dots[i] = dots[up];
				dots[up] = d0;
				if (breaking > 0) continue;
			}

		}

		if (left > 0 && left < dots.length && right > 0 && right < dots.length) {

			if (dots[i].r + dots[i].g + dots[i].b > dots[left].r + dots[left].g + dots[left].b) {
				Dot d0 = dots[i];
				dots[i] = dots[left];
				dots[left] = d0;
				if (breaking > 0) continue;
			} else {
				Dot d0 = dots[i];
				dots[i] = dots[right];
				dots[right] = d0;
				if (breaking > 0) continue;
			}

		}

	}

}

void blur () {
	for (int i = 0; i < dots.length; i++) {

		if (usePower > 0 && dots[i].power == 0) {
			continue;
		}
		dots[i].power = max(dots[i].power - (0.001 / (float)usePower + 0.001), 0);

		int x = i % width;
		int y = (i - x) / width;
		int left = y * width + (x - 1);
		int right = y * width + (x + 1);
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;
		int ul = (y - 1) * width + (x - 1);
		int ur = (y - 1) * width + (x + 1);
		int dl = (y + 1) * width + (x - 1);
		int dr = (y + 1) * width + (x + 1);

		if (left > 0 && left < dots.length && right > 0 && right < dots.length && up > 0 && up < dots.length && down > 0 && down < dots.length) {
			float r = (dots[left].r + dots[up].r + dots[right].r + dots[down].r + dots[ul].r + dots[ur].r + dots[dl].r + dots[dr].r) / 8;
			float g = (dots[left].g + dots[up].g + dots[right].g + dots[down].g + dots[ul].g + dots[ur].g + dots[dl].g + dots[dr].g) / 8;
			float b = (dots[left].b + dots[up].b + dots[right].b + dots[down].b + dots[ul].b + dots[ur].b + dots[dl].b + dots[dr].b) / 8;

			if (usePower > 0) {
				dots[i].r = lerp(dots[i].r, r, dots[i].power);
				dots[i].g = lerp(dots[i].g, g, dots[i].power);
				dots[i].b = lerp(dots[i].b, b, dots[i].power);
			} else {
				dots[i].r = lerp(dots[i].r, r, 0.015);
				dots[i].g = lerp(dots[i].g, g, 0.015);
				dots[i].b = lerp(dots[i].b, b, 0.015);
			}
		}

	}
}
void evalToColor () {
	for (int i = 0; i < dots.length; i++) {

		if (usePower > 0 && dots[i].power == 0) {
			continue;
		}

		int x = i % width;
		int y = (i - x) / width;
		int left = y * width + (x - 1);
		int right = y * width + (x + 1);
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;

		if (left > 0 && left < dots.length && right > 0 && right < dots.length) {
			Dot d0 = dots[i];
			if (d0.r > dots[left].r) {
				dots[i] = dots[left];
				dots[left] = d0;
				if (breaking > 0) continue;
			} else if (d0.r > dots[right].r) {
				dots[i] = dots[right];
				dots[right] = d0;
				if (breaking > 0) continue;
			}
		}

		if (up > 0 && up < dots.length && down > 0 && down < dots.length) {
			Dot d0 = dots[i];
			if (d0.g > dots[up].g) {
				dots[i] = dots[up];
				dots[up] = d0;
				if (breaking > 0) continue;
			} else if (d0.g > dots[down].g) {
				dots[i] = dots[down];
				dots[down] = d0;
				if (breaking > 0) continue;
			}
		}

		if (up > 0 && up < dots.length && right > 0 && right < dots.length) {
			Dot d0 = dots[i];
			if (d0.b > dots[up].b) {
				dots[i] = dots[up];
				dots[up] = d0;
				if (breaking > 0) continue;
			} else if (d0.b > dots[right].b) {
				dots[i] = dots[right];
				dots[right] = d0;
				if (breaking > 0) continue;
			}
		}

	}
}

void evalToNoise () {
	for (int i = 0; i < dots.length; i++) {

		if (usePower > 0 && dots[i].power == 0) {
			continue;
		}
		dots[i].power = max(dots[i].power - (0.1 / (float)usePower + 0.001), 0);


		int x = i % width;
		int y = (i - x) / width;
		int dx = 0;
		int dy = 0;

		if (nx * dots[i].r > 0.5) {
			dx = x + 1;
		} else if (nx * dots[i].b < 0.5) {
			dx = x - 1;
		}

		if (ny * dots[i].g > 0.5) {
			dy = y + 1;
		} else if (ny * dots[i].b < 0.5) {
			dy = y - 1;
		}

		if (dy * width + dx > 0 && dy * width + dx < dots.length) {
			Dot d0 = dots[i];
			int t = dy * width + dx;
			/*
			dots[t].r = lerp(dots[t].r, d0.r, dots[t].r * 0.5);
			dots[t].g = lerp(dots[t].g, d0.g, dots[t].g * 0.5);
			dots[t].b = lerp(dots[t].b, d0.b, dots[t].b * 0.5);
			*/
			dots[i] = dots[t];
			dots[t] = d0;
		}
	}
}

void evalToRadial () {
	for (int i = 0; i < dots.length; i++) {

		if (usePower > 0 && dots[i].power == 0) {
			continue;
		}
		dots[i].power = max(dots[i].power - (0.5 / (float)usePower + 0.001), 0);

		int x = i % width;
		int y = (i - x) / width;
		int dx = 0;
		int dy = 0;

		dx = x - (int)lerp(x, width * c, 0.25);
		dy = y - (int)lerp(y, height * s, 0.25);

		if (dx < 0) {
			dx = x - 1;
		}
		if (dy < 0) {
			dy = y - 1;
		}
		if (dy > 0) {
			dy = y + 1;
		}
		if (dx > 0) {
			dx = x + 1;
		}

		if (dy * width + dx > 0 && dy * width + dx < dots.length) {
			Dot d0 = dots[i];
			dots[i] = dots[dy * width + dx];
			dots[dy * width + dx] = d0;
			/*
			dots[dy * width + dx].r = lerp(dots[dy * width + dx].r, d0.r, d0.b * 0.1);
			dots[dy * width + dx].g = lerp(dots[dy * width + dx].g, d0.g, d0.r * 0.1);
			dots[dy * width + dx].b = lerp(dots[dy * width + dx].b, d0.b, d0.g * 0.1);
			*/
		}
	}
}

void evalToCenter () {
	for (int i = 0; i < dots.length; i++) {

		if (usePower > 0 && dots[i].power == 0) {
			continue;
		}
		dots[i].power = max(dots[i].power - (0.5 / (float)usePower + 0.001), 0);

		int x = i % width;
		int y = (i - x) / width;
		int dx = 0;
		int dy = 0;

		if (x < (width * 0.5)) {
			dx = x - 1;
		}
		if (x > (width * 0.5)) {
			dx = x + 1;
		}
		if (y > (height * 0.5)) {
			dy = y - 1;
		}
		if (y < (height * 0.5)) {
			dy = y + 1;
		}

		if (dy * width + dx > 0 && dy * width + dx < dots.length) {
			Dot d0 = dots[i];
			dots[i] = dots[dy * width + dx];
			dots[dy * width + dx] = d0;
		}
	}
}

void draw ()
{
	background(0);

	for (int i = 0; i < dots.length; i++) {
		int x = i % width;
		int y = (i - x) / width;

		fill(dots[i].Color());
		noStroke();

		pushMatrix();
		translate(x, y, 0);
		rect(0, 0, 1, 1);
		popMatrix();
	}

	/*
	pushMatrix();
	translate(c * width, s * height, 0);
	fill(255);
	rect(0, 0, 5, 5);
	popMatrix();
	*/

	long t = System.currentTimeMillis();
	if (t % 10 == 0) {
		String fname = "r" + radialEvals + "-n" + noiseEvals + "-c" + colorEvals + "-l" + levelsEvals + "-minc" + minCircles + "-maxc" + maxCircles + "-b" + breaking + "-i" + intensityEvals + "-blur" + blurEvals + " -pow" + usePower;
		save(outputName + fname + "-time-" + t + ".jpg");
	}
}

