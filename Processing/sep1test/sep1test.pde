// # sep1test
// **Created By:** + tingham
// **Created On:** + Sun Sep 01 2019
// 

import java.util.Collections;

int tick = 0;
String outputName = "data/output/" + System.currentTimeMillis() + "/";

IntList working_pixels = null; // new Int();// = new color[];
ArrayList<Chunk> chunks = null;

int chunk_count_x = 2;
int chunk_count_y = 2;
boolean is_building = false;

void setup ()
{
  size(1024, 1024);

  PImage img = loadImage("data/input/IMG_0342.jpeg");
  image(img, 0, 0);

  //float random_r = random(0.5, 2.0);
  //float random_g = random(0.5, 2.0);
  //float random_b = random(0.5, 2.0);

  //noiseSeed(int(random(255.0)));

  //loadPixels();
  //for (int i = 0; i < width * height; i++) {
  //  int x = i % width;
  //  int y = (i - x) / width;
  //  int n1 = int(noise(x / (width * random_r), y / (height * random_r)) * 255);
  //  int n2 = int(noise(y / (height * random_g), x / (width * random_g)) * 255);
  //  int n3 = int(noise(x / (width * random_b), y / (height * random_b)) * 255);

  //  n1 = (n1 > 160 ? n1 + 32 : n1 < 96 ? n1 - 32 : n1);
  //  n2 = (n2 > 160 ? n2 + 32 : n2 < 96 ? n2 - 32 : n2);
  //  n3 = (n3 > 160 ? n3 + 32 : n3 < 96 ? n3 - 32 : n3);

  //  pixels[i] = color(n1, n2, n3, 255);
  //}
  //working_pixels = new IntList(pixels);

  loadPixels();
  build();
  for (int c = 0; c < chunks.size(); c++) {
    chunks.get(c).stripe();
  }
  updatePixels();

  //thread("update");

  Collections.sort(chunks);
  draw_once();
  noLoop();
	long t = System.currentTimeMillis();
  save(outputName + "s-" + t + ".jpg");
}

void build () {
  is_building = true;

  chunks = new ArrayList<Chunk>();

  for (int x = 0; x < chunk_count_x; x++) {
    for (int y = 0; y < chunk_count_y; y++) {
      int _width = width / chunk_count_x;
      int _height = height / chunk_count_y;
      Chunk chunk = new Chunk(pixels, x * _width, y * _height, _width, _height);
      chunks.add(chunk);
    }
  }
  is_building = false;
}

void update () {
  while(true) {
    tick++;
    try {
      Thread.sleep(2);
      Collections.sort(chunks);
    } catch (Exception e) {
    }
  }
}

void flow_sort () {
  for (int i = 0; i < chunks.size(); i++) {
    int x = i % chunk_count_x;
    int y = (i - x) / chunk_count_x;

    int left_index = y * chunk_count_x + (x - 1);
    int down_index = (y + 1) * chunk_count_x + x;
    int up_index = (y - 1) * chunk_count_x + x;
    int right_index = y * chunk_count_x + (x + 1);

    if (left_index > -1 && up_index > -1 && right_index <= chunk_count_x * chunk_count_y && down_index <= chunk_count_x * chunk_count_y) {
      if (chunks.get(up_index).average_red > chunks.get(i).average_red) {
        swap(chunks, up_index, i);
      } else {
        swap(chunks, i, up_index);
      }
      if (chunks.get(left_index).average_red > chunks.get(i).average_red) {
        swap(chunks, left_index, i);
      } else {
        swap(chunks, i, left_index);
      }
    }
  }
}

void swap (ArrayList<Chunk> in, int at, int to) {
  Chunk _d = in.get(to);
  in.set(to, in.get(at));
  in.set(at, _d);
}

void swap (IntList in, int at, int to) {
  int _d = in.get(to);
  in.set(to, in.get(at));
  in.set(at, _d);
}

void draw ()
{
  if (!is_building) {
  //  draw_once();
  }
  // loadPixels();
  /*
  for (int p = 0; p < pixels.length; p++) {
    pixels[p] = working_pixels.get(p);
  }
  */
  // updatePixels();
	long t = System.currentTimeMillis();
	if (t % 30 == 0) {
		//save(outputName + "s-" + t + ".jpg");
	}
}

void draw_once () {
  loadPixels();
  for (int c = 0; c < chunks.size(); c++) {
    Chunk chunk = chunks.get(c);
    int chunk_x = c % chunk_count_x;
    int chunk_y = (c - chunk_x) / chunk_count_x;
    chunk_x *= (width / chunk_count_x);
    chunk_y *= (height / chunk_count_y);
    // println(chunk_x + ", " + chunk_y);
    for (int p = 0; p < chunk.data.size(); p++) {
      int pixel_x = p % chunk.snip_width;
      int pixel_y = (p - pixel_x) / chunk.snip_width;
      // println("\t" + pixel_x + ", " + pixel_y);
      int x = chunk_x + pixel_x;
      int y = chunk_y + pixel_y;
      int pixel = chunk.data.get(p);
      pixels[(y * width) + x] = pixel;
    }
  }
  updatePixels();
}

class Chunk implements Comparable<Chunk> {
  public IntList data;

  public int average;
  public int average_red;
  public int average_green;
  public int average_blue;

  public int sum_red;
  public int sum_green;
  public int sum_blue;

  public int snip_width;
  public int snip_height;

  public Chunk (int[] pixels, int x, int y, int snip_width, int snip_height) {
    this.snip_width = snip_width;
    this.snip_height = snip_height;
    this.data = new IntList();
    int index = 0;
    for (int _x = x; _x < (snip_width + x); _x++) {
      for (int _y = y; _y < (snip_height + y); _y++) {
        int pixel = pixels[_y * width + _x];
        this.sum_red += red(pixel);
        this.sum_green += green(pixel);
        this.sum_blue += blue(pixel);
        this.data.append(pixel);
      }
    }
    this.average_red = this.sum_red / this.data.size();
    this.average_green = this.sum_green / this.data.size();
    this.average_blue = this.sum_blue / this.data.size();
    this.average = (this.average_red + this.average_green + this.average_blue) / 3;
  }

  public void stripe () {
    for (int i = 0; i < this.data.size(); i++ ) {
      int x = i % this.snip_width;
      int y = (i - x) /  this.snip_width;
      if (x == 0) {
        this.data.set(i, color(0));
      }
      if (y == 0) {
        this.data.set(i, color(0));
      }
      if (x == this.snip_width -1 ) {
        this.data.set(i, color(0));
      }
      if (y == this.snip_width -1 ) {
        this.data.set(i, color(0));
      }
    }
  }

  @Override
  int compareTo(Chunk c2) {
    int a = this.sum_red + this.sum_green + this.sum_blue;
    int b = c2.sum_red + c2.sum_green + c2.sum_blue;
    return a - b;
  }
}
