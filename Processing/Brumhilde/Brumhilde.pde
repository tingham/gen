// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Oct 15 2013
// 
import com.mutiny.*;

int width = 1280;
int height = 720;
int brushSize = 64;

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Paint[] paint;

void setup ()
{
	size (width, height, P3D);
	paint = new Paint[width * height];

	noiseDetail(20, 0.6);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float n1 = noise(
				(float)x / (float)width,
				(float)y / (float)height
			);
		float n2 = noise(
				(float)x / (float)width,
				(float)y / (float)height
			);

		paint[i] = new Paint(random(0.4, 0.6), random(0.4, 0.6), random(0.4, 0.6), n1, n2);
	}
	fill();
}

void fill ()
{
	loadPixels();
	for (int i = 0; i < pixels.length; i++) {
		int x = i % width;
		int y = (i - x) / width;
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;
		int left = y * width + (x - 1);
		int right = y * width + (x + 1);

		if (up > 0 && left > 0 && right < pixels.length && down > pixels.length) {
			swapPixels(i, up);
			swapPixels(i, left);
			swapPixels(i, right);
			swapPixels(i, down);
		}

		pixels[i] = paint[i].dot.Color();
	}
	updatePixels();
}

void keyPressed ()
{
	if (key == '[') {
		brushSize--;
	}
	if (key == ']') {
		brushSize++;
	}
}

void putPaint ()
{
	int brush = brushSize + (int)random(brushSize / 4) + 1;
	int half = brush / 2;
	PVector source = new PVector(mouseX, mouseY);

	noiseSeed((int)random(10) + 1);

	// noiseSeed((int)random(100));
	// noiseDetail(20, random(1));

	float r = 0;
	float g = 0;
	float b = 0;

	int lead = (int)random(3);
	switch (key) {
		case 'r':
			r = random(0.5, 1.0);
			g = random(0.25, 0.5);
			b = random(0.25, 0.5);
			break;
		case 'g':
			r = random(0.25, 0.5);
			g = random(0.5, 1.0);
			b = random(0.25, 0.5);
			break;
		case 'b':
			r = random(0.25, 0.5);
			g = random(0.25, 0.5);
			b = random(0.5, 1.0);
			break;
		case 'w':
			r = random(0.5, 1.0);
			g = random(0.5, 1.0);
			b = random(0.5, 1.0);
			break;
	}

	for (int x = 0; x < brush; x++) {
		for (int y = 0; y < brush; y++) {

			PVector destination = new PVector(
				mouseX + x - half,
				mouseY + y - half
			);

			int indice = (int)(destination.y * width + destination.x);
			float a = ((float)x / (float)(brush * 2)) * 4;
			float z = (float)y / (float)(brush * 2) * 4;

			float n = noise(
					a * 2, z * 2
				);
			float n1 = noise(
					a * 3, z * 3
				);
			float n2 = noise(
					a * 4, z * 4
				);
			float n3 = noise(
					a * 5, z * 5
				);

			if (indice > 0 &&
				indice < pixels.length &&
				source.dist(destination) < (n * half)) {

				Paint p = paint[indice];
				p.dot.r = r * n1 * (paint[mouseY * width + mouseX].dot.r + 0.2);
				p.dot.g = g * n2 * (paint[mouseY * width + mouseX].dot.g + 0.2);
				p.dot.b = b * n3 * (paint[mouseY * width + mouseX].dot.b + 0.2);
				p.density += 0.001;

				p.viscosity = lerp(
					p.viscosity,
					(p.dot.r + p.dot.g + p.dot.b),
					0.5
				);

				paint[indice] = p;

			}

		}
	}
}

void mouseDragged ()
{
	putPaint();
}

void sortPixels ()
{
	for (int i = 0; i < paint.length; i++) {
		int x = i % width;
		int y = (i - x) / width;
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;
		int left = y * width + (x - 1);
		int right = y * width + (x + 1);

		int moved = -1;

		if (up > 0 &&
			down < paint.length &&
			left > 0 &&
			right < paint.length) {

			if (paint[i].dot.r == 0.5 && paint[i].dot.g == 0.5 && paint[i].dot.b == 0.5) {
				continue;
			}

			// only where densities are similar
			moved = swapPixels(i, up);

			if (moved == up) {
				continue;
			}

			moved = swapPixels(i, left);

			if (moved == left) {
				continue;
			}

			moved = swapPixels(i, down);

			if (moved == down) {
				continue;
			}

			swapPixels(i, right);

		}
	}
}

int swapPixels (int a, int b)
{
	float diffDensity = abs(paint[a].density - paint[b].density);
	if (diffDensity < 0.1 && paint[a].viscosity > paint[b].viscosity) {

		Paint p0 = paint[a];
		Paint p1 = paint[b];

		paint[a] = p1;
		paint[b] = p0;

		return b;

	}
	return -1;
}

void draw ()
{
	// sortPixels();
	fill();

	strokeWeight(32);
	stroke(230);
	noFill();
	rect(0, 0, width, height);

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

