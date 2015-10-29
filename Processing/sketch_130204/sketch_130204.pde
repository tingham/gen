// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Feb 04 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
	size(width, height);

}

void draw ()
{
	translate(width / 2, height / 2);

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

