// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 16 2017
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
}

void draw ()
{
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

