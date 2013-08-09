// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jul 29 2013
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int sqsize = 2;
int matte = 32;
int updateFrequency = 29;
float lerpDelta = 0.1;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
// String inputName = "data/input/tumblr_mghg36SoL71r06hkoo2_1280.jpg";
// String inputName = "data/input/6625823165_a44be8a7e9_o.jpg";
// Robert
// String inputName = "data/input/6625823165_8aea2ccc21_b.jpg";
String inputName = "data/input/8328112884_e4179bc175_b.jpg";


Chunk[] chunks;

void setup ()
{
	PImage img = loadImage(inputName);
	img.loadPixels();

	size(img.width, img.height, P3D);
	width = img.width;
	height = img.height;

	chunks = new Chunk[img.pixels.length / (sqsize * sqsize)];

	println(chunks.length);

	int index = 0;

	for (int i = 0; i < img.pixels.length && index < chunks.length; i++) {
		int x = i % img.width;
		int y = (i - x) / img.width;

		if (x % sqsize == 0 && y % sqsize == 0) {
			ArrayList<Dot> chunkDots = new ArrayList<Dot>();

			for (int m = 0; m < sqsize * sqsize; m++) {
				int ox = m % sqsize;
				int oy = (m - ox) / sqsize;

				int pixel = (oy + y) * img.width + (ox + x);

				if (pixel < img.pixels.length) {
					float r = red(img.pixels[pixel]) / 255;
					float g = green(img.pixels[pixel]) / 255;
					float b = blue(img.pixels[pixel]) / 255;
					float a = alpha(img.pixels[pixel]) / 255;
					Dot d = new Dot(r, g, b, a);
					chunkDots.add(d);
				}
			}

			Chunk chunk = new Chunk(chunkDots, sqsize);
			chunk.x = x;
			chunk.y = y;

			Dot median = chunk.median();
			Dot average = chunk.average();

			chunks[index] = chunk;
			index++;
		}
	}

	thread("update");
}

void update ()
{
	while (true) {
		try {
			tick++;
			medianAverageEvalSwap();
			Thread.sleep(updateFrequency);
		} catch(Exception e) {
			println(e);
		}
	}
}

void subSwirl ()
{
	for (int i = 0; i < chunks.length; i++) {
		for (int d = 0; d < chunks[i].dots.length; d++) {
			int x = d % sqsize;
			int y = (d - x) / sqsize;

			int up = (y - 1) * sqsize + x;
			int left = y * sqsize + (x - 1);
			int down = (y + 1) * sqsize + x;
			int right = y * sqsize + (x + 1);

			if (up > 0 && left > 0 && down < chunks[i].dots.length && right < chunks[i].dots.length) {

				if (chunks[i].dots[d].r > chunks[i].dots[up].r &&
						chunks[i].dots[down].r > chunks[i].dots[up].g &&
						chunks[i].dots[left].r > chunks[i].dots[right].b) {
					Dot d0 = chunks[i].dots[d];
					chunks[i].dots[d] = chunks[i].dots[up];
					chunks[i].dots[up] = d0;
				}

				if (chunks[i].dots[d].g > chunks[i].dots[right].g &&
						chunks[i].dots[left].g > chunks[i].dots[right].b &&
						chunks[i].dots[up].g > chunks[i].dots[down].r) {
					Dot d0 = chunks[i].dots[d];
					chunks[i].dots[d] = chunks[i].dots[right];
					chunks[i].dots[right] = d0;
				}

				if (chunks[i].dots[d].b > chunks[i].dots[left].b &&
						chunks[i].dots[right].b > chunks[i].dots[left].r &&
						chunks[i].dots[down].b > chunks[i].dots[right].g) {
					Dot d0 = chunks[i].dots[d];
					chunks[i].dots[d] = chunks[i].dots[left];
					chunks[i].dots[left] = d0;
				}

			}
		}
	}
}
void medianAverageEvalChannelSwap ()
{
	for (int i = 0; i < chunks.length - 1; i++) {

		int local = (width / sqsize);

		int x = (i % local);
		int y = ((i - x) / local);

		int up = (y - 1) * local + x;
		int down = (y + 1) * local + x;
		int left = y * local + (x - 1);
		int right = y * local + (x + 1);

		if (up > 0 && down < chunks.length - 1 && left > 0 && right < chunks.length - 1) {

			Dot avg = chunks[i].average();
			Dot med = chunks[i].median();

			boolean swapType = false;

			if (avg.Sum() == 0 || 
					chunks[up].average().Sum() == 0 || 
					chunks[right].average().Sum() == 0 || 
					chunks[left].average().Sum() == 0 || 
					chunks[down].average().Sum() == 0) {
				continue;
			}

			if (chunks[i].average().r > chunks[i].average().g && chunks[i].average().g < chunks[left].average().b) {
				swapChannels(i, left, "r");
			} else {
				swapChannels(left, i, "r");
			}

			if (chunks[i].average().g > chunks[i].average().b && chunks[i].average().b < chunks[right].average().r) {
				swapChannels(i, right, "g");
			} else {
				swapChannels(right, i, "g");
			}

			/*

			if (chunks[i].average().b > chunks[i].average().r && chunks[i].average().r < chunks[down].average().g) {
				swapChannels(i, down, "b");
			} else {
				swapChannels(i, up, "b");
			}
			*/

		}

	}
}

void medianAverageEvalSwap ()
{
	for (int i = 0; i < chunks.length - 1; i++) {

		int local = (width / sqsize);

		int x = (i % local);
		int y = ((i - x) / local);

		int up = (y - 1) * local + x;
		int down = (y + 1) * local + x;
		int left = y * local + (x - 1);
		int right = y * local + (x + 1);
		int ur = (y - 1) * local + (x + 1);
		int dl = (y + 1) * local + (x - 1);

		if (up > 0 && down < chunks.length - 1 && left > 0 && right < chunks.length - 1 && ur > 0 && ur < chunks.length && dl > 0 && dl < chunks.length) {

			Dot avg = chunks[i].average();
			Dot med = chunks[i].median();

			boolean swapType = false;

			if (avg.Sum() > 0.5) {
				swapType = true;
			}

			// if left and right have more in common than me and right, bring them closer together.
			// left + right
			if (abs(chunks[left].average().r - chunks[right].average().r) < abs(chunks[i].average().r - chunks[right].average().r)) {
				swapChunks(left, i);
			}

			if (abs(chunks[up].average().g - chunks[down].average().g) < abs(chunks[i].average().g - chunks[down].average().g)) {
				swapChunks(up, i);
			}

			if (abs(chunks[right].average().b - chunks[left].average().b) < abs(chunks[i].average().b - chunks[left].average().b)) {
				swapChunks(right, i);
			}

			if (abs(chunks[down].average().Sum() - chunks[up].average().Sum()) < abs(chunks[i].average().Sum() - chunks[up].average().Sum())) {
				swapChunks(down, i);
			}

			if (abs(chunks[ur].average().Sum() - chunks[dl].average().Sum()) < abs(chunks[i].average().Sum() - chunks[dl].average().Sum())) {
				swapChunks(ur, i);
			}

			/*
			if (avg.r > chunks[right].median().r && (avg.r < med.r || avg.g > med.r)) {
				swapChunks(swapType ? i : right, left);
			}

			if (avg.g > chunks[down].median().g && (avg.g < med.g || avg.b > med.g)) {
				swapChunks(swapType ? i : down, up);
			}

			if (avg.b > chunks[left].median().b && (avg.b > med.b || avg.r < med.g)) {
				swapChunks(swapType ? i : left, right);
			}

			Dot upMed = chunks[up].median();
			if (avg.Sum() > upMed.Sum()) {
				swapChunks(swapType ? i : down, up);
			} else {
				if (chunks[i].average().r > chunks[i].average().g || chunks[i].average().g < chunks[i].average().b) {
					swapChunks(i, left);
				}
			}
			if (chunks[i].average().g > chunks[i].average().b || chunks[i].average().b < chunks[i].average().r) {
				swapChunks(i, right);
			}
			if (chunks[i].average().b > chunks[i].average().r || chunks[i].average().r < chunks[i].average().g) {
				swapChunks(i, down);
			}
			*/

		}

	}
}

void swapChannels (int a, int b, String channel) {
	if (a > 0 && a < chunks.length && b > 0 && b < chunks.length) {
		Chunk chunka = chunks[a];
		Chunk chunkb = chunks[b];
		for (int i = 0; i < ((chunka.dots.length > chunkb.dots.length) ? chunkb.dots.length : chunka.dots.length); i++) {
			if (channel == "r") {
				chunks[b].dots[i].r = chunka.dots[i].r;
				chunks[a].dots[i].r = chunkb.dots[i].r;
			} else if (channel == "g") {
				chunks[b].dots[i].g = chunka.dots[i].g;
				chunks[a].dots[i].g = chunkb.dots[i].g;
			} else if (channel == "b") {
				chunks[b].dots[i].b = chunka.dots[i].b;
				chunks[a].dots[i].b = chunkb.dots[i].b;
			}
		}
		chunks[a].clearCache();
		chunks[b].clearCache();
	}
}

void swapChunks (int a, int b) {
	if (a > 0 && a < chunks.length && b > 0 && b < chunks.length) {
		Chunk chunka = chunks[a];
		Chunk chunkb = chunks[b];
		chunks[b] = chunka;
		chunks[a] = chunkb;
	}
}

void draw ()
{
	background(32);

	loadPixels();

	if (width == 0 || height == 0) {
		return;
	}

	// width of chunks is to chunks length as width of image is to pixels length
	int local = (width / sqsize);
	for (int c = 0; c < chunks.length; c++) {

		int x = (c % local);
		int y = ((c - x) / local);

		x = x * sqsize;
		y = y * sqsize;

		int[] cpixels = chunks[c].pixels();

		for (int i = 0; i < sqsize * sqsize; i++) {
			int cx = i % sqsize;
			int cy = (i - cx) / sqsize;
			int cindex = ((y + cy) * width + (x + cx));
			if (i < cpixels.length) {
				/*
				// Copy average value into pixel quadrant
				*/
				// pixels[cindex] = chunks[c].average().Color(); // cpixels[i];
				copyAverages(c, cx, cy, cindex);
				// pixels[cindex] = cpixels[i];
			}
		}

	}

	updatePixels();

	fill(240);
	noStroke();
	rect(0, 0, width, (matte));
	rect(0, 0, (matte), height);
	rect(width - (matte), 0, (matte), height);
	rect(0, height - (matte), width, (matte));

	long t = System.currentTimeMillis();
	if (t % 10 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

void copyAverages (int c, int cx, int cy, int cindex)
{
	float aTx = ((((float)cx / (float)sqsize) + ((float)cy / (float)sqsize)) * 0.5) * 0.5;
	if (c < chunks.length - 1) {
		Dot a = chunks[c].average();
		if (a != null) {
			Dot d = chunks[c].average().darker(aTx);
			if (cindex < pixels.length - 1) {
				pixels[cindex] = d.Color();
			}
		}
	}
}

