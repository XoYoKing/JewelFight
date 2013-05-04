//
//  PlayerStonePanel.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class  FighterVo,DoJewlPanel;

@interface PvPPlayerStonePanel : CCLayer
{
    CCLabelTTF *nameLabel; // 玩家名字
    DoJewlPanel *stonePanel; // 宝石面板
    
}

-(void) setFighter:(FighterVo*)fv;

@end
