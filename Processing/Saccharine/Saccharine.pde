// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri May 23 2014
// 

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;
Dot infA = new Dot(0.7, 0.5, 0.0, 1.0, 1.0);
Dot infB = new Dot(0.5, 0.4, 0.1, 1.0, 1.0);

void setup ()
{
    size(width, height, P3D);
}

void build () {

    dots = new Dot[width * height];

    float scale2 = random(5, 15);
    float scale3 = random(15, 30);

    noiseDetail((int)random(8, 16) + 16, 0.6);

    for (int i = 0; i < dots.length; i++) {
        int x = i % width;
        int y = (i - x) / width;

        float fx = (float)x / (float)width;
        float fy = (float)y / (float)height;

        float n1 = noise(fx, fy);
        float n2 = noise((fx * scale2) + scale2, (fy * scale2) + scale2);
        float n3 = noise((fx * scale3) + scale3, (fy * scale3) + scale3);

        float s1 = 0.85 + sin(sqrt((x * x) + (y * y)) * 0.01) * 0.15;

        n1 = lerp(n1, n3, n2);

        dots[i] = new Dot(
                n1, n1, n1,
                1.0, 1.0
            );

        if (n1 > 0.5) {
            dots[i].r *= infA.r;
            dots[i].g *= infA.g;
            dots[i].b *= infA.b;
        } else {
            dots[i].r *= infB.r;
            dots[i].g *= infB.g;
            dots[i].b *= infB.b;
        }
    }

    blur();

    bleed();

}
void blur () {
    for (int i = 0; i < dots.length; i++) {
        int x = i % width;
        int y = (i - x) / width;
        int l = x - 1;
        int r = x + 1;
        int u = y - 1;
        int d = y + 1;

        if (l > 0 && r < width && u > 0 && d < height) {
            dots[i].r = (dots[u * width + l].r + dots[u * width + x].r + dots[u * width + r].r + 
                dots[y * width + l].r + dots[y * width + x].r + dots[y * width + r].r +
                dots[d * width + l].r + dots[d * width + x].r + dots[d * width + r].r) / 9;
            dots[i].g = (dots[u * width + l].g + dots[u * width + x].g + dots[u * width + r].g + 
                dots[y * width + l].g + dots[y * width + x].g + dots[y * width + r].g +
                dots[d * width + l].g + dots[d * width + x].g + dots[d * width + r].g) / 9;
            dots[i].b = (dots[u * width + l].b + dots[u * width + x].b + dots[u * width + r].b + 
                dots[y * width + l].b + dots[y * width + x].b + dots[y * width + r].b +
                dots[d * width + l].b + dots[d * width + x].b + dots[d * width + r].b) / 9;
        }
    }
}

void bleed () {
    for (int i = 0; i < dots.length; i++) {
        int x = i % width;
        int y = (i - x) / width;
        int l = x - 1;
        int r = x + 1;
        int u = y - 1;
        int d = y + 1;

        if (l > 0 && r < width && u > 0 && d < height) {
            Dot center = dots[i];
            Dot dul = dots[u * width + l];
            Dot du = dots[u * width + x];
            Dot dur = dots[u * width + r];
            Dot dl = dots[y * width + l];
            Dot dr = dots[y * width + r];
            Dot ddl = dots[d * width + l];
            Dot dd = dots[d * width + x];
            Dot ddr = dots[d * width + r];

        }
    }
}

void draw ()
{
    build();

    loadPixels();
    for (int i = 0; i < dots.length; i++) {
        pixels[i] = dots[i].Color();
    }
    updatePixels();
	long t = System.currentTimeMillis();
	if (t % 2 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

