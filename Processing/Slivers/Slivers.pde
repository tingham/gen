// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Dec 15 2014
// 
import com.urbanfort.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Poly p;


void setup ()
{
    size(width, height, P3D);
}

void draw ()
{
    background(255);

    p = new Poly(
            new PVector(random(0, width), random(0, height)),
            new PVector(random(0, width), random(0, height)),
            new PVector(random(0, width), random(0, height)),
            new PVector(random(0, width), random(0, height))
        );
    line(p.a.x, p.a.y, p.b.x, p.b.y);
    line(p.b.x, p.b.y, p.c.x, p.c.y);
    line(p.c.x, p.c.y, p.d.x, p.d.y);
    line(p.d.x, p.d.y, p.a.x, p.a.y);

    /*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
    */
}

