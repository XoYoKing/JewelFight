//
//  JewelAction.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class JewelController;

@interface GemAction : NSObject
{
    JewelController *jewelController; //宝石控制器
    NSString *name; // 宝石动作名称
    BOOL skipped; // 是否跳过
}

-(id) initWithJewelController:(JewelController*)contr name:(NSString*)n;


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
