//
//  EffectSprite.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@interface EffectSprite : CCSprite
{
    CGPoint offset;
    BOOL isAttachedToEffectSpriteLayer;
}

@property (readwrite,nonatomic) CGPoint offset;

/// Moves the EffectSprite if it is attached to the effectSpriteLayer
-(void)parentMoved:(CGPoint)newPosition;

@end
