//
//  OpponentJewelPanel.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"


@class UserInfo,FighterVo,GemBoard;
@interface PvPOpponentJewelPanel : CCLayer
{
    CCLabelTTF *nameLabel; // 名字标签
    GemBoard *gemBoard; // 宝石面板
}

@property (readonly,nonatomic) GemBoard *gemBoard;

/// 设置对手信息
-(void) setOpponent:(UserInfo*)opp;


@end
