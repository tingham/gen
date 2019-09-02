// # Chopsui
// **Created By:** + tingham
// **Created On:** + Thu Mar 02 2017
// 
//
import java.util.Collections;

int width = 1600;
int height = 900;
int tick = 0;

int sliceW = 128;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<Slice> slices = new ArrayList<Slice>();
ArrayList<PImage> sunsets = new ArrayList<PImage>();

void setup ()
{
	size(1600, 900, P3D);
	loadSunsets();
	loadPatterns();
	background(64);

	imageMode(CENTER);
	PImage sample = sunsets.get((int)random(0, sunsets.size()));
	image(sample, width * 0.5, height * 0.5);

	loadPixels();
}

void loadSunsets () {
	String sunsetPath = sketchPath() + "/data/input/sunsets/";
	File sunDir = new File(sunsetPath);
	String[] suns = sunDir.list();
	for (String r : suns) {
		PImage p = loadImage(sunsetPath + "/" + r);
		p.resize(0, height);
		sunsets.add(p);
	}
}

void loadPatterns () {
	String rootPath = sketchPath() + "/data/input/patterns/";
	File dir = new File(rootPath);
	String[] list = dir.list();
	for (String s : list) {
		if (s.indexOf(".") > 0) {
			PImage image = loadImage(rootPath + "/" + s);
			int intervals = 10;
			for (int i = 0; i < intervals; i++) {
				PImage gg = extractStripFromImage(image, (float)i / (float)intervals);
				if (gg != null && gg.width > 0 && gg.height > 0) {
					Slice ss = new Slice(s, gg);
					if (ss != null && ss.validate()) {
						slices.add(ss);
					}
					else {
						println("failed slice.");
					}
				}
				else {
					println("failed image.");
				}
			}
		}
	}

	// Collections.sort(slices);
}

PImage extractStripFromImage(PImage image, float r) {
	int x = clamp((int)random(0, image.width * 0.5));
	int width = clamp((int)random(x, image.width * 0.5));
	int height = clamp((int)random(128, 256));
	int y = clamp((int)(image.height * r) - height); 

	// println(x + ", " + y + ", " + width + ", " + height);

	return image.get(x, y, width, height);
}

int clamp (int i) {
	return (int)max(0, i);
}

void draw ()
{
	tick = tick + 1;

	if (tick % 10 == 0) {
		for (int i = 0; i < pixels.length; i++) {
			int x = i % width;
			int y = (i - x) / width;

			if (random(1.0) > 0.999) {
				Slice s = nearestSlice(pixels[i]);
				if (s != null) {
					image(s.image, x, y);
				}
			}
		}
	}
	// long t = System.currentTimeMillis();
	// if (t % 30 == 0) {
	// 	save(outputName + "s-" + t + ".jpg");
	// }
}

public Slice nearestSlice (int pixel) {
	float minDistance = 999999999;
	Slice result = null;
	for (Slice s : slices) {
		float r = red(pixel) / 255;
		float g = green(pixel) / 255;
		float b = blue(pixel) / 255;
		float dist = s.distance(r, g, b);
		// println("Checking against: " + r + ", " + g + ", " + b);

		if (dist < minDistance - random(0.01, 0.05) && !Float.isNaN(dist)) {
			minDistance = dist;
			result = s;
			// println("Set result to: " + s + " distance: " + minDistance);
		}
	}
	return result;
}

public class Slice implements Comparable<Slice> {
	public String name;
	public PImage image;
	public Float avgR;
	public Float avgG;
	public Float avgB;
	int hash;

	public Slice (String name, PImage img) {
		name = name;
		int r = 0;
		int g = 0;
		int b = 0;
		int count = 0;

		img.resize(sliceW, 0);

		for (int i = 0; i < img.pixels.length; i++) {
			// if (alpha(img.pixels[i]) > 0) {
				r = r + (int)(red(img.pixels[i]) / 255);
				g = g + (int)(green(img.pixels[i]) / 255);
				b = b + (int)(blue(img.pixels[i]) / 255);
				count++;
			// }
		}

		avgR = new Float((float)r / (float)img.pixels.length);
		avgG = new Float((float)g / (float)img.pixels.length);
		avgB = new Float((float)b / (float)img.pixels.length);

		println("Creating slice " + name + " with " + avgR + ", " + avgG + ", " + avgB);

		image = img;

		hash = (r * 255) + (g * 255) + (b * 255) + ((int)random(0, 10000));
	}

	boolean validate () {
		return !(avgR.isNaN() && avgG.isNaN() && avgB.isNaN());
	}

	int compareTo (Slice sw) {
		if (this == sw) {
			return 0;
		}

		if (avgR > avgG && avgR > avgB) {
			if (avgR > sw.avgR) {
				return 1;
			}
			else if (avgR == sw.avgR) {
				return 0;
			}
			else {
				return -1;
			}
		}
		else if (avgG > avgR && avgG > avgB) {
			if (avgG > sw.avgG) {
				return 1;
			}
			else if (avgG == sw.avgG) {
				return 0;
			}
			else {
				return -1;
			}
		}
		if (avgB > sw.avgB) {
			return 1;
		}
		else if (avgB == sw.avgB) {
			return 0;
		}
		else {
			return -1;
		}

	}

	int hashCode () {
		return hash;
	}

	boolean equals(Object o) {
		return o instanceof Slice?
			((Slice)o).hash == hash : false;
	}

	public float distance (float r, float g, float b) {
		return (float)Math.sqrt(Math.pow(r - avgR, 2) + Math.pow(g - avgG, 2) + Math.pow(b - avgB, 2));
	}

	public String toString () {
		return "Slice: " + hashCode();
	}
}









