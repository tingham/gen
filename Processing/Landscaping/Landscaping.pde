// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Mar 09 2014
// 

int width = 1024;
int height = 1024;
int tick = 0;
int rateLimit = 0;
float landmassScale = 0.55;
float targetDensity = 0.4;
int blurAmount = 4;
int variation = 8;
int[] data;
int seedValue;
String outputName = "data/output/";
ArrayList<PVector> riverHits;

void setup ()
{
	size(width, height, P3D);
	riverHits = new ArrayList<PVector>();
	build();
}

void mouseClicked ()
{
	if (mouseButton == LEFT) {
		build();
	} else {
		save(outputName + "s-" + seedValue + "-" + System.currentTimeMillis() + ".jpg");
	}
}

void build ()
{
	loadPixels();
	data = pixels;

	createLandMass ();

	for (int b = 0; b < blurAmount; b++) {
		blurLandMass();
	}

	createMountains();

	for (int b = 0; b < blurAmount * 0.5; b++) {
		blurLandMass();
	}

	createHills();

	for (int b = 0; b < blurAmount * 0.25; b++) {
		blurLandMass();
	}

	PVector c = new PVector(width * 0.5, height * 0.5);
	/*
	float mmax = 0;
	for (int i = 0; i < data.length; i++) {
		if (brightness(data[i]) > mmax) {
			mmax = brightness(data[i]);
			c = new PVector(i % width, (i - (i % width) / width));
		}
	}
	*/
	createRivers(c);
	println("River hits: " + riverHits.size());
	for (PVector p : riverHits) {
		int i = (int)(p.y * width + p.x);
		if (i > -1 && i < data.length) {
			data[i] = color(255, 0, 0);
		}
	}

	/*
	for (int i = 0; i < 10; i++) {
		createRivers(new PVector(random(width * 0.35, width * 0.65), random(height * 0.35, height * 0.65)));
	}
	*/

	for (int i = 0; i < data.length; i++) {
		pixels[i] = data[i];
	}

	updatePixels();
}

void reduce (float f)
{
	for (int i = 0; i < data.length; i++) {
		data[i] = (int)(data[i] * f);
	}
}

void createRivers (PVector sample)
{
	// Rivers are formed by taking a point sample
	// iterating that sample
	// Finding the cardinal neighbors of each cell
	// Finding the cardinal neighbor with the lowest value that
	// hasn't already been traversed
	// Decrementing that neighbor by one value level
	// Then making that neighbor the new centroid.


	int x = (int)sample.x;
	int y = (int)sample.y;
	int up = (y - 1) * width + x;
	int down = (y + 1) * width + x;
	int left = y * width + (x - 1);
	int right = y * width + (x + 1);

	int minCardinal = -1;
	float b = brightness(data[y * width + x]);
	if (x > -1 && x < width - 1 && y > 0 && y < height - 1 && b > 32) {
		float r = random(1);
		if (r > 0.75) {
			println("up");
			minCardinal = up;
		} else if (r > 0.5) {
			println("right");
			minCardinal = right;
		} else if (r > 0.25) {
			println("down");
			minCardinal = down;
		} else {
			println("left");
			minCardinal = left;
		}
		PVector np = new PVector(minCardinal % width, (minCardinal - (minCardinal % width) / width));
		if (inList(riverHits, np) == false) {
			riverHits.add(np);
			createRivers(np);
		} else {
			createRivers(np);
		}
	}

}

boolean inList(ArrayList<PVector> list, PVector val)
{
	for (PVector test : list) {
		return (test.x == val.x && test.y == val.y);
	}
	return false;
}

void createHills ()
{
	// data is a mask basically
	// so we can generate noise in the white area only
	noiseSeed((int)random(10));
	noiseDetail(10, 0.55);
	PVector center = new PVector(
		random(width * 0.25, width * 0.75),
		random(height * 0.25, height * 0.75)
	);

	for (int i = 0; i < data.length; i++) {
		float b = brightness(data[i]);
		int x = i % width;
		int y = (i - x) / width;
		PVector p = new PVector(x, y);
		float f = noise(
			((float)x / (float)width) * 12.5,
			((float)y / (float)height) * 20
		);
		float d = (center.dist(p) / width);

		if (b > 32 && b < 245) {
			f = (f * 255 * (1 - d)) * (b / 255);
			data[i] = color((int)(f + b / 2));
		}
	}
}

void createMountains ()
{
	// data is a mask basically
	// so we can generate noise in the white area only
	noiseSeed((int)random(10));
	noiseDetail(6, 0.8);
	PVector center = new PVector(
		random(width * 0.25, width * 0.75),
		random(height * 0.25, height * 0.75)
	);

	for (int i = 0; i < data.length; i++) {
		// float b = brightness(data[i]);
		int x = i % width;
		int y = (i - x) / width;
		PVector p = new PVector(x, y);
		float f = noise(
			((float)x / (float)width) * 5,
			((float)y / (float)height) * 7.5
		);
		float d = (center.dist(p) / width);
		if (f > 0.5) {
			f = min(1, max(0, f * (1 - d)));
			f = ((f - 0.5) * 2) * 255;
			if (brightness(data[i]) == 128 && f > 128) {
				data[i] = color((int)f);
			}
		}

		// f = min(1.0, max(0.0, f)) * (1.0 - d);
		// data[i] = color((int)(f * b));
	}
}

void blurLandMass ()
{
	for (int i = 0; i < data.length; i++) {
		int x = (i % width);
		int y = (i - x) / width;
		int left = x - 1;
		int right = x + 1;
		int top = y - 1;
		int bottom = y + 1;
		blurIndex(i);
		if (left > -1) {
			blurIndex(y * width + left);
		}
		if (top > -1) {
			blurIndex(top * width + x);
		}
		if (right < width) {
			blurIndex(y * width + right);
		}
		if (bottom < height) {
			blurIndex(bottom * width + x);
		}
	}
}

void blurIndex (int i)
{
	int x = (i % width);
	int y = (i - x) / width;
	int left = x - 1;
	int right = x + 1;
	int top = y - 1;
	int bottom = y + 1;

	IntList samples = new IntList();
	samples.append(y * width + x);

	if (left > -1 && top > -1) {
		samples.append(top * width + left);
	}

	if (top > -1) {
		samples.append(top * width + x);
	}

	if (top > -1 && right < width) {
		samples.append(top * width + right);
	}
	
	if (left > -1) {
		samples.append(y * width + left);
	}

	if (right < width) {
		samples.append(y * width + right);
	}

	if (left > -1 && bottom < height) {
		samples.append(bottom * width + left);
	}

	if (bottom < height) {
		samples.append(bottom * width + x);
	}

	if (bottom < height && right < width) {
		samples.append(bottom * width + right);
	}

	int total = totalSample(samples);
	int average = (int)total / samples.size();

	if (brightness(data[i]) != 128.0) {
		data[i] = color(average);
	}
}


int totalSample (IntList samples)
{
	int total = 0;
	for (int i = 0; i < samples.size(); i++) {
		total += (int)brightness(data[samples.get(i)]);
	}
	return total;
}

void createLandMass ()
{
	int totalDensity = 0;
	rateLimit++;
	PVector center = new PVector(width * 0.5, height * 0.5);

	int[] seeds = new int[] {13, 80,14, 30, 61, 85, 98, 731};
	int seed = (int)random(seeds.length - 1);
	seedValue = seeds[seed];
	println("Seed: " + seedValue);
	noiseSeed(seedValue);
	noiseDetail(30, 0.6);

	for (int i = 0; i < data.length; i++) {
		int x = (i % width);
		int y = ((i - x) / width);
		PVector p = new PVector(x, y);
		float distance = p.dist(center) / width;
		float f = noise((float)x / width, (float)y / height);
		if (f * landmassScale > distance) {
			data[i] = color(128);
			totalDensity++;
		} else{
			data[i] = color(0);
		}
	}

	if ((float)totalDensity / (float)data.length < targetDensity && rateLimit < 5) {
		println("totalDensity " + ((float)totalDensity / (float)data.length));
		createLandMass();
	}
}

void draw ()
{
}

