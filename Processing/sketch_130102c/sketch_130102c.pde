int width = 256;
int height = 256;
int tick = 0;

public class Vector2 {
  float x;
  float y;
  public Vector2 (float _x, float _y) {
    this.x = _x;
    this.y = _y;
  }
}

Vector2 v0 = new Vector2(random(width), random(height));
Vector2 v1 = new Vector2(random(width), random(height));

void setup () {
   size(width, height);
   fill(255);
   stroke(255);
   rect(0, 0, width, height);
   curve(v0, v1);
}

void draw () {
  tick++;
  v0.x = (0.5 + sin(tick * 0.01) * 0.5) * width;
  v0.y = (0.5 + sin(tick * 0.005) * 0.5) * height;
  v1.x = (0.5 + cos(tick * 0.01) * 0.5) * width;
  v1.y = (0.5 + cos(tick * 0.005) * 0.5) * height;
  
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(sin(tick * 10));
  curve(v0, v1);
  popMatrix();
}

void curve (Vector2 from, Vector2 to) {
  fill(255, 0, 0);
  rect(from.x, from.y, 2, 2);
  fill(0, 255, 0);
  rect(to.x, to.y, 2, 2);
  
  int steps = 360;
  Vector2 mid = new Vector2(
    from.x + to.x / 2,
    from.y + to.y / 2
  );
  float r = TWO_PI / 360;
  for (int i = 0; i < steps; i++) {
    float angle = i * r;
    from.x = mid.x + cos(angle);
    from.y = mid.y + sin(angle);
    to.x = mid.x + sin(angle);
    to.y = mid.x + cos(angle);
    stroke(0, 0, 0, sin(tick) * 255);
    point(from.x, from.y);
  }
}

Vector2 vlerp (Vector2 a, Vector2 b, float t) {
  return new Vector2(
    lerp(a.x, b.x, t),
    lerp(a.y, b.y, t)
  );
}
