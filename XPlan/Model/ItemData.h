//
//  ItemData.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 物品数据
@interface ItemData : NSObject
{
    int uniqueId; // 唯一标识
    int itemId; // 物品标识
    int targetId; // 道具目标targetId
    int slot; // 在背包仓库时,标识在哪个格子/ 在身上时,标识在哪个部位/ 在邮件或寄售挂单时,标识顺序
    int amount; // 数量
    int maxAmount; // 最大上限数
    int quality; // 品质等级 (道具名字颜色)
    int itemType1; // 道具1级分类 1. 装备 2药品
    
    
}

@end
