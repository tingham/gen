// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jan 10 2013
// 

import java.util.Calendar;

ArrayList<Blob> blobs = new ArrayList<Blob>();
float time;
float deltaTime = 0;
int tick = 0;
int width = 1280;
int height = 720;
int sphereSize = 10;
int sphereDetail = 6;
int particleCount = 50;

class Blob {
	PVector p;
	PVector t;
	float speed;

	public Blob (PVector p, PVector t) { 
		this.p = p;
		this.t = t;
		this.speed = random(1);
	}

	public void AcquireNewTarget ()
	{
		for (int i = 0; i < blobs.size(); i++) {
			Blob b = blobs.get(i);
			if (b != this) {
				if (abs(this.p.dist(b.p)) < sphereSize * sphereSize) {
					PVector diff = new PVector(random(width), random(height));
				   	PVector.sub(b.t, this.t, diff);
					this.t.lerp(diff, deltaTime);
				}
			}
		}
	}
}

void setup ()
{
	time = Calendar.getInstance().get(Calendar.MILLISECOND);

	size(width, height, P3D);

	for (int i = 0; i < particleCount; i++) {
		blobs.add(
			new Blob(
				new PVector(random(width), random(height)),
				new PVector(random(width), random(height))
			)
		);
	}

	sphereDetail(sphereDetail);

	thread("update");
}

void update ()
{
	while (true) {
		try {
			for (int i = 0; i < blobs.size(); i++) {
				Blob b = blobs.get(i);
				b.p.lerp(b.t, deltaTime * b.speed);
				b.AcquireNewTarget();
			}
			Thread.sleep(80);
		} catch (Exception e) {

		}
	}
}

void draw ()
{
	tick++;
	background(0, 1);

	deltaTime = (Calendar.getInstance().get(Calendar.MILLISECOND) - time) / 1000;
	if (deltaTime < 0.0) {
		deltaTime = 0.015;
	}

	fill(255, 255, 255, 255);
	stroke(0, 0, 0, 128);

	for (int i = 0; i < blobs.size(); i++) {
		Blob b = blobs.get(i);
		pushMatrix();
		translate(b.p.x, b.p.y);
		sphere(sphereSize);
		popMatrix();
	}

	time = Calendar.getInstance().get(Calendar.MILLISECOND);
}

