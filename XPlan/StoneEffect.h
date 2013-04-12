//
//  BaseEffect.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class StoneSprite;

/// 宝石效果s
@interface StoneEffect : NSObject
{
    StoneSprite *stone; // 对应宝石
    
}

-(void) update:(ccTime)delta;

@end
