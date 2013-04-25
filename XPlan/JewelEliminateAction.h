//
//  JewelElimateAction.h
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemAction.h"

@interface JewelEliminateAction : GemAction
{
    CCArray *elimList; // 待消除宝石列表
}

/// 构造函数
-(id) initWithJewelController:(GemController *)contr  elimList:(CCArray*)list;

@end
