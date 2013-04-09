//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"

int main(int argc, char* argv[])
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	int retVal = -1;
	@try
	{
		KITLog(@"main.m: Creating an instance of '%@'", KITAppSubclassName);
		retVal = UIApplicationMain(argc, argv, nil, KITAppSubclassName);
	}
	@catch( NSException* exception )
	{
		KITLog(@"*** Uncaught exception: %@", exception.description);
		KITLog(@"*** Stack trace: %@", [exception callStackSymbols]);
		KITLog(@"*** Please set a breakpoint in %@ at line %d or add an 'All Objective C Exceptions' breakpoint with the Breakpoint navigator",
			[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__);
	}
	[pool release];
	return retVal;
}
