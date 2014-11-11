// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Nov 05 2014
// 

import com.urbanfort.*;
import processing.video.*;


int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

Capture cam;
int[] camPixels;

void setup ()
{
    size(width, height, P2D);
    String[] cameras = Capture.list();
    if (cameras.length > 0) {
        cam = new Capture(this, cameras[0]);
        cam.start();
    } else {
        println("Cameras not available.");
    }
}

void pullFrame ()
{
    camPixels = new int[width * height];
    if (cam != null && cam.available() ==  true) {
        cam.read();
    }
    image(cam, -256, 0);
    loadPixels();
    for (int i = 0; i < camPixels.length; i++) {
        camPixels[i] = pixels[i];
    }
    // fill(0);
    // rect(0, 0, width, height);
}

void update ()
{
    int[] ppix = camPixels;
    for (int i = 0; i < ppix.length; i++) {
        int x = i % width;
        int y = (i - x) / width;
        int up = (y - 1) * width + x;
        int down = (y + 1) * width + x;
        int left = y * width + (x - 1);
        int right = y * width + (x + 1);

        if (up > 0 && up < ppix.length && down > 0 && down < ppix.length &&
            left > 0 && left < ppix.length && right > 0 && right < ppix.length) {

            if (red(ppix[left]) > red(ppix[up])) {
                ppix = swap(left, right, ppix);
            }
            if (blue(ppix[up]) > blue(ppix[right])) {
                ppix = swap(up, down, ppix);
            }
            if (green(ppix[right]) > green(ppix[down])) {
                ppix = swap(right, left, ppix);
            }
        }
    }
    camPixels = ppix;
}

int[] swap (int a, int b, int[] px)
{
    int d0 = px[a];
    px[a] = px[b];
    px[b] = d0;
    return px;
}

void draw ()
{
    tick++;

    pullFrame();

    update();

    loadPixels();
    for (int i = 0; i < camPixels.length; i++) {
        pixels[i] = camPixels[i];
    }
    updatePixels();

    /*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
    */
}

int[] blob (float x, float y, float size, float scale, int pixels[], int clr)
{
    int totalPoints = 360;

    for (int i = 0; i < totalPoints; i++) {
        int cx = (i % (int)size);
        int cy = (i - cx) / (int)size;

        float n1 = noise((float)cx / size, 0) * scale;
        float n2 = noise(0, (float)cy / size) * scale;

        float fx = (sin(i) * size * 0.5) + n1;
        float fy = (cos(i) * size * 0.5) + n2;

        int index = (int)(y + fy) * width + (int)(x + fx);

        if (index > 0 && index < pixels.length) {
            pixels[index] = clr;
        }
    }
    return pixels;
}

