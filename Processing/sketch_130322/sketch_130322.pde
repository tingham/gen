// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Mar 22 2013
// 

int width = 64;
int height = 64;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

PImage bimg = createImage(width, height, RGB);
PImage img = createImage(width, height, RGB);
ArrayList<MCPoint> mcMap = null;
int mcSamples = 64;

void setup ()
{
	size(width, height);

	img.loadPixels();

	for (int i = 0; i < width * height; i++) {
		int x = i % width;
		int y = (i - x) / width;

		float n = noise((float)x / width * 2.5, (float)y / height * 2.5);
		n = (float)((float)((int)(n * 10)) / 10);
		img.pixels[i] = color(n * 255);
	}
	bimg.loadPixels();
	bimg.pixels = img.pixels;
	bimg.updatePixels();

	img.updatePixels();

	thread("update");
}

void update () {
	// During each pass, expand each mc one point in each cardinal direction until it hits a threshold pixel.
	while (true) {
		try {
			img.loadPixels();

			if (mcMap == null) {
				mcMap = new ArrayList<MCPoint>();
				for (int i = 0; i < mcSamples; i++) {
					MCPoint mcPoint = new MCPoint();
					mcPoint.origin = new PVector(random(width), random(height));
					mcPoint.radius = 1;
					// if mcPoint ! in list
					mcMap.add(mcPoint);
				}
			}

			int rIndex = -1;
			ArrayList<MCPoint> removals = new ArrayList<MCPoint>();

			for (MCPoint mc : mcMap) {
				rIndex++;
				int mcIndex = (int)(mc.origin.y * width + mc.origin.x);
				boolean skipMc = false;
				float abDist = 0;
				float abLimit = 0;

				// if I collide with another mc, skip me
				for (MCPoint mcn : mcMap) {
					abDist = mc.origin.dist(mcn.origin);
					abLimit = mc.radius + mcn.radius;
					if (abDist <= abLimit && mc != mcn) {
						if (mc.radius < mcn.radius &&
							mc != mcn &&
							mc.radius > 0) {
							removals.add(mc);
						}
						skipMc = true;
						break;
					}
				}

				if (!skipMc) {
					for (int p = 0; p < img.pixels.length; p++) {
						int x = p % width;
						int y = (p - x) / width;
						PVector evl = new PVector(x, y);
						if (evl.dist(mc.origin) < mc.radius &&
							abs(brightness(img.pixels[p]) - brightness(img.pixels[mcIndex])) < 128) {
							mc.radius++;
						}
					}
					mc.radius++;
				}
			}

			// mcMap.removeAll(removals);

			img.updatePixels();
			Thread.sleep(1);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	background(255);
	image(img, 0, 0);

	for (int i = 0; i < mcMap.size(); i++) {
		MCPoint mc = mcMap.get(i);
		stroke(255, 0, 0);
		strokeWeight(2);
		noFill();
		point(mc.origin.x, mc.origin.y);
		strokeWeight(.5);
		ellipse(mc.origin.x, mc.origin.y, mc.radius * 2, mc.radius * 2);
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0 && mousePressed) {
		save(outputName + "s-" + t + ".jpg");
	}
}

class MCPoint {
	PVector origin;
	float radius;
	boolean active;
}
