//
//  StoneEffectManager.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ViewStoneController.h"
#import "StonePanel.h"
#import "PopupManager.h"

@implementation ViewStoneController

-(id) initWithStonePanel:(StonePanel *)panel
{
    if ((self = [super init]))
    {
        stonePanel = panel;
        
        // 设置宝石面板操作代理
        [stonePanel setDelegate:self];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    // 检查有无模态对话框存在
    if ([[PopupManager sharedManager] isModalPopupActive])
    {
        return;
    }
    
    // 检查宝石动作
    [self updateActions:delta];
}

-(void) updateActions:(ccTime)delta
{
    /*
    if (self->currentAction != nil)
    {
        [self->currentAction update:delta];
        
        if ([self->currentAction isOver])
        {
            self->currentAction = nil;
        }
    }
    
    if (self->currentAction == nil)
    {
        if ([self->actionVoList count] > 0)
        {
            self->currentAction = [self->actionVoList]
        }
    }
     */
}

@end
