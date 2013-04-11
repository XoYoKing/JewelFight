//
//  FightScene.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "BaseCommand.h"


@class PvPController,UserInfo;

/// 战斗场景
@interface PvPScene : CCScene
{
    PvPController *controller; // 控制器
    UserInfo *oppUser; // 对手用户
    CCArray *oppFightHeroList; // 对手出战英雄
    int state;
}

/// pvp战斗控制器
@property (readonly,nonatomic) PvPController *controller;

/// 对手用户信息
@property (readwrite,nonatomic,retain) UserInfo *oppUser;

/// 对手出战英雄
@property (readonly,nonatomic) CCArray *oppFightHeroList;

-(void) initialize;

/// 变更状态
-(void) changeState:(int)newState;


/// 开始战斗
-(void) enterFight;

@end
