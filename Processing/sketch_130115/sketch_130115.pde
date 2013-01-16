// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 15 2013
// 
PImage input;

int tick = 0;
int lineThreshold = 16;

ArrayList<Pixel> pixels = new ArrayList<Pixel>();

void setup ()
{
	input = loadImage("data/input/input.jpg");
	input.loadPixels();
	size(input.width, input.height);

	for (int x = 1; x < input.width - 2; x++) {
		for (int y = 1; y < input.height - 2; y++) {
			pixels.add(new Pixel(x, y, y * width + x, input));
		}
	}

	thread("update");
}

void update () {
	while (true) {
		for (int i = 1; i < pixels.size() - 2; i++) {
			int px = pixels.get(i).x - 1;
			int py = pixels.get(i).y - 1;
			int indice = py * width + px;
			if (indice < pixels.size() - 1) {
				if (pixels.get(i).red < pixels.get(indice).red) {
					pixels.get(i).x = (int)lerp(pixels.get(i).x, pixels.get(indice).x, 0.015);
					pixels.get(i).y = (int)lerp(pixels.get(i).y, pixels.get(indice).y, 0.015);
				}
			}

			px = pixels.get(i).x + 1;
			py = pixels.get(i).y + 1;
			indice = py * width + px;
			if (indice < pixels.size() - 1) {
				if (pixels.get(i).blue < pixels.get(indice).blue) {
					pixels.get(i).x = (int)lerp(pixels.get(i).x, pixels.get(indice).x, 0.015);
					pixels.get(i).y = (int)lerp(pixels.get(i).y, pixels.get(indice).y, 0.015);
				}
			}

			px = pixels.get(i).x - 1;
			py = pixels.get(i).y + 1;
			indice = py * width + px;
			if (indice < pixels.size() - 1) {
				if (pixels.get(i).green < pixels.get(indice).green) {
					pixels.get(i).x = (int)lerp(pixels.get(i).x, pixels.get(indice).x, 0.015);
					pixels.get(i).y = (int)lerp(pixels.get(i).y, pixels.get(indice).y, 0.015);
				}
			}

		}
		try {
			Thread.sleep(1);
		} catch (Exception e) {

		}
	}
}

void draw ()
{
	tick++;

	background(255);

	noStroke();
	rectMode(CENTER);

	int max = pixels.size();
	int modStyle = (int)random(3) + 5;
	for (int i = 0; i < max; i++) {
		fill(pixels.get(i).pixelColor);
		rect(pixels.get(i).x, pixels.get(i).y, 1, 1);
	}

	if (tick % 30 == 0) {
		save("data/output/image-" + System.currentTimeMillis() + ".jpg");
	}
}

int[] neighbors (int x, int y) {
	int[] result = new int[8];
	int dx = 0;
	int dy = 0;
	
	// top left
	dx = x - 1;
	dy = y - 1;
	result[0] = input.pixels[dy * width + dx];
	
	// top
	dx = x;
	dy = y - 1;
	result[1] = input.pixels[dy * width + dx];

	// top right
	dx = x + 1;
	dy = y - 1;
	result[2] = input.pixels[dy * width + dx];

	// right
	dx = x + 1;
	dy = y;
	result[3] = input.pixels[dy * width + dx];

	// bottom right
	dx = x + 1;
	dy = y + 1;
	result[4] = input.pixels[dy * width + dx];

	// bottom
	dx = x;
	dy = y + 1;
	result[5] = input.pixels[dy * width + dx];

	// bottom left
	dx = x - 1;
	dy = y + 1;
	result[6] = input.pixels[dy * width + dx];

	dx = x - 1;
	dy = y;
	result[7] = input.pixels[dy * width + dx];

	return result;
}

class Pixel {
	int x;
	int y;
	int indice;
	color pixelColor;
	float red;
	float green;
	float blue;

	public Pixel (int x, int y, int indice, PImage img) {
		this.x = x;
		this.y = y;
		this.indice = indice;
		this.pixelColor = img.pixels[this.y * img.width + this.x];
		this.red = red(this.pixelColor);
		this.green = green(this.pixelColor);
		this.blue = blue(this.pixelColor);
	}
}
