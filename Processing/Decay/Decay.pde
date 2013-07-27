// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jul 25 2013
// 

import com.mutiny.*;
import java.util.Collections;
import java.util.Comparator;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
String input = "rivet.jpg";
String inputName = "data/input/" + input;

ArrayList<Dot> dots;

void setup ()
{
	dots = new ArrayList<Dot>();


	PImage img = loadImage(inputName);
	img.loadPixels();
	
	size(img.width, img.height, P3D);

	for (int i = 0; i < img.pixels.length; i++) {
		dots.add(
				new Dot(
					red(img.pixels[i]) / 255,
					green(img.pixels[i]) / 255,
					blue(img.pixels[i]) / 255,
					1,
					1
				)
			);
	}
	thread("update");
}

void update ()
{
	while (true) {
		try {
			Collections.sort(dots, new Comparator<Dot>() {
				public int compare (Dot d1, Dot d2) {
					if (d1.r + d1.g + d1.b > d2.r + d2.g + d2.b) {
						return -1;
					} else {
						return 1;
					}
				}
			});
			Thread.sleep(30);
		} catch (Exception e) {
		}
	}
}

void draw ()
{
	background(32);

	loadPixels();
	for (int i = 0; i < dots.size(); i++) {
		int x = i % width;
		int y = (i - x) / width;

		pixels[i] = dots.get(i).Color();
	}
	updatePixels();
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}


