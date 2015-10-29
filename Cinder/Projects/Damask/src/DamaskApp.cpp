#include "cinder/app/AppNative.h"
#include "cinder/gl/gl.h"
#include "cinder/Perlin.h"

using namespace ci;
using namespace ci::app;
using namespace std;

class DamaskApp : public AppNative {
  public:
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();
    int tick;
};

void DamaskApp::setup()
{
    tick = 0;
}

void DamaskApp::mouseDown( MouseEvent event )
{
}

void DamaskApp::update()
{
}

void DamaskApp::draw()
{
    tick++;
    
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) );
    
    Perlin p = Perlin();
    
    for (int x = 0; x < 640; x++) {
        for (int y = 0; y < 480; y++) {
            float f = 0.5 * p.noise(
               ((float)x / 640) * (tick * 10),
               ((float)y / 480) * (tick * 10)
                                    ) + 0.5;

            Color c = Color(
                (float)x / 640 * f,
                (float)y / 480 * f,
                f
            );
            gl::color(c);
            gl::drawSolidCircle(Vec2f(x, y), 1);
        }
    }
}

CINDER_APP_NATIVE( DamaskApp, RendererGl )
