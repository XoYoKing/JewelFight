//
//  JewelDropAction.h
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAction.h"

/// 宝石掉落动作
@interface JewelFallAction : JewelAction
{
    CCArray *addList; // 新加的宝石数据对象
    BOOL isFallingJewels; // 是否正在下落宝石
    
}

/// 初始化
-(id) initWithJewelController:(JewelController *)contr addList:(CCArray*)list;

@end
