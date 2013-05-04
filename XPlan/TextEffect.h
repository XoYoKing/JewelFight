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
@interface TextEffect : EffectSprite
{
    
}

/// 初始化
-(id) initWithType:(int)_type text:(NSString*)_text item:(FieldItem*)_item pos:(CGPoint)_pos;

-(void) start;

@end
