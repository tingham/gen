// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Oct 15 2013
// 
import com.mutiny.*;

int width = 1280;
int height = 720;
int brushSize = 64;
float densityThreshold = 0.02;
float r = 0;
float g = 0;
float b = 0;


int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Paint[] paint;

void setup ()
{
	size (width, height, P3D);
	paint = new Paint[width * height];

	noiseDetail(20, 0.6);

	PVector av = new PVector(width * 0.5, height * 0.5);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		PVector pv = new PVector(x, y);

		float n1 = noise(
				(float)x / (float)width * 5,
				(float)y / (float)height * 5
			);
		float n2 = noise(
				(float)(x + width) / (float)width * 7,
				(float)y / (float)height * 7
			);
		float n3 = noise(
				(float)(x + height) / (float)width * 9,
				(float)y / (float)height * 9
			);

		float distanceDriver = 1.0 - ((float)pv.dist(av) / (float)height);

		paint[i] = new Paint(distanceDriver, n2, n3, n1, n2);

	}
	fill();
}

void fill ()
{
	loadPixels();
	for (int i = 0; i < paint.length; i++) {

		kernel(i);

		if (random(1.0) < 0.75) {
			continue;
		}

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

			int maxDensityIndex = i;
			float maxDensity = 0f;

			if (paint[up].density > maxDensity) {
				maxDensity = paint[up].density;
				maxDensityIndex = up;
			}
			if (paint[left].density > maxDensity) {
				maxDensity = paint[left].density;
				maxDensityIndex = left;
			}
			if (paint[right].density > maxDensity) {
				maxDensity = paint[right].density;
				maxDensityIndex = right;
			}
			if (paint[down].density > maxDensity) {
				maxDensity = paint[down].density;
				maxDensityIndex = down;
			}

			float shift = paint[maxDensityIndex].viscosity * paint[i].viscosity + 0.1;

			paint[i].dot.r = lerp(paint[i].dot.r, paint[maxDensityIndex].dot.r, shift);
			paint[i].dot.g = lerp(paint[i].dot.g, paint[maxDensityIndex].dot.g, shift);
			paint[i].dot.b = lerp(paint[i].dot.b, paint[maxDensityIndex].dot.b, shift);

			pixels[i] = paint[i].dot.Color();

			paint[up].dot.r = lerp(paint[up].dot.r, paint[i].dot.r, paint[up].viscosity * shift);
			paint[up].dot.g = lerp(paint[up].dot.g, paint[i].dot.g, paint[up].viscosity * shift);
			paint[up].dot.b = lerp(paint[up].dot.b, paint[i].dot.b, paint[up].viscosity * shift);

			paint[right].dot.r = lerp(paint[right].dot.r, paint[i].dot.r, paint[right].viscosity * shift);
			paint[right].dot.g = lerp(paint[right].dot.g, paint[i].dot.g, paint[right].viscosity * shift);
			paint[right].dot.b = lerp(paint[right].dot.b, paint[i].dot.b, paint[right].viscosity * shift);

			paint[left].dot.r = lerp(paint[left].dot.r, paint[i].dot.r, paint[left].viscosity * shift);
			paint[left].dot.g = lerp(paint[left].dot.g, paint[i].dot.g, paint[left].viscosity * shift);
			paint[left].dot.b = lerp(paint[left].dot.b, paint[i].dot.b, paint[left].viscosity * shift);

			paint[down].dot.r = lerp(paint[down].dot.r, paint[i].dot.r, paint[down].viscosity * shift);
			paint[down].dot.g = lerp(paint[down].dot.g, paint[i].dot.g, paint[down].viscosity * shift);
			paint[down].dot.b = lerp(paint[down].dot.b, paint[i].dot.b, paint[down].viscosity * shift);
		}


	}
	updatePixels();
}

void keyPressed ()
{
	if (key == '[') {
		brushSize -= 8;
	}
	if (key == ']') {
		brushSize += 8;
	}

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
			r = random(0.45, 0.5);
			g = random(0.45, 0.5);
			b = random(0.75, 1.0);
			break;
		case 'w':
			r = random(0.85, 1.0);
			g = random(0.85, 1.0);
			b = random(0.85, 1.0);
			break;
	}

	if (brushSize > 255) {
		brushSize = 255;
	}
	if (brushSize < 0) {
		brushSize = 4;
	}
}

void putPaint ()
{
	int brush = brushSize + (int)random(4);
	int half = brush / 2;
	float brushFloat = 1.0 - ((float)brush / 255.0);

	PVector source = new PVector(mouseX, mouseY);

	noiseSeed((int)random(10) + 1);
	int lead = (int)random(3);

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

				//p.dot.r = lerp(r * n1, paint[indice].dot.r, 1.0 - brushFloat);
				//p.dot.g = lerp(g * n2, paint[indice].dot.g, 1.0 - brushFloat);
				//p.dot.b = lerp(b * n3, paint[indice].dot.b, 1.0 - brushFloat);

				p.density = brushFloat;
				p.viscosity = max(0.0, min(1.0, 1.0 - brushFloat));

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
	paint[a] = p1;
	paint[b] = p0;
}

void kernel (int i) {
	int x = i % width;
	int y = (i - x) / width;
	PVector[] offsets = new PVector[] {
			new PVector(-1, 0),
			new PVector(-1, -1),
			new PVector(0, -1),
			new PVector(1, -1),
			new PVector(1, 0),
			new PVector(1, 1),
			new PVector(0, 1),
			new PVector(-1, 1)
		};

	int ro = offsets.length;
	for (int o = 0; o < offsets.length; o++) {
		ro--;
		int index1 = (y + (int)offsets[o].y) * width + (x + (int)offsets[o].x);
		int index2 = (y + (int)offsets[ro].y) * width + (x + (int)offsets[ro].x);
		if (index1 > 0 && index1 < paint.length &&
			index2 > 0 && index2 < paint.length) {
			float f = abs(paint[index1].dot.Sum() - paint[index2].dot.Sum());
			if (f > 0.125f) {
				paint[i].dot.r += 0.01 * paint[i].viscosity;
				paint[i].dot.g += 0.01 * paint[i].viscosity;
				paint[i].dot.b += 0.01 * paint[i].viscosity;
			}
			
		}
	}

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

