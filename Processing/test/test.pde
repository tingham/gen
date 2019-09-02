// # test
// **Created By:** + tingham
// **Created On:** + Fri Jul 20 2018
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

float wind = 45f;
float sail = 0f;
float rudder = 0f;
float heading = 0f;

float windInput = 0f;
float lastMouse = -1;

void setup ()
{
  size(512, 512);
}

void draw ()
{
	long t = System.currentTimeMillis();
  calculateHeading();

  background(128);
  stroke(0);

  // sail = sin(tick * 0.01) * 180;
  // rudder = sin(tick * 0.1) * 45;
  // wind = windInput * 360;

  headingCompass();
  sailLine();
  rudderLine();
  windGlyph();

	if (t % 30 == 0) {
		// save(outputName + "s-" + t + ".jpg");
	}
  tick++;
}

void calculateHeading () {
  heading = (wind - (sail - rudder));
}

void mouseDown () {
  lastMouse = mouseX;
}

void mouseDragged () {
  float delta = (lastMouse - mouseX) * 0.1f;

  if (mouseButton == LEFT) {
    sail = clamp((sail + delta), 0f, 360f);
  } else if (mouseButton == RIGHT) {
    wind = clamp((wind + delta), 0f, 360f);
  } else if (mouseButton == CENTER) {
    rudder = clamp((rudder + delta), -45f, 45f);
  }

  lastMouse = mouseX;
}

void sailLine () {
  pushMatrix();

    translate(width * 0.5f, height * 0.5f);

    rotate(radians(sail));

    fill(245);
    triangle(-10, 64, 0, -64, 10, 64);

  popMatrix();
}

void rudderLine () {
  pushMatrix();

    translate(width * 0.5f, (height * 0.5f) + 64);

    rotate(radians(rudder));

    fill(128, 95, 10);
    triangle(-10, 2, 0, 96, 10, 2);
    fill(200);
    textAlign(CENTER);
    text(String.format("%.2f", rudder), 0, 104);

  popMatrix();
}

void windGlyph () {
  pushMatrix();
    translate(width * 0.1f, height * 0.9f);
    rotate(radians(wind));
    fill(25, 128, 128);
    ellipse(0, 0, 64, 64);
    fill(190, 128, 10);
    triangle(-8, 30, 0, -30, 8, 30);
    rotate(-radians(wind));
    fill(200);
    textAlign(CENTER);
    text(String.format("%.2f %.2f", wind, windInput), 0, 44);
  popMatrix();
}

void headingCompass () {
  pushMatrix();
    translate(width * 0.5f, (height * 0.5f) + 64);
    rotate(radians(heading));
    fill(64);
    stroke(32);
    float dim = width * 0.35f;
    ellipse(0, 0, dim, dim);
    fill(96);
    triangle(
        (dim * -0.5f), 0, // left
        0, (dim * -0.5f), // center
        (dim * 0.5f), 0
        );
  popMatrix();
}

float clamp(float val, float min, float max) {
    return max(min, min(max, val));
}
