//
//  EffectSprite.m
//  XPlan
//
//  Created by Hex on 11/19/12.
//
//

#import "EffectSprite.h"
#import "Constants.h"

@implementation EffectSprite

@synthesize offset;

-(id) init
{
    if((self=[super init]))
    {
        isAttachedToEffectSpriteLayer = NO;
    }
    return self;
}

-(void) setParent:(CCNode *)parent
{
    [super setParent:parent];
    [self setShaderProgram:[[CCShaderCache sharedShaderCache]
                                programForKey:kCCShader_PositionTextureColorAlphaTest]];
}


-(void) setPosition:(CGPoint)position
{
    [super setPosition:ccpAdd(offset, position)];
}

-(void)parentMoved:(CGPoint)newPosition
{
    if(isAttachedToEffectSpriteLayer)
    {
        self.position = newPosition;
    }
}


@end
