// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 14 2013
// 
int width = 1280;
int height = 720;
float t = 0;

void setup ()
{
	size(width, height);
}

void draw ()
{
	t += 2.0;

	rectMode(CORNER);

	background(0);
	noStroke();
	fill(0, 0, 0, 255);
	rect(0, 0, width, height);

	strokeWeight(1.1);

	rectMode(CENTER);

	for (int x = 0; x < width; x++) {

		for (int y = 0; y < height; y++) {

			float fx = (float)((float)(x + t) / width) * 5;
			float fy = (float)((float)(y + t) / height) * 4;
			float na = noise(fx, fy);

			stroke(na * 64, na * 128, na * 255);
			noFill();
			point(x, y);

			if (na > 0.6) {
				pushMatrix();
				translate(x, y);
				stroke(64, random(128) + (noise(fy, fx) * 128), 64, 32);
				noFill();
				rect(0, 0, 1, random(6) + 2);
				popMatrix();
			}

		}

	}

	if (random(1) > 0.75) {
		save("data/output/r" + java.util.Calendar.getInstance().get(java.util.Calendar.MILLISECOND) + ".jpg");
	}
}

