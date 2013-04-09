//
//  StoneDisposeAction.h
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneAction.h"

/// 消除宝石动作
@interface StoneDisposeAction : StoneAction
{
    int specialType; // 特殊宝石类型
    CCArray *specialList; // 特殊宝石列表
    CCArray *disposeList; // 消除宝石列表
}

-(id) initWithStonePanel:(StonePanel *)panel disposeList:(CCArray*)disList specialList:(CCArray*)speList;

@end
