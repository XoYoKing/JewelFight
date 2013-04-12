//
//  StoneCell.h
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>


@class StoneSprite,StonePanel;

/// 宝石面板的格子
@interface StoneCell : NSObject
{
    StonePanel *panel; // 对应宝石面板
    CGPoint coord; // 格子坐标
    NSString *jewelId; // 宝石标识
    NSString *comingStoneId; // 即将到来的宝石标识
}

/// 格子坐标
@property (readwrite,nonatomic,assign) CGPoint coord;

/// 对应宝石面板
@property (readonly,nonatomic) StonePanel *panel;

/// 宝石面板
@property (readwrite,nonatomic,retain) NSString *jewelId;

/// 即将到来的宝石标识
@property (readwrite,nonatomic,retain) NSString *comingStoneId;

/// 宝石
@property (readwrite,nonatomic,retain) StoneSprite *stoneItem;

/// 初始化
-(id) initWithStonePanel:(StonePanel*)thePanel coord:(CGPoint)theCoord;

@end
