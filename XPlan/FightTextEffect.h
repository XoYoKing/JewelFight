//
//  TextEffect.h
//  XPlan
//
//  Created by Hex on 4/23/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"

#define kTextEffectTypeLoss 0
#define kTextEffectTypeGain 1
#define kTextEffectTypeBonus 2

/// 文字特效
@interface FightTextEffect : EffectSprite
{
    
}

/// 初始化
-(id) initWithType:(int)ty text:(NSString*)te pos:(CGPoint)po;

-(void) start;

@end
