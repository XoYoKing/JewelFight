//
//  JewelMessageData.h
//  XPlan
//
//  Created by Hex on 4/21/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "MessageData.h"

@interface JewelMessageData : MessageData
{
    long userId; // 宝石消息来源用户
}

@property (readonly,nonatomic) long userId;

-(id) initWithUserId:(long)uid;

@end
