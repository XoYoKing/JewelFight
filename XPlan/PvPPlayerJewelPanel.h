//
//  PlayerJewelPanel.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class  FighterVo,JewelPanel;

@interface PvPPlayerJewelPanel : CCLayer
{
    CCLabelTTF *nameLabel; // 玩家名字
    JewelPanel *jewelPanel; // 宝石面板
    
}

@property (readonly,nonatomic) JewelPanel *jewelPanel;

-(void) setFighter:(FighterVo*)fv;

@end
