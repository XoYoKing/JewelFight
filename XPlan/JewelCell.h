//
//  JewelCell.h
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JewelSprite,JewelController,JewelVo;

/// 宝石格子
@interface JewelCell : NSObject
{
    JewelController *controller; // 宝石控制器
    CGPoint coord; // 格子坐标
    int jewelGlobalId; // 宝石唯一标识
}

/// 控制器
@property (readonly,nonatomic) JewelController *controller;

/// 格子坐标
@property (readwrite,nonatomic,assign) CGPoint coord;

@property (readwrite,nonatomic) int jewelGlobalId;

/// 关联宝石数据对象
@property (readonly,nonatomic) JewelVo *jewelVo;

/// 宝石
@property (readonly,nonatomic) JewelSprite *jewelSprite;

/// 初始化
-(id) initWithJewelController:(JewelController*)jc coord:(CGPoint)cd;

@end
