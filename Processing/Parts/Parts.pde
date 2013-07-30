// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jul 29 2013
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int sqsize = 2;
float lerpDelta = 0.1;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
// String inputName = "data/input/tumblr_mghg36SoL71r06hkoo2_1280.jpg";
// String inputName = "data/input/6625823165_a44be8a7e9_o.jpg";
String inputName = "data/input/6625823165_8aea2ccc21_b.jpg";


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
			Dot[] chunkDots = new Dot[sqsize * sqsize];

			for (int m = 0; m < sqsize * sqsize; m++) {
				int ox = m % sqsize;
				int oy = (m - ox) / sqsize;

				int pixel = (oy + y) * img.width + (ox + x);

				if (pixel > 0 && pixel < img.pixels.length - 1) {
					float r = red(img.pixels[pixel]) / 255;
					float g = green(img.pixels[pixel]) / 255;
					float b = blue(img.pixels[pixel]) / 255;
					float a = alpha(img.pixels[pixel]) / 255;
					Dot d = new Dot(r, g, b, a);
					chunkDots[m] = d;
				}
			}

			Chunk chunk = new Chunk(chunkDots, sqsize);
			chunk.x = x;
			chunk.y = y;
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
			for (int i = 0; i < chunks.length - 1; i++) {

				int local = (width / sqsize) + 1;

				int x = (i % local);
				int y = ((i - x) / local);

				int up = (y - 1) * local + x;
				int down = (y + 1) * local + x;
				int left = y * local + (x - 1);
				int right = y * local + (x + 1);

				if (up > 0 && down < chunks.length && left > 0 && right < chunks.length) {
					Dot avg = chunks[i].average();
					boolean swapType = false;

					if (avg.Sum() == 0 || 
							chunks[up].average().Sum() == 0 || 
							chunks[right].average().Sum() == 0 || 
							chunks[left].average().Sum() == 0 || 
							chunks[down].average().Sum() == 0) {
						continue;
					}

					if (avg.Sum() > 0.5) {
						swapType = true;
					}

					if (avg.Sum() > chunks[up].average().Sum()) {
						swapChunks(i, up);
					}

					if (avg.r > chunks[right].average().r) {
						swapChunks(swapType ? i : right, left);
					} else if (avg.r > chunks[right].average().g) {
						swapChunks(swapType ? left : i, right);
					}

					if (avg.g > chunks[down].average().g) {
						swapChunks(swapType ? i : down, up);
					} else if (avg.g > chunks[right].average().b) {
						swapChunks(swapType ? up : i, down);
					}

					if (avg.b > chunks[left].average().b) {
						swapChunks(swapType ? i : left, right);
					} else if (avg.b > chunks[right].average().r) {
						swapChunks(swapType ? right : i, left);
					}

				}

			}
			Thread.sleep(10);
		} catch(Exception e) {
			println(e);
		}
	}
}

void swapChunks (int a, int b) {
	Chunk chunka = chunks[a];
	Chunk chunkb = chunks[b];
	chunks[b] = chunka;
	chunks[a] = chunkb;
}

void draw ()
{
	background(32);

	loadPixels();

	if (width == 0 || height == 0) {
		return;
	}

	// width of chunks is to chunks length as width of image is to pixels length
	int local = (width / sqsize) + 1;
	for (int c = 0; c < chunks.length; c++) {

		int x = (c % local);
		int y = ((c - x) / local);

		x = x * sqsize;
		y = y * sqsize;

		int[] cpixels = chunks[c].pixels();

		for (int i = 0; i < sqsize * sqsize; i++) {
			int cx = i % sqsize;
			int cy = (i - cx) / sqsize;
			pixels[((y + cy) * width + (x + cx))] = cpixels[i];
		}

		// image(img, chunks[i].x, chunks[i].y);
	}

	updatePixels();

	long t = System.currentTimeMillis();
	if (t % 10 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

