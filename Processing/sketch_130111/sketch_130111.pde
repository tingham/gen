// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jan 11 2013
// Draw a series of gradient backgrounds with curve overlays.
// generative curve sphere

int width = 1280;
int height = 720;

PVector root = new PVector(
	random(width * 0.5) + (width * 0.25),
	random(height * 0.5) + (height * 0.25),
	0
);
int sphereDetail = 15;
int sphereSize = (int)(random(25) + 25);

float tick = 0;

void setup ()
{
	size(width, height, P3D);
	smooth();

	sphereDetail(sphereDetail);

}

void draw () {
	render();
}

void render ()
{
	tick++;

	fill(0);
	rect(0, 0, width, height);

	float xSeed = random(128);
	float ySeed = random(128);

	root.lerp(
		new PVector(
			random(width * 0.5) + (width * 0.25),
			random(height * 0.5) + (height * 0.25),
			0
		),
		0.15
	);

	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			stroke(
				xSeed + (sin(x * 0.001) * 128),
				ySeed + (cos(y * 0.001) * 128),
			   	cos((x + y / 2) * 0.001) * 255,
				128
			);
			strokeWeight(1);
			point(x, y);
		}
	}

	fill(128 + random(64));
	noStroke();
	lights();
	pushMatrix();
	translate(root.x, root.y, sphereSize * 0.6);
	sphere(sphereSize);
	popMatrix();

	float startZ = sphereSize * 0.5;
	float infY = random(0.1);

	color mc = color(
		random(54) + 200,
		random(54) + 200,
		random(54) + 200,
		32
	);
	fill(mc);
	noStroke();
	noLights();
	for (int i = 0; i < width * 0.5; i++) {
		pushMatrix();
		translate(root.x + i, (root.y - (sphereSize * 0.85)) - (sin(i * infY) * sphereSize * 0.5), startZ + i);
		sphere((sphereSize * (i * 0.005)) + 0.0001);
		popMatrix();
	}

	mc = color(
		random(54) + 200,
		random(54) + 200,
		random(54) + 200,
		32
	);

	infY = random(0.1);

	fill(mc);
	noStroke();
	noLights();
	for (int i = 0; i < width * 0.5; i++) {
		pushMatrix();
		translate(root.x - i, ((root.y - (sphereSize * 0.5)) + (sphereSize * 0.85)) + (cos(i * infY) * sphereSize * 0.75), startZ + i);
		sphere((sphereSize * (i * 0.005)) + 0.0001);
		popMatrix();
	}

	if (random(1) > 0.75) {
		save("data/output/generative-" + tick + ".jpg");
	}
}

