// # Tiles
// **Created By:** + tingham
// **Created On:** + Mon Jan 16 2017
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
	size(1024, 768, P3D);
}

void draw ()
{
	background(32);

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

