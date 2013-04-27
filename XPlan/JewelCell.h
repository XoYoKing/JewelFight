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
@interface JewelCell : NSObject
{
    JewelBoard *board; // 对应宝石面板
    CGPoint coord; // 格子坐标
    int jewelGlobalId; // 宝石唯一标识
    int comingJewelGlobalId; // 即将到来的宝石标识
}

/// 格子坐标
@property (readwrite,nonatomic,assign) CGPoint coord;

/// 对应宝石面板
@property (readonly,nonatomic) JewelBoard *board;

/// 宝石面板
@property (readwrite,nonatomic) int jewelGlobalId;

/// 即将到来的宝石标识
@property (readwrite,nonatomic) int comingJewelGlobalId;

/// 宝石
@property (readonly,nonatomic) JewelSprite *jewelSprite;

/// 在宝石面板上的范围
@property (readonly,nonatomic) CGRect boardRect;

/// 初始化
-(id) initWithJewelBoard:(JewelBoard*)jb coord:(CGPoint)cd;

@end