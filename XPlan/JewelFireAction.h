//
//  JewelFireAction.h
//  XPlan
//
//  Created by Hex on 4/14/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAction.h"

#define kJewelFireActionStateBeforeFire 0 // 准备
#define kJewelFireActionStateFiring 1 // 燃烧中
#define kJewelFireActionStateOver 2 // 动作结束

/// 宝石燃烧动作
@interface JewelFireAction : JewelAction
{
    CCArray *jewelVoList; // 需要燃烧的宝石集合

    int state;
    int newState;
}

-(id) initWithJewelController:(JewelController *)contr jewelVoList:(CCArray*)list;

@end
