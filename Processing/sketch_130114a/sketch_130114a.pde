// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Jan 14 2013
// 

import java.util.Calendar;

ArrayList<MVector> mvs = new ArrayList<MVector>();
int width = 1280;
int height = 720;
int limit = 50;

class MVector {
	PVector p;
	int maxConnections;
	int connections;

	public MVector (float x, float y) {
		this.p = new PVector(x, y);
		this.maxConnections = (int)random(50);
	}
}

void setup ()
{
	for (int i = 0; i < limit; i++) {
		mvs.add(
			new MVector(random(width), random(height))
		);
	}

	size(width, height);
}

void draw ()
{
	MVector mv = mvs.get((int)random(mvs.size() - 1));
	lines(mv);
	stroke(128, 0, 0);
	noFill();
	ellipse(
		mv.p.x,
		mv.p.y,
		mv.connections + 1.0,
		mv.connections + 1.0
	);

	if (random(1) > 0.5) {
		save("data/output/d" + System.currentTimeMillis() + ".jpg");
	}
}

void lines (MVector m) {
	for (int i = 0; i < mvs.size(); i++) {
		if (mvs.get(i).connections < mvs.get(i).maxConnections &&
			m.connections < m.maxConnections) {
			mvs.get(i).connections++;
			m.connections++;

			stroke(0);
			strokeWeight(0.5);
			line(m.p.x, m.p.y, mvs.get(i).p.x, mvs.get(i).p.y);
		}
	}
}
