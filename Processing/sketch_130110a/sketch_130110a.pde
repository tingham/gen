// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jan 10 2013
// 

import java.util.Calendar;

class MVector {
	PVector p;

	public MVector (float x, float y, float z) {
		this.p = new PVector(x, y, z);
	}

	public void Slerp(MVector end, float value)
	{
		this.p.x = lerp(this.p.x, end.p.x, sin(value * PI * 0.5));
		this.p.y = lerp(this.p.y, end.p.y, cos(value * PI * 0.5));
		this.p.z = lerp(this.p.z, end.p.z, value);
	}

}

int width = 1280;
int height = 720;

MVector mv = new MVector(random(width), random(height), 0);
MVector target = new MVector(random(width), random(height), 0);

float time = 0;
float deltaTime = 0;
float shiftDistance = 50;

int tick = 0;

void setup ()
{
	size(width, height, P3D);

	time = Calendar.getInstance().get(Calendar.MILLISECOND);

	sphereDetail(10);
}

void draw ()
{
	tick++;

	deltaTime = max(min(Calendar.getInstance().get(Calendar.MILLISECOND) - time, 0.015), 1.0);

	mv.Slerp(target, deltaTime * 0.001);

	fill(255, 255, 255, 128);
	noStroke();
	pushMatrix();
	translate(mv.p.x, mv.p.y, mv.p.z);
	sphere(10);
	popMatrix();

	time = Calendar.getInstance().get(Calendar.MILLISECOND);


	target.Slerp(
		new MVector(
			(random(-shiftDistance, shiftDistance) + target.p.x),
			(random(-shiftDistance, shiftDistance) + target.p.y),
			random(-5, 5) + target.p.z
		),
		deltaTime * 5
	);

	fill(0, 0, 0, 5);
	rect(0, 0, width, height);
}

