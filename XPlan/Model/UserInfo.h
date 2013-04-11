//
//  PersonVo.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class HeroVo;

/// 用户信息
@interface UserInfo : NSObject
{
    long userId; // 用户标识
    NSString *name; // 用户名称
    int sex; // 性别
    NSString *currentMap; // 角色
    int silver; // 银币数量
    int gold; // 金币数量
    int diamond; // 钻石数量
    NSString *avatar; // 用户头像
}

/// 用户唯一标识
@property (readwrite,nonatomic) long userId;

/// 用户名称
@property (readwrite,nonatomic,retain) NSString *name;

/// 当前所处地图
@property (readwrite,nonatomic,retain) NSString *currentMap;

/// 性别
@property (readwrite,nonatomic) int sex;

/// 银币数量
@property (readwrite,nonatomic) int silver;

/// 金币数量
@property (readwrite,nonatomic) int gold;

/// 钻石数量
@property (readwrite,nonatomic) int diamond;

/// avatar头像
@property (readwrite,nonatomic,copy) NSString *avatar;

@property (readwrite,nonatomic,retain) HeroVo *figureHero;

@end
