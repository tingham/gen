// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 08 2013
// 

String imageName = "JSP_9121.jpg";
PImage image;

void setup ()
{
	image = loadImage("data/input/" + imageName);
	image.loadPixels();

	size(image.width, image.height);

	// background(0, 1);
	render();
}

void render ()
{
	int l = 0;
	fill(255);
	for (int x = 0; x < image.width; x++) {
		for (int y = 0; y < image.height; y++) {
			int p = (int)brightness(image.pixels[y * width + x]);
			int c = (int)(p + l / 2);
			stroke((c / 32) * 255, 0, blue(((c / 128) * 255)));
			strokeWeight(2);
			point(x, y);
			l = p;
		}
	}
}

