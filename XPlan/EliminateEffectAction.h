//
//  ElinimateEffect.h
//  XPlan
//
//  Created by Hex on 5/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JewelEliminateAction.h"

/// 消除效果
@interface EliminateEffectAction : NSObject
{
    JewelController *jewelController;
    JewelEliminateAction *ownerAction;
    NSString *name; // 宝石动作名称
    BOOL skipped; // 是否跳过
}

-(id) initWithJewelController:(JewelController *)contr eliminateAction:(JewelEliminateAction*)a;

/// 开始
-(void) start;

/// 是否结束
-(BOOL) isOver;

/// 跳过
-(void) skip;

/// 执行
-(void) execute;

/// 逻辑更新
-(void) update:(ccTime)delta;

@end
