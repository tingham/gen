// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Aug 05 2013
// 
import com.mutiny.*;

int tick = 0;

boolean overlapChunks = false;
boolean useAbsoluteValue = true;
boolean midToneSourceImage = false;
boolean noiseMapMidTone = false;
String mode = "Both"; //Add, Subtract, Both

String outputName = "data/output/" + System.currentTimeMillis() + "/";

String aPath = "data/input/a.jpg";
String bPath = "data/input/fire.jpg";

PImage a, b;

Dot[] source;
Dot[] effect;
Dot[] result;

void setup ()
{
	provision();
}

void provision ()
{
	if (aPath != null && bPath != null) {

		a = loadImage(aPath);
		b = loadImage(bPath);

		a.loadPixels();
		b.loadPixels();

		source = new Dot[a.width * a.height];
		effect = new Dot[a.width * a.height];
		result = new Dot[a.width * a.height];

		for (int i = 0; i < a.width * a.height; i++) {
			int x = i % a.width;
			int y = (i - x) / a.width;

			float fx = (float)x / (float)a.width;
			float fy = (float)y / (float)a.height;

			int bx = (int)floor(fx * b.width);
			int by = (int)floor(fy * b.height);

			int tIndex = by * b.width + bx;
			effect[i] = new Dot(b.pixels[tIndex]);
			source[i] = new Dot(a.pixels[i]);

			result[i] = new Dot(a.pixels[i]);

			if (midToneSourceImage) {
				float n1 = noise(fx, fy);
				float n2 = noise(fx * 2, fy * 2);
				float n3 = noise(fx * 3, fy * 3);

				effect[i].r = lerp(effect[i].r, 0.5, (noiseMapMidTone) ? n1 : 0.5);
				effect[i].g = lerp(effect[i].g, 0.5, (noiseMapMidTone) ? n2 : 0.5);
				effect[i].b = lerp(effect[i].b, 0.5, (noiseMapMidTone) ? n3 : 0.5);
			}
		}

		for (int i = 0; i < a.width * a.height; i++) {
			int x = i % a.width;
			int y = (i - x) / a.width;

			int[] neighbors = new int[8];

			neighbors[0] = (y - 1) * width + x; //int up
			neighbors[1] = (y - 1) * width + (x - 1); //int upLeft 
			neighbors[2] = (y - 1) * width + (x + 1); //int upRight 
			neighbors[3] = y * width + (x - 1); //int left 
			neighbors[4] = y * width + (x + 1); //int right 
			neighbors[5] = (y + 1) * width + x; //int down 
			neighbors[6] = (y + 1) * width + (x - 1); //int downLeft
			neighbors[7] = (y + 1) * width + (x + 1); //int downRight 

			for (int mc = 0; mc < neighbors.length; mc++) {
				int finalIndex = neighbors[mc];
				if (finalIndex > 0 && finalIndex < result.length) {
					float r = (effect[i].r + result[i].r) - 1.0;
					float g = (effect[i].g + result[i].g) - 1.0;
					float b = (effect[i].b + result[i].b) - 1.0;

					if (!useAbsoluteValue) {
						r /= 8;
						g /= 8;
						b /= 8;
					}

					if (mode == "Add") {
						r = (r > 0) ? r : 0;
						g = (g > 0) ? g : 0;
						b = (b > 0) ? b : 0;
					}
					else if (mode == "Subtract") {
						r = (r < 0) ? r : 0;
						g = (g < 0) ? g : 0;
						b = (b < 0) ? b : 0;
					}

					result[finalIndex] = new Dot(
							r,
							g,
							b,
							1,
							1
						);
				}
			}
		}

		size(a.width, a.height, P3D);

	}
}

void draw ()
{
	loadPixels();
	for (int d = 0; d < effect.length; d++) {
		pixels[d] = result[d].Color();
	}
	updatePixels();

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

