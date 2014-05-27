// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat May 24 2014
// 

int width = 513;
int height = 513;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int w = 4;
int[] cells = new int [width / w];
int[] rules = new int[] {0,1,0,1,1,0,1,0};

void setup ()
{
    size(width, height, P3D);
    /*
    for (int i = 0; i < cells.length; i++) {
        if (random(0, 1) > 0.5) {
            cells[i] = 1;
        } else {
            cells[i] = 0;
        }
    }
    */
    cells[(width / w) / 2] = 1;
}

void mouseDragged () {
    println("S");
    if (mouseX / w > 0 && mouseX / w < cells.length) {
        cells[(int)mouseX / w] = cells[(int)mouseX / w] == 1 ? 0 : 1;
    }
}

void update () {
    int[] newstate = new int[width / w];
    for (int i = 0; i < cells.length; i++) {
        int left = 0;
        if (i - 1 > 0) {
            left = cells[i - 1];
        } else {
            left = cells[cells.length - 1];
        }

        int middle = cells[i];

        int right = 0;
        if (i + 1 < cells.length) {
            right = cells[i + 1];
        } else {
            right = cells[0];
        }

        newstate[i] = evaluate(left, middle, right);
    }
    cells = newstate;
}

int evaluate (int l, int m, int r) {
    String s = "" + l + m + r;
    int index = Integer.parseInt(s, 2);
    return rules[index];
}

void draw ()
{
	long t = System.currentTimeMillis();
    tick++;

    if (tick > (height / w)) {
		save(outputName + "s-" + t + ".jpg");
        tick = 0;
        for (int r = 0; r < rules.length; r++) {
            if (random(0, 1) > 0.5) {
                rules[r] = 1;
            } else {
                rules[r] = 0;
            }
        }
    }

    update();

    for (int i = 0; i < cells.length; i++) {
        if (cells[i] == 1) {
            fill(0);
        } else {
            fill(255);
        }
        rect(i * w, tick * w, w, w);
    }
	if (t % 30 == 0) {
		// save(outputName + "s-" + t + ".jpg");
	}
}

