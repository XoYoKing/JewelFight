//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"


// the private static singleton instance
static KITSound* singleton = nil;


// private methods
@interface KITSound ()
	-(BOOL) hasSoundId:(NSString*)fname;
	-(int) setSoundId:(NSString*)fname;
	-(int) getSoundId:(NSString*)fname;
	-(void) deleteSoundId:(NSString*)fname;
	-(void) updateSound:(NSTimer*)timer;
	-(void) loadRequest:(NSString*)fname soundId:(int)soundId;
@end



@implementation KITSound

#pragma mark -
#pragma mark Class methods

	+(KITSound*) sharedSound
	{
		@synchronized(self)
		{
			if (!singleton)
				singleton = [[self alloc] init];
		}
		return singleton;
	}

	+(void) purge
	{
		@synchronized(self)
		{
			[singleton release];
		}
	}

	+(id) alloc
	{
		@synchronized(self)
		{
			KITAssert(singleton == nil, @"There can only be one KITSound singleton");
			return [super alloc];
		}
		return nil;
	}

#pragma mark -
#pragma mark Loading

	-(void) loadSound:(NSString*)fname
	{
		@try
		{
			// if we have not already loaded this effect
			if( fname != nil && [fname length] > 0 && ![self hasSoundId:fname] )
			{
				// load this sound
				[self loadRequest:fname soundId:[self setSoundId:fname]];
			}
		}
		@catch( NSException* exception )
		{
			KITLog(@"Exception in KITSound's loadSound: '%@'", exception);
		}
	}

	-(void) unloadSound:(NSString*)fname
	{
		if( fname != nil && [fname length] > 0 )
		{
			// look up the sound id
			int soundId = [self getSoundId:fname];

			if(engine != nil)
			{
				// unload this sound
				if( [engine unloadBuffer:soundId] )
				{
					[self deleteSoundId:fname];
					//KITLog(@"Successfully unloaded sound buffer '%@' id=%d", fname, soundId);
				}
				//else
				//	KITLog(@"Unable to unload sound buffer '%@' id=%d", fname, soundId);
			}
		}
	}

	-(BOOL) isDoneLoading
	{
		return (engine != nil && engine.asynchLoadProgress >= 1.0f);
	}

#pragma mark -
#pragma mark Playing

	-(ALuint) playSound:(NSString*)fname
	{
		return [self playSound:fname volume:1.0f pan:0.0f pitch:1.0f loop:NO group:kSoundGroupMultiple];
	}

	// play a sound effect with a lower volume based on distance from camera
	-(ALuint) playSound:(NSString*)fname distanceSQ:(float)distanceSQ
	{
		const float maxDistanceSQ = 690000.0f;
		
		// greater distance = lower volume
		float volume = 1.0f - (distanceSQ / maxDistanceSQ);
		volume = clampf(volume,0.1f,1.0f);
		//KITLog(@"Playing sound '%@' at distance squared %.1f, volume %.1f", fname, distanceSQ, volume);

		// re-use the other method
		return [self playSound:fname volume:volume pan:0.0f pitch:1.0f loop:NO group:kSoundGroupMultiple];
	}

	-(ALuint) playSound:(NSString*)fname volume:(CGFloat)volume pan:(CGFloat)pan pitch:(CGFloat)pitch loop:(BOOL)loop group:(int)group
	{
		// look up the sound id
		int soundId = [self getSoundId:fname];
		if( soundId <= 0 )
			KITLog(@"Cannot find sound '%@'. Perhaps it is missing the file name extension .caf, .mp3, .aif, etc...?", fname);

		// play the sound if we can
		return ((engine == nil || soundId <= 0) ? CD_MUTE :
			[engine playSound:soundId sourceGroupId:group pitch:pitch pan:pan gain:volume loop:loop]);
	}

	-(void) stopSound:(ALuint)soundId
	{
		if(engine != nil)
			[engine stopSound:soundId];
	}
	
#pragma mark -
#pragma mark Setting

	-(void) setVolume:(ALuint)fx volume:(ALfloat)volume;
	{
		alSourcef(fx, AL_GAIN, volume > 1.0f ? 1.0f : (volume < 0.0f ? 0.0f : volume));
	}

#pragma mark -
#pragma mark Instance methods

	-(id) init
	{
		self = [super init];
		if(self != nil)
		{
			//KITLog(@"Starting sound engine");
			
			// wait until engine has loaded to use it
			engine = nil;
			
			// initialize audio manager asynchronously as it can take a few seconds
			[CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];

			// create arrays, dictionary, etc.
			sounds = [[NSMutableDictionary alloc] init];
			loadRequests = [[NSMutableArray alloc] init];
			soundsCount = 0;

			// launch timer to check on sound engine
			[NSTimer scheduledTimerWithTimeInterval:1.0f/10.0f
				target:self selector:@selector(updateSound:) userInfo:nil repeats:YES];
		}
		return self;
	}

	-(void) dealloc
	{
		[sounds release];
		[loadRequests release];

		engine = nil;
		singleton = nil;

		[super dealloc];
	}

	-(void) updateSound:(NSTimer*)timer
	{
		// we must wait until the sound engine is initialized to get the engine
		if(engine == nil && [CDAudioManager sharedManagerState] == kAMStateInitialised)
		{
			// get engine
			engine = [CDAudioManager sharedManager].soundEngine;
			
			// setup a few groups for sound effect playback
			int groups[kSoundGroupTotal];
			groups[kSoundGroupSingle] = 2; // only one or two at a time
			groups[kSoundGroupMultiple] = 16; // 16 sounds at a time
			[engine defineSourceGroups:groups total:kSoundGroupTotal];
			
			// load any sounds that are waiting to be loaded
			[engine loadBuffersAsynchronously:loadRequests];

			// no longer need to update
			[timer invalidate];
		}
	}

	-(void) loadRequest:(NSString*)fname soundId:(int)soundId
	{
		if( fname != nil && [fname length] > 0 )
		{
			// assert this effect exists
			KITAssert1([KITApp resourceExists:fname], @"The sound effect '%@' must exist in resources", fname);

			// create load request
			CDBufferLoadRequest* request =
				[[[CDBufferLoadRequest alloc] init:soundId filePath:fname] autorelease];

			// load it later
			if(engine == nil)
			{
				[loadRequests addObject:request];
			}
			
			// load it now
			else
			{
				@try
				{
					NSMutableArray* requests = [[[NSMutableArray alloc] init] autorelease];
					[requests addObject:request];
					[engine loadBuffersAsynchronously:requests];
				}
				@catch(NSException* e)
				{
					KITLog(@"KITSound loadRequest exception: %@: %@", [e name], [e reason]);
				}
			}
		}
	}	

#pragma mark -
#pragma mark Sound IDs

	-(BOOL) hasSoundId:(NSString*)fname
	{
		return ([sounds valueForKey:fname] != nil);
	}

	-(int) setSoundId:(NSString*)fname
	{
		soundsCount++;
		
		// get an integer identifier representing our effect
		NSNumber* soundId = [[NSNumber alloc] initWithInt:soundsCount];
		
		// save the file name to identifier association
		[sounds setValue:soundId forKey:fname];
		
		// no longer need this because the sounds array retains it
		[soundId release];
		
		return soundsCount;
	}
	
	-(int) getSoundId:(NSString*)fname
	{
		return [[sounds valueForKey:fname] intValue];
	}

	-(void) deleteSoundId:(NSString*)fname
	{
		[sounds removeObjectForKey:fname];
		
		// note that we do not reduce soundsCount because we want
		// all future sound buffers to have a unique id
	}

@end
