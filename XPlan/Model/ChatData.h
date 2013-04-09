//
//  ChatData.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 聊天数据
@interface ChatData : NSObject
{
    UInt32 channel; // 发言频道
    NSString *nickName; // 昵称
    NSString *chatMessage; // 聊天内容
    NSString *priName; // 私聊对象
    BOOL isVip; //是否是VIP
}

/// 发言频道
@property (readwrite,nonatomic) UInt32 channel;

/// 昵称
@property (readwrite,nonatomic,retain) NSString *nickName;

/// 聊天内容
@property (readwrite,nonatomic,retain) NSString *charMessage;

/// 私聊对象
@property (readwrite,nonatomic,retain) NSString *priName;

/// 是否是VIP
@property (readwrite,nonatomic) BOOL isVip;

@end
