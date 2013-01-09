// Random noise and a box blur.

int width = 32;
int height = 32;
int scale = 8;

float[][] data;
float[][] hd;

void setup () {
    size(width * scale, height * scale);
    frameRate(0);
    data = new float[width][height];
    hd = new float[width * scale][height * scale];
    buildData();
    draw();
}

void buildData () {
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            data[x][y] = p(x, y);
        }
    }
    for (int x = 0; x < width * scale; x++) {
     for (int y = 0; y < height * scale; y++) {
        int _x = floor(x / scale);
        int _y = floor(y / scale);        
        hd[x][y] = data[_x][_y];
     }
    }
}

void draw () {
    // x = 71
    // x = 71 / 4
    // x = 17
    for (int x = 0; x < width * scale; x++) {
        for (int y = 0; y < height * scale; y++) {
            stroke(d(x, y) * 255);
            point(x, y);
        }
    }
}

float p (int x, int y) {
    return cos((pow(x, 2)) * (pow(y, 2)));
}

float d (int x, int y) {
    if (x - 1 > 0 && x + 1 < (width * scale) - 1 && y - 1 > 0 && y + 1 < (height * scale) - 1) {
        float a, b, c, d, e, f, g, h, i;
        a = hd[x-1][y-1];
        b = hd[x-1][y+1];
        c = hd[x+1][y-1];
        d = hd[x+1][y+1];
        e = hd[x][y-1];
        f = hd[x][y+1];
        g = hd[x+1][y];
        h = hd[x+1][y];
        i = hd[x][y];
        hd[x][y] = ((a + b + c + d + e + f + g + h + i) / 9);
    }
    return hd[x][y];
}

