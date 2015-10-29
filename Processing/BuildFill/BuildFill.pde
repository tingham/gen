// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat May 24 2014
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

void setup ()
{
    size(width, height, P3D);

    buildBase();
}

void buildBase () {
    dots = new Dot[width * height];
    PVector center = new PVector(width * 0.5, height * 0.5);
    for (int i = 0; i < dots.length; i++) {
        PVector p = new PVector(
            i % width,
            (i - (i % width)) / width
        );
        float n1 = noise((p.x / width) * 2, (p.y / height) * 2);
        float d = p.dist(center);

        if (d / (width * .5) < n1) {
            dots[i] = new Dot(d / (width * 2), d / (width * 2), d / (width * 2), 1.0, 1.0);
        } else {
            dots[i] = new Dot(d / (width * 2), d / (width * 2), d / (width * 2), 1.0, 1.0).lighter(2);
        }
    }
}

void update () {
}

void draw ()
{
    tick++;

    update();

    loadPixels();
    for (int i = 0; i < dots.length; i++) {
        pixels[i] = dots[i].Color();
    }
    updatePixels();

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		// save(outputName + "s-" + t + ".jpg");
	}
}

