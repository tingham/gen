// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Fri Jan 04 2013
// Draw a square at a static location.
// Draw a circle at a moving location.
// Draw a bezier curve between the center of both objects.

int width = 1280;
int height = 720;

int movetick = 0;
int randomTickOffset = (int)random(30);

float tick = 0.0;

float squareX = random(width - 32) + 32,
	  squareY = random(height - 32) + 32,
	  squareXTarget = random(width - 32) + 32,
	  squareYTarget = random(height - 32) + 32,
	  squareSize = 32,
	  circleX = 0.0,
	  circleY = 0.0,
	  circleSize = 64,
	  avgX1 = 0.0,
	  avgY1 = 0.0,
	  avgX2 = 0.0,
	  avgY2 = 0.0;

float s1 = 0.0,
	  s2 = 0.0,
	  c1 = 0.0,
	  c2 = 0.0;

void setup ()
{
	size(width, height);
	fill(140);
	noStroke();
	rect(0, 0, width * 2, height * 2);
}

void clear ()
{
	rectMode(CENTER);
	fill(225, 225, 225, 2);
	noStroke();
	rect(0, 0, random(width) * 1.5, random(height) * 1.5);
}

void draw ()
{

	tick += 0.01;
	movetick++;

	s1 = 0.5 + sin(tick) * 0.5;
	s2 = 0.5 + sin(tick * (10 + random(1))) * 0.5;

	c1 = 0.5 + cos(tick) * 0.5;
	c2 = 0.5 + cos(tick * (11 + random(1))) * 0.5;

	if (movetick % (30 + randomTickOffset) == 0) {
		randomTickOffset = (int)random(30);
		squareXTarget = random(width * 0.8) + (width * 0.1);
		squareYTarget = random(height * 0.8) + (height * 0.1);
	}

	squareX = lerp(squareX, squareXTarget, 0.01);
	squareY = lerp(squareY, squareYTarget, 0.0075);

	circleX = ((width * 0.8) * c1) + width * 0.1;
	circleY = ((height * 0.8) * s1) + height * 0.1;

	float tempAvgX1 = lerp(squareX + random(-squareSize, squareSize), circleX, 0.25);
	float tempAvgY1 = lerp(squareY + random(-squareSize, squareSize), circleY, 0.25);

	float tempAvgX2 = lerp(squareX, circleX, 0.75);
	float tempAvgY2 = lerp(squareY, circleY, 0.75);

	avgX1 = lerp(avgX1, tempAvgX1, s2);
	avgY1 = lerp(avgY1, tempAvgY1, c2);

	avgX2 = lerp(avgX2, tempAvgX2, s2);
	avgY2 = lerp(avgY2, tempAvgY2, c2);

	pushMatrix();
	translate(width / 2, (height /* 0.75*/) / 2);
	scale(0.25);
	rotate(tick * 0.2);

	clear();

	drawSquare();

	if (movetick % 7 == 0) {
		clear();
	}

	drawCircle();

	if (movetick % 2 == 0) {
		clear();
	}

	drawPath();

	popMatrix();


	String t = "" + movetick + "";
	while (t.length() < 10) {
		t = "0" + t;
	}

	if (movetick < 12000) {
		save("data/output/take01/" + t + ".tga");
	}
}

void drawPath ()
{
	noFill();

	stroke(0, 0, 0, 255);
	strokeWeight(4.0);
	curveTightness(-0.5);
	beginShape();
	curveVertex(squareX + (squareSize * 0.5), squareY + (squareSize * 0.5));
	curveVertex(squareX, squareY);
	curveVertex(avgX1, avgY1);
	curveVertex(avgX2, avgY2);
	curveVertex(circleX, circleY);
	curveVertex(circleX - (circleSize * 0.5), circleY - (circleSize * 0.5));
	endShape();

	stroke(200, 0, 0, 255);
	strokeWeight(3.0);
	curveTightness(-1);
	beginShape();
	curveVertex(squareX + (squareSize * 0.5), squareY + (squareSize * 0.5));
	curveVertex(squareX, squareY);
	curveVertex(avgX1, avgY1);
	curveVertex(avgX2, avgY2);
	curveVertex(circleX, circleY);
	curveVertex(circleX - (circleSize * 0.5), circleY - (circleSize * 0.5));
	endShape();

	fill(200, 0, 0, 255);
	ellipse(circleX, circleY, circleSize * 0.25, circleSize * 0.25);
	rectMode(CENTER);
	rect(squareX, squareY, squareSize * 0.25, squareSize * 0.25);
}

void drawCircle ()
{
	fill(128);
	stroke(0);
	ellipseMode(CENTER);
	ellipse(circleX, circleY, circleSize, circleSize);
}

void drawSquare ()
{
	fill(128);
	stroke(0);
	strokeWeight(1);
	rectMode(CENTER);
	rect(squareX, squareY, squareSize, squareSize);
}

