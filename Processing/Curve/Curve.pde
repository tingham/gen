// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Sep 06 2013
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] curvePoints;

void setup ()
{
	size(width, height, P3D);
	frameRate(1);
}

void draw ()
{
	background(32);

	curvePoints = new Dot[width];

	float startX = random(width);
	float startY = random(height);

	for (int i = 0; i < curvePoints.length; i++) {
		float nx = (float)(i % width);
		float ny = (i - nx) / width;
		float x = startX + (sin(i) * (width * noise(nx, 0)));
		float y = startY + (cos(i) * (height * noise(0, ny)));
		curvePoints[i] = new Dot(1, 1, 1, 1, 1);
		curvePoints[i].x = x;
		curvePoints[i].y = y;
	}

	noFill();
	for (int i = 2; i < curvePoints.length - 2; i = i + 3) {
		Dot a = curvePoints[i - 2];
		Dot b = curvePoints[i - 1];
		Dot c = curvePoints[i];
		Dot d = curvePoints[i + 1];
		Dot e = curvePoints[i + 2];

		beginShape();
		curveVertex(a.x, a.y);
		curveVertex(b.x, b.y);
		curveVertex(c.x, c.y);
		curveVertex(d.x, d.y);
		curveVertex(e.x, e.y);
		endShape();

	}

	loadPixels();

	for (int i = 0; i < pixels.length; i++) {
		float x = (float)(i % width);
		float y = (float)(i - x) / width;
		float n = noise(x / width, y / height);

		int left = (int)(y * width + (x - 1));
		int right = (int)(y * width + (x + 1));

		if (left > 0 && right < pixels.length) {
			if (brightness(pixels[left]) < brightness(pixels[i]) ||
				brightness(pixels[right]) < brightness(pixels[i])) {
				n *= 0.25;
			}
		}

		pixels[i] = color(255 * n);
	}

	updatePixels();

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

