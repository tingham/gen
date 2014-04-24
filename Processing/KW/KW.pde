// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Apr 16 2014
// 
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
int iwidth = 0;
int iheight = 0;

String inputName = "data/input/tumblr_n45keuad0i1qzo2pmo5_1280.jpg";
// String inputName = "data/input/tumblr_n45keuad0i1qzo2pmo2_1280.jpg";
String outputName = "data/output/" + System.currentTimeMillis() + "/";
Dot[] dots;

void setup ()
{
    PImage img = loadImage(inputName);
    img.loadPixels();
    width = img.width;
    height = img.height;
    size(width, height, P3D);

    dots = new Dot[img.pixels.length];
    for (int i = 0; i < img.pixels.length; i++) {
        Dot d = new Dot(
                red(img.pixels[i]) / 255f,
                green(img.pixels[i]) / 255f,
                blue(img.pixels[i]) / 255f,
                1f
            );
        dots[i] = d;
    }
}

void update () {
    for (int i = 0; i < dots.length; i++) {
        int x = i % width;
        int y = (i - x) / width;
        int left = y * width + (x - 1);
        int right = y * width + (x + 1);
        int up = (y - 1) * width + x;
        int down = (y + 1) * width + x;

        if (left > 0 && right < dots.length &&
            up > 0 && down < dots.length) {

            if (dots[left].r > dots[up].g && dots[right].b > dots[down].r) {
                swap(left, i);
            }

            if (dots[up].g > dots[right].b && dots[down].r > dots[left].g) {
                swap(right, i);
            }

            if (dots[right].r > dots[down].g && dots[left].b > dots[up].r) {
                swap(up, i);
            }

            if (dots[down].g > dots[left].b && dots[up].r > dots[right].g) {
                swap(down, i);
            }

        }
    }
}

void swap (int a, int b) {
    Dot d0 = dots[a];
    dots[a] = dots[b];
    dots[b] = d0;
}

void draw ()
{
    tick++;

    float s = (mouseX - (width * 0.5)) / width; // sin(tick * 0.1) * 0.01;

    // update();

    background(32, 32, 32, 32);

    pushMatrix();
    translate(width * 0.5, 0, -(width * 0.2));
    rotate(HALF_PI, 0, s, 0);
    translate(width * -0.5, 0, 0);
    noFill();
    // loadPixels();
    sphereDetail(3);
    for (int i = 0; i < dots.length; i++) {
        int x = i % width;
        int y = (i - x) / width;
        int r = (int)random(5) + 5;
        if (x % r == 0 && y % r == 0) {
            pushMatrix();
            translate(x, y, (dots[i].r * 96) + (dots[i].g * 64) + (dots[i].b * 32) * s);
            stroke(dots[i].Color());
            sphere(2);
            popMatrix();
        }
    }
    popMatrix();
    //updatePixels();
    /*
	long t = System.currentTimeMillis();
	if (t % 2 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
    */
}

