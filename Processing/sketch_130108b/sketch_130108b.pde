// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 08 2013
// 

ArrayList<PVector> points = new ArrayList<PVector>();

int width = 1280;
int height = 720;

int mapx = 100;
int mapy = 100;
int mapz = 100;

int tick = 0;

void setup ()
{
	size(width, height, P3D);

	int count = mapx * mapz;

	for (int x = 0; x < mapx; x++) {
		for (int y = 0; y < mapy; y++) {

			points.add(
				new PVector(
					((float)x / (float)mapx) - 0.5,
					((sin(x * 0.1) + cos(y * 0.1))),
					((float)y / (float)mapy) - 0.5
				)
			);

		}
	}

	fill(0);
	noStroke();
	rect(0, 0, width, height);

	sphereDetail(8);
}

void draw ()
{
	tick++;
	translate(width / 2, height / 2);
	rotate(TWO_PI * -0.125, 0, 0, 0);
	rotate(tick * 0.01, 0, 1, 0);
	background(0, 1);

	translate(0, 5, 0);
	lights();
	translate(0, -5, 0);

	float s1 = sin(tick * 0.1);
	float c1 = 0.5 + cos(tick * 0.1) * 0.5;

	int indice =  0;
	for (int x = 0; x < mapx; x++) {
		for (int y = 0; y < mapy; y++) {
			float fx = (float)x;
			float fy = (float)y;

			PVector p = points.get(indice);
			pushMatrix();
			// translate(p.x * width, p.y * mapy * (sin(tick * 0.1) + cos(tick * 0.1)), p.z * height);
			translate(p.x * width, p.y * mapy, p.z * height);
			// translate(p.x * width, noise(x * sin(fx) * s1, y * cos(fy) * s1) * (mapy * 2) * s1, p.z * height);
			float no = noise(sin(indice), cos(tick * 0.01) * p.y * mapy, sin(y));
			fill(225);
			sphere(no * 6);
			popMatrix();
			indice++;
		}
	}

	int t = (int)random(255) + 128;
	if (tick % t == 0) {
		save("data/output/" + tick + "-" + t + ".jpg");
	}
}

