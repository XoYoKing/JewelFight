//
//  JewelAddAction.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemAction.h"

/// 添加宝石动作
@interface GemAddAction : GemAction
{
    CCArray *jewelVoList; // 要增加的宝石列表
}

/// 连续消除
@property (readonly,nonatomic) int continueDispose;

/// 构造函数
-(id) initWithJewelController:(GemController *)contr  jewelVoList:(CCArray*)list;

@end
