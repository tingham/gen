// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Dec 16 2014
// 

import com.urbanfort.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Dot[] dots;

void setup ()
{
    size(width, height, P3D);
    dots = new Dot[width * height];
    for (int i = 0; i < dots.length; i++) {
        float b = random(0, 1);
        dots[i] = new Dot(b, b, b, 1);
    }
}

void update ()
{
    Dot[] dcp = new Dot[dots.length];
    for (int i = 0; i < dots.length; i++) {
        dcp[i] = dots[i].average(dots[i]);
    }

    for (int i = 0; i < dots.length; i++) {
        int x = i % width;
        int y = (i - x) / width;
        int[][] offs = {
            {-1, -1}, {0, -1}, {1, -1},
            {-1, 0}, {0, 0}, {1, 0},
            {-1, 1}, {0, 1}, {1, 1}
        };

        for (int o = 0; o < offs.length; o++) {
            int index = (y + offs[o][1]) * width + (x + offs[o][0]);
            if (index > 0 && index < dots.length) {
                dcp[index] = dots[i].lerp(dots[index], 0.1);
            }
        }
    }
    dots = dcp;
}

void draw ()
{
    update();

    loadPixels();
    for (int i = 0; i < dots.length; i++) {
        pixels[i] = dots[i].Color();
    }
    updatePixels();
}

