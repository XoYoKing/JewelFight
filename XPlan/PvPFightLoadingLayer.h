//
//  PvPFightLoadingLayer.h
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "HonsterBar.h"

@interface PvPFightLoadingLayer : CCLayer
{
    HonsterBar *loadingBar; // 加载进度条
    CCSprite *loadingBgSprite;
    CCSprite *loadingBarSprite;
    CCSprite *loadingMaskSprite;
}

@end
