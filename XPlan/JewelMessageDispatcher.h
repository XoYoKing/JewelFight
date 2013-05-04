//
//  JewelMessageDispatcher.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 宝石消息触发器
@interface JewelMessageDispatcher : NSObject
{
    CCArray *messageQueue; // 消息队列
}

/// 发布消息
-(void) dispatchMessage:(int)messgeId object:(id)object;
@end
