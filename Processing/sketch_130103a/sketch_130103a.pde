PImage input;
int downsample = 12;
int tick = 0;
float dotScale = 0.75;

void setup () {
	input = loadImage("input-half.jpg");
	input.loadPixels();
	size(input.width, input.height);
	fill(0);
	rect(0, 0, input.width, input.height);
}

void draw () {
	tick++;
	float as = 0.5 * sin(tick * 0.123) + 0.5;
	float bs = 0.5 * sin(tick * 0.1345) + 0.5;
	float cs = 0.5 * sin(tick * 0.1456) + 0.5;
	float ds = 0.5 * sin(tick * 0.1567) + 0.5;
	int d = downsample;

	stroke(input.pixels[0]);

	int sx = 0,
		sy = 0,
		ax = 0,
		ay = 0,
		bx = 0,
		by = 0,
		index = 0;

	for (int x = 0; x < input.width; x++) {

		for (int y = 0; y < input.height; y++) {

			if (y % d == 0 && x % d == 0) {
				strokeWeight(1.0);
				fill(input.pixels[y * width + x]);
				stroke(input.pixels[y * width + x]);
				rect(x, y, d, d);
				sx = x;
				sy = y;
				ax = (int)(x - (d * 0.25));
				ay = (int)(y - (d * 0.25));
				bx = (int)(x + (d * 0.25));
				by = (int)(y + (d * 0.25));
			}


			int aI = ay * width + ax,
				bI = by * width + bx,
				cI = ay * width + bx,
				dI = by * width + ax;

			if (y % (d / 2) == 0 && x % (d / 2) == 0) {
				if (aI > 0 && aI < input.pixels.length - 1) {
					color mc = input.pixels[aI];
					stroke(mc);
					strokeWeight((brightness(mc) / 255) * (d * as * dotScale));
					point(ax, ay);
				}
				if (bI > 0 && bI < input.pixels.length - 1) {
					color mc = input.pixels[bI];
					stroke(mc);
					strokeWeight((brightness(mc) / 255) * (d * bs * dotScale));
					point(bx, by);
				}
				if (cI > 0 && cI < input.pixels.length - 1) {
					color mc = input.pixels[cI];
					stroke(mc);
					strokeWeight((brightness(mc) / 255) * (d * cs * dotScale));
					point(ax, by);
				}
				if (dI > 0 && dI < input.pixels.length - 1) {
					color mc = input.pixels[dI];
					stroke(mc);
					strokeWeight((brightness(mc) / 255) * (d * ds * dotScale));
					point(bx, ay);
				}

				color mc = input.pixels[y * width + x];
				stroke(red(mc), green(mc), blue(mc), 32);
				strokeWeight((brightness(mc) / 255 * (ds * d)));
				point(sx + (d / 2), sy + (d / 2));

			}

			index++;
		}

	}
	if (tick > 30 && tick < 60) {
		save("data/downsample-dots-" + tick + ".tga");
	}
}
