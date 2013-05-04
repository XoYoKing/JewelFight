//
//  StoneVo.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"


/// 宝石数据对象 Stone Value Object
@interface StoneVo : NSObject
{
    NSString *globalId; // 全局标识
    int stoneId; // 宝石Item标识
    int stoneType; // 宝石类型
    int special; // 特殊宝石
    CGPoint coord; // 所处坐标
    int yGap; // ??
    int hDispose; // 水平消除宝石数量
    int vDispose; // 垂直消除宝石数量
    int state; // 宝石状态 0为未消除, 1为消除
    BOOL disposeTop;
    BOOL disposeRight;
    
}

/// 全局标识
@property (readwrite,nonatomic,retain) NSString *globalId;

/// 宝石标识
@property (readwrite,nonatomic) int stoneId;

///宝石类型 1 普通宝石; 2 特殊宝石
@property (readwrite,nonatomic) int stoneType;

/// 宝石坐标
@property (readwrite,nonatomic) CGPoint coord;

///
@property (readwrite,nonatomic) int yGap;

/// 将要到达的y坐标
@property (readonly,nonatomic) int toY;

/// 执行耗时
@property (readonly,nonatomic) float time;

/// 水平方向消除宝石数量
@property (readwrite,nonatomic) int hDispose;

/// 垂直方向消除宝石数量
@property (readwrite,nonatomic) int vDispose;

/// 销毁上方
@property (readwrite,nonatomic) BOOL disposeTop;

/// 销毁右侧
@property (readwrite,nonatomic) BOOL disposeRight;

/// 特殊道具
@property (readwrite,nonatomic) int special;

/// 宝石状态 0 为未消除 1为消除
@property (readwrite,nonatomic) int state;

/// 当前宝石能够消掉的宝石数量
-(int) disposeNum;

-(BOOL) lt;

/// 是否出现在最左侧
-(BOOL) isLeft;

-(BOOL) isRight;

-(BOOL) isTop;

-(BOOL) isBottom;

/// 重新设置宝石标识
-(void) newId;

@end
