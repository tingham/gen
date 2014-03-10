// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Mar 09 2014
// 

int width = 512;
int height = 512;
int tick = 0;
int rateLimit = 0;
float landmassScale = 0.55;
float targetDensity = 0.4;
int blurAmount = 256;
int variation = 8;
int[] data;
int seedValue;
String outputName = "data/output/";

void setup ()
{
	size(width, height, P3D);
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

	// createMountains();

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

void createMountains ()
{
	// data is a mask basically
	// so we can generate noise in the white area only
	noiseSeed((int)random(10));
	noiseDetail(30, 0.7);
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
			((float)x / (float)width) * 2,
			((float)y / (float)height) * 3.5
		);
		float d = (center.dist(p) / width);
		// TODO: Calculate distance to pinnacle center here and
		// multiply value.
		f = min(1.0, max(0.0, f)) * (1.0 - d);
		data[i] = color((int)(f * b));
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

	if (brightness(data[i]) != 255.0) {
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
			data[i] = color(255);
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

