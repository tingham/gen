// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat May 24 2014
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int w = 32;
int[] cells = new int [(width / w) * (height / w)];
int[] next = new int[cells.length];
int[] rules = new int[] {0,1,0,1,1,0,1,0};

void setup ()
{
    size(width, height, P3D);
    frameRate(10);
    for (int i = 0; i < cells.length; i++) {
        cells[i] = (int)random(2);
    }
}

void mouseDragged () {
}

void update () {
    int _width = width / w;

    for (int i = 0; i < cells.length; i++) {
        int x = i % _width;
        int y = (i - x) / _width;

        next[i] = evaluate(x, y);
    }
    cells = next;
}

int evaluate (int x, int y) {
    int offsets[][] = new int[][] {{-1, -1}, {0, -1}, {1, 1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};
    int total = 0;
    int _width = width / w;
    int _height = height / w;

    for (int i = 0; i < offsets.length; i++) {
        int indice = ((y + offsets[i][1]) * _width + (x + offsets[i][0]));
        if (indice > 0 && indice < cells.length) {
            if (cells[indice] > 0) {
                total++;
            }
        }
    }

    int me = y * _width + x;
    if (cells[me] == 1 && total < 2) {
        return 0;
    } else if (cells[me] == 1 && total > 3) {
        return 0;
    } else if (cells[me] == 0 && total == 3) {
        return 1;
    } else {
        return cells[me];
    }
}

void draw ()
{
	long t = System.currentTimeMillis();
    tick++;

    int _width = width / w;
    int _height = height / w;

	save(outputName + "s-" + t + ".jpg");

    update();

    for (int i = 0; i < cells.length; i++) {
        int x = i % _width;
        int y = (i - x) / _width;

        if (cells[i] == 1) {
            fill(0);
        } else {
            fill(255);
        }
        rect(x * w, y * w, w, w);

        float d = 0.45;
        fill(0);
        ellipse(x * w, y * w, (w * d), (w * d));
        ellipse(x * w, (y + 1) * w, (w * d), (w * d));
        ellipse((x + 1) * w, y * w, (w * d), (w * d));
        ellipse((x + 1) * w, (y + 1) * w, (w * d), (w * d));
    }
}

