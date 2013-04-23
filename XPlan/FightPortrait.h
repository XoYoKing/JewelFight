//
//  PvPPortraitPanel.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "FighterVo.h"
#import "HonsterBar.h"

/// 对战英雄面板
@interface FightPortrait : CCLayer
{
    CCSprite *playerFighterPortrait; // 玩家战士头像
    CCSprite *opponentFighterPortrait; // 对手战士头像
    HonsterBar *playerFighterLifeBar; // 玩家战士血量条
    HonsterBar *opponentFighterLifeBar; // 对手战士血量条
    CCSprite *playerHp;
    CCSprite *playerHpBg;
    CCSprite *playerHpMask;
    CCSprite *opponentHp;
    CCSprite *opponentHpBg;
    CCSprite *opponentHpMask;
}

/// 设置玩家战士信息
-(void) setPlayerFighter:(FighterVo*)fv;

/// 设置对手战士信息
-(void) setOpponentFighter:(FighterVo*)fv;

/// 更新玩家战士血量
-(void) updatePlayerFighterLifeBarWithLife:(int)life maxLife:(int)maxLife;

/// 更新对手战士血量
-(void) updateOpponentFighterLifeBarWithLife:(int)life maxLife:(int)maxLife;

@end
