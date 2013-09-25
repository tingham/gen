// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Sep 08 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
	size(width, height, P3D);
}

void draw ()
{
	tick++;
	background(32);
	stroke(180);
	strokeWeight(2);

	curve(new PVector(width * 0.5, height * 0.5), width * 0.5, 0.01);

	long t = System.currentTimeMillis();
	save(outputName + "s-" + t + ".jpg");
}

void curve (PVector center, float radius, float rate)
{

	if (radius < 10) {
		return;
	}

	float sp = rate;

	int count = (int)(radius * radius);

	float _x = center.x;
	float _y = center.y;
	PVector f = new PVector(_x, _y);

	for (int i = -count; i <= count; i++) {

		float x = sin(i * 0.1) * sp;
		float y = cos(i * 0.1) * sp;

		sp = lerp(sp, radius, 0.01);

		line(
			_x,
			_y,
			center.x + x,
			center.y + y
		);

		_x = center.x + x;
		_y = center.y + y;
	
		if ((int)x % 32 == 0 && (int)y % 32 == 0) {
			f = new PVector(_x, _y);
		}

	}

	//curve(f, radius / 2, rate * 0.25);


}
