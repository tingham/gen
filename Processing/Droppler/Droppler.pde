// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Oct 27 2014
// 

int width = 1024;
int height = 1024;
int cursorSize = 10;
float pulseSize = 10f;
int tick = 0;
boolean holding = false;
float radius = 0f;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

PVector ball = new PVector(width * 0.5, height * 0.5);
PVector start = new PVector(0, 0);
PVector end = new PVector(0, 0);
PVector heading = new PVector(0, 0);
PVector bump = new PVector(0, 0);

ArrayList<PVector> slabs = new ArrayList<PVector>();

void setup ()
{
    size(width, height, P2D);
    for (int i = 0; i < 10; i++) {
        slabs.add(new PVector(random(cursorSize, width - (cursorSize * 2)), random(cursorSize, height - (cursorSize * 2))));
    }
    frameRate(60);
}

void mousePressed ()
{
    start.x = mouseX;
    start.y = mouseY;
    end.x = mouseX;
    end.y = mouseY;
    holding = true;
}

void mouseDragged ()
{
    ball.x = start.x;
    ball.y = start.y;
    end.x = mouseX;
    end.y = mouseY;
    pulseSize = cursorSize * 3f;
}

void mouseReleased ()
{
    holding = false;
    heading = PVector.sub(start, end);
    heading.normalize();
    heading.mult(radius * 0.125);
}

void draw ()
{
	long t = System.currentTimeMillis();
    tick++;

    float pulse = 0.5 * sin(tick / 10f) + 0.5f;

    pushMatrix();
    translate(bump.x, bump.y);

    fill(128);
    rect(0, 0, width, height);

    fill(32, 0, 0, 32);

    radius = max(abs(end.x - start.x), abs(end.y - start.y)) * 2f;

    if (holding) {
        radius += pulse * pulseSize;
    }

    ellipse(
        start.x,
        start.y,
        radius,
        radius
    );

    fill(255, 0, 0, 32);
    stroke(255, 0, 0, 128);
    ellipse(start.x, start.y, cursorSize, cursorSize);
    stroke(0, 255, 0, 128);
    ellipse(end.x, end.y, cursorSize, cursorSize);

    stroke(0, 0, 0, 128);
    if (holding) {
        line(start.x, start.y, end.x, end.y);
    }

	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}

    if (!holding) {
        end = PVector.lerp(end, start, 0.5);
    }

    fill(196);
    stroke(0);
    ellipse(ball.x, ball.y, cursorSize * 2, cursorSize * 2);


    pulseSize = pulseSize * 0.75f;
    heading.lerp(new PVector(0, 0), 0.01);
    ball = PVector.add(ball, heading);
    bump.lerp(new PVector(0, 0), noise(tick, 0));

    fill(255);
    noStroke();
    drawSlabs();

    collision();

    popMatrix();
}

void drawSlabs ()
{
    for(PVector p : slabs) {
        rect(p.x + bump.x, p.y + bump.y, 64 - bump.x, 64 - bump.y);
    }
}

void collision ()
{
    if (ball.y + heading.y <= 0 || ball.y + heading.y >= height) {
        heading.y *= -1;
        bump.x = random(-20, 20);
    }

    if (ball.x + heading.x <= 0 || ball.x + heading.x >= width) {
        heading.x *= -1;
        bump.y = random(-20, 20);
    }

    for(PVector p : slabs) {
        if (ball.y > p.y && ball.y < p.y + 64) {
            if ((ball.x + heading.x > p.x - 5 && ball.x + heading.x < p.x + 5) ||
                (ball.x + heading.x > p.x + 64 - 5 && ball.x + heading.x < p.x + 64 + 5)) {
                heading.x *= -1;
                bump.y = random(-20, 20);
            }
        }
        if (ball.x > p.x && ball.x < p.x + 64) {
            if ((ball.y + heading.y > p.y - 5 && ball.y + heading.y < p.y + 5) ||
                (ball.y + heading.y > p.y + 64 - 5 && ball.y + heading.y < p.y + 64 + 5)) {
                heading.y *= -1;
                bump.x = random(-20, 20);
            }
        }
    }
}
