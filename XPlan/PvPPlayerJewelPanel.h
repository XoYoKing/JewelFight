//
//  PlayerjewelBoard.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class  FighterVo,JewelBoard;

@interface PvPPlayerJewelPanel : CCLayer
{
    CCLabelTTF *nameLabel; // 玩家名字
    JewelBoard *jewelBoard; // 宝石面板
    
}

@property (readonly,nonatomic) JewelBoard *jewelBoard;

@end
