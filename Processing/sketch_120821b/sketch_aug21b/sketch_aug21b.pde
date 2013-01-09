/**
 * Diamond Noise Map
 * @author: T.C. Ingham
 * @brief: Generates a noise map at scale using diamond algorithm.
 * @discussion: Suitable for island height maps, underground locations, spitball textures, etc.
 * It's worth pointing out that we're not using any built-in methods of processing here for
 * for the express purpose of portability. e.g. We actually use this code in a C# wrapper for Unity3d.
 * We do use processing to output the final image, obviously.
 **/

// animation timer
int tick = 0;

// dimensions
int srcWidth = 64;
int srcHeight = 64;

// by driving the output scale you can output images larger (or smaller) than your intended map resolution.
// consider solutions where instead of doing SDS for heightmap conversion, you simply blur the image a bit.
float outputScale = 8.0;

// Generated map data.
float data[][];

// Will optionally save a file result for your image (requires a ./data directory.)
boolean storeResults = false;
boolean storeFrames = true;

/*** Image Controls ***/

// Specify starting seeds for the corners of your image.
float[] cornerValues = new float[]{0.0, 0.0, 0.0, 0.0};

// each subdivision of the map can have an interpreted scale factor.
// Larger values result in a smoother output.
float fScale = 4.0;

// the amount of randomness to add to each generated mid-point.
float fRoughness = 0.1;

void setup () {
  // Establish a canvas size for your output.
  size(floor(srcWidth * outputScale), floor(srcHeight * outputScale));
  
  // Initialize your data array.
  data = new float[srcWidth][srcHeight];
  
  // Set framerate to ensure we don't generate a bazillion maps (if we're saving files.)
  frameRate(10);
}

void draw () {

  float c1 = cornerValues[0];
  float c2 = cornerValues[1];
  float c3 = cornerValues[2];
  float c4 = cornerValues[3];
  float r = 0.001;
  float g = 0.001;
  float b = 0.001;
  
  subdivide(0, 0, srcWidth, srcHeight, c1, c2, c3, c4);

  for (int x = 0; x < srcWidth; x++) {
    for (int y = 0; y < srcHeight; y++) {
      if (srcWidth == srcHeight)
      {
        // Applies a 90 degree rotation (simple) and overlays colors to smooth.
        r = lerp(r, pound(data[x][y] + (data[y][x] * 0.125), 1), b);
        g = lerp(g, pound(data[x][y] + (data[y][x] * 0.125), 1), r);
        b = lerp(g, pound(data[x][y] + (data[y][x] * 0.125), 1), g);
      }
      else {
        // No-hack applicator.
        b = pound(data[x][y], 1);
      }
      if (outputScale == 1.0) {
        stroke(b * 255);
        point(x, y);
      } 
      else {
        noStroke();
        fill(r * 255, g * 255, b * 255);
        float _x = (x * outputScale) - (outputScale * 0.5);
        float _y = (y * outputScale) - (outputScale * 0.5);
        float _w = x + outputScale;
        float _h = y + outputScale;
        rect(_x, _y, _w, _h);
      }
    }
  }
  tick++;

  if (storeResults)
  {
    Date d = new Date();
    save("data/" + srcWidth + "x" + srcHeight + "_w" + outputScale + "-" + (d.getTime() / 1000) + "-sketch.jpg");
  }
  
  if (storeFrames) {
     saveFrame("data/" + srcWidth + "x" + srcHeight + "_w" + outputScale + "-####.jpg");
  }
}

// Truncate a float.
float pound(float val, int dp)
{
  return int(val*pow(10, dp))/pow(10, dp);
}

void subdivide (int x, int y, int w, int h, float c1, float c2, float c3, float c4)
{
  float e1, e2, e3, e4;
  float middle, c;
  int newWidth = w / 2;
  int newHeight = h / 2;
  int ix, iy;

  if (w > 1 && h > 1)
  {
    if (x == 0 && y == 0 && w == srcWidth && h == srcHeight)
    {
      middle = random(0.75, 1.0);
    } 
    else {
      middle = max(0, min(1, ((c1 + c2 + c3 + c4) * 0.25) + displace(newWidth + newHeight)));
    }
    e1 = max(0, min(1, (c1 + c2) * 0.5));
    e2 = max(0, min(1, (c2 + c3) * 0.5));
    e3 = max(0, min(1, (c3 + c4) * 0.5));
    e4 = max(0, min(1, (c4 + c1) * 0.5));

    subdivide(x, y, newWidth, newHeight, c1, e1, middle, e4);
    subdivide(x + newWidth, y, w - newWidth, newHeight, e1, c2, e2, middle);
    subdivide(x + newWidth, y + newHeight, w - newWidth, h - newHeight, middle, e2, c3, e3);
    subdivide(x, y + newHeight, newWidth, h = newHeight, e4, middle, e3, c4);
  }
  else
  {
    c = (c1 + c2 + c3 + c4) * 0.25;
    ix = (int)floor(x);
    iy = (int)floor(y);
    data[ix][iy] = c;
    if (w == 2)
    {
      data[ix + 1][iy] = c; // lerp(data[ix + 1][iy], c, 0.5);
    }
    if (h == 2)
    {
      data[ix][iy + 1] = c; // lerp(data[ix][iy + 1], c, 0.5);
    }
    if (w == 2 && h == 2)
    {
      data[ix + 1][iy + 1] = c; // lerp(data[ix + 1][iy + 1], c, 0.5);
    }
  }
}

float displace (float s)
{
  float fMax = (s / fScale) * fRoughness;
  return (random(0.0, 1.0) - 0.5) * fMax;
}

