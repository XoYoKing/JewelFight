//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

///
/// @mainpage iPhone Game Kit API reference
///
/// This is the iPhone Game Kit's API reference.
/// Start by browsing KITAppDelegate or the Classes.
///
/// Note regarding NSLog:
/// Use KITLog instead of NSLog and set the KIT_LOG_MESSAGES=1
/// preprocessor macro in your app target's debug build settings.
/// Using NSLog can slow down your app because it is not
/// automatically disabled in distribution builds and therefore
/// writes to the console of the device.
///

// setup the main class to create the app with
#ifndef KITAppSubclassName
	#define KITAppSubclassName @"KITApp"
#endif


// whether or not to show the frame rate (a general indicator of performance)
#define kKITShowFPS 1

// whether or not to use landscape mode
#define kKITLandscapeOrientation 0

// the ideal frame rate
#define kKITIdealFPS 60.0f

// whether or not to automatically make HD TMX maps (usually leave this on)
#define kKITAutoHDTMXFiles 1

// turn on Cocos2D's fixing of TMX artifacts
#ifndef CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL
	#define CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL 1
#endif

// turn on non-mipmapped texture support
#ifndef CC_TEXTURE_NPOT_SUPPORT
	#define CC_TEXTURE_NPOT_SUPPORT 1
#endif

// apple iOS related imports
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// cocos2d related imports
#import "cocos2d.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"

// iPhone Game Kit related imports
#import "KITProfile.h"
#import "KITSettings.h"
#import "KITSound.h"
#import "KITApp.h"
#import "KITCategories.h"
#import "KITTMXParser.h"

// KITLog & KITAssert (use these instead of NSLog or NSAssert)
// if KIT_LOG_MESSAGES is not defined...
#if !defined(KIT_LOG_MESSAGES) || KIT_LOG_MESSAGES == 0

	#define KITLog(...) do {} while (0)
	#define KITAssert(...) do {} while (0)
	#define KITAssert1(...) do {} while (0)
	#define KITAssert2(...) do {} while (0)
	#define KITAssert3(...) do {} while (0)
	#define KITAssert4(...) do {} while (0)
	#define KITAssert5(...) do {} while (0)

// if KIT_LOG_MESSAGES is defined in your Target's Build Settings > Preprocessor Macros...
#else

	#define KITLog(...) NSLog(__VA_ARGS__)
	static inline void KITAssert(BOOL condition, NSString* message)
	{
		if( !condition )
		{
			KITLog(@"*** Assertion failure: %@", message);
			KITLog(@"*** Call stack was: %@", [NSThread callStackSymbols]);

			// Make your debugging life a lot easier by adding a breakpoint
			// at the next line of code and keep breakpoints active. This will
			// cause Xcode to pause here and show you the list of past methods
			// that led to this assertion failure.
			
			// If you are hitting a breakpoint here, look at the last assertion
			// failure message in your Debug Area's Console and use the Debug
			// navigator to browse the call stack to trace down what went wrong.
			
			KITLog(@"*** Please set a breakpoint in %@ at line %d or add an 'All Objective C Exceptions' breakpoint with the Breakpoint navigator",
				[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__);
			
			// If for some reason Xcode is not breaking at your breakpoint,
			// try switching from GDB to LLDB with your Product menu's Edit Scheme
			// command.

			@throw message;
		}
	}
	#define KITAssert1(condition, format, param1) KITAssert( condition, [NSString stringWithFormat:format, param1] )
	#define KITAssert2(condition, format, param1, param2) KITAssert( condition, [NSString stringWithFormat:format, param1, param2] )
	#define KITAssert3(condition, format, param1, param2, param3) KITAssert( condition, [NSString stringWithFormat:format, param1, param2, param3] )
	#define KITAssert4(condition, format, param1, param2, param3, param4) KITAssert( condition, [NSString stringWithFormat:format, param1, param2, param3, param4] )
	#define KITAssert5(condition, format, param1, param2, param3, param4, param5) KITAssert( condition, [NSString stringWithFormat:format, param1, param2, param3, param4, param5] )

#endif
