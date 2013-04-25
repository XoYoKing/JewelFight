//
//  FightLayer.h
//  XPlan
//
//  Created by Hex on 4/23/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class FightField,FightPortrait;

/// 战斗面板
@interface FightPanel : CCLayer
{
    CCLayer *streetLayer; // 街道层
    FightField *fightField;
    FightPortrait *portrait;
    
}

@property (readonly,nonatomic) FightField *fightField;

@property (readonly,nonatomic) FightPortrait *portrait;

/// 设置战斗地点
-(void) setFightStreet:(int)sId;

@end
