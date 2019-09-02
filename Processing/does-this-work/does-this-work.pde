// # does-this-work
// **Created By:** + tingham
// **Created On:** + Sun Sep 01 2019
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
  size(512, 512);
}

void draw ()
{
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		// save(outputName + "s-" + t + ".jpg");
	}
}

