// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Sep 26 2013
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
String inputName = "data/input/lauren-peralta.jpeg";

com.mutiny.Paint[] paint;

void setup ()
{
	PImage img = loadImage(inputName);
	img.loadPixels();

	size(img.width, img.height, P3D);
	width = img.width;
	height = img.height;

	paint = new com.mutiny.Paint[width * height];

	noiseDetail(10, 0.6);

	for (int i = 0; i < paint.length; i++) {
		float x = (float)i % width;
		float y = (float)(i - x) / width;

		float n1 = noise((x / width), (y / height));
		float n2 = noise((x / width) * 4, (y / height) * 4);
		float n3 = noise((x / width) * 3, (y / height) * 3);
		float n4 = noise((x / width) * 4, (y / height) * 4);
		float n5 = noise((x / width) * 5, (y / height) * 5);

		paint[i] = new com.mutiny.Paint(
			new Dot(n3, n4, n1, 1f, 1f),
			n1,
			(brightness(img.pixels[i]) / 255.0) * 0.1
		);
	}

	background(32);

	image(img, 0, 0);
	convertPixelsToPaint(true);

	frameRate(30);
}

void mouseDragged ()
{
	int index = mouseY * width + mouseX;
	for (int i = 0; i < 100; i++) {
		int x = i % 10;
		int y = (i - x) / 10;
		int m = (mouseY + y) * width + (mouseX + x);
		if (m > 0 && m < paint.length) {
			paint[m].viscosity = random(1);
		}
	}
}

void convertPixelsToPaint (boolean retainProperties)
{
	loadPixels();
	for (int i = 0; i < paint.length; i++) {
		Dot d = new Dot(pixels[i]);
		paint[i].dot = d;
	}
	
}

void dropPaint (int size)
{
	int index =  (int)(
		random((size + 1), height - (size + 1)) * width + random((size + 1), width - (size + 1))
	);

	com.mutiny.Paint p = new com.mutiny.Paint(
		new Dot(random(1.0), random(1.0), random(1.0), random(1), 1),
		random(1),
		random(1)
	);
	int fx = index % width;
	int fy = (index - fx) / width;

	for (int x = 0; x < size; x++) {
		for (int y = 0; y < size; y++) {
			paint[(fy + y) * width + (fx + x)] = p;
		}
	}

}

void drawCircle (int size)
{
	stroke(random(255), random(255), random(255), random(255));
	strokeWeight(size * 0.1);
	noFill();
	ellipse(random(width), random(height), size, size);
}

void repaint ()
{
	for (int i = 0; i < paint.length; i++) {
		effectOnlyMe(i);
		// effectEveryPixel(i);
		// densityGreater(i);
	}
}

void effectEveryPixel (int i) 
{
	int x = i % width;
	int y = (i - x) / width;
	int up = (y - 1) * width + x;
	int down = (y + 1) * width + x;
	int left = y * width + (x - 1);
	int right = y * width + (x + 1);
	int ul = (y - 1) * width + (x - 1);
	int dl = (y + 1) * width + (x - 1);
	int ur = (y - 1) * width + (x + 1);
	int dr = (y + 1) * width + (x + 1);

	if (up > 0 && down < paint.length && left > 0 && right < paint.length && ul > 0 && dl > 0 && ul < paint.length && dl < paint.length && ur > 0 && ur < paint.length && dr > 0 && dr < paint.length) {
			paint[up] = new com.mutiny.Paint(paint[i], paint[up]);
			paint[down] = new com.mutiny.Paint(paint[i], paint[down]);
			paint[left] = new com.mutiny.Paint(paint[i], paint[left]);
			paint[right] = new com.mutiny.Paint(paint[i], paint[right]);
			paint[ul] = new com.mutiny.Paint(paint[i], paint[ul]);
			paint[dr] = new com.mutiny.Paint(paint[i], paint[dr]);
			paint[ur] = new com.mutiny.Paint(paint[i], paint[ur]);
			paint[dl] = new com.mutiny.Paint(paint[i], paint[dl]);
	}
}

void effectOnlyMe (int i)
{
	int x = i % width;
	int y = (i - x) / width;
	int up = (y - 1) * width + x;
	int down = (y + 1) * width + x;
	int left = y * width + (x - 1);
	int right = y * width + (x + 1);
	int ul = (y - 1) * width + (x - 1);
	int dl = (y + 1) * width + (x - 1);
	int ur = (y - 1) * width + (x + 1);
	int dr = (y + 1) * width + (x + 1);

	if (x > 1 && x < width - 1 && y > 1 && y < height - 1) {

		if (paint[i].viscosity == EPSILON) {
			return;
		}

		if (paint[i].viscosity > paint[up].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[up]);
			paint[up].viscosity = lerp(paint[up].viscosity, 0, 0.001);
		}
		if (paint[i].viscosity > paint[down].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[down]);
			paint[down].viscosity = lerp(paint[down].viscosity, 0, 0.001);
		}
		if (paint[i].viscosity > paint[left].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[left]);
			paint[left].viscosity = lerp(paint[left].viscosity, 0, 0.001);
		}
		if (paint[i].viscosity > paint[right].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[right]);
			paint[right].viscosity = lerp(paint[right].viscosity, 0, 0.001);
		}
		if (paint[i].viscosity > paint[ul].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[ul]);
			paint[ul].viscosity = lerp(paint[ul].viscosity, 0, 0.001);
		}
		if (paint[i].viscosity > paint[dr].viscosity) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[dr]);
			paint[dr].viscosity = lerp(paint[dr].viscosity, 0, 0.001);
		}
		if (paint[i].viscosity > paint[ur].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[ur]);
			paint[ur].viscosity = lerp(paint[ur].viscosity, 0, 0.001);
		}
		if (paint[i].viscosity > paint[dl].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[dl]);
			paint[dl].viscosity = lerp(paint[dl].viscosity, 0, 0.001);
		}
	}
}

void densityGreater (int i) 
{
	int x = i % width;
	int y = (i - x) / width;
	int up = (y - 1) * width + x;
	int down = (y + 1) * width + x;
	int left = y * width + (x - 1);
	int right = y * width + (x + 1);
	int ul = (y - 1) * width + (x - 1);
	int dl = (y + 1) * width + (x - 1);
	int ur = (y - 1) * width + (x + 1);
	int dr = (y + 1) * width + (x + 1);

	if (up > 0 && down < paint.length && left > 0 && right < paint.length && ul > 0 && dl > 0 && ul < paint.length && dl < paint.length && ur > 0 && ur < paint.length && dr > 0 && dr < paint.length) {
		if (paint[i].density > paint[up].density ) {
			paint[up] = new com.mutiny.Paint(paint[i], paint[up]);
		}
		if (paint[i].density > paint[down].density ) {
			paint[down] = new com.mutiny.Paint(paint[i], paint[down]);
		}
		if (paint[i].density > paint[left].density ) {
			paint[left] = new com.mutiny.Paint(paint[i], paint[left]);
		}
		if (paint[i].density > paint[right].density ) {
			paint[right] = new com.mutiny.Paint(paint[i], paint[right]);
		}
		if (paint[i].density > paint[ul].density ) {
			paint[ul] = new com.mutiny.Paint(paint[i], paint[ul]);
		}
		if (paint[i].density > paint[dr].density) {
			paint[dr] = new com.mutiny.Paint(paint[i], paint[dr]);
		}
		if (paint[i].density > paint[ur].density ) {
			paint[ur] = new com.mutiny.Paint(paint[i], paint[ur]);
		}
		if (paint[i].density > paint[dl].density ) {
			paint[dl] = new com.mutiny.Paint(paint[i], paint[dl]);
		}
	}
}

void draw ()
{
	tick++;

	if (random(1) > 0.75) {
		repaint();
	}

	/*
	if (tick % (int)(random(10) + 10) == 0) {
		dropPaint((int)random(64, 128));
	}

	if (tick % (int)(random(10) + 10) == 0) {
		drawCircle((int)random(width * 0.25));
		convertPixelsToPaint(true);
	}
	*/

	loadPixels();

	for (int i = 0; i < paint.length; i++) {
		pixels[i] = paint[i].dot.Color();
	}

	updatePixels();
	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

