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
@interface StoneData : NSObject
{
    NSString *stoneId; // 宝石标识
    NSString *type; // 宝石类型
    int special; // 特殊道具
    int x; // x坐标
    int y; // y坐标
    int yGap; // ??
    int hDispose; // 水平消除宝石数量
    int vDispose; // 垂直消除宝石数量
    int state; // 宝石状态 0为未消除, 1为消除
    BOOL disposeTop;
    BOOL disposeRight;
    
}

@property (readwrite,nonatomic) NSString *stoneId;

/// x坐标
@property (readwrite,nonatomic) int x;

/// y 坐标
@property (readwrite,nonatomic) int y;

/// 将要到达的y坐标
@property (readonly,nonatomic) int toY;

/// 执行耗时
@property (readonly,nonatomic) float time;

-(int) disposeNum;

-(BOOL) lt;

/// 是否出现在最左侧
-(BOOL) isLeft;

-(BOOL) isRight;

-(BOOL) isTop;

-(BOOL) isBottom;

@end
