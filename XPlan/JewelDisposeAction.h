//
//  JewelDisposeAction.h
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAction.h"

/// 消除宝石动作
@interface JewelDisposeAction : JewelAction
{
    int specialType; // 特殊宝石类型
    CCArray *specialList; // 特殊宝石列表
    CCArray *disposeList; // 消除宝石列表
}

-(id) initWithJewelPanel:(JewelPanel *)panel disposeList:(CCArray*)disList specialList:(CCArray*)speList;

@end
