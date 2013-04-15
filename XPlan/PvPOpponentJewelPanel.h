//
//  OpponentJewelPanel.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"


@class UserInfo,FighterVo,JewelPanel;
@interface PvPOpponentJewelPanel : CCLayer
{
    CCLabelTTF *nameLabel; // 名字标签
    JewelPanel *jewelPanel; // 宝石面板
}

@property (readonly,nonatomic) JewelPanel *jewelPanel;

/// 设置对手信息
-(void) setOpponent:(UserInfo*)opp;

/// 设置战士信息
-(void) setFighter:(FighterVo*)fv;

@end
