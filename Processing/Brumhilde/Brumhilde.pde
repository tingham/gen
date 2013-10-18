// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Oct 15 2013
// 
import com.mutiny.*;

int width = 1280;
int height = 720;
int brushSize = 64;
float densityThreshold = 0.02;

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
	for (int i = 0; i < paint.length; i++) {
		int x = i % width;
		int y = (i - x) / width;
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;
		int left = y * width + (x - 1);
		int right = y * width + (x + 1);

		if (paint[i] == null) {
			continue;
		}

		if (up > 0 && left > 0 && right < pixels.length && down < pixels.length) {

			if ((abs(paint[i].density - paint[up].density) > densityThreshold) ||
				(abs(paint[i].density - paint[left].density) > densityThreshold) ||
				(abs(paint[i].density - paint[right].density) > densityThreshold) ||
				(abs(paint[i].density - paint[down].density) > densityThreshold)) {
				continue;
			}

			if (paint[i].dot.Sum() > paint[up].dot.Sum()) {
				swapPixels(left, right);
			}

			if (paint[i].dot.r > paint[right].dot.g) {
				swapPixels(up, down);
			}
			
			if (paint[i].dot.g > paint[down].dot.b) {
				swapPixels(right, left);
			}

			if (paint[i].dot.b > paint[left].dot.r) {
				swapPixels(down, up);
			}

			pixels[i] = paint[i].dot.Color();

		}

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

	float r = 0;
	float g = 0;
	float b = 0;

	int lead = (int)random(3);
	switch (key) {
		case 'r':
			r = random(0.75, 1.0);
			g = random(0.35, 0.5);
			b = random(0.35, 0.5);
			break;
		case 'g':
			r = random(0.35, 0.5);
			g = random(0.75, 1.0);
			b = random(0.35, 0.5);
			break;
		case 'b':
			r = random(0.35, 0.5);
			g = random(0.35, 0.5);
			b = random(0.75, 1.0);
			break;
		case 'w':
			r = random(0.75, 1.0);
			g = random(0.75, 1.0);
			b = random(0.75, 1.0);
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

void swapPixels (int a, int b)
{
	Paint p0 = paint[a];
	Paint p1 = paint[b];

	/*
	float disp = random(p0.density * p1.viscosity * p0.viscosity) * 0.001;
	p0.density -= disp;
	p1.density += disp;
	*/

	paint[a] = p1;
	paint[b] = p0;
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
	if (t % 90 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

