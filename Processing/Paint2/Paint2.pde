// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Oct 13 2013
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

Daub d;

void setup ()
{
	size(width, height, P3D);
	d = new Daub(width * 0.5, height * 0.5, 64, 1, 0, 0);
}

void draw ()
{
	if (d != null) {
		loadPixels();
		d.Draw(pixels, width);
		updatePixels();
	}

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

