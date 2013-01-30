// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 29 2013
// 

int width = 720;
int height = 1024;
int tick = 0;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<PVector> points = new ArrayList<PVector>();
color[] cache = new color[width * height];

void setup ()
{
	size(width, height);
	frameRate(1);

	for (int i = 0; i < 32; i++) {
		points.add(
			new PVector(random(-1, 1), random(-1, 1))
		);
	}

}

void draw ()
{
	fill(200, 200, 200, 32);
	noStroke();
	rect(0, 0, width, height);

	for (int p = 0; p < cache.length; p++) {
		int x = cache.length / width;
		int y = cache.length % width;
		// if (x % 16 == 0 && y % 16 == 0) {
		//		drawSquare(cache, x, y, 16);
		// }
		if (random(1) > 0.5) {
			stroke(cache[p]);
			strokeWeight(1.1);
			point(x, y);
		}
	}

	stroke(32);

	for (int i = 0; i < points.size(); i++) {
		PVector point = points.get(i);
		if (random(1) > 0.5) {
			drawCircles(point);
		}
		if (random(1) > 0.5) {
			drawTriangles(point);
		}
		if (random(1) > 0.5) {
			drawSlashes(point);
		}
	}

	loadPixels();

	for (int p = 0; p < pixels.length; p++) {
		cache[p] = pixels[p];
	}

	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 2 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

void drawSquare (int[] px, int x, int y, int r) {
	for (int ix = x; ix < x + r; ix++) {
		for (int iy = y; iy < y + r; iy++) {
			int indice = iy * width + ix;
			if (indice < px.length) {
				stroke(px[indice]);
				point(ix, iy);
			}
		}
	}
}

void drawCircles (PVector origin) {
	int count = (int)random(12) + 1;
	for (int i = 0; i < count; i++) {
		float ox = origin.x * noise(i / count, i / count);
		float oy = origin.y * noise(i / count, i / count);
		float x = (width * 0.5) + (width * 0.125 * ox);
		float y = (height * 0.5) + (height * 0.125 * oy);
		float r = random(width * 0.125) + (width * 0.125);
		strokeWeight(r / (width * 0.25));
		noFill();
		ellipse(x, y, r, r);
	}
}

void drawTriangles (PVector origin) {
	int count = (int)random(7) + 1;
	for (int i = 0; i < count; i++) {
		float a = ((float)i / (float)count) * (width * 0.25);
		float b = origin.x * (width * 0.25);
		float c = origin.y * (height * 0.25);
		pushMatrix();
		translate(width / 2, height / 2);
		strokeWeight(((float)i / (float)count) + 1);
		noFill();
		triangle(a, b, b, c, c, a);
		popMatrix();
	}
}

void drawSlashes (PVector origin) {
	int count = (int)random(5) + 1;
	for (int i = 0; i < count; i++) {
		float fi = (float)i / (float)count;
		PVector a = new PVector(
			(origin.x + random(-1, 1)) + (cos(fi * 4) * TWO_PI) * (width * random(0.0625)),
			(origin.y + random(-1, 1)) + (sin(fi * 4) * TWO_PI) * (height * random(0.0625))
		);
		PVector b = new PVector(
			(origin.x + random(-1, 1)) - (cos(fi * 4) * TWO_PI) * (width * random(0.0625)),
			(origin.y + random(-1, 1)) - (sin(fi * 4) * TWO_PI) * (height * random(0.0625))
		);
		pushMatrix();
		translate(width / 2, height / 2);
		strokeWeight(random(3) + 0.1);
		line(a.x, a.y, b.x, b.y);
		popMatrix();
	}
}

