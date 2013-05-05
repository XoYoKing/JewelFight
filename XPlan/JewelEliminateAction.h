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
    CCArray *connectedGroup; // 待消除宝石序列组
    
    BOOL allJewelsEliminated; // 全部宝石消除完毕标记
}

/// 构造函数
-(id) initWithJewelController:(JewelController *)contr  connectedGroup:(CCArray*)group;

@end
