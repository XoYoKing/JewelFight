//
//  FightLayer.m
//  XPlan
//
//  Created by Hex on 4/23/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightPanel.h"
#import "CCBReader.h"

@implementation FightPanel

@synthesize fightField,portrait;

- (void) didLoadFromCCB
{
    
}

/// 设置战斗地点
-(void) setFightStreet:(int)sId
{
    // 获取街道
    // 街道使用CocosBuilder实现, 可以做矢量动画
    CCNode *bg = [CCBReader nodeGraphFromFile:[NSString stringWithFormat:@"street%d.ccbi",sId]];
    [streetLayer addChild:bg];
    [bg release];
}

@end
