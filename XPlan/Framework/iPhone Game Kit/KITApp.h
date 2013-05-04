//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"

///
/// This class acts as a delegate between your game, Apple's frameworks and Cocos2d.
///
@interface KITApp : NSObject <UIApplicationDelegate, CCDirectorDelegate>
	{
		UIWindow* window;
		UINavigationController* navController;
	}
	
	/// Transition to a new scene with a fade through black
	+(void) fadeToScene:(CCScene*)scene duration:(float)duration;

	/// Run a scene (automatically replaces any existing scene)
	+(void) runScene:(CCScene*)scene;
	
	/// Returns YES if the resource filename exists in your game's bundle
	+(BOOL) resourceExists:(NSString*)fname;

	/// Returns YES if the sprite frame exists in cached memory
	+(BOOL) spriteFrameExists:(NSString*)fname;
	
	/// Returns YES if your game is running in high definition (used with regular iPads or retina-enabled iPhones / iPod Touches)
	+(BOOL) isHD;

	/// Returns YES if your game is running in double high definition (used with iPads with retina displays)
	+(BOOL) isDoubleHD;

	/// Returns YES if retina display is possible and enabled
	+(BOOL) isRetinaEnabled;

	/// Returns YES if running in high definition and retina is not enabled
	+(BOOL) isHDNonRetina;
	
	/// Returns the true window size, correct for the current orientation
	+(CGSize) winSize;

	/// Returns a float scaled for the current display mode (scales up for high definition)
	+(float) scale:(float)f;

	/// Return a point offset from the middle of the screen and scaled for the current display mode (scales up for high definition)
	+(CGPoint) centralize:(CGPoint)p;
	
	/// Returns the maximum texture size in pixels
	+(int) maxTextureSize;

	/// Returns the current time stamp in seconds
	+(double) currentTimeInSeconds;

	/// Returns the amount of time the app has been running
	+(double) runTime;

	/// Returns the current memory usage in bytes
	+(long) memoryUsage;

	/// Returns an NSString of the current device idiom (iPhone or iPad)
	+(NSString*) idiom;

	/// Start your game (override this method with a category)
	-(void) startApp;

	/// Stop your game (override this method with a category)
	-(void) stopApp;

	/// Pause your game (override this method with a category)
	-(void) pauseApp;

	/// Resume your game (override this method with a category)
	-(void) resumeApp;

	/// Get your game ready to be put back in the foreground (override this method with a category)
	-(void) foregroundApp;

	/// Get your game ready to go in the background by freeing up as much memory as you can (override this method with a category)
	-(void) backgroundApp;

@end

