// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Sep 03 2013
// 
import java.util.*;
import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

ArrayList<Dot> sourcePoints = new ArrayList<Dot>();
ArrayList<Dot> finalPoints = new ArrayList<Dot>();
Object[] rPoints;

void setup ()
{
	size (width, height, P3D);

	for (int i = 0; i < width; i++) {
		Dot p = new Dot(random(width), random(height));
		sourcePoints.add(p);
	}

	thread("update");
}

void update ()
{
	while (sourcePoints.size() > 0) {

		try {

			ArrayList<Dot> removePoints = new ArrayList<Dot>();

			final Dot p = sourcePoints.get(0);

			finalPoints.add(p);
			sourcePoints.remove(p);

			Collections.sort(sourcePoints, new Comparator<Dot>(){
				public int compare(Dot a, Dot b) {
					if (a.dist(p) < b.dist(p)) {
						return -1;
					}
					return 1;
				}
			});

			finalPoints.add(sourcePoints.get(0));
			sourcePoints.remove(sourcePoints.get(0));

			if (sourcePoints.size() > 0) {
				finalPoints.add(sourcePoints.get(0));
				sourcePoints.remove(sourcePoints.get(0));
			}

			finalPoints.add(p);


			rPoints = finalPoints.toArray();

			Thread.sleep(35);

		} catch (Exception e) {
			println(e);
		}

	}
}

void draw ()
{
	if (rPoints == null) {
		return;
	}

	background(64);

	println(rPoints.length);

	Dot start = (Dot)rPoints[0];
	for (int i = 0; i < rPoints.length; i++) {
		line(start.x, start.y, ((Dot)rPoints[i]).x, ((Dot)rPoints[i]).y);
		ellipse(start.x, start.y, 4, 4);
		start = (Dot)rPoints[i];
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

