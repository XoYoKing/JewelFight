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

/// 加载层
@interface LoadingLayer : CCLayer
{
    HonsterBar *loadingBar; // 加载进度条
    CCSprite *loadingBgSprite;
    CCSprite *loadingBarSprite;
    CCSprite *loadingMaskSprite;
    CCLabelTTF *textLabel; // 文本标签
}

/// 设置加载百分比
-(void) setPercent:(float)value;


/// 设置加载文本
-(void) setText:(NSString*)text;

@end
