// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Aug 26 2013
// 

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] foodDots;
Dot[] growthDots;

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

