PImage input;
ArrayList redpoints = new ArrayList();
ArrayList greenpoints = new ArrayList();
ArrayList bluepoints = new ArrayList();
int greenComponent = (int)random(128);
int redComponent = (int)random(128);
int blueComponent = (int)random(128);
int lineAlpha = 32;
int maxPoints = 1024;
float redCount = 0;
float greenCount = 0;
float blueCount = 0;
float minDistance = 0.25;
float minOffset = -32;
float maxOffset = 32;
int tick = 0;

class P {
	float x;
	float y;

	public P (float _x, float _y) {
		this.x = _x;
		this.y = _y;
	}

	public float Distance (P b) {
		return sqrt(
			((b.x - this.x) * (b.x - this.x)) + ((b.y - this.y) * (b.y - this.y))
		);
	}
}

void setup () {
	input = loadImage("input-2.jpg");
	input.loadPixels();
	size(input.width, input.height);
	// image(input, 0, 0);
	fill(255);
	rect(0, 0, input.width, input.height);

	maxPoints = (int)(input.width * input.height * 0.25);

	filter(input.pixels, (int)random(255), 0);
	filter(input.pixels, (int)random(255), 1);
	filter(input.pixels, (int)random(255), 2);

	minOffset = input.width * -0.25;
	maxOffset = input.width * 0.25;
}

void draw () {
	tick++;
	int redt = (int)random(32),
		greent = (int)random(32),
		bluet = (int)random(32);

	P redb = (P)redpoints.get((int)random(redpoints.size()));
	P reda = (P)redpoints.get((int)random(redpoints.size()));
	if (redt > 0 && abs(reda.Distance(redb)) > input.width * minDistance) {
		redt--;
		drawImagePixels(reda);
		drawImagePixels(redb);
		stroke(redComponent, 0, 0, lineAlpha);
		noFill();
		curveTightness(0.0);
		beginShape();
		curveVertex(reda.x, reda.y);
		curveVertex(reda.x, reda.y);
		curveVertex(random(reda.x) + random(minOffset, maxOffset), random(reda.y) + random(minOffset, maxOffset));
		curveVertex(random(redb.x) + random(minOffset, maxOffset), random(redb.y) + random(minOffset, maxOffset));
		curveVertex(redb.x, redb.y);
		curveVertex(redb.x, redb.y);
		endShape();
		noStroke();
		fill(redComponent + 255 / 2, 0, 0, lineAlpha * 0.125);
		ellipse(redb.x, redb.y, random(256), random(256));
		redCount += random(-0.5, 1);
	}

	P greena = (P)greenpoints.get((int)random(greenpoints.size()));
	P greenb = (P)greenpoints.get((int)random(greenpoints.size()));
	if (greent > 0 && abs(greena.Distance(greenb)) > input.width * minDistance) {
		greent--;
		drawImagePixels(greena);
		drawImagePixels(greenb);
		stroke(0, greenComponent, 0, lineAlpha);
		noFill();
		curveTightness(0.0);
		beginShape();
		curveVertex(greena.x, greena.y);
		curveVertex(greena.x, greena.y);
		curveVertex(random(greena.x) + random(minOffset, maxOffset), random(greena.y) + random(minOffset, maxOffset));
		curveVertex(random(greenb.x) + random(minOffset, maxOffset), random(greenb.y) + random(minOffset, maxOffset));
		curveVertex(greenb.x, greenb.y);
		curveVertex(greenb.x, greenb.y);
		endShape();
		noStroke();
		fill(0, greenComponent + 255 / 2, 0, lineAlpha * 0.125);
		ellipse(greenb.x, greenb.y, random(256), random(256));
		greenCount += random(-0.5, 1);
	}

	P bluea = (P)bluepoints.get((int)random(bluepoints.size()));
	P blueb = (P)bluepoints.get((int)random(bluepoints.size()));
	if (bluet > 0 && abs(bluea.Distance(blueb)) > input.width * minDistance) {
		bluet--;
		drawImagePixels(bluea);
		drawImagePixels(blueb);
		stroke(0, 0, blueComponent, lineAlpha);
		noFill();
		curveTightness(0.0);
		beginShape();
		curveVertex(bluea.x, bluea.y);
		curveVertex(bluea.x, bluea.y);
		curveVertex(random(bluea.x) + random(minOffset, maxOffset), random(bluea.y) + random(minOffset, maxOffset));
		curveVertex(random(blueb.x) + random(minOffset, maxOffset), random(blueb.y) + random(minOffset, maxOffset));
		curveVertex(blueb.x, blueb.y);
		curveVertex(blueb.x, blueb.y);
		endShape();
		noStroke();
		fill(0, 0, blueComponent + 255 / 2, lineAlpha * 0.125);
		ellipse(blueb.x, blueb.y, random(256), random(256));
		blueCount += random(-0.5, 1);
	}

	drawImagePixels(new P(random(input.width), random(input.height)));
	drawImagePixels(new P(random(input.width), random(input.height)));
	drawImagePixels(new P(random(input.width), random(input.height)));

	if (tick % 30 == 0 && tick < 30 * 300) {
		String t = "0" + tick;
		while(t.length() < 10) {
			t = "0" + t;
		}
		save("data/output/color-luminance-correlations-" + t + ".tif");
	}
}

void drawImagePixels (P p) {
	int index = (int)(p.y * input.width + p.x);
	index = min(max(index, 0), input.pixels.length - 1);
	int radius = (int)(brightness(input.pixels[index]));
	int check = (int)random(3) + 2;
	if (p.x > radius + 1 && p.x < input.width - (radius + 2) &&
			p.y > radius + 1 && p.y < input.height - (radius + 2)) {
		pushMatrix();
		translate(p.x, p.y);
		rotate(random(-0.02, 0.02));
		for (int x = 0; x < radius; x++) {
			for (int y = 0; y < radius; y++) {
				if (y % check == 0 && x % check == 0) {
					color mc = input.pixels[(int)((p.y + y) * input.width + (p.x + x))];
					stroke(
						red(mc),
						green(mc),
						blue(mc),
						128
					);
					point(x, y);
				}
			}
		}
		popMatrix();
	}
}

void filter (color[] pix, int search, int component) {
	for (int x = 0; x < input.width; x++) {
		for (int y = 0; y < input.height; y++) {
			if (y * input.width + x > 2 && y * input.width + x < pix.length - 2) {
				int avg = 0;
				switch (component) {
					case 0:
						avg = (int)((red(pix[y * input.width + x]) + red(pix[y * input.width + x - 1]) + red(pix[y * input.width + x]) + 1) / 3);
						break;
					case 1:
						avg = (int)((green(pix[y * input.width + x]) + green(pix[y * input.width + x - 1]) + green(pix[y * input.width + x]) + 1) / 3);
						break;
					case 2:
						avg = (int)((blue(pix[y * input.width + x]) + blue(pix[y * input.width + x - 1]) + blue(pix[y * input.width + x]) + 1) / 3);
						break;
				}
				if (avg == search) {
					switch (component) {
						case 0:
							redpoints.add(new P(x, y));
							if (redpoints.size() > maxPoints) {
								return;
							}
							break;
						case 1:
							greenpoints.add(new P(x, y));
							if (greenpoints.size() > maxPoints) {
								return;
							}
							break;
						case 2:
							bluepoints.add(new P(x, y));
							if (bluepoints.size() > maxPoints) {
								return;
							}
							break;
					}
				}
			}
		}
	}
}
