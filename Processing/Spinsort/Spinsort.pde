// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Mon Sep 23 2013
// 

import com.mutiny.*;

int width = 512;
int height = 512;
int tick = 0;

String outputName = "data/output/" + System.currentTimeMillis() + "/";

boolean output = false;

Dot[] originalPixels;
Dot[] finalPixels;

void setup ()
{
	size(width, height, P3D);

	originalPixels = new Dot[width * height];
	finalPixels = new Dot[width * height];

	loadPixels();
	for (int i = 0; i < width * height; i++) {
		float x = (float)(i % width);
		float y = (float)(i - x) / width;
		float f1 = noise(x / width, y / height);
		float f2 = noise((x / width) * 2, (y / height) * 2);
		float f3 = noise((x / width) * 3, (y / height) * 3);
		pixels[i] = new Dot(f1, f2, f3, 1.0, 1.0).Color();
	}
	updatePixels();

	for (int i = 0; i < 32; i++) {
		float s = random((width + height / 2) * 0.125, (width + height / 2) * 0.5);
		float x = random(s * 0.6, width - (s * 0.6));
		float y = random(s * 0.6, height - (s * 0.6));


		float r = (float)random(255);
		float g = (float)random(255);
		float b = (float)random(255);
		float a = (float)random(255);

		stroke(r * 0.9, g * 0.9, b * 0.9, a * 0.9);

		fill(r, g, b, a * 0.1);
		ellipse(x, y, s, s);

		fill(r + random(4), g + random(4), b + random(4), a * 0.2);
		ellipse(x, y, s * 0.9, s * 0.9);

		fill(r + random(8), g + random(8), b + random(8), a * 0.3);
		ellipse(x, y, s * 0.8, s * 0.8);

		fill(r + random(12), g + random(12), b + random(12), a * 0.4);
		ellipse(x, y, s * 0.7, s * 0.7);

		fill(r + random(16), g + random(16), b + random(16), a * 0.5);
		ellipse(x, y, s * 0.6, s * 0.6);

		fill(r + random(20), g + random(20), b + random(20), a * 0.6);
		ellipse(x, y, s * 0.5, s * 0.5);

		fill(r + random(24), g + random(24), b + random(24), a * 0.7);
		ellipse(x, y, s * 0.4, s * 0.4);

		fill(r + random(28), g + random(28), b + random(28), a * 0.8);
		ellipse(x, y, s * 0.3, s * 0.3);
	}

	loadPixels();
	for (int i = 0; i < originalPixels.length; i++) {
		Dot d = new Dot(
				(float)red(pixels[i]) / 255,
				(float)green(pixels[i]) / 255,
				(float)blue(pixels[i]) / 255,
				1.0,
				1.0
			);
		originalPixels[i] = d;
		finalPixels[i] = d;
	}
}

void spinPixels ()
{
	float offsetIncrement = (float)1.0 / (float)finalPixels.length;

	float sp = 0.01;
	float center = width * 0.5;

	int count = (int)(width * width);
	int pIndex = 0;

	for (int i = -count; i < count; i++) {

		float x = center + (sin(i) * sp);
		float y = center + (cos(i) * sp);

		sp = lerp(sp, width, 0.01);

		int index = (int)(y * width + x);

		if (index > 0 && index < finalPixels.length) {
			// finalPixels[index] = finalPixels[index].darker(0.1);
			if (finalPixels[index].Sum() > finalPixels[pIndex].Sum() && finalPixels[index].power > 0) {
				finalPixels[index].power -= 0.1;
				SwapDots(index, pIndex);
			}
			pIndex = index;
		}

	}
}

void finalizePixels ()
{
	for (int i = 0; i < originalPixels.length; i++) {
		int x = i % width;
		int y = (i - x) / width;
		int up = (y - 1) * width + x;
		int down = (y + 1) * width + x;
		int left = y * width + (x + 1);
		int right = y * width + (x - 1);
		int lastMove = 0;
		
		if (up > 0 && down < finalPixels.length && right > 0 && left < finalPixels.length) {
			if (tick % 300 == 0) {
				spinSort(i, up, down, left, right);
				continue;
			}
			if (tick % 3 == 0) {
				colorShift(i, up, down, left, right);
				continue;
			}
			if (tick % 2 == 0) {
				lastMove = rotateSort(i, up, down, left, right, lastMove);
				continue;
			}
		}
	}
}

int rotateSort(int i,int up, int down, int left, int right, int lastMove)
{
	int result = i;

	if (originalPixels[left].r + originalPixels[up].g > originalPixels[right].r + finalPixels[down].g) {
		if (lastMove == up) {
			result = left;
		}
		else {
			result = right;
		}
	SwapDots(i, result);
	return result;
	}

	if (originalPixels[up].g + originalPixels[right].b > originalPixels[down].g + finalPixels[left].b) {
		if (lastMove == right) {
			result = up;
		}
		else {
			result = down;
		}
	SwapDots(i, result);
	return result;
	}

	if (originalPixels[right].b + originalPixels[down].r > originalPixels[left].b + finalPixels[up].r) {
		if (lastMove == down) {
			result = left;
		}
		else {
			result = up;
		}
	SwapDots(i, result);
	return result;
	}
	
	return result;
}

void spinSort (int i, int up, int down, int left, int right)
{
	if (finalPixels[i].r < finalPixels[up].r) {
		// delta down is the angle
		// delta up is the radius
		float angle = (finalPixels[up].r - finalPixels[down].r) * 0.125;
		float radius = width * (finalPixels[up].r - finalPixels[i].r);
		float fx = sin(angle) * radius;
		float fy = cos(angle) * radius;

		int newIndice = (int)(fy * width + fx);
		if (newIndice > 0 && newIndice < finalPixels.length) {
			SwapDots(i, newIndice);
		}
	}

	if (finalPixels[i].g < finalPixels[left].g) {
		// delta right is the angle
		// delta left is the radius
		float angle = (finalPixels[left].g - finalPixels[right].g) * 0.125;
		float radius = width * (finalPixels[left].g - finalPixels[i].g);
		float fx = sin(angle) * radius;
		float fy = cos(angle) * radius;

		int newIndice = (int)(fy * width + fx);
		if (newIndice > 0 && newIndice < finalPixels.length) {
			SwapDots(i, newIndice);
		}
	}

	if (finalPixels[i].b < finalPixels[down].b) {
		// delta up is the angle
		// delta down is the radius
		float angle = (finalPixels[down].b - finalPixels[up].b) * 0.125;
		float radius = width * (finalPixels[down].b - finalPixels[i].b);
		float fx = sin(angle) * radius;
		float fy = cos(angle) * radius;

		int newIndice = (int)(fy * width + fx);
		if (newIndice > 0 && newIndice < finalPixels.length) {
			SwapDots(i, newIndice);
		}
	}
}

void colorShift (int i, int up, int down, int left, int right)
{
	if (finalPixels[i].r < finalPixels[up].r) {
		SwapDots(i, up);
	}
	else {
		SwapDots(i, left);
	}

	if (finalPixels[i].g < finalPixels[right].g) {
		SwapDots(i, right);
	}
	else {
		SwapDots(i, down);
	}

	if (finalPixels[i].b < finalPixels[down].b) {
		SwapDots(i, down);
	}
	else {
		int dir = (int)random(4);
		switch (dir) {
			case 0:
				SwapDots(i, right);
				break;
			case 1:
				SwapDots(i, left);
				break;
			case 2:
				SwapDots(i, up);
				break;
			case 3:
				SwapDots(i, down);
				break;
		}
	}
}

void SwapDots (int a, int b) {
	Dot d0 = finalPixels[a];
	finalPixels[a] = finalPixels[b];
	finalPixels[b] = d0;
}

void draw ()
{
	tick++;
	
	//finalizePixels();

	spinPixels();

	loadPixels();
	for (int i = 0; i < finalPixels.length; i++) {
		pixels[i] = finalPixels[i].Color();
	}
	updatePixels();

	if (output) {
		long t = System.currentTimeMillis();
		if (t % 30 == 0) {
			save(outputName + "s-" + t + ".jpg");
		}
	}
}

