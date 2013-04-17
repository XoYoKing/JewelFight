//
//  JewelElimateAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelEliminateAction.h"
#import "JewelController.h"
#import "JewelCell.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "Constants.h"

@interface JewelEliminateAction()

@end

@implementation JewelEliminateAction

-(id) initWithJewelController:(JewelController *)contr elimList:(CCArray *)list
{
    if ((self = [super initWithJewelController:contr name:@"JewelEliminateAction"]))
    {
        elimList = [list retain];
    }
    
    return self;
}

-(void) dealloc
{
    [elimList release];
    [super dealloc];
}

-(void) start
{
    // 检查是否跳过动作
    if (skipped)
    {
        return;
    }
    
    for (JewelSprite * elimSprite in elimList)
    {
        // 执行消除动画
        [elimSprite animateEliminate:1];
    }
    
    
}

-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    if ([self isAllJewelEliminated])
    {
        return YES;
    }
    return NO;
}

-(void) update:(ccTime)delta
{
    if ([self isAllJewelEliminated])
    {
        [self execute];
    }
}

-(void) execute
{
    // 宝石更新时会自动删除宝石,所以这块不处理
    // 考虑新宝石
    
}

/// 检查全部宝石是否消除完毕
-(BOOL) isAllJewelEliminated
{
    BOOL eliminated = YES;
    for (JewelSprite * elimSprite in elimList)
    {
        if (elimSprite.state!=kJewelStateEliminated)
        {
            eliminated = NO;
            break;
        }
    }
    
    return eliminated;
}

@end
