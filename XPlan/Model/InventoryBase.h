//
//  InventoryBase.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class ItemData;

/// 基础背包
@interface InventoryBase : NSObject
{
    int _type; //背包类型
    CCArray *_items; // 背包物品集合
}

/// 背包类型
@property (readonly,nonatomic) int type;

/// 背包物品集合
@property (readonly,nonatomic) CCArray *items;

/// 添加物品
-(void) addItem:(ItemData*)item;

@end
