// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Feb 12 2013
// 

int width = 1024;
int height = 1024;
int tick = 0;
int margin = -1;

ArrayList<Tile> images = new ArrayList<Tile>();
String inputPath = "/Users/tingham/Documents/Schnoz-Project/schnoz-prep/";
String outputName = "data/output/" + System.currentTimeMillis() + "/";

void setup ()
{
	size(width, height);
	loadImages(new java.io.File(inputPath));
	thread("update");
}

void loadImages (java.io.File selection) {
	for (java.io.File s : selection.listFiles()) {
		if (s.getAbsolutePath().indexOf(".jpg") > -1) {
			images.add(new Tile(s.getAbsolutePath(), random(width), random(height)));
		}
	}
}

void update () {
	while (true) {
		for (Tile t : images) {
			/*
			ArrayList<Tile> nearby = new ArrayList<Tile>();
			for (Tile ti : images) {
				if (t.distanceTo(ti) < 512) {
					nearby.add(ti);
				}
			}
			*/
			t.update(images);
		}
		try {
			Thread.sleep(10);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	background(64);

	for (Tile t : images) {
		image(t.img, t.x, t.y);
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		// save(outputName + "s-" + t + ".jpg");
	}
}

class Tile {
	PImage img;
	float x;
	float y;
	float w;
	float h;

	public Tile (String imgpath, float x, float y) {
		this.img = loadImage(imgpath);
		this.img.loadPixels();
		this.x = x;
		this.y = y;
		this.w = this.img.width;
		this.h = this.img.height;
	}

	public PVector collides (Tile t) {
		PVector result = new PVector(0, 0);
		float f = 1 - ((this.w * this.h) / (width * height));
		float o = ((this.w + this.h) / 2) * 0.125;
		float b = random(5);
		if (t.pointInRect(this.topLeft())) {
			result.x += b + (o * f);
			result.y += b + (o * f);
		}
		if (t.pointInRect(this.topRight())) {
			result.x -= b + (o * f);
			result.y += b + (o * f);
		}
		if (t.pointInRect(this.bottomLeft())) {
			result.x += b + (o * f);
			result.y -= b + (o * f);
		}
		if (t.pointInRect(this.bottomRight())) {
			result.x -= b + (o * f);
			result.y -= b + (o * f);
		}

		if (t.pointInRect(this.center())) {
			result.x += random(-2, 2);
			result.y += random(-2, 2);
		}

		if (this.x <= 0) {
			this.x += 1;
		}
		if (this.x + this.w >= width) {
			this.x -= 1;
		}
		if (this.y <= 0) {
			this.y += 1;
		}
		if (this.y + this.h >= height) {
			this.y -= 1;
		}

		return result;
	}

	public void update (ArrayList<Tile> nearby) {
		for (Tile t : nearby) {
			PVector col = this.collides(t);
			if (abs(col.x) > 0 || abs(col.y) > 0) {
				this.x += col.x; //lerp(this.x, this.x + col.x, 0.1);
				this.y += col.y; //lerp(this.y, this.y + col.y, 0.1);
			}
		}
	}

	public float distanceTo (Tile t) {
		PVector a = this.center();
		PVector b = t.center();
		return abs(a.dist(b));
	}

	public PVector topLeft () {
		return new PVector(this.x, this.y);
	}
	public PVector topRight () {
		return new PVector(this.x + this.w, this.y);
	}
	public PVector bottomLeft () {
		return new PVector(this.x, this.y + this.h);
	}
	public PVector bottomRight () {
		return new PVector(this.x + this.w, this.y + this.h);
	}

	public PVector center () {
		return new PVector(this.x + (this.w / 2), this.y + (this.h / 2));
	}

	public boolean pointInRect (PVector point) {
		return (point.x + margin >= this.x && point.x - margin <= this.x + this.w &&
				point.y + margin >= this.y && point.y - margin <= this.y + this.h);
	}
}
