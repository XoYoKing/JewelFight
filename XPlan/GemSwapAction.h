//
//  JewelSwapAction.h
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemAction.h"

@class GemSprite;

/// 宝石交换动作
@interface GemSwapAction : GemAction
{
    
    // 使用标识而不是对象是因为在Action执行过程中有可能引用失效
    int jewelGlobalId1;
    int jewelGlobalId2;
    int state;
    int newState;
}

@property (readonly,nonatomic) GemSprite *jewel1;

@property (readonly,nonatomic) GemSprite *jewel2;

/// 构造函数
-(id) initWithJewelController:(GemController *)contr  jewel1:(GemSprite*)j1 jewel2:(GemSprite*)j2;

-(id) initWithJewelController:(GemController *)contr jewel1:(GemSprite *)j1 jewel2:(GemSprite *)j2 checkElimate:(BOOL)check;


@end
