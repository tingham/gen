// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Mar 18 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int[] unsorted;

void setup ()
{
	size(width, height);
	unsorted = new int[width];
}

void draw ()
{
	background(200);

	for (int i = 0; i < width; i++) {
		int r = (int)random(width) + (width) / 2;
		unsorted[i] = r;
		stroke(128, 33, 33, 255);
		fill(128, 33, 33, 255);
		strokeWeight(4);
		rect(i, unsorted[i], 4, 4);
	}

	qSort(unsorted, 0, unsorted.length - 1);

	for (int i = 0; i < width; i++) {
		stroke(33, 128, 33, 255);
		fill(33, 128, 33, 255);
		strokeWeight(4);
		rect(i, unsorted[i], 4, 4);
	}

	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

void qSort (int[] list, int l, int h) {
	int i = l;
	int j = h;
	int p = list[l + (h - l) / 2];
	while (i <= j) {
		while (list[i] < p) {
			i++;
		}
		while (list[j] > p) {
			j--;
		}
		if (i <= j) {
			int x = list[i];
			list[i] = list[j];
			list[j] = x;
			i++;
			j--;
		}
	}

	if (l < j) {
		qSort(list, l, j);
	}

	if (i < h) {
		qSort(list, i, h);
	}
}
