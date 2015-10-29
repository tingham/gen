#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/ImageIo.h"
#include "cinder/gl/Texture.h"
#include "cinder/qtime/MovieWriter.h"
#include "cinder/Utilities.h"

using namespace ci;
using namespace ci::app;
using namespace std;

class MutinyApp : public AppBasic {
  public:
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();
    void prepareSettings(Settings *settings);
    
    gl::Texture imageInput;
    Surface32f surface;
    qtime::MovieWriter movie;
    int tick;
};

void MutinyApp::prepareSettings(Settings *settings)
{
    settings->enableMultiTouch();
    settings->setTitle("Hi there.");
    settings->setWindowSize(1280, 720);
    settings->setFrameRate(30.0f);
}

void MutinyApp::setup()
{
    imageInput = gl::Texture(loadImage(loadAsset( "josie.jpg" )));
    surface = Surface32f(imageInput);
    
    fs::path path = getSaveFilePath();
	if( path.empty() )
		return; // user cancelled save
    
	// The preview image below is entitled "Lava" by "Z T Jackson"
	// http://www.flickr.com/photos/ztjackson/3241111818/
    
	movie = qtime::MovieWriter( path, getWindowWidth(), getWindowHeight() );
    tick = 0;
}

void MutinyApp::mouseDown( MouseEvent event )
{
}

void MutinyApp::update()
{
}

void MutinyApp::draw()
{
    tick++;
    
	// clear out the window with black
    gl::clear( Color::black(), false );
    
    gl::draw( imageInput, imageInput.getBounds() );
    
    float sx = 0.0f;
    float sy = 0.0f;
    
    for (int x = 0; x < imageInput.getWidth(); x++) {
        for (int y = 0; y < imageInput.getHeight(); y++) {
            if (x % 7 == 0 && y % 7 == 0) {
                sx = sin(getElapsedSeconds() * (float)((float)x / (float)imageInput.getWidth())) * 10;
                sy = cos(getElapsedSeconds() * (float)((float)y / (float)imageInput.getHeight())) * 10;
                ColorAf c = surface.getPixel(Vec2i(x, y));
                gl::color(c);
                float brightness = ((float)c.r + (float)c.g + (float)c.b) / (float)3;
                gl::drawSolidCircle(Vec2f(sx + x, sy + y), brightness * 2.5f);
                c.a *= 0.5f;
                gl::color(c);
                gl::drawSolidCircle(Vec2f(sx + x, sy + y), brightness * 5.0f);
            }
        }
    }
    
    if (tick < 300) {
        movie.addFrame(copyWindowSurface());
    } else if (tick == 301) {
        movie.finish();
        exit(0);
    }
    
}

CINDER_APP_BASIC( MutinyApp, RendererGl )
