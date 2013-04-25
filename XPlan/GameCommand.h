//
//  GameCommand.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "BaseCommand.h"

@class UserInfo,HeroVo,PlayerInfo,GemVo,FighterVo,AttackVo;

@interface GameCommand : BaseCommand
{
    
}

#pragma mark -
#pragma mark Request

/// 请求心跳
-(void) requestHeart;

/// 请求进入游戏
-(void) requestEnterGame;

/// 请求连接房间
-(void) requestHomeWithHomeId:(NSString*)homeId;

#pragma mark -
#pragma mark Populate

/// 封装用户数据
+(void) populateUserInfo:(UserInfo*)user data:(ServerDataDecoder*)data;

/// 封装玩家数据
+(void) populatePlayerInfo:(PlayerInfo*)player data:(ServerDataDecoder*)data;

/// 封装武将数据
+(void) populateHeroVo:(HeroVo*)hero data:(ServerDataDecoder*)data;


#pragma mark -
#pragma mark Response



@end
