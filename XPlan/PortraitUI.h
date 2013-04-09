//
//  PortraitUI.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "FighterVo.h"
#import "CCScale9Sprite.h"

@interface PortraitUI : CCNode
{
    CCScale9Sprite *portrait; // 头像
    int hp; // 血量
    int maxHp; // 最大血量
    FighterVo *fighterVo; // 英雄角色信息
}

/// 英雄战斗状态信息
@property (readwrite,nonatomic,retain) FighterVo *fighterVo;

/// 血量
@property (readwrite,nonatomic) int hp;

/// 最大血量
@property (readwrite,nonatomic) int maxHp;

/// 初始化
-(id) initWithFighterVo:(FighterVo*)fv;

-(void) initUI;

/// 减少生命值
-(void) reduceHp:(int)reduce;

@end
