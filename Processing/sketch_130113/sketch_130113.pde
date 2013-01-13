// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Jan 13 2013
// 
import java.util.Calendar;

int width = 1280;
int height = 720;
int tick = 0;
float time = 0;
float deltaTime = 0;
int pSize = 16;
float nScale = 1;

PVector p1 = new PVector(random(width), random(height));
PVector p2 = new PVector(random(width), random(height));

void setup ()
{
	size(width, height);
	time = Calendar.getInstance().get(Calendar.MILLISECOND);
}

void draw ()
{
	tick++;

	translate(-pSize / 2, -pSize / 2);
	nScale = (0.5 + sin(tick * 0.1) * 0.5) * 2;

	deltaTime = Calendar.getInstance().get(Calendar.MILLISECOND) - time;
	if (deltaTime < 0) {
		deltaTime = 0.015;
	}

	p1.lerp(p2, deltaTime);
	p2.lerp(new PVector(random(width), random(height)), deltaTime);

	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			if (x % pSize == 0 && y % pSize == 0) {
				float fx = (float)((float)(x * sin(tick)) / (float)width);
				float fy = (float)((float)(y * cos(tick)) / (float)height);
				// float n = noise(fx * nScale, fy * nScale);
				float n = noise(sin(x + fx), cos(y + fy));
				fill(sin(fx) * 255, cos(fy) * 255, cos(fx * fy) * 255);
				noStroke();
				pushMatrix();
				translate(x + (pSize * 0.5), y + (pSize * 0.5));
				rotate(HALF_PI * n);
				rect(0, 0, pSize, pSize);
				popMatrix();
			}
		}
	}

	time = Calendar.getInstance().get(Calendar.MILLISECOND);

	if (tick % 5 == 0 && random(1) > 0.5) {
		save("data/output/r_" + tick + "_" + time + ".jpg");
	}
}

