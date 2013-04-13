//
//  JewelAddAction.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAction.h"

/// 添加宝石动作
@interface JewelAddAction : JewelAction
{
    CCArray *jewelVoList; // 要增加的宝石列表
    int continueDispose;
}

/// 连续消除
@property (readonly,nonatomic) int continueDispose;

/// 构造函数
-(id) initWithJewelPanel:(JewelPanel *)panel continueDispose:(int)cd jewelVoList:(CCArray*)list;

@end
