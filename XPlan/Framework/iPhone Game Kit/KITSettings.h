//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"

///
/// Base class for your game's custom Settings singleton object
///
@interface KITSettings : NSObject <NSCoding>
	{
		NSMutableDictionary* dictionary;
	}

	/// The master settings dictionary
	@property (readwrite,copy,nonatomic) NSMutableDictionary* dictionary;

	/// Get the shared singleton
	+(KITSettings*) get;
	
	/// Purge the shared singleton
	+(void) purge;
	
	/// Load settings from a save file
	+(BOOL) loadSettings:(int)saveNumber;
	
	/// Save settings to the the save file
	+(void) saveSettings:(int)saveNumber;
	
	/// Clears the settings
	-(void) clear;

@end
