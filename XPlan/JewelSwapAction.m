//
//  JewelSwapAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelSwapAction.h"
#import "JewelSprite.h"
#import "JewelBoard.h"
#import "Constants.h"
#import "JewelController.h"
#import "JewelEliminateAction.h"
#import "GameMessageDispatcher.h"
#import "JewelSwapMessageData.h"

#define kTagActionJewelSwap 400 // 宝石交换

@interface JewelSwapAction()
{
    BOOL checkElimate; // 是否检查消除宝石
}

@end

@implementation JewelSwapAction

@synthesize jewel1,jewel2;

-(id) initWithJewelController:(JewelController *)contr jewel1:(JewelSprite *)j1 jewel2:(JewelSprite *)j2
{
    return [self initWithJewelController:contr jewel1:j1 jewel2:j2 checkElimate:YES];
}

-(id) initWithJewelController:(JewelController *)contr jewel1:(JewelSprite *)j1 jewel2:(JewelSprite *)j2 checkElimate:(BOOL)check
{
    if ((self = [super initWithJewelController:contr name:@"JewelSwapAction"]))
    {
        jewelGlobalId1 = j1.globalId;
        jewelGlobalId2 = j2.globalId;
        checkElimate = check;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(JewelSprite*) jewel1
{
    return [jewelController.jewelBoard getJewelSpriteWithGlobalId:jewelGlobalId1];
}

-(JewelSprite*) jewel2
{
    return [jewelController.jewelBoard getJewelSpriteWithGlobalId:jewelGlobalId2];
}

-(void) start
{
    // 检查是否跳过动作
    if (skipped)
    {
        return;
    }
    
    // 如果为空,则跳过动作
    if (!self.jewel1 || !self.jewel2)
    {
        [self skip];
        return;
    }
    
    // 宝石面板设置为不可操作
    [jewelController.jewelBoard setIsControlEnabled:NO];
    
    // 交换位置
    JewelSprite *j1 = self.jewel1;
    JewelSprite *j2 = self.jewel2;
    CCAction *action1 = [CCMoveTo actionWithDuration:0.2f position:[jewelController.jewelBoard cellCoordToPosition:j2.coord]];
    action1.tag =kTagActionJewelSwap;
    [j1 runAction:action1];
    
    CCAction *action2 = [CCMoveTo actionWithDuration:0.2f position:[jewelController.jewelBoard cellCoordToPosition:j1.coord]];
    action2.tag = kTagActionJewelSwap;
    [j2 runAction:action2];
}


-(void) update:(ccTime)delta
{
    JewelSprite *j1 = self.jewel1;
    JewelSprite *j2 = self.jewel2;
    if ([j1 getActionByTag:kTagActionJewelSwap]==nil && [j2 getActionByTag:kTagActionJewelSwap]==nil&&!skipped)
    {
        [self execute];
    }
    
    
    if (skipped)
    {
        //
    }
}

-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    if ([self.jewel1 getActionByTag:kTagActionJewelSwap]==nil && [self.jewel2 getActionByTag:kTagActionJewelSwap]==nil)
    {
        return YES;
    }
    return NO;
}

-(void) execute
{    
    // 交换完成,检查消除
    [jewelController.jewelBoard updateJewelGridInfo];
    
    if (checkElimate)
    {
        // 检查可消除性
        CCArray *elimList = [[CCArray alloc] initWithCapacity:20];
        [jewelController.jewelBoard findHorizontalEliminableJewels:elimList withJewel:self.jewel1];
        [jewelController.jewelBoard findVerticalEliminableJewels:elimList withJewel:self.jewel1];
        [jewelController.jewelBoard findHorizontalEliminableJewels:elimList withJewel:self.jewel2];
        [jewelController.jewelBoard findVerticalEliminableJewels:elimList withJewel:self.jewel2];
        
        // 存在可消除宝石
        if (elimList.count>0)
        {
            JewelEliminateAction *elimateAction = [[JewelEliminateAction alloc] initWithJewelController:jewelController elimList:elimList];
            [jewelController queueAction:elimateAction top:NO];
            [elimateAction release];
            
            // 发送切换消息
            JewelSwapMessageData *msg = [JewelSwapMessageData dataWithUserId:jewelController.userId jewelGlobalId1:jewelGlobalId1 jewelGlobalId2:jewelGlobalId2];
            [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:jewelController message:JEWEL_MESSAGE_SWAP_JEWELS object:msg];
        }
        else
        {
            // 不存在消除对象, 切换回去
            JewelSwapAction *swapAction = [[JewelSwapAction alloc] initWithJewelController:jewelController jewel1:self.jewel2 jewel2:self.jewel1 checkElimate:NO];
            [jewelController queueAction:swapAction top:NO];
            [swapAction release];
        }
        
        // 重置消除列表
        [elimList release];
        elimList = nil;
    }
    
    // 允许面板操作?
    [jewelController.jewelBoard setIsControlEnabled:YES];
}


@end
