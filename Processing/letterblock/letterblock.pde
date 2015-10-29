// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Jan 05 2013
// 
// Draws a series of alphabetical letters in a single line on a grid.

String[] letters = new String[] {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

int height = 128;
int width = letters.length * height;
PFont kooky32 = loadFont("/Users/tingham/DropBox/Processing/letterblock/data/fonts/CartoonistKooky-32.vlw");
PFont kooky48 = loadFont("/Users/tingham/DropBox/Processing/letterblock/data/fonts/CartoonistKooky-48.vlw");
PFont kooky72 = loadFont("/Users/tingham/DropBox/Processing/letterblock/data/fonts/CartoonistKooky-72.vlw");

void setup ()
{
	size(width, height);
	noStroke();
	fill(128, 128, 128, 255);
	rect(0, 0, width, height);
}

void draw ()
{
	for (int i = 0; i < letters.length; i++) {
		float x = (height * i) + (height * 0.5);
		float y = height * 0.5;
		String letter = letters[i];
		fill(32);
		textAlign(CENTER, CENTER);
		textFont(kooky72);
		pushMatrix();
		translate(x, y);
		text(letter, 0, 0);
		popMatrix();
	}

	save("data/output/letters-" + width + "-" + height + ".tif");
}

