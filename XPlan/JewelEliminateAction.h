//
//  JewelElimateAction.h
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAction.h"

@interface JewelEliminateAction : JewelAction
{
    CCArray *elimList; // 待消除宝石列表
}

/// 构造函数
-(id) initWithJewelController:(JewelController *)contr  elimList:(CCArray*)list;

@end