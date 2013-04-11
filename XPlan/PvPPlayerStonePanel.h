//
//  PlayerStonePanel.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class  FighterVo,DoStonePanel;

@interface PvPPlayerStonePanel : CCLayer
{
    DoStonePanel *stonePanel; // 宝石面板
    
}

-(void) setFighter:(FighterVo*)fv;

@end
