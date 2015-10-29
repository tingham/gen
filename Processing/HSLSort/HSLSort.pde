// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Dec 13 2014
// 

int width = 512;
int height = 512;
int sqSize = 64;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int[] colors;

void setup ()
{
    size(width, height, P2D);

    int count = (width  / sqSize) * (height / sqSize);

    colors = new int[count];

    for (int i = 0; i < count; i++) {
        colors[i] = color(
                random(64, 196),
                random(64, 196),
                random(64, 196),
                255
            );
    }
}

void draw ()
{
    sort();

    for (int i = 0; i < colors.length; i++) {
        int boxX = i % (width / sqSize);
        int boxY = (i - boxX) / (width / sqSize);
        
        fill(colors[i]);
        rect(boxX * sqSize, boxY * sqSize, sqSize, sqSize);
        fill(0, 0, 0, 255);
        text(hue(colors[i]), boxX * sqSize, boxY * sqSize + 12);
        text(brightness(colors[i]), boxX * sqSize, boxY * sqSize + 24);
    }
}

void sort ()
{
    for (int i = 0; i < colors.length; i++) {
        if (i + 1 < colors.length) {
            int a = colors[i];
            int b = colors[i + 1];

            // 0.937 * 100 93.7 (int)93
            int h1 = (int)((hue(a) / 255) * 100);
            int h2 = (int)((hue(b) / 255) * 100);
            int b1 = (int)((brightness(a) / 255) * 100);
            int b2 = (int)((brightness(b) / 255) * 100);
            int s1 = (int)((saturation(a) / 255) * 100);
            int s2 = (int)((saturation(b) / 255) * 100);

            int d1 = (h1 * 128) + (b1 * 4) + s1;
            int d2 = (h2 * 128) + (b2 * 4) + s2;

            if (d1 < d2) {
                swap(i, i + 1);
            }

        }
    }
}

void swap (int a, int b)
{
    int d0 = colors[a];
    colors[a] = colors[b];
    colors[b] = d0;
}

