//
//  JewelSwapAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelSwapAction.h"
#import "JewelSprite.h"
#import "JewelPanel.h"
#import "Constants.h"
#import "JewelController.h"

#define kTagActionJewelSwap 400 // 宝石交换

@interface JewelSwapAction()

@end

@implementation JewelSwapAction

@synthesize jewel1,jewel2;

-(id) initWithJewelController:(JewelController *)contr jewel1:(JewelSprite *)j1 jewel2:(JewelSprite *)j2
{
    if ((self = [super initWithJewelController:contr name:@"JewelSwapAction"]))
    {
        jewelGlobalId1 = j1.globalId;
        jewelGlobalId2 = j2.globalId;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(JewelSprite*) jewel1
{
    return [jewelController.jewelPanel getJewelSpriteWithGlobalId:jewelGlobalId1];
}

-(JewelSprite*) jewel2
{
    return [jewelController.jewelPanel getJewelSpriteWithGlobalId:jewelGlobalId2];
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
    [jewelController.jewelPanel setIsControlEnabled:NO];
    
    // 交换位置
    JewelSprite *j1 = self.jewel1;
    JewelSprite *j2 = self.jewel2;
    CCAction *action1 = [CCMoveTo actionWithDuration:0.3f position:[jewelController.jewelPanel cellCoordToPosition:j2.coord]];
    action1.tag =kTagActionJewelSwap;
    [j1 runAction:action1];
    
    CCAction *action2 = [CCMoveTo actionWithDuration:0.3f position:[jewelController.jewelPanel cellCoordToPosition:j1.coord]];
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
    [jewelController.jewelPanel updateJewelGridInfo];
    
    
    // 允许面板操作?
    [jewelController.jewelPanel setIsControlEnabled:YES];
}


@end
