//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"


// private static variables
static KITSettings* singleton = nil;
static NSString* savePath = nil;


// private methods
@interface KITSettings ()
	+(void) makeSavePath:(int)saveNumber;
@end


@implementation KITSettings

	@synthesize dictionary;

#pragma mark -
#pragma mark Instance methods

	-(id) init
	{
		self = [super init];
		if( self != nil )
		{
			dictionary = nil;
			[self clear];
			KITLog(@"Settings init %@", self);
		}
		return self;
	}

	-(id) initWithCoder:(NSCoder*)coder
	{
		self = [super init];
		if( self != nil )
		{
			dictionary = [[NSMutableDictionary alloc] initWithDictionary:
				[coder decodeObjectForKey:@"dictionary"]];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder*)coder
	{
		[coder encodeObject:dictionary forKey:@"dictionary"];
	}

	-(void) dealloc
	{
		[dictionary release]; dictionary = nil;
		[savePath release]; savePath = nil;
		[super dealloc];
	}

	-(void) clear
	{
		[dictionary release];
		dictionary = [[NSMutableDictionary alloc] init];
	}

	-(NSString*) description
	{
		return [NSString stringWithFormat:@"%@", dictionary];
	}

#pragma mark -
#pragma mark Class methods

	+(KITSettings*) get
	{
		@synchronized(self)
		{
			// create our single instance
			if(singleton == nil)
				singleton = [[self alloc] init];
		}
		return singleton;
	}

	+(id) alloc
	{
		@synchronized(self)
		{
			// assert that we are the only instance
			KITAssert(singleton == nil, @"There can only be one KITSettings object");
			return [super alloc];
		}
		return nil;
	}

	+(void) purge
	{
		@synchronized(self)
		{
			[singleton release];
		}
	}
	
	// this is the method that creates the singleton Settings object
	+(BOOL) loadSettings:(int)saveNumber
	{
		@synchronized(self)
		{
			// release any existing instance
			[singleton release];
			
			// load our data
			[[self class] makeSavePath:saveNumber];
			singleton = [[NSKeyedUnarchiver unarchiveObjectWithFile:savePath] retain];
			
			// couldn't load?
			if(singleton == nil)
			{
				KITLog(@"Couldn't load KITSettings, so initialized with defaults");
				[self get];
				return NO;
			}

			KITLog(@"Loaded settings from '%@' %@", [savePath stringByAbbreviatingWithTildeInPath], singleton);
		}
		return YES;
	}
	
	+(void) saveSettings:(int)saveNumber
	{
		// make the save file path
		[[self class] makeSavePath:saveNumber];

		// archive our singleton to the save path
		id dataObject = [self get];
		[NSKeyedArchiver archiveRootObject:dataObject toFile:savePath];
		
		KITLog(@"Saved settings to '%@' %@", [savePath stringByAbbreviatingWithTildeInPath], dataObject);
	}

	+(void) makeSavePath:(int)saveNumber
	{
		// get our app's document directory
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		
		// make our save file name
		NSString* saveFile = [[NSString alloc] initWithFormat:@"savefile%d.sav", saveNumber];
		
		// append save file name and retain
		[savePath release];
		savePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:saveFile] retain];
		
		// release the temporary save file name
		[saveFile release];
	}

@end
