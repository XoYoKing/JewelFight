//
//  JewelAction.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "JewelManager.h"

@interface JewelAction : NSObject
{
    JewelPanel *jewelPanel; //宝石面板
}

-(id) initWithJewelPanel:(JewelPanel*)panel;


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
