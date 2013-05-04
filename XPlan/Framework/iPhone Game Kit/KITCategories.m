//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"


@implementation NSObject (Extended)

	-(NSString*) className
	{
		return NSStringFromClass([self class]);
	}

@end


@implementation NSString (Extended)

	-(BOOL) hasSubstring:(NSString*)subString
	{
		NSRange r = [self rangeOfString:subString];
		return (r.location != NSNotFound);
	}
	
	-(BOOL) isLowercase
	{
		NSCharacterSet* allButLowercaseCharacterSet = [[NSCharacterSet lowercaseLetterCharacterSet] invertedSet];
		return( [self rangeOfCharacterFromSet:allButLowercaseCharacterSet].location == NSNotFound );
	}
	
	+(id) capitalize:(NSString*)string
	{
		return( [string isLowercase] ? [string capitalizedString] : string );
	}

	-(NSNumber*) numberByAddingInt:(int)value
	{
		return [NSNumber numberWithInt:[self intValue] + value];
	}

	-(NSNumber*) numberByAddingFloat:(float)value
	{
		return [NSNumber numberWithFloat:[self floatValue] + value];
	}

@end


@implementation NSNumber (Extended)

	-(NSNumber*) numberByAddingInt:(int)value
	{
		return [NSNumber numberWithInt:[self intValue] + value];
	}

	-(NSNumber*) numberByAddingFloat:(float)value
	{
		return [NSNumber numberWithFloat:[self floatValue] + value];
	}

@end


@implementation NSArray (Extended)

	-(id) randomObject
	{
		return [self objectAtIndex:(rand() % [self count])];
	}

	-(BOOL) hasObject:(id)object
	{
		for( int i = ([self count] - 1); i >= 0; i-- )
		{
			if( object == [self objectAtIndex:i] )
				return YES;
		}

		return NO;
	}

@end


@implementation NSMutableArray (Extended)

	-(void) reverseArray
	{
		if( [self count] > 0 )
		{
			int i = 0;
			int j = [self count] - 1;
			while( i < j )
			{
				[self exchangeObjectAtIndex:i withObjectAtIndex:j];
				i++;
				j--;
			}
		}
	}

@end


@implementation NSDictionary (Extended)

	-(CGPoint) pointFromXKey:(NSString*)xKey yKey:(NSString*)yKey
	{
		return ccp([[self valueForKey:xKey] floatValue], [[self valueForKey:yKey] floatValue]);
	}

	-(CGSize) sizeFromWidthKey:(NSString*)widthKey heightKey:(NSString*)heightKey
	{
		return CGSizeMake([[self valueForKey:widthKey] floatValue], [[self valueForKey:heightKey] floatValue]);
	}

@end


@implementation CCNode (Extended)

	-(float) width
	{
		return self.contentSize.width;
	}

	-(float) height
	{
		return self.contentSize.height;
	}
	
	-(void) removeFromParent
	{
		[self removeFromParentAndCleanup:YES];
	}

	-(int) leafIndex
	{
		int index = 0;
		if( self.parent != nil && self.parent.children != nil )
		{
			// find this 'leaf' in parent's children
			for( id leaf in self.parent.children )
			{
				if( leaf == self )
					break;

				index++;
			}
			
			// check index
			if( index >= [self.parent.children count] )
				index = -1;
		}
		return index;
	}
	
	-(CGPoint) vectorTo:(CCNode*)otherNode
	{
		return ccpNormalize(ccpSub(otherNode.position, self.position));
	}

	-(BOOL) isPointWithinBoundingBox:(CGPoint)point
	{
		return CGRectContainsPoint([self boundingBox], point);
	}

	-(CCLabelBMFont*) addLabelBMFont:(NSString *)fontFile string:(NSString *)string
		position:(CGPoint)pos scale:(CGFloat)scale alignment:(int)alignment z:(int)z
	{
		// determine the x anchor position
		float anchorX = 0.5f;
		switch( alignment )
		{
			case kAlignmentLeft: anchorX = 0.0f; break;
			case kAlignmentRight: anchorX = 1.0f; break;
			default:
			case kAlignmentCenter: anchorX = 0.5f; break;
		}
		
		// create the label, set it up, and add it as a child
		CCLabelBMFont* label = [[CCLabelBMFont alloc] initWithString:string fntFile:fontFile];
		label.anchorPoint = ccp(anchorX, 0.5f);
		label.position = pos;
		label.scale = scale;
		[self addChild:label z:z];
		
		// release the allocated label...
		[label release];
		
		// ...and return a valid object because addChild retained it
		return label;
	}

@end



@implementation CCScene (Extended)

	-(id) initWithChildClass:(Class)class
	{
		self = [super init];
		if( self != nil )
		{
			// create the child object
			id child = [[class alloc] init];
			
			// add it (retains the child)
			[self addChild:child];
			
			// release (because it's already retained)
			[child release];
		}
		return self;
	}

@end



@implementation CCSprite (Extended)

	-(CGPoint) anchorOffset
	{
		CGPoint size = ccpFromSize(self.contentSize);
		CGPoint anchorPosition = ccpCompMult(self.anchorPoint, size);
		return ccpSub(anchorPosition, ccpMult(size, 0.5f));
	}

	-(void) setDisplayFrameName:(NSString*)fname
	{
		[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fname]];
	}

	-(void) setFrame:(NSString*)fname
	{
		[self setDisplayFrameName:fname];
	}
	
	-(void) glow:(float)duration
	{
		id action = [CCFadeIn actionWithDuration:(duration / 2.0f)];
		id rev = [CCFadeOut actionWithDuration:(duration / 2.0f)];
		[self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:action, rev, nil]]];
	}

	-(void) animate:(CCAnimation*)animation tag:(int)tag repeat:(BOOL)repeat restore:(BOOL)restore;
	{
		id action = [CCAnimate actionWithAnimation:animation];
		if(repeat)
			action = [CCRepeatForever actionWithAction:action];
		[action setTag:tag];
		[self runAction:action];
	}

@end



@implementation CCAnimation (Extended)

	// we use initWith instead of animationWith so we don't bloat the autorelease pool
-(id) initWithFormat:(NSString*)nameFormat subString:(NSString*)subString frameCount:(int)frameCount delay:(CGFloat)delay
	{
		// create array for the animation's frames
		KITSpriteFrameArray* animFrames = [[KITSpriteFrameArray alloc]
                                           initWithFormat:nameFormat subString:subString frameCount:frameCount];

		// create this animation with frames
		self = [self initWithSpriteFrames:animFrames.array delay:delay];
		
		[animFrames release];
		return self;
	}

@end



@implementation CCTMXLayer (Extended)

	-(int) intValueFromProperty:(NSString*)propertyName
	{
		return [[self propertyNamed:propertyName] intValue];
	}
	
	-(BOOL) hasProperty:(NSString*)propertyName
	{
		return ([self intValueFromProperty:propertyName] != 0);
	}

	-(CGPoint) pointFromXProperty:(NSString*)xProperty yProperty:(NSString*)yProperty
	{
		return ccp([self intValueFromProperty:xProperty], [self intValueFromProperty:yProperty]);
	}

@end



@implementation CCMenuItemSprite (Extended)

	-(id) initFromNormalSpriteFrameName:(NSString*)normalFname selected:(NSString*)selectedFname
		disabled:(NSString*)disabledFname target:(id)target selector:(SEL)selector
	{
		CCSpriteFrameCache* cacher = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSprite* normalSprite = [[CCSprite alloc] initWithSpriteFrame:[cacher spriteFrameByName:normalFname]];
		CCSprite* selectedSprite = nil,*disabledSprite = nil;

		if( selectedFname != nil )
			selectedSprite = [[CCSprite alloc] initWithSpriteFrame:[cacher spriteFrameByName:selectedFname]];
		if( disabledFname != nil )
			disabledSprite = [[CCSprite alloc] initWithSpriteFrame:[cacher spriteFrameByName:disabledFname]];
		
		self = [self initWithNormalSprite:normalSprite selectedSprite:selectedSprite
			disabledSprite:disabledSprite target:target selector:selector];
		
		[normalSprite release];
		[selectedSprite release];
		[disabledSprite release];
		
		return self;
	}
	
@end



@implementation UITouch (Extended)

	-(CGPoint) locationInGL
	{
		return [[CCDirector sharedDirector] convertToGL:[self locationInView:self.view]];
	}

	-(CGPoint) previousLocationInGL
	{
		return [[CCDirector sharedDirector] convertToGL:[self previousLocationInView:self.view]];
	}

@end


@implementation KITSpriteFrameArray

	@synthesize array;

-(id) initWithFormat:(NSString*)format subString:(NSString*)subString frameCount:(int)frameCount
	{
		self = [self init];
		if( self != nil )
		{
			// create the array
			array = [[NSMutableArray alloc] initWithCapacity:frameCount];
			
			// load each frame
			for(int i = 0; i < frameCount; i++)
			{
				// create filename using format
				NSString* fname = (subString != nil ?
					[[NSString alloc] initWithFormat:format, subString, i] :
					[[NSString alloc] initWithFormat:format, i]);
				
				// load the frame
				@try
				{
					CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fname];
					KITAssert1(frame != nil, @"Missing sprite frame '%@' in resources or spritesheets", fname);
                    
					// add this frame to this array
					[array addObject:frame];
				}
				@catch(NSException* exception)
				{
					KITLog(@"Exception in KITSpriteFrameArray: %@: %@", [exception name], [exception reason]);
				}
				
				[fname release];
			}
		}
		return self;
	}

@end



BOOL KITCircleIntersectsRect(CGPoint circlePosition,float circleRadius,CGRect rect)
{
	// find the closest point to the circle within the rectangle
	CGPoint closest = ccp(clampf(circlePosition.x, rect.origin.x, rect.origin.x + rect.size.width),
		clampf(circlePosition.y, rect.origin.y, rect.origin.y + rect.size.height));

	// calculate the distance between the circle's center and this closest point
	CGPoint distance = ccpSub(circlePosition, closest);

	// if the distance is less than the circle's radius, an intersection occurs
	return( ccpLengthSQ(distance) < (circleRadius * circleRadius) );

/*
	circleDistance.x = abs(circle.x - rect.x - rect.width/2);
	circleDistance.y = abs(circle.y - rect.y - rect.height/2);

	if (circleDistance.x > (rect.width/2 + circle.r)) { return false; }
	if (circleDistance.y > (rect.height/2 + circle.r)) { return false; }

	if (circleDistance.x <= (rect.width/2)) { return true; } 
	if (circleDistance.y <= (rect.height/2)) { return true; }

	cornerDistance_sq = (circleDistance.x - rect.width/2)^2 +
						 (circleDistance.y - rect.height/2)^2;

	return (cornerDistance_sq <= (circle.r^2));

	float rectW_2 = (rect.size.width / 2.0f);
	float rectH_2 = (rect.size.height / 2.0f);

	// calculate the distance between the circle's center and the rectangle's center
	CGPoint circleDistance;
	circleDistance.x = fabsf(circlePosition.x - rect.origin.x + rectW_2);
	circleDistance.y = fabsf(circlePosition.y - rect.origin.y + rectH_2);
	
	// is the circle far enough away to rule out an intersection?
	if( circleDistance.x > (rectW_2 + circleRadius)
	|| circleDistance.y > (rectH_2 + circleRadius) )
		return NO;
	
	// is the circle close enough to guarantee an intersection?
	if( circleDistance.x <= rectW_2
	|| circleDistance.y <= rectH_2 )
		return YES;
*/	
	
}