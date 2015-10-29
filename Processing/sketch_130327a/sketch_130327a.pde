// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Mar 27 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<Zone> zones;

void setup ()
{
	size(width, height);

	zones = new ArrayList<Zone>();
	Zone z = new Zone();
	z.heightMap = new float[width * height];
	z.growthMap = new float[width * height];
	float rSeed = random(1);
	float gSeed = random(1);
	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float n = noise((float)(x + rSeed) / (float)width, (float)(y + rSeed) / (float)height);
		float g = noise(
			((float)(x + gSeed) / (float)width) * 10,
			((float)(y + gSeed) / (float)height) * 10
		);

		z.heightMap[i] = n;
		z.growthMap[i] = (float)((int)(g * 10) / 10.0);
	}
	zones.add(z);

	render();
}

void render ()
{
	for (Zone z : zones) {
		for (int i = 0; i < z.heightMap.length; i++) {
			int x = i % width;
			int y = (i - x) / width;
			float iverse = 1.0 - z.growthMap[i];

			stroke(z.heightMap[i] * 255);
			strokeWeight(1.5);
			point(x, y);
			
			if (z.heightMap[i] < (0.75 + (z.growthMap[i] * 0.25)) &&
				z.growthMap[i] > 0.25) {
				stroke(z.growthMap[i] * 32, z.growthMap[i] * 255, z.growthMap[i] * 32, 128);
				point(x, y);
			} else if (z.heightMap[i] < (0.25 + (iverse * 0.25)) &&
				z.growthMap[i] < 0.25) {
				stroke(iverse * 255, iverse * 255, 32, 128);
				point(x, y);
			}

		}
	}
	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

class Zone {
	float[] heightMap;
	float[] growthMap;

	float evaluateFriction (int i) {
		// determine if nearby cells have threshold difference
		// return 0-1 probability
		for (int r = 0; r < neighbors(i).length; r++) {
		}
	}

}
