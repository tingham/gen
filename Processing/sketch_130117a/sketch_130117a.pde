
// # MyProcessingSketch
// **Created By:** + tingham
// **Created On:** + Thu Jan 17 2013
// 
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.processing.LeapMotion;
import com.leapmotion.leap.processing.*;

LeapMotion leapMotion;
com.leapmotion.leap.Vector avgPos = com.leapmotion.leap.Vector.zero();

int width = 1024;
int height = 1024;

void setup()
{
	size(width, height);
	background(20);

	leapMotion = new LeapMotion(this);
}

void draw()
{
	fill(20, 20, 20, 20);
	rect(0, 0, width, height);

	fill(255, 255, 255, 128);
	ellipse(avgPos.get(0), avgPos.get(1), avgPos.get(2), avgPos.get(2));
}

void onInit(final Controller controller)
{
	println("Initialized");
}

void onConnect(final Controller controller)
{
	println("Connected");
}

void onDisconnect(final Controller controller)
{
	println("Disconnected");
}

void onExit(final Controller controller)
{
	println("Exited");
}

void onFrame(final Controller controller)
{
	// println("Frame" + controller.frame().hands().count());
  com.leapmotion.leap.Frame frame = (com.leapmotion.leap.Frame)controller.frame();
  if (!frame.hands().empty()) {
    com.leapmotion.leap.Hand hand = frame.hands().get(0);
    com.leapmotion.leap.FingerList fingers = hand.fingers();
    if (!fingers.empty()) {
      
                // Calculate the hand's average finger tip position
                com.leapmotion.leap.Vector _avgPos = com.leapmotion.leap.Vector.zero();
                for (com.leapmotion.leap.Finger finger : fingers) {
                    _avgPos = _avgPos.plus(finger.tipPosition());
                }
                
                _avgPos = _avgPos.divide(fingers.count());
                
                avgPos = new com.leapmotion.leap.Vector(
                  _avgPos.get(0) + avgPos.get(0) / 2,
                  _avgPos.get(1) + avgPos.get(1) / 2,
                  _avgPos.get(2) + avgPos.get(2) / 2
                 );
    }
  }
}

