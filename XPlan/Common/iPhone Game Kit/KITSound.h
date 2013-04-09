//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"

// sound groups
enum 
{
	kSoundGroupSingle=0,
	kSoundGroupMultiple,
	kSoundGroupTotal
};

///
/// Wraps the CocosDenshion sound engine with asynchronous loading in a handy singleton object
///
@interface KITSound : NSObject
	{
		CDSoundEngine* engine;
		NSMutableDictionary* sounds;
		NSMutableArray* loadRequests;
		BOOL soundReady;
		int soundsCount;
	}

	/// Get the shared KITSound singleton instance
	+(KITSound*) sharedSound;

	/// Purge the shared KITSound instance (automatically called by KITApp)
	+(void) purge;

	/// Load a sound effect by filename
	-(void) loadSound:(NSString*)fname;

	/// Unload a sound effect by filename
	-(void) unloadSound:(NSString*)fname;

	/// Returns YES if done with initial loading
	-(BOOL) isDoneLoading;

	/// Play a sound by filename and return the sound ID
	-(ALuint) playSound:(NSString*)fname;

	/// Play a sound by filename, at a given distance squared and return the sound ID
	-(ALuint) playSound:(NSString*)fname distanceSQ:(float)distanceSQ;

	/// Play a sound by filename with the given parameters and return the sound ID
	-(ALuint) playSound:(NSString*)fname volume:(CGFloat)volume pan:(CGFloat)pan pitch:(CGFloat)pitch loop:(BOOL)loop group:(int)group;

	/// Stop a sound with given sound ID
	-(void) stopSound:(ALuint)soundId;
	
	/// Set the volume of a sound, given the sound ID
	-(void) setVolume:(ALuint)soundId volume:(ALfloat)volume;

@end
