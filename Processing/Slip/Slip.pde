// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Oct 29 2013
// 
import com.mutiny.*;

int width = 512;
int height = 768;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

void setup ()
{
	size(width, height, P3D);
	dots = new Dot[width * height];

	PVector center = new PVector(width * 0.5, height * 0.5);
	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;
		PVector pos = new PVector(x, y);

		float n1 = noise((float)x / width, (float)y / height);

		float distance = pos.dist(center);

		float pa = distance / ((width > height) ? height : width);

		float n2 = pa / n1;

		if (pos.dist(center) / width < n1 &&
			pos.dist(center) / height < n1) {
			dots[i] = new Dot(n2, 0.0, 0.0, 1.0, 1.0);
		}
		else {
			dots[i] = new Dot(0.5, 0.5, 0.5, 1.0, 1.0);
		}
	}
}

void fill ()
{
	loadPixels();
	for (int i = 0; i < dots.length; i++) {
		pixels[i] = dots[i].Color();
	}
	updatePixels();
}

void draw ()
{
	fill();

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

