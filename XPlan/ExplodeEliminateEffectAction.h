//
//  ExplodeEliminateEffect.h
//  XPlan
//
//  Created by Hex on 5/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "EliminateEffectAction.h"

@class JewelVo,JewelSprite;

@interface ExplodeEliminateEffectAction : EliminateEffectAction
{
    int actorGlobalId;
    float timer;
    BOOL eliminateDone; // 消除结束标记
}

-(id) initWithJewelController:(JewelController *)contr eliminateAction:(JewelEliminateAction *)a jewel:(JewelVo*)jv;


@end
