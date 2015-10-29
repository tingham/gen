// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Apr 04 2013
// 

int width = 1024;
int height = 1024;
int chipsize = 32;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
int[] data;
Chip[] chips;

void setup ()
{
	size(width, height);
	data = new int[width * height];
	chips = new Chip[width * height / chipsize];

	for (int i = 0; i < width * height; i++) {
		float x = i % width;
		float y = (i - x) / width;
		float n = noise(x / (float)width, y / (float)height);
		data[i] = color(n * 255);
	}

	int index = 0;
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			if (y % chipsize == 0 && x % chipsize == 0) {
				Chip c = new Chip((float)x, (float)y, (float)chipsize, (float)chipsize, data, width, height);
				chips[index] = c;
				index++;
			}
		}
	}
}

void draw ()
{
	for (int c = 0; c < chips.length; c++) {
		if (chips[c] != null) {
			int x = (c * chipsize) % (width);
			int y = ((c * chipsize) - x) / (width);
			chips[c].renderAt(x, y);
		}
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0 && mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

class Chip {
	float x;
	float y;
	float w;
	float h;
	int[] pixels;

	public Chip (
		float _x, float _y,
		float _w, float _h,
		int[] _pixels, int _width, int _height) {
		this.x = _x;
		this.y = _y;
		this.w = _w;
		this.h = _h;

		if (_pixels.length > _w * _h) {
			int index = 0;
			this.pixels = new int[(int)(this.w * this.h)];
			for (int ix = (int)this.x; ix < (int)(this.w + this.x); ix++) {
				for (int iy = (int)this.y; iy < (int)(this.h + this.y); iy++) {
					int pindex = iy * _width + ix;
					this.pixels[index] = _pixels[pindex];
					index++;
				}
			}
		} else {
			this.pixels = _pixels;
		}
	}

	public void renderAt (int x, int y) {
		for (int i = 0; i < this.w * this.h; i++) {
			float ix = i % this.w;
			float iy = (i - ix) / this.w;
			fill(this.pixels[i]);
			rect(x + ix, y + iy, 1, 1);
		}
	}
}
