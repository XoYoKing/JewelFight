//
//  PlayerInfo.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "UserInfo.h"
#import "HeroData.h"

/// 玩家信息
@interface PlayerVo : UserInfo
{
    BOOL isNew; // 是否是新玩家
    CCArray *heros; // 玩家全部武将集合
}

/// 新玩家标识
@property (readwrite,nonatomic) BOOL isNew;

/// 基于武将标识获取武将数据对象
-(HeroData*) getHeroVoById:(NSString*)heroId;

/// 获取全部武将
-(CCArray*) getAllHeros;

@end
