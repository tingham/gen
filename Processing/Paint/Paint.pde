// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Sep 26 2013
// 
import com.mutiny.*;

int width = 1280;
int height = 720;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
String inputName = "data/input/";
String[] assets = new String[] {
	"coreena-lewis.jpg",
	"katie-west-01.jpg",
	"katie-west-02.jpg",
	"katie-west-03.jpg",
	"lauren-peralta.jpeg",
	"sarah-cirilli.jpg"
	};

com.mutiny.Paint[] paint;
String assetname = null;
PImage img;
float frameSize = 0.1f;
boolean debug = false;

float rDriver = 1.0;
float gDriver = 1.0;
float bDriver = 1.0;

void setup ()
{
	// setupImage();
	setupNoise();

	convertPixelsToPaint(true);

	frameRate(20);
}

void setupNoise ()
{

	size(width, height, P3D);

	paint = new com.mutiny.Paint[width * height];

	noiseDetail(10, 0.6);

	background(32);

	loadPixels();

	PVector center = new PVector(
			width * 0.5,
			height * 0.5
		);

	PVector second = new PVector(
			random(width - (width * 0.25)) + (width * 0.25),
			random(height - (height * 0.25)) + (height * 0.25)
		);

	for (int i = 0; i < paint.length; i++) {
		float x = (float)i % width;
		float y = (float)(i - x) / width;

		float n1 = noise((x / width) * 2.5, (y / height) * 2.5);
		float n2 = noise((x / width) * 4, (y / height) * 4);
		float n3 = noise((x / width) * 3, (y / height) * 3);
		float n4 = noise((x / width) * 4, (y / height) * 4);
		float n5 = noise((x / width) * 5, (y / height) * 5);

		PVector thisPoint = new PVector(x, y);

		if (thisPoint.dist(center) < (height * 0.4) * n1 ||
			thisPoint.dist(second) < (height * 0.2) * n1) {
			paint[i] = new com.mutiny.Paint(
				new Dot(n3 * rDriver, n4 * gDriver, n5 * bDriver, 1f, 1f),
				n1,
				n2
			);
		}
		else {
			paint[i] = new com.mutiny.Paint(new Dot(0.1, 0.1, 0.1, 1, 1), n1, n2);
		}

		pixels[i] = paint[i].dot.Color();
	}

	updatePixels();

}

void setupImage ()
{
	if (assetname == null) {
		assetname = inputName + assets[(int)random(0, assets.length)];
		img = loadImage(assetname);
		img.loadPixels();
	}

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

		float r = (red(img.pixels[i]) / 255.0);
		float g = (green(img.pixels[i]) / 255.0);
		float b = (blue(img.pixels[i]) / 255);
		float rgbMagnitude = sqrt((r * r) + (g * g) + (b * b)) * 0.5;

		rgbMagnitude = Math.min(1, Math.max(0, rgbMagnitude));

		paint[i] = new com.mutiny.Paint(
			new Dot(n3, n4, n1, 1f, 1f),
			1 - rgbMagnitude, //0.5, // 1 - brightness(img.pixels[i]) / 255.0,
			rgbMagnitude
		);
	}

	background(32);

	image(img, 0, 0);
}

void mouseDragged ()
{
	int index = mouseY * width + mouseX;
	for (int i = 0; i < 100; i++) {
		int x = i % 10;
		int y = (i - x) / 10;
		int m = (mouseY + y) * width + (mouseX + x);
		if (m > 0 && m < paint.length) {
			paint[m].viscosity = random(0.9);
			paint[m].density = random(0.5);
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
		sortedEvaluate(i);
	}
}

void gravity (int i)
{
	int x = i % width;
	int y = (i - x) / width;
	int down = (y + 1) * width + x;
	int dr = (y + 1) * width + (x + 1);
	int dl = (y + 1) * width + (x - 1);

	if (x > 1 && x < width - 1 && y > 1 && y < height - 1) {

		com.mutiny.Paint p1 = paint[i];
		com.mutiny.Paint p2 = paint[down];

		if (p1.density > p2.density && p1.viscosity < p2.viscosity) {
			// paint[i] = p2;
			paint[down] = p1;
			// gravity(down);
		}

		com.mutiny.Paint p3 = paint[i];
		com.mutiny.Paint p4 = paint[dl];

		if (p3.density > p4.density && p3.viscosity < p4.viscosity) {
			gravity(down);
		}

		com.mutiny.Paint p5 = paint[i];
		com.mutiny.Paint p6 = paint[dr];

		if (p5.density > p6.density && p5.viscosity < p6.viscosity) {
			gravity(down);
		}
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

		if (paint[up].density < paint[i].density) {
			paint[up] = new com.mutiny.Paint(paint[i], paint[up]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[up].viscosity > paint[i].viscosity && paint[up].density < paint[i].density) {
			effectEveryPixel(up);
			SwapPaint(i, up);
			return;
		}

		if (paint[down].density < paint[i].density) {
			paint[down] = new com.mutiny.Paint(paint[i], paint[down]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[down].viscosity > paint[i].viscosity && paint[down].density < paint[i].density) {
			effectEveryPixel(down);
			SwapPaint(i, down);
			return;
		}

		if (paint[left].density < paint[i].density) {
			paint[left] = new com.mutiny.Paint(paint[i], paint[left]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[left].viscosity > paint[i].viscosity && paint[left].density < paint[i].density) {
			effectEveryPixel(left);
			SwapPaint(i, left);
			return;
		}

		if (paint[right].density < paint[i].density) {
			paint[right] = new com.mutiny.Paint(paint[i], paint[right]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[right].viscosity > paint[i].viscosity && paint[right].density < paint[i].density) {
			effectEveryPixel(right);
			SwapPaint(i, right);
			return;
		}

		if (paint[ul].density < paint[i].density) {
			paint[ul] = new com.mutiny.Paint(paint[i], paint[ul]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[ul].viscosity > paint[i].viscosity && paint[ul].density < paint[i].density) {
			effectEveryPixel(ul);
			SwapPaint(i, ul);
			return;
		}

		if (paint[dr].density < paint[i].density) {
			paint[dr] = new com.mutiny.Paint(paint[i], paint[dr]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[dr].viscosity > paint[i].viscosity && paint[dr].density < paint[i].density) {
			effectEveryPixel(dr);
			SwapPaint(i, dr);
			return;
		}

		if (paint[dl].density < paint[i].density) {
			paint[dl] = new com.mutiny.Paint(paint[i], paint[dl]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[dl].viscosity > paint[i].viscosity && paint[dl].density < paint[i].density) {
			effectEveryPixel(dl);
			SwapPaint(i, dl);
			return;
		}

		if (paint[ur].density < paint[i].density) {
			paint[ur] = new com.mutiny.Paint(paint[i], paint[ur]);
			paint[i].density *= 0.9999;
			paint[i].viscosity *= 0.9999;
		}

		if (paint[ur].viscosity > paint[i].viscosity && paint[ur].density < paint[i].density) {
			effectEveryPixel(ur);
			SwapPaint(i, ur);
			return;
		}

	}
}

void SwapPaint (int a, int b)
{   
	com.mutiny.Paint p = paint[a];
	paint[a] = paint[b];
	paint[b] = p;

	float density = paint[a].density - paint[b].density;
	if (density > EPSILON) {
		paint[a].dot.r = lerp(paint[a].dot.r, paint[b].dot.r, density);
		paint[a].dot.g = lerp(paint[a].dot.g, paint[b].dot.g, density);
		paint[a].dot.b = lerp(paint[a].dot.b, paint[b].dot.b, density);

		paint[a].viscosity *= 0.9999f;
		paint[b].viscosity *= 0.9999f;
	}
}

boolean evaluateInverse = false;

void sortedEvaluate (int i)
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

		float mostViscosity = 0;
		int mostIndex = 0;

		if (mostViscosity < paint[up].viscosity) {
			mostViscosity = paint[up].viscosity;
			mostIndex = down;
		}
		if (mostViscosity < paint[left].viscosity) {
			mostViscosity = paint[left].viscosity;
			mostIndex = right;
		}
		if (mostViscosity < paint[right].viscosity) {
			mostViscosity = paint[right].viscosity;
			mostIndex = left;
		}
		if (mostViscosity < paint[down].viscosity) {
			mostViscosity = paint[down].viscosity;
			mostIndex = up;
		}
		if (mostViscosity < paint[ul].viscosity) {
			mostViscosity = paint[ul].viscosity;
			mostIndex = ul;
		}
		if (mostViscosity < paint[dr].viscosity) {
			mostViscosity = paint[dr].viscosity;
			mostIndex = dr;
		}
		if (mostViscosity < paint[dl].viscosity) {
			mostViscosity = paint[dl].viscosity;
			mostIndex = dl;
		}
		if (mostViscosity < paint[ur].viscosity) {
			mostViscosity = paint[ur].viscosity;
			mostIndex = ur;
		}

		// what if they are all equal?
		SwapPaint(i, mostIndex);
	}

}
void simpleEvaluate (int i)
{
	int x = i % width;
	int y = (i - x) / width;
	int up = (y - 1) * width + x;
	int down = (y + 1) * width + x;
	int left = y * width + (x - 1);
	int right = y * width + (x + 1);
	int score = 0;

	if (x > 1 && x < width - 1 && y > 1 && y < height - 1) {
		
		if (paint[i].viscosity == EPSILON) {
			return;
		}
		if (paint[i].dot.r > paint[up].dot.g && paint[i].viscosity > paint[up].viscosity && paint[i].cache != "up") {
			score++;
			paint[i].cache = "up";
			SwapPaint(i, up);
		}

		if (paint[i].dot.g > paint[left].dot.b && paint[i].viscosity > paint[left].viscosity && paint[i].cache != "left") {
			score++;
			paint[i].cache = "left";
			SwapPaint(i, left);
		}

		if (paint[i].dot.b > paint[right].dot.r && paint[i].viscosity > paint[right].viscosity && paint[i].cache != "right") {
			score++;
			paint[i].cache = "right";
			SwapPaint(i, right);
		}

		if (paint[i].density > paint[down].density && paint[i].cache != "down") {
			score++;
			paint[i].cache = "down";
			SwapPaint(i, down);
		}

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

		//if (paint[i].viscosity > paint[up].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[up]);
			paint[up].viscosity = lerp(paint[up].viscosity, 0, 0.001);
		//}
		//if (paint[i].viscosity > paint[down].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[down]);
			paint[down].viscosity = lerp(paint[down].viscosity, 0, 0.001);
		//}
		//if (paint[i].viscosity > paint[left].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[left]);
			paint[left].viscosity = lerp(paint[left].viscosity, 0, 0.001);
		//}
		//if (paint[i].viscosity > paint[right].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[right]);
			paint[right].viscosity = lerp(paint[right].viscosity, 0, 0.001);
		//}
		/*
		//if (paint[i].viscosity > paint[ul].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[ul]);
			paint[ul].viscosity = lerp(paint[ul].viscosity, 0, 0.001);
		//}
		//if (paint[i].viscosity > paint[dr].viscosity) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[dr]);
			paint[dr].viscosity = lerp(paint[dr].viscosity, 0, 0.001);
		//}
		//if (paint[i].viscosity > paint[ur].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[ur]);
			paint[ur].viscosity = lerp(paint[ur].viscosity, 0, 0.001);
		//}
		//if (paint[i].viscosity > paint[dl].viscosity ) {
			paint[i] = new com.mutiny.Paint(paint[i], paint[dl]);
			paint[dl].viscosity = lerp(paint[dl].viscosity, 0, 0.001);
		//}
		*/
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

	if (random(1) > 0.75) {
		repaint();
	}

	loadPixels();

	for (int i = 0; i < paint.length; i = i + 8) {
		pixels[i] = paint[i].dot.Color();
		pixels[i + 1] = paint[i + 1].dot.Color();
		pixels[i + 2] = paint[i + 2].dot.Color();
		pixels[i + 3] = paint[i + 3].dot.Color();
		pixels[i + 4] = paint[i + 4].dot.Color();
		pixels[i + 5] = paint[i + 5].dot.Color();
		pixels[i + 6] = paint[i + 6].dot.Color();
		pixels[i + 7] = paint[i + 7].dot.Color();
		if (paint[i].dot.r > 1f) {
			println(paint[i].dot.r);
		}
	}

	if (debug) {
		for (int i = 0; i < paint.length; i++) {
			int x = i % width;
			int y = (i - x) / width;
			int up = (y - 1) * width + x;
			int down = (y + 1) * width + x;
			int right = y * width + (x + 1);
			int left = y * width + (x - 1);

			if (x > 1 && x < width - 1 && y > 1 && y < height - 1) {
				if (abs(paint[i].density - paint[up].density) > 0.01 ||
						abs(paint[i].density - paint[down].density) > 0.01 ||
						abs(paint[i].density - paint[left].density) > 0.01 ||
						abs(paint[i].density - paint[right].density) > 0.01 ) {
					pixels[i] = paint[i].dot.darker(0.75).Color();
					pixels[up] = paint[i].dot.lighter(1.5).Color();
				}
			}
		}
	}

	updatePixels();

	strokeWeight(width * frameSize);
	stroke(230);
	noFill();
	rect(0, 0, width, height);

	long t = System.currentTimeMillis();
	//if (t % 2 == 0) {
		tick++;
		save(outputName + "s-" + t + ".jpg");
		if (tick % 30 == 0) {
			println("Frame: " + tick);
		}
	//}
}

