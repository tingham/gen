// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Aug 03 2013
// 
import com.mutiny.*;

int width = 1024;
int height = 1024;
int tick = 0;
int sqsize = 64;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Chunk[] chunks;

void setup ()
{
	size(width, height, P3D);
	build();
	// thread("update");
}

void update ()
{
	while (true) {
		try {
			build();
			render();
			Thread.sleep(120);
		} catch (Exception e) {
		}
	}
}

void build ()
{
	tick++;

	loadPixels();
	float n3 = random(1);
	float n4 = random(1);

	noiseSeed(tick);
	noiseDetail(20, 0.5);

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float n1 = noise((float)((float)x / width) * (5.0 * n3), (float)((float)y / height) * (5.0 * n3));
		float n2 = noise((float)((float)x / width) * (5.0 * n4), (float)((float)y / height) * (5.0 * n4));

		Dot d = new Dot(n1, n2, n3, 1, 1);
		pixels[i] = d.Color();
	}
	updatePixels();

	chunks = Chunk.process(pixels, width, sqsize);
}

void draw ()
{
	build();

	loadPixels();
	int local = (width / sqsize);
	for (int c = 0; c < chunks.length; c++) {

		if (chunks[c] == null) {
			println("Bomb " + c);
			continue;
		}

		int x = (c % local);
		int y = ((c - x) / local);

		x = x * sqsize;
		y = y * sqsize;

		int[] cpixels = chunks[c].pixels();

		for (int i = 0; i < sqsize * sqsize; i++) {
			int cx = i % sqsize;
			int cy = (i - cx) / sqsize;

			float fx = ((float)cx / sqsize) * 2;
			float fy = ((float)cy / sqsize) * 2;

			float ef = (abs(0.5 - fx) + abs(0.5 - fy)) / 2;

			int cindex = ((y + cy) * width + (x + cx));
			if (i < cpixels.length) {
				if (random(1) < ef) {
					pixels[cindex] = chunks[c].dots[i].Color();
				} else {
					pixels[cindex] = chunks[c].median().Color();
				}
				/*
				if (random(1) > 0.7) {
					pixels[cindex] = chunks[c].median().saturate(ef * 0.1).darker(ef * 0.1).Color();
				} else if (random(1) > 0.3) {
					pixels[cindex] = chunks[c].average().Color();
				} else {
					pixels[cindex] = chunks[c].dots[i].saturate(ef).darker(ef * 0.25).Color();
				}
				*/
			}
		}
	}
	updatePixels();

	noFill();
	stroke(220);
	strokeWeight(sqsize * 2);
	rect(0, 0, width, height);

	long t = System.currentTimeMillis();
	// if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	// }
}

