// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 28 2013
// 
PImage input;
// String imageName = "3400976175_57a9243379_o.jpg";
String imageName = "6016656690_2a2aedcc50_b.jpg";
String outputName = "data/output/" + imageName + "-" + System.currentTimeMillis() + "/";

int[] r;
int[] g;
int[] b;
color[] clr;

void setup ()
{
	input = loadImage("data/input/" + imageName);
	size(input.height, input.height);
	input.loadPixels();

	r = new int[input.width * input.height];
	g = new int[input.width * input.height];
	b = new int[input.width * input.height];
	clr = new int[input.width * input.height];

	for (int i = 0; i < input.width * input.height; i++) {
		r[i] = (int)red(input.pixels[i]);
		g[i] = (int)green(input.pixels[i]);
		b[i] = (int)blue(input.pixels[i]);
		clr[i] = input.pixels[i];
	}

	r = sort(r);
	g = sort(g);
	b = sort(b);
	// clr = sort(clr);
}

void draw ()
{
	background(0);

	for (int i = 0; i < input.pixels.length; i++) {
		float x = i / input.width;
		float y = i % input.width;
		float n = /*noise(x * 0.01, y * 0.01) * */ (brightness(clr[i]) / 255);
		float s = sin(i * 0.01) * (n * 10);
		stroke(r[i], g[i], b[i]);
		strokeWeight(1.1);
		point(x + s, y - s);
		if (i % 120 == 0) {
			r = reverse(r);
		}
		if (i % 330 == 0) {
			g = reverse(g);
		}
		if (i % 550 == 0) {
			b = reverse(b);
		}
	}

	long t = System.currentTimeMillis();
	if (t % 10 == 0) {
		save(outputName + t + ".jpg");
	}
}

