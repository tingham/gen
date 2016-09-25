// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sat Sep 24 2016
// 

int tick = 0;
int rings = 50;
int ringMod = 5;
float dimensionalFactor = 0.225;
float tooltip_amount = 0.0;
float tooltip_target = 0.0;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

boolean isHeadingIndicatorAbsolute = false;

Agent agent = new Agent();

void setup ()
{
	size(768, 768, P3D);
	noSmooth();

	// for (AType atype: agent.primary) {
	// 	atype.currentValue = random(1.0);
	// }

	agent.x = width * 0.5;
	agent.y = height * 0.5;
}

void draw ()
{
	tooltip_amount = lerp(tooltip_amount, tooltip_target, 1.0 / 30.0);
	tooltip_target = lerp(tooltip_target, 0, 1.0 / 180.0);
	agent.experience = agent.experience + 50.0;

	background(32);

	// TODO: Compartmentalize
	for (AType atype: agent.primary) {
		float cross = atan2(atype.midpointY - (height * 0.5), atype.midpointX - (width * 0.5));

		float x = (cos(cross) * (width * dimensionalFactor)) + width * 0.5;
		float y = (sin(cross) * (height * dimensionalFactor)) + height * 0.5;

		stroke(255, 0, 0);
		ellipse(x, y, 10, 10);

		float distance = sqrt(pow(x - agent.x, 2) + pow(y - agent.y, 2));

		float newValue = 1.0 - (distance / (width * dimensionalFactor));
		if (newValue > atype.currentValue) {
			atype.currentValue = newValue;
		}
		noStroke();
		fill(0, 0, 0, 64);
		strokeWeight(1);
		ellipse(atype.midpointX, atype.midpointY, distance, distance);
	}

	stroke(0, 200, 20);
	strokeWeight(4);

	drawTriangle(agent.primary, -180.0, dimensionalFactor);
	drawTriangle(agent.secondary, 0.0, dimensionalFactor * 2);

	drawOriginIndicator();
	drawConcentricRings();
	drawValueContacts(agent.primary);

	pushMatrix();
	translate(0, 0, 0.1);
	drawCurrentIndicator();
	drawHeadingIndicator();
	popMatrix();

	pushMatrix();
	translate(0, 0, 0.2);
	drawExperienceBar();
	popMatrix();

	// long t = System.currentTimeMillis();
	// if (t % 30 == 0) {
	// 	save(outputName + "s-" + t + ".jpg");
	// }
}

float current_experience = 0.0;
boolean canPerformLevelUp = false;
void drawExperienceBar () {
	current_experience = lerp(current_experience, agent.experience, 1.0 / 60.0);
	fill(0, 200, 20, 128);
	noStroke();
	rect(10, 10, (width - 20) * (((int)current_experience % 1000) / 1000.0), 10);
	if ((int)agent.experience % 1000 == 0) {
		performLevelUp();
	}
}

boolean isPerformingLevelUp = false;
void performLevelUp () {
	if (!isPerformingLevelUp) {
		isPerformingLevelUp = true;

		float headingX = cos(agent.heading);
		float headingY = sin(agent.heading);

		agent.x = agent.x + headingX;
		agent.y = agent.y + headingY;

		println("LevelUp " + agent.x + ", " + agent.y);

		isPerformingLevelUp = false;
	}
}

void mouseMoved () {
	tooltip_target = 1.0;
}

void drawOriginIndicator () {
	fill (0, 200, 20, 32);
	noStroke();
	ellipse(width * 0.5, height * 0.5, width * 0.05, height * 0.05);
}

void drawConcentricRings () {
	noFill();
	for (int i = 0; i < rings; i++) {
		float size = (float)i / (float)rings;
		if (i % ringMod == 0) {
			stroke(0, 200, 20, 32);
			strokeWeight(1.25);
		}
		else {
			stroke(0, 200, 20, 16);
			strokeWeight(0.5);
		}
		ellipse(width * 0.5, height * 0.5, (width * dimensionalFactor * 2) * size, (height * dimensionalFactor * 2) * size);
	}
	stroke(0, 200, 20, 64);
	strokeWeight(2);
	ellipse(width * 0.5, height * 0.5, (width * dimensionalFactor * 2) - 1, (height * dimensionalFactor * 2) - 1);
}

void drawValueContacts (ArrayList<AType> list) {
	float originX = width * 0.5;
	float originY = height * 0.5;

	for (AType atype: list) {
		float amountWidth = (atype.currentValue * (width * dimensionalFactor));
		float amountHeight = (atype.currentValue * (height * dimensionalFactor));

		// TODO the x and y are wrong here, we're like 75% short.
		float cross = radians(degrees(atan2(atype.midpointY - originY, atype.midpointX - originX)));
		float x = (cos(cross) * amountWidth) + originX;
		float y = (sin(cross) * amountHeight) + originY;

		stroke(0, 200, 20, 96);
		ellipse(x, y, 8, 8);
	}
}

void drawCurrentIndicator () {
	noStroke();
	fill(0, 200, 20, 255);
	ellipse((int)agent.x, (int)agent.y, 28, 28);
	fill(64, 64, 64, 128);
	ellipse((int)agent.x, (int)agent.y, 8, 8);
}

void drawHeadingIndicator () {
	float halfWidth = width * 0.5;
	float halfHeight = height * 0.5;

	if (!isHeadingIndicatorAbsolute) {
		halfWidth = agent.x;
		halfHeight = agent.y;
	}

	noStroke();

	// tracks the mouse position if the button is down.
	if (mousePressed && mouseButton == LEFT) {
		float cross = degrees(atan2(mouseY - halfHeight, mouseX - halfWidth)) - 90.0;

		cross = cross - (float)((int)cross % (360 / agent.primary.size()));

		agent.heading = atan2(mouseY - halfHeight, mouseX - halfWidth);

		pushMatrix();
		translate(halfWidth, halfHeight);
		rotateZ(radians(cross));
		fill(0, 0, 0, 128);
		triangle(0, 12, 6, -4, -6, -4);
		fill(0, 200, 20, 128);
		triangle(0, 10, 5, -4, -5, -4);
		popMatrix();
	}
}

void drawTriangle (ArrayList<AType> list, float start_angle, float size) {
	float angle_increment = 360.0 / list.size();
	float current_angle = start_angle;

	float halfWidth = width * 0.5;
	float halfHeight = height * 0.5;

	float sizeWidth = width * size;
	float sizeHeight = height * size;

	int index = 0;

	for (AType atype: list) {
		float x1 = (sin(radians(current_angle)) * sizeWidth) + halfWidth;
		float y1 = (cos(radians(current_angle)) * sizeHeight) + halfHeight;

		current_angle = current_angle + angle_increment;

		float x2 = (sin(radians(current_angle)) * sizeWidth) + halfWidth;
		float y2 = (cos(radians(current_angle)) * sizeHeight) + halfHeight;

		line(x1, y1, x2, y2);

		float x3 = (x1 + x2) * 0.5;
		float y3 = (y1 + y2) * 0.5;

		atype.midpointX = x3;
		atype.midpointY = y3;

		float cross = atan2(y2 - y1, x2 - x1);

		float alpha = tooltip_amount * 128;

		textAlign(CENTER);
		textSize(20);
		fill(0, 200, 20, int(alpha));

		pushMatrix();
		translate(x3, y3);
		rotateZ(cross);
		text(atype.name + " (" + nf(atype.currentValue * 50, 2, 1) + ")", 0, 20);
		popMatrix();

		index++;
	}
}

class Agent {
	ArrayList<AType> primary = new ArrayList<AType>();
	ArrayList<AType> secondary = new ArrayList<AType>();
	float experience = 0.0;
	float heading = 0.0;
	float x = 0.0;
	float y = 0.0;

	Agent () {
		this.primary.add(new AType("Strength"));
		this.primary.add(new AType("Intellect"));
		this.primary.add(new AType("Dexterity"));

		this.secondary.add(new AType("Charisma"));
		this.secondary.add(new AType("Resilience"));
		this.secondary.add(new AType("Willpower"));
	}
}

class AType {
	String name;
	float currentValue = 0.0;
	float midpointX = 0.0;
	float midpointY = 0.0;

	AType (String _name) {
		this.name = _name;
	}
}
