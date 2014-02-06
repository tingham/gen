// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Feb 02 2014
// 
//
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
int intervals = 70;
int step = 5;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

void setup ()
{
	size(width, height, P3D);
	dots = new Dot[width * height];

	tick = (int)random(20) + 2;

	generate();
}

void generate () {
	noiseDetail(20, 0.5);

	for (int i = 0; i < dots.length; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float fx = ((float)x / width) * 2;
		float fy = ((float)y / height) * 2;

		float n1 = noise(fx, fy);
		float n2 = noise(((fx + (tick * 0.1)) * 1.5), (fy + (tick * 0.5)) * 1.5);
		float n3 = noise((fx + (tick * 0.3)) * 4, ((fy + (tick * 0.1))) * 4);
		float n4 = noise((fx + (tick * 0.3)) * 4, ((fy + (tick * 0.3))) * 4) * 0.5;

		if (dots[i] == null) {
			Dot d = new Dot(n1, n2, n3, 1, 1);
			dots[i] = d;
		} else {
			Dot d = new Dot(lerp(dots[i].r, n1, n4), lerp(dots[i].g, n2, n4), lerp(dots[i].b, n3, n4), 1, 1);
			dots[i] = d;
		}
	}
}

void update () {
	for (int i = 0; i < dots.length; i++) {
		int x = i % width;
		int y = (i - x) / width;

		int u = (y - 1) * width + x;
		int d = (y + 1) * width + x;
		int l = y * width + (x - 1);
		int r = y * width + (x + 1);

		if (u > 0 && d < dots.length && l > 0 && r < dots.length && i > 0 && i < dots.length) {

			if (dots[i].r < dots[d].r) {
				Dot d0 = dots[d];
				dots[d] = dots[i];
				dots[i] = d0;
			}

			if (dots[i].g < dots[l].g && dots[i].b < dots[l].b) {
				Dot d0 = dots[l];
				dots[l] = dots[i];
				dots[i] = d0;
			}

			if (dots[i].b < dots[u].b && dots[i].r < dots[u].r && dots[i].g > dots[u].g) {
				Dot d0 = dots[u];
				dots[u] = dots[i];
				dots[i] = d0;
			}

		}
	}
}

void draw ()
{
	tick++;

	if (tick % (step * intervals) == 0) {
		generate();
	}


	if (tick % step == 0) {
		loadPixels();
		for (int i = 0; i < dots.length; i++) {
			pixels[i] = dots[i].Color();
		}
		updatePixels();
	}

	update();

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

