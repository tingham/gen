// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Jan 12 2013
// 
import java.util.Calendar;

int width = 1280;
int height = 720;
int tick = 0;
float time = 0;
float deltaTime = 0;
int pSize = 8;

void setup ()
{
	size(width, height, P2D);
	fill(0);
	rect(0, 0, width, height);
	time = Calendar.getInstance().get(Calendar.MILLISECOND);
}

void draw ()
{
	tick++;

	translate(width / 2, height / 2);
	rotate(tick * 0.01);

	deltaTime = Calendar.getInstance().get(Calendar.MILLISECOND) - time;
	if (deltaTime < 0) {
		deltaTime = 0.015;
	}

	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			if (x % pSize == 0 && y % pSize == 0) {

				float d1 = 0.5 + sin(x + y + deltaTime) * 0.5;
				float t1 = 0.5 + sin(tick) * 0.5;
				float s1 = 0.5 + sin(x * y * d1) * 0.5;

				fill(s1 * 255, d1 * 64, t1 * 32, s1 * 32);
				noStroke();
				pushMatrix();
				translate(width / 2 - x,height / 2 - y);
				rect(0, 0, pSize, pSize);
				popMatrix();
			}
		}
	}

	time = Calendar.getInstance().get(Calendar.MILLISECOND);

	if (tick % 10 == 0 && random(1) > 0.9) {
		save("data/output/r_" + time + ".jpg");
	}
}

