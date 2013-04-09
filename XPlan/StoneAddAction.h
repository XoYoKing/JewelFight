//
//  StoneAddAction.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneAction.h"

/// 添加宝石动作
@interface StoneAddAction : StoneAction
{
    CCArray *stoneVoList; // 要增加的宝石列表
    int continueDispose;
}

/// 连续消除
@property (readonly,nonatomic) int continueDispose;

/// 构造函数
-(id) initWithStonePanel:(StonePanel *)panel continueDispose:(int)cd stoneVoList:(CCArray*)list;

@end
