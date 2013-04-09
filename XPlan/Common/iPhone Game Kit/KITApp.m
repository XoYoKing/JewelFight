//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"
#import <mach/mach.h>

// static private "member" variables
static float maxDimensionInPixels = 480.0f;
static float maxDimensionInPoints = 480.0f;
static BOOL retinaEnabled = NO;
static BOOL isRetina = NO;
static BOOL isHD = NO;
static BOOL isDoubleHD = NO;
static BOOL isMultitasking = NO;
static BOOL isForeground = YES;
static float enlargingScaleFactor = 1.0f;
static double _appStartTime = 0.0;
static float _iosVersion = 3.0f;

// private methods
@interface KITApp ()
	-(void) launch;
	-(void) setupGraphics;
	-(void) setupConstants;
@end

void setupExternals();

@implementation KITApp

#pragma mark -
#pragma mark Instance methods

	-(void) launch
	{
		_appStartTime = [[self class] currentTimeInSeconds];
		_iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		KITLog(@"KITApp launch started, iOS version %.1f", _iosVersion);
		
		// setup any external apis
		setupExternals();

		// setup the graphical display
		[self setupGraphics];
		
		// sound engine is automatically created the first time [KITSound sharedSound] is called
		
		// launch the game
		[self startApp];
		
		KITLog(@"KITApp launch took %.2f seconds", [[self class] runTime]);
	}
	
	-(void) setupGraphics
	{
		// create the window
		window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

		// set cocos2d director options
		CCDirector* director = [CCDirector sharedDirector];
		#if kKITShowFPS
			[director setDisplayStats:YES];
		#else
			[director setDisplayStats:NO];
		#endif
		[director setAnimationInterval:(1.0f / kKITIdealFPS)]; // how many frames per second (ideally)

		// manually create the embedded (apple) graphics library view
		CCGLView* __glView = [CCGLView viewWithFrame:[window bounds]
			pixelFormat:kEAGLColorFormatRGB565
			depthFormat:GL_DEPTH_COMPONENT24_OES // we need a depth buffer for better z ordering
			preserveBackbuffer:NO
			sharegroup:nil
			multiSampling:NO // turning on multiSampling seems to slow things down...
			numberOfSamples:0];

		// attach the openglView to the director
		[director setView:__glView];
		[director setDelegate:self];
		director.wantsFullScreenLayout = YES;

		// allow multiple touches so player can swing sword while walking
		[__glView setMultipleTouchEnabled:YES];

		// enable retina
		retinaEnabled = [[CCDirector sharedDirector] enableRetinaDisplay:YES];

		// use RootViewController manage EAGLView
		navController = [[UINavigationController alloc] initWithRootViewController:director];
		navController.navigationBarHidden = YES;

		// set root view controller seems to work on the simulator, but on the device
		// it doesn't set the initial orientation correctly
		if( _iosVersion >= 6.0f )
			[window setRootViewController:navController];
		else
			[window addSubview:navController.view];

		// make main window visible
		[window makeKeyAndVisible];

		// set default alpha pixel format so we conserve video memory
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
		
		// get the screen size in points
		CGSize screenSizeInPoints = [[CCDirector sharedDirector] winSize];
		
		// get the actual screen size in pixels
		CGSize screenSize = CGSizeMake(480.0f, 320.0f); // all devices before 3.2 were 480x320
		if(_iosVersion >= 3.2f)
			screenSize = [UIScreen mainScreen].currentMode.size;

		// get maximum window dimension in pixels and points
		maxDimensionInPixels = MAX(screenSize.width, screenSize.height);
		maxDimensionInPoints = MAX(screenSizeInPoints.width, screenSizeInPoints.height);

		// setup the our private static variables
		[self setupConstants];
	}
	
	-(void) setupConstants
	{
		// test out the settings for our platform / device
		isHD = (maxDimensionInPixels > 480.0f);
		isRetina = (maxDimensionInPoints != maxDimensionInPixels);
		isDoubleHD = (maxDimensionInPixels >= 2048.0f);
		isMultitasking = ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]
			&& [[UIDevice currentDevice] isMultitaskingSupported]);
		
		// increase the pixel positions in high-def mode
		if( [[self class] isDoubleHD] || [[self class] isHDNonRetina] )
			enlargingScaleFactor = 2.0f;
		else
			enlargingScaleFactor = 1.0f;

		// report what we learned
		KITLog(@"KITApp window width is %.0f pixels/%.0f points, HD=%@, Retina available=%@ (enabled=%@)",
			maxDimensionInPixels, maxDimensionInPoints, isHD ? @"yes" : @"no",
			isRetina ? @"yes" : @"no", retinaEnabled ? @"yes" : @"no");
	}

	-(void) dealloc
	{
		// release our singletons
		[KITSound purge];
		[KITProfile purge];
		
		// stop notifications
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

		// release our window
		[navController release];
		[window release];
		
		// remember to [super dealloc]
		[super dealloc];
	}

#pragma mark -
#pragma mark UIApplicationDelegate methods

	-(void) applicationDidFinishLaunching:(UIApplication*)application
	{
		[self launch];
	}
	
	-(void) applicationWillTerminate:(UIApplication*)application
	{
		[self stopApp];
		
		// dealloc all scenes
		[[CCDirector sharedDirector] end];

		// cause our dealloc
		[self release];
	}

	-(void) applicationWillResignActive:(UIApplication*)application
	{
		// getting a call, pause the game
		[[CCDirector sharedDirector] pause];
		[self pauseApp];
	}

	-(void) applicationDidBecomeActive:(UIApplication*)application
	{
		// call done, resume the game
		[[CCDirector sharedDirector] resume];
		[self resumeApp];
	}

	-(void) applicationDidEnterBackground:(UIApplication*)application 
	{
		isForeground = NO;
		
		// stop the game and hibernate in the background
		[[CCDirector sharedDirector] stopAnimation];
		[self backgroundApp];
		
		KITLog(@"KITApp is now in the background and using %ldk memory", [[self class] memoryUsage] / 1024);
	}

	-(void) applicationWillEnterForeground:(UIApplication*)application 
	{
		isForeground = YES;

		// start the game again and un-hibernate
		[[CCDirector sharedDirector] startAnimation];
		[self foregroundApp];
	}

	-(void) applicationDidReceiveMemoryWarning:(UIApplication*)application
	{
		// purge what memory we can
		[[CCDirector sharedDirector] purgeCachedData];
		KITLog(@"Removed unused textures");
	}

	-(void) applicationSignificantTimeChange:(UIApplication*)application
	{
		// rather than move our player off the screen with a huge delta,
		// set next delta time to zero
		[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	}
	
#pragma mark -
#pragma mark Scenes

	+(void) fadeToScene:(CCScene*)scene duration:(float)duration
	{
		// create transition scene
		CCScene* transition = [CCTransitionFade transitionWithDuration:duration scene:scene withColor:ccc3(0, 0, 0)];
		
		// run it
		[self runScene:transition];
	}
	
	+(void) runScene:(CCScene*)scene
	{
		// get the director
		CCDirector* director = [CCDirector sharedDirector];

		// run this scene...
		if( director.runningScene == nil )
			[director runWithScene:scene];
		
		// ...or replace the current scene
		else
			[director replaceScene:scene];
	}
	
#pragma mark -
#pragma mark Resources

	+(BOOL) resourceExists:(NSString*)fname
	{
		// if we cannot get a full path name then it doesn't exist
		return (fname && [fname length] > 0
			&& [[NSBundle mainBundle] pathForResource:fname ofType:nil] != nil);
			//&& ![[CCFileUtils fullPathFromRelativePath:fname] isEqualToString:fname]);
	}

	+(BOOL) spriteFrameExists:(NSString*)fname
	{
		CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fname];
		return (frame != nil);
	}
	
#pragma mark -
#pragma mark Graphics

	+(BOOL) isHD
	{
		return isHD;
	}
	
	+(BOOL) isDoubleHD
	{
		return isDoubleHD;
	}
	
	+(BOOL) isRetinaEnabled
	{
		return retinaEnabled;
	}

	+(BOOL) isHDNonRetina
	{
		return (isHD && !retinaEnabled);
	}
	
	+(CGSize) winSize
	{
		// start with cocos2d's winsize
		CGSize iSize = [[CCDirector sharedDirector] winSize];
		
		// make sure dimensions are correct for our preferred orientation
		#if kKITLandscapeOrientation == 1
		if( iSize.width < iSize.height )
		#else
		if( iSize.width > iSize.height )
		#endif
		{
			float oldWidth = iSize.width;
			iSize.width = iSize.height;
			iSize.height = oldWidth;
		}
		
		return iSize;
	}
	
	+(float) scale:(float)f
	{
		return f * enlargingScaleFactor;
	}

	+(CGPoint) centralize:(CGPoint)p
	{
		// always get a fresh window size because of orientation changes
		CGSize iSize = [[self class] winSize];
		
		// return the point offset from the middle and scaled
		return ccp([[self class] scale:p.x] + (iSize.width / 2.0f), [[self class] scale:p.y] + (iSize.height / 2.0f));
	}

#pragma mark -
#pragma mark Memory & Time

	+(int) maxTextureSize
	{
		// use an opengl call to determine maximum texture size
		GLint myGLint = 0;
		glGetIntegerv(GL_MAX_TEXTURE_SIZE, &myGLint);
		return (int)myGLint;
	}
	
	+(double) currentTimeInSeconds
	{
		return CFAbsoluteTimeGetCurrent();
	}

	+(double) runTime
	{
		if( _appStartTime == 0.0 )
			return 0.0;
		return [[self class] currentTimeInSeconds] - _appStartTime;
	}

	+(long) memoryUsage
	{
		struct task_basic_info info;
		mach_msg_type_number_t size = sizeof(info);
		kern_return_t kerr = task_info(mach_task_self(),
			TASK_BASIC_INFO,
			(task_info_t)&info,
			&size);
		
		if( kerr != KERN_SUCCESS)
			KITLog(@"Error getting memory usage with task_info(): %s", mach_error_string(kerr));
		
		return ( kerr == KERN_SUCCESS ? info.resident_size : 0 );
		
	}

	+(NSString*) idiom
	{
		// this gets the idiom in a safe way, using respondsToSelector
		UIUserInterfaceIdiom i = UI_USER_INTERFACE_IDIOM();
		
		// iPad?
		if( i == UIUserInterfaceIdiomPad )
			return @"iPad";
		
		// otherwise it's iPhone
		return @"iPhone";
	}

	-(void) startApp
	{
		// for your app to implement with a subclass
	}
	
	-(void) stopApp
	{
		// for your app to implement with a subclass
	}

	-(void) pauseApp
	{
		// for your app to implement with a subclass
	}

	-(void) resumeApp
	{
		// for your app to implement with a subclass
	}

	-(void) foregroundApp
	{
		// for your app to implement with a subclass
	}
	
	-(void) backgroundApp
	{
		// for your app to implement with a subclass
	}

	// override to allow different orientations
	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
		#if kKITLandscapeOrientation == 1
			BOOL ret = UIInterfaceOrientationIsLandscape(interfaceOrientation);
			#if TARGET_IPHONE_SIMULATOR
				if( [KITApp runTime] < 3.0f )
					ret = (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
			#endif
		#else
			BOOL ret = UIInterfaceOrientationIsPortrait(interfaceOrientation);
			#if TARGET_IPHONE_SIMULATOR
				if( [KITApp runTime] < 3.0f )
					ret = (interfaceOrientation == UIInterfaceOrientationPortrait);
			#endif
		#endif
		
		//KITLog(@"Should autorotate to %d? Answer %d", interfaceOrientation, ret);
		return ret;
	}

@end



#ifdef FLURRY_ANALYTICS_KEY

	#import "FlurryAnalytics.h"
	
	// stringification macros:
	// http://gcc.gnu.org/onlinedocs/cpp/Stringification.html
	#define MACRO_NAME(f) #f
	#define MACRO_VALUE(f) MACRO_NAME(f)

	void uncaughtExceptionHandler(NSException *exception)
	{
		[FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
	}

	void setupExternals()
	{
		// start up flurry
		NSString* key = [[NSString alloc] initWithUTF8String:MACRO_VALUE(FLURRY_ANALYTICS_KEY)];
		NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
		[FlurryAnalytics startSession:key];
		KITLog(@"Started Flurry analytics version %@", [FlurryAnalytics getFlurryAgentVersion]);
		//KITLog(@"Flurry analytics key '%@'", key);
		[key release];
	}

#else
	
	void setupExternals()
	{
	}

#endif
