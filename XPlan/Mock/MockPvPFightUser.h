//
//  PvPFightUser.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface MockPvPFightUser : NSObject
{
    UserInfo *userInfo; // 玩家信息
    CCArray *fighters; // 战士集合
    int currentFighterIndex; // 当前战士索引
    NSMutableDictionary *jewelDict; // 宝石字典
    CCArray *jewelList; // 宝石列表
}

@property (readwrite,nonatomic,retain) UserInfo *userInfo;

@property (readwrite,nonatomic,retain) CCArray *fighters;

@property (readwrite,nonatomic) int currentFighterIndex;

@property (readwrite,nonatomic,retain) NSMutableDictionary *jewelDict;

@property (readwrite,nonatomic,retain) CCArray *jewelList;

-(void) initJewels;

-(void) swapJewel1:(int)globalId1 jewel2:(int)globalId2;

-(void) eliminateJewelsWithGlobalIds:(CCArray*)globalIds;

/// 填充宝石
-(void) fillEmptyJewels:(CCArray*)filledList;

@end
