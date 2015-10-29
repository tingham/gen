// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Sun Mar 17 2013
// 

int width = 512;
int height = 512;
int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

int[] unsortedList = new int[width];

void setup ()
{
	size(width, height);
}

void draw ()
{
	tick++;
	if (tick >= width) {
		tick = 0;
	}

	for (int i = 0; i < tick; i++) {
		unsortedList[i] = (int)random(tick);
	}
	int[] sortedList = bSort(unsortedList);

	for (int x = 0; x < sortedList.length; x++) {
		stroke(33, 33, 33, 128);
		rect(x, sortedList[x], 2, sortedList[x] * 0.5);
	}
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		save(outputName + "s-" + t + ".jpg");
	}
}

int[] bSort (int[] list) {
	int length = list.length;
	boolean work = true;

	while (work) {
		work = false;
		for (int i = 1; i < length; i++) {
			if (list[i - 1] > list[i]) {
				int a = list[i - 1];
				int b = list[i];
				list[i] = a;
				list[i - 1] = b;
				work = true;
			}
		}
		length--;
	}
	return list;
}
