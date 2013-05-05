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
    NSMutableArray *eliminateGroup; // 消除宝石标识集合组
}

@property (readonly,nonatomic) NSMutableArray *eliminateGroup;

+(id) dataWithUserId:(long)uid eliminateGroups:(NSMutableArray*)group;

-(id) initWithUserId:(long)uid eliminateGroups:(NSMutableArray*)group;


@end
