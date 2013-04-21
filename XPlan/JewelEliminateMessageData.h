//
//  JewelEliminateMessageData.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelMessageData.h"

/// 宝石消除数据
@interface JewelEliminateMessageData : JewelMessageData
{
    CCArray *jewelGlobalIds; // 消除宝石标识集合
}

@property (readonly,nonatomic) CCArray *jewelGlobalIds;

+(id) dataWithUserId:(long)uid jewelGlobalIds:(CCArray*)globalIds;

-(id) initWithUserId:(long)uid jewelGlobalIds:(CCArray*)globalIds;


@end
