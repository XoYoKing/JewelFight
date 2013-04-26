//
//  JewelSwapAction.h
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemAction.h"

@class JewelSprite;

/// 宝石交换动作
@interface GemSwapAction : GemAction
{
    
    // 使用标识而不是对象是因为在Action执行过程中有可能引用失效
    int jewelGlobalId1;
    int jewelGlobalId2;
    int state;
    int newState;
}

@property (readonly,nonatomic) JewelSprite *jewel1;

@property (readonly,nonatomic) JewelSprite *jewel2;

/// 构造函数
-(id) initWithJewelController:(JewelController *)contr  jewel1:(JewelSprite*)j1 jewel2:(JewelSprite*)j2;

-(id) initWithJewelController:(JewelController *)contr jewel1:(JewelSprite *)j1 jewel2:(JewelSprite *)j2 checkElimate:(BOOL)check;


@end
