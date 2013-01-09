// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jan 04 2013
// 

int width = 1280;
int height = 720;
int tick = 0;
int lineDelay = 10;
int majorEllipseDelay = 120;
int minorEllipseDelay = 160;
int triangleDelay = 200;

float bottomLineTick = 0;

void setup ()
{
	size(width, height);
	fill(240, 240, 240);
	noStroke();
}

float lastBottomLineX = 0;

void draw ()
{
	tick++;

	smooth();

	if (tick > majorEllipseDelay) {
		stroke(90, 90, 90, 8);
		strokeWeight(2);
		noFill();
		ellipse(width * 0.5, height * 0.4, height * 0.4, height * 0.4);
	}

	if (tick > minorEllipseDelay) {
		stroke(90, 90, 90, 8);
		strokeWeight(2);
		noFill();
		ellipse(width * 0.5, height * 0.4, height * 0.3, height * 0.3);

	}

	if (tick > lineDelay) {
		bottomLineTick += 0.005;
		stroke(90, 90, 90, 255);
		strokeWeight(2);
		line(lastBottomLineX, (height * 0.7) + sin(tick * 0.01), width * bottomLineTick, (height * 0.7) + sin(tick * 0.01));
		lastBottomLineX = (width * bottomLineTick);
	}

	if (tick >= triangleDelay) {
		stroke(90, 90, 90, 16);
		pushMatrix();
		translate(width * 0.5, height * 0.4);
		rotate(sin(tick * 0.1) * PI);
		stroke(90, 90, 90, 16);
		line(0, 0, width * 0.5 - width * 0.4, height * 0.4 - height * 0.7);
		line(0, 0, width * 0.5 - width * 0.6, height * 0.4 - height * 0.7);
		stroke(90, 90, 90, 4);
		line(0, 0, width * 0.4, height * 0.4 + height * 0.7);
		line(0, 0, width * 0.6, height * 0.4 + height * 0.7);
		popMatrix();
	}

	clamps();
}

void clamps () {
	bottomLineTick = max(min(bottomLineTick, 1.0), 0);
}

