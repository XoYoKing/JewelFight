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
    CCArray *eliminateGroup; // 消除宝石标识集合组
}

@property (readonly,nonatomic) CCArray *eliminateGroup;

+(id) dataWithUserId:(long)uid eliminateGroups:(CCArray*)group;

-(id) initWithUserId:(long)uid eliminateGroups:(CCArray*)group;


@end
