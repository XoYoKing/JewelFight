//
//  OpponentjewelBoard.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"


@class UserInfo,FighterVo,JewelBoard;
@interface PvPOpponentJewelPanel : CCLayer
{
    CCLabelTTF *nameLabel; // 名字标签
    JewelBoard *jewelBoard; // 宝石面板
}

@property (readonly,nonatomic) JewelBoard *jewelBoard;

/// 设置对手信息
-(void) setOpponent:(UserInfo*)opp;


@end
