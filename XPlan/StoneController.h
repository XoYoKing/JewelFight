//
//  StoneController.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class StonePanel,StoneVo;
/// 宝石控制器
@interface StoneController : NSObject
{
    StonePanel *stonePanel; //对应宝石面板
    NSMutableDictionary *stoneGrid; // 宝石格子
    
    // special
    CCArray *specialList; // 特殊宝石列表
    StoneVo *currentSpecial; // 当前特殊宝石
}

/// 宝石面板
@property (readonly,nonatomic) StonePanel *stonePanel;

/// 初始化
-(id) initWithStonePanel:(StonePanel*)panel;

@end
