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
@interface GemVo : NSObject
{
    int globalId; // 全局标识
    int jewelId; // 宝石Item标识
    int jewelType; // 宝石类型
    int special; // 特殊宝石
    CGPoint coord; // 所处坐标
    int yGap; // y轴移动距离
    int hEliminate; // 水平消除宝石数量
    int vEliminate; // 垂直消除宝石数量
    int state; // 宝石状态 0为未消除, 1为消除
    BOOL eliminateTop;
    BOOL eliminateRight;
    
}

/// 全局标识
@property (readwrite,nonatomic) int globalId;

/// 宝石标识
@property (readwrite,nonatomic) int jewelId;

///宝石类型 1 普通宝石; 2 特殊宝石
@property (readwrite,nonatomic) int jewelType;

/// 宝石坐标
@property (readwrite,nonatomic) CGPoint coord;

///
@property (readwrite,nonatomic) int yGap;

/// 将要到达的y坐标
@property (readonly,nonatomic) int toY;

/// 执行耗时
@property (readonly,nonatomic) float time;

/// 水平方向消除宝石数量
@property (readwrite,nonatomic) int hEliminate;

/// 垂直方向消除宝石数量
@property (readwrite,nonatomic) int vEliminate;

/// 销毁上方
@property (readwrite,nonatomic) BOOL eliminateTop;

/// 销毁右侧
@property (readwrite,nonatomic) BOOL eliminateRight;

/// 特殊道具
@property (readwrite,nonatomic) int special;

/// 宝石状态 0 为未消除 1为消除
@property (readwrite,nonatomic) int state;

/// 当前宝石能够消掉的宝石数量
-(int) eliminateNum;

-(BOOL) lt;

/// 添加y轴缺口
-(void) addYGap;

/// 是否出现在最左侧
-(BOOL) isLeft;

-(BOOL) isRight;

-(BOOL) isTop;

-(BOOL) isBottom;

/// 重新设置宝石标识
-(void) newId;

@end
