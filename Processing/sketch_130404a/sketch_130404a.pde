// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Apr 4 2013
// 

ArrayList<ImageChunk> chunks = new ArrayList<ImageChunk>();
PImage input;
int sqSize = 128;
int width = 1024;
int height = 1024;
String inputName = "3242199272_9ce651ff62_b";

void setup ()
{
	input = loadImage("data/input/" + inputName + ".jpg");
	input.loadPixels();
	size(width, height);
	for (int x = 0; x < input.width; x += sqSize) {
		for (int y = 0; y < input.height; y += sqSize) {
			ImageChunk tmp = new ImageChunk(new PVector(x, y), new PVector(sqSize, sqSize));
			tmp.finalize(input);
			chunks.add(tmp);
		}
	}
	sortChunks();
	render();
}

void render ()
{
	int x = 0;
	int y = 0;
	for (int i = 0; i < chunks.size(); i++) {
		int ichunk = i * sqSize;
		x = ichunk % input.width;
		y = ((ichunk - x) / input.width) * sqSize;
		// x = ((i * sqSize) / input.width) * sqSize;
		// y = ((i * sqSize) % input.width);
		ImageChunk chunk = chunks.get(i);
		copy(
			input,
			(int)chunk.pos.x,
			(int)chunk.pos.y,
			(int)chunk.bounds.x,
			(int)chunk.bounds.y,
			(int)x, // space these out evenly
			(int)y,
			(int)chunk.bounds.x,
			(int)chunk.bounds.y
		);
		noFill();
		stroke(32);
		strokeWeight(1.1);
		rect(x, y, sqSize, sqSize);
	}

	save("data/output/color-diff-" + inputName + sqSize + ".jpg");
}

void sortChunks () {
	ArrayList<ImageChunk> newChunks = new ArrayList<ImageChunk>();
	while (!chunks.isEmpty()) {
		int maxScore = -10;
		ImageChunk maxChunk = null;
		for (ImageChunk c : chunks) {
			if (c.score > maxScore) {
				maxScore = c.score;
				maxChunk = c;
			}
		}
		newChunks.add(maxChunk);
		chunks.remove(maxChunk);
		println(chunks.size());
	}
	chunks = newChunks;
}

public class ImageChunk {
	PVector pos;
	PVector bounds;
	int score;

	public ImageChunk (PVector pos, PVector bounds) {
		this.score = 0;
		this.pos = pos;
		this.bounds = bounds;
	}

	public void finalize (PImage img) {
		int score = 0;
		color mc = img.pixels[0],
			  lmc = img.pixels[0];

		for (int x = (int)this.pos.x; x < this.pos.x + this.bounds.x; x++) {
			for (int y = (int)this.pos.y; y < this.pos.y + this.bounds.y; y++) {
				if (img.pixels.length > y * img.width + x) {
					mc = img.pixels[y * img.width + x];
					score += abs((red(mc) - red(lmc)));
					score += abs((green(mc) - green(lmc)));
					score += abs((blue(mc) - blue(lmc)));
					lmc = mc;
				}
			}
		}
		this.score = abs(score);
	}

	public int compareTo(ImageChunk b) {
		return this.score > b.score ? -1 : 1;
	}

	public boolean equals(ImageChunk b) {
		return false;
	}

}

