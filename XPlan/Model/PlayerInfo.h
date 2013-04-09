//
//  PlayerInfo.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "UserInfo.h"
#import "HeroVo.h"

/// 玩家信息
@interface PlayerInfo : UserInfo
{
    BOOL isNew; // 是否是新玩家
    NSMutableDictionary *heroDict;
    CCArray *heroList; // 玩家全部英雄集合
    NSString *heroLeaderId; // 英雄队长标识
    CCArray *heroFighterIds; //  出战英雄队伍集合
}

/// 新玩家标识
@property (readwrite,nonatomic) BOOL isNew;

/// 队长标识
@property (readwrite,nonatomic,retain) NSString *heroLeaderId;

/// 出战队伍集合
@property (readonly,nonatomic) CCArray *heroFighterIds;

/// 添加英雄数据对象
-(void) addHeroVo:(HeroVo*)hero;

/// 基于英雄标识获取英雄数据对象
-(HeroVo*) getHeroVo:(NSString*)heroId;

/// 获取全部英雄
-(CCArray*) getHeros;

/// 获取英雄队长
-(HeroVo*) getHeroLeader;

/// 获取英雄出战战队
-(CCArray*) getHeroFighters;

@end
