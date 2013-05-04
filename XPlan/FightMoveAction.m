//
//  FightMoveAction.m
//  XPlan
//
//  Created by Hex on 4/22/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightMoveAction.h"
#import "FighterSprite.h"
#import "Constants.h"
#import "FightField.h"

@implementation FightMoveAction

-(id) initWithFightField:(FightField *)f actor:(FighterSprite *)a  move:(int)m distance:(float)d time:(float)t
{
    if ((self = [super initWithFightField:f name:@"FightMoveAction"]))
    {
        actor = a; //
        target = t; // target
        move = m; // 移动方向
        distance = d;
        time = t;
    }
    
    return self;
}

-(void) start
{
    // 检查是否跳过动作
    if (skipped)
    {
        return;
    }
    
    // 如果为空,则跳过动作
    if (!self.actor)
    {
        [self skip];
        return;
    }
    
    if (move == 0)
    {
        return;
    }
    
    // 设定目标位置
    CGPoint targetPos = CGPointZero;
    
    if (move == 1)
    {
        targetPos = [fightField getPositionByCoord:actor.]
    }
    
    CCAction *move = [[CCSequence actions:
                       [CCMoveTo actionWithDuration:time position:<#(CGPoint)#>], nil]]
    
    JewelSprite *j1 = self.jewel1;
    CCAction *action1 = [CCMoveTo actionWithDuration:0.2f position:[jewelController.jewelPanel cellCoordToPosition:j2.coord]];
    action1.tag =kTagActionJewelSwap;
    [j1 runAction:action1];

}



@end
