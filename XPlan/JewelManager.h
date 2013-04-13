//
//  JewelController.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class JewelPanel,JewelVo;
/// 宝石控制器
@interface JewelManager : NSObject
{
    JewelPanel *jewelPanel; //对应宝石面板
    NSMutableDictionary *jewelGrid; // 宝石格子
    
    // special
    CCArray *specialList; // 特殊宝石列表
    JewelVo *currentSpecial; // 当前特殊宝石
}

/// 宝石面板
@property (readonly,nonatomic) JewelPanel *jewelPanel;

/// 初始化
-(id) initWithJewelPanel:(JewelPanel*)panel;

@end
