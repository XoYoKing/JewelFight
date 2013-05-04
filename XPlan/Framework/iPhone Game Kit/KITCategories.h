//
//  See the file 'LICENSE_iPhoneGameKit.txt' for the license governing this code.
//      The license can also be obtained online at:
//          http://www.iPhoneGameKit.com/license
//

#import "iPhoneGameKit.h"

enum
{
	kAlignmentLeft,
	kAlignmentCenter,
	kAlignmentRight
};

//
// our "extensions" to other people's classes
// (called "categories" in Objective C)
//

/// Extends NSObject
@interface NSObject
(Extended)
	/// Returns an NSString of this object's class name
	-(NSString*) className;
@end

/// Extends NSString
@interface NSString
(Extended)
	/// Return YES if this string has the given substring
	-(BOOL) hasSubstring:(NSString*)subString;

	/// Returns YES if the string is all lowercase
	-(BOOL) isLowercase;

	/// If the given string is all lowercase then this method returns
	/// a capitalized autorelease string, else it returns the given string
	+(id) capitalize:(NSString*)string;

	/// Returns a new NSNumber by adding the given integer value to this object's value
	-(NSNumber*) numberByAddingInt:(int)value;

	/// Returns a new NSNumber by adding the given floating point value to this object's value
	-(NSNumber*) numberByAddingFloat:(float)value;
@end

/// Extends NSNumber
@interface NSNumber
(Extended)
	/// Returns a new NSNumber by adding the given integer value to this object's value
	-(NSNumber*) numberByAddingInt:(int)value;

	/// Returns a new NSNumber by adding the given floating point value to this object's value
	-(NSNumber*) numberByAddingFloat:(float)value;
@end

/// Extends NSArray
@interface NSArray
(Extended)
	/// Return a random object from this array
	-(id) randomObject;

	/// Return YES if this array has the given object
	-(BOOL) hasObject:(id)object;
@end

/// Extends NSMutableArray
@interface NSMutableArray
(Extended)
	/// Reverses the array
	-(void) reverseArray;
@end

/// Extends NSDictionary
@interface NSDictionary
(Extended)
	/// Returns a CGPoint from an x value and y value in this dictionary
	-(CGPoint) pointFromXKey:(NSString*)xKey yKey:(NSString*)yKey;

	/// Returns a CGSize from a width value and height value in this dictionary
	-(CGSize) sizeFromWidthKey:(NSString*)widthKey heightKey:(NSString*)heightKey;
@end

/// Extends CCNode
@interface CCNode
(Extended)
	/// Shortcut to self.contentSize.width
	@property (readonly,nonatomic) float width;

	/// Shortcut to self.contentSize.height
	@property (readonly,nonatomic) float height;

	/// Removes the node from its parent and cleans up
	-(void) removeFromParent;

	/// Return the integer index of this node, where 0 represents the first node in the parent's children and 1 represents the second
	-(int) leafIndex;

	/// Return a normalized vector from this node's position to the otherNode's position
	-(CGPoint) vectorTo:(CCNode*)otherNode;

	/// Return YES if the point is within our bounding box
	-(BOOL) isPointWithinBoundingBox:(CGPoint)point;

	/// Creates a label and adds it as a child of this node, given the argument properties
	-(CCLabelBMFont*) addLabelBMFont:(NSString*)fontFile string:(NSString*)string position:(CGPoint)pos scale:(CGFloat)scale alignment:(int)alignment z:(int)z;
@end

/// Extends CCScene
@interface CCScene
(Extended)
	/// Initialize the scene and add a child of the given class type
	-(id) initWithChildClass:(Class)c;
@end

/// Extends CCSprite
@interface CCSprite
(Extended)
	/// Return a CGPoint representing how much the anchor point has offset the sprite (value is in points)
	-(CGPoint) anchorOffset;

	/// Set the currently displayed sprite frame by filename
	-(void) setDisplayFrameName:(NSString*)fname;

	/// Shortcut method for setDisplayFrameName (seems more intuitive for auto-complete)
	-(void) setFrame:(NSString*)fname;

	/// Run an action that makes the sprite fade in and out over the specified duration (repeats until cancelled)
	-(void) glow:(float)duration;

	/// Run an animation action given the animation and other parameters
	-(void) animate:(CCAnimation*)animation tag:(int)tag repeat:(BOOL) repeat restore:(BOOL)restore;
@end

/// Extends CCAnimation
@interface CCAnimation
(Extended)
	/// Initialize the animation with a format for the sprite frame names, a substring, frame count, and delay
-(id) initWithFormat:(NSString*)nameFormat subString:(NSString*)subString frameCount:(int)frameCount delay:(CGFloat)delay;
@end

/// Extends CCTMXLayer
@interface CCTMXLayer
(Extended)
	/// Get the integer value of a layer property
	-(int) intValueFromProperty:(NSString*)propertyName;

	/// Return YES if the layer has a property with the given name
	-(BOOL) hasProperty:(NSString*)propertyName;

	/// Return a CGPoint created from an x property and y property
	-(CGPoint) pointFromXProperty:(NSString*)xProperty yProperty:(NSString*)yProperty;
@end

/// Extends CCMenuItemSprite
@interface CCMenuItemSprite
(Extended)
	/// Initialize this menu item with sprite frame names, a target and selector
	-(id) initFromNormalSpriteFrameName:(NSString*)normalFname selected:(NSString*)selectedFname
		disabled:(NSString*)disabledFname target:(id)target selector:(SEL)selector;
@end

/// Extends UITouch
@interface UITouch
(Extended)
	-(CGPoint) locationInGL;
	-(CGPoint) previousLocationInGL;
@end

/// An array of cached sprite frames
@interface KITSpriteFrameArray : NSObject
	{
		NSMutableArray* array;
	}
	
	/// The array of sprite frames
	@property (readonly,nonatomic) NSMutableArray* array;
	
	/// Initialize the array with cached sprite frames, given a format string, sub string and frame count
-(id) initWithFormat:(NSString*)format subString:(NSString*)subString frameCount:(int)frameCount;

@end

/// Returns YES if the circle intersects the rectangle
BOOL KITCircleIntersectsRect(CGPoint circlePosition,float circleRadius,CGRect rect);
