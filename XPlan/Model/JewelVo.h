//
//  JewelVo.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"


/// 宝石数据对象 Jewel Value Object
@interface JewelVo : NSObject
{
    int globalId; // 全局标识
    int jewelId; // 宝石Item标识
    int jewelType; // 宝石类型
    int special; // 特殊宝石
    CGPoint coord; // 所处坐标
    int yGap; // y轴移动距离
    int state; // 宝石状态 0为未消除, 1为消除
    
}

/// 全局标识
@property (readwrite,nonatomic) int globalId;

/// 宝石标识
@property (readwrite,nonatomic) int jewelId;

///宝石类型 1 普通宝石; 2 特殊宝石
@property (readwrite,nonatomic) int jewelType;

/// 宝石坐标
@property (readwrite,nonatomic) CGPoint coord;

@property (readwrite,nonatomic) float yPos;

/// 宝石下落速度
@property (readwrite,nonatomic) float ySpeed;

/// 执行耗时
@property (readonly,nonatomic) float time;

/// 特殊宝石类型
@property (readwrite,nonatomic) int special;

/// 宝石状态 0 为未消除 1为消除
@property (readwrite,nonatomic) int state;

@end
