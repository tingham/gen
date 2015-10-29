// # Power
// **Created By:** + tingham
// **Created On:** + Thu May 16 2013
// 
import com.mutiny.*;

int width = 1280;
int height = 720;
int tick = 0;
String inputName = "data/input/" + "Matterhorn-Lake-Switzerland.jpg";
String outputName = "data/output/" + System.currentTimeMillis() + "/";
PImage input;
Dot[] dots = new Dot[width * height];

void setup ()
{
	size(width, height, P3D);
	input = loadImage(inputName);
	input.resize(width, height);
	input.loadPixels();
	for (int i = 0; i < input.pixels.length; i++) {
		dots[i] = new Dot(red(input.pixels[i]) / 255, green(input.pixels[i]) / 255, blue(input.pixels[i]) / 255, alpha(input.pixels[i]) / 255);
	}

	thread("update");
}

void update () {
	while (true) {
		try {
			for (int i = 0; i < pixels.length; i++) {
				int x = i % width;
				int y = i - x / width;

				int u = y - 1 * width + x;
				int d = y + 1 * width + x;
				int l = y * width + (x - 1);
				int r = y * width + (x + 1);

				if (u > 0 && u < pixels.length) {
					evaluate(i, u);
					continue;
				}
				if (r > 0 && r < pixels.length) {
					evaluate(i, r);
					continue;
				}
				if (d > 0 && d < pixels.length) {
					evaluate(i, d);
					continue;
				}
				if (l > 0 && l < pixels.length) {
					evaluate(i, l);
					continue;
				}
			}
			Thread.sleep(5);
		} catch (Exception e) {
		}
	}
}

void evaluate (int a, int b) {
	int c1 = dots[a].Color();
	int c2 = dots[b].Color();
	if (dots[a].r > dots[b].r) {
		swap(a, b);
	} else if (dots[a].g < dots[b].g) {
		swap(a, b);
	} else if (dots[a].b < dots[b].b) {
		swap(a, b);
	}
}

void swap (int a, int b) {
	Dot d0 = dots[a];
	dots[a] = dots[b];
	dots[b] = d0;
}

void draw ()
{
	background(0);
	loadPixels();
	for (int i = 0; i < pixels.length; i++) {
		pixels[i] = dots[i].Color();
	}
	updatePixels();
	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

