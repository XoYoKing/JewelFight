//
//  JewelCell.h
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JewelSprite,JewelBoard;

/// 宝石面板的格子
@interface GemCell : NSObject
{
    JewelBoard *board; // 对应宝石面板
    CGPoint coord; // 格子坐标
    int gemGlobalId; // 宝石唯一标识
    int comingGemGlobalId; // 即将到来的宝石标识
}

/// 格子坐标
@property (readwrite,nonatomic,assign) CGPoint coord;

/// 对应宝石面板
@property (readonly,nonatomic) JewelBoard *board;

/// 宝石面板
@property (readwrite,nonatomic) int gemGlobalId;

/// 即将到来的宝石标识
@property (readwrite,nonatomic) int comingGemGlobalId;

/// 宝石
@property (readonly,nonatomic) JewelSprite *gemSprite;

/// 在宝石面板上的范围
@property (readonly,nonatomic) CGRect panelRect;

/// 初始化
-(id) initWithJewelPanel:(JewelBoard*)thePanel coord:(CGPoint)theCoord;

@end
