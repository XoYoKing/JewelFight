//
//  PVPOpponentAndFightersCommandData.h
//  XPlan
//
//  Created by Hex on 4/23/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "CommandData.h"
#import "UserInfo.h"

/// PvP 对手和战士信息
@interface PVPOpponentAndFightersCommandData : CommandData
{
    int playerTeam; // 玩家阵营
    CCArray *playerFighters; // 玩家战士集合
    
    int opponentTeam; // 对手阵营
    UserInfo *opponentUserInfo; // 对手信息
    CCArray *opponentFighters; // 对手战士集合
    
    int streetId; // 街道标识
}

@property (readwrite,nonatomic) int playerTeam;

@property (readonly,nonatomic) CCArray *playerFighters;

@property (readwrite,nonatomic) int opponentTeam;

@property (readonly,nonatomic) UserInfo *opponentUserInfo;

@property (readonly,nonatomic) CCArray *opponentFighters;

/// 街道标识
@property (readwrite,nonatomic) int streetId;

@end
