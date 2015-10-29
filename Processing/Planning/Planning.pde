// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Tue Jan 07 2014
// 

int width = 512;
int height = 512;
int mapWidth = 256;
int mapHeight = 256;

float buildingWidthMin = 0.075;
float buildingHeightMin = 0.75;
float buildingWidthMax = 0.2;
float buildingHeightMax = 0.2;

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";
ArrayList<PRect> rects;

void setup ()
{
	size(width, height, P3D);
	rects = new ArrayList<PRect>();

	int numBuildings = (int)random(5) + 5;
	for (int i = 0; i < numBuildings; i++) {
		PRect p = new PRect(
					new PVector(mapWidth, mapHeight),
					new PVector(random(buildingWidthMin, buildingWidthMax) * mapWidth, random(buildingHeightMin, buildingHeightMax) * mapHeight)
				);
		rects.add(p);
	}
}

void draw ()
{
	background(255);

	for (int i = 0; i < rects.size(); i++) {
		rect(
			rects.get(i).origin.x,
			rects.get(i).origin.y,
			rects.get(i).size.x,
			rects.get(i).size.y
		);
	}

	/*
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
	*/
}

class PRect {
	public PVector origin;
	public PVector size;

	public PRect (PVector o, PVector s) {
		this.origin = o;
		this.size = s;
	}
}
