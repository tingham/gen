// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Wed Jan 09 2013
// 

import java.util.Date;
import java.util.Calendar;

PVector hoursIndicator;
PVector minutesIndicator;
PVector secondsIndicator;

PVector hoursIndicatorTarget;
PVector minutesIndicatorTarget;
PVector secondsIndicatorTarget;

float hoursSize = 10.0;
float minutesSize = 10.0;
float baseSecondsSize = 10.0;
float secondsSize = 10.0;

int width = 1280;
int height = 720;

int tick = 0;

float time;

float hours = 0;
float minutes = 0;
float seconds = 0;

void setup ()
{
	size(width, height, P3D);

	hoursIndicator = new PVector(random(width / 2), random(height / 2), 0);
	minutesIndicator = new PVector(random(width / 2), random(height / 2), 0);
	secondsIndicator = new PVector(random(width / 2), random(height / 2), 0);


	hoursIndicatorTarget = new PVector(width / 2, height / 2, 0);
	minutesIndicatorTarget = new PVector(width / 2, height / 2, 0);
	secondsIndicatorTarget = new PVector(width / 2, height / 2, 0);

	time = Calendar.getInstance().get(Calendar.MILLISECOND);
	
	sphereDetail(10); 
	thread("update");
}

void update ()
{
	while (true) {
		// exec
		Calendar rightNow = Calendar.getInstance();
		seconds = (float)rightNow.get(Calendar.SECOND);
		minutes = (float)rightNow.get(Calendar.MINUTE);
		hours = (float)rightNow.get(Calendar.HOUR_OF_DAY);

		float canvasYBase = height / 2;
		float canvasXBase = width / 2;

		secondsIndicatorTarget = new PVector(
			width / 2,
			canvasYBase + ((seconds / 60) * canvasYBase),
			0.0
		);

		minutesIndicatorTarget = new PVector(
			(cos(minutes) * canvasXBase) + canvasXBase,
			(sin(minutes) * canvasYBase) + canvasYBase,
			((sin(minutes) * canvasXBase) + canvasXBase) * 0.1
		);

		hoursIndicatorTarget = new PVector(
			(sin(hours) * canvasXBase) + canvasXBase,
			(cos(hours) * canvasYBase) + canvasYBase,
			((cos(hours) * canvasXBase) + canvasXBase) * 0.1
		);


		try {
			Thread.sleep(1000);
		} catch (Exception e) {}
	}
}

void draw ()
{
	tick++;

	float deltaTime = (Calendar.getInstance().get(Calendar.MILLISECOND) - time) / 1000;
	if (deltaTime < 0) {
		deltaTime = 0.015;
	}

	secondsIndicator.lerp(
		secondsIndicatorTarget,
		deltaTime
	);

	minutesIndicator.lerp(
		minutesIndicatorTarget,
		deltaTime * 0.00016666667
	);

	hoursIndicator.lerp(
		hoursIndicatorTarget,
		deltaTime * 0.00016666667
	);

	noStroke();

	fill(0, 0, 0, 5);
	rect(0, 0, width, height);

	fill(255, 255, 255, 255);

	pushMatrix();
	translate(width / 2, height / 2, 0);
	sphere(baseSecondsSize);
	popMatrix();

	pushMatrix();
	fill(255, 0, 0, 255);
	translate(secondsIndicator.x, secondsIndicator.y, secondsIndicator.z);
	sphere(secondsSize);
	popMatrix();

	pushMatrix();
	fill(0, 255, 0, 255);
	translate(minutesIndicator.x, minutesIndicator.y, minutesIndicator.z);
	sphere(minutesSize);
	popMatrix();

	pushMatrix();
	fill(0, 0, 255, 255);
	translate(hoursIndicator.x, hoursIndicator.y, hoursIndicator.z);
	sphere(hoursSize);
	popMatrix();

	time = Calendar.getInstance().get(Calendar.MILLISECOND);
}

