/**
 * Rooms
 **/
int width = 128;
int height = 128;

int roomMin = 8;
int roomMax = 12;
int roomCount = 5;

ArrayList rooms;

float[][] data;

int tick = 0;

class Room {
    int x;
    int y;
    int width;
    int height;
    
    public boolean PointInRoom (int _x, int _y) {
      return (_x >= x && _x <= x + width && _y >= y && _y <= y + height);  
    }
}

void setup () {
    size(width, height);
    frameRate(30);
    data = new float[width][height];
    generateRooms();
}

void generateRooms () {
    rooms = new ArrayList();
    while (rooms.size() < roomCount) {
        Room r = new Room();
        r.width = floor(random(roomMin, roomMax));
        r.height = floor(random(roomMin, roomMax));
        r.x = floor(random(0 + (r.width * 0.5), width - (r.width * 0.5)));
        r.y = floor(random(0 + (r.height * 0.5), height - (r.height * 0.5)));
        // check overlap with other rooms
        rooms.add(r);
    }
}

void draw () {
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            stroke(data[x][y] * 255);
            point(x, y);
        }
    }
    tick++;
}

