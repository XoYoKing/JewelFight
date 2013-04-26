//
//  JewelDropAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelDropAction.h"
#import "JewelController.h"
#import "JewelBoard.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "GemCell.h"
#import "JewelEliminateAction.h"
#import "JewelMessageData.h"
#import "GameMessageDispatcher.h"

@interface JewelDropAction()
{
    CCArray *dropJewels; // 下落宝石列表
}

@end

@implementation JewelDropAction

-(id) initWithJewelController:(JewelController *)contr
{
    if ((self = [super initWithJewelController:contr name:@"JewelDropAction"]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) start
{
    // 检查是否跳过动作
    if (skipped)
    {
        return;
    }
    
    // 宝石面板设置为不可操作
    [jewelController.jewelBoard setIsControlEnabled:NO];
    
    JewelBoard *panel = jewelController.jewelBoard;
    dropJewels = [[CCArray alloc] initWithCapacity:10];
    
    
    // 循环遍历全部宝石格子
    for (int i = 0; i< panel.gridSize.width;i++)
    {
        for (int j=0; j< panel.gridSize.height; j++)
        {
            GemCell *cell = [panel getCellAtCoord:ccp(i,j)];
            if (cell!=nil && cell.gemSprite == nil)
            {
                for (int k = j-1; k >= 0;k--)
                {
                    // 宝石下落逻辑
                    GemCell *upCell = [panel getCellAtCoord:ccp(i,k)];
                    if (upCell.gemSprite!=nil)
                    {
                        // 掉落距离计数
                        [upCell.gemSprite.jewelVo addYGap];
                        
                        // 检查是否在下落列表中
                        if (![dropJewels containsObject:upCell.gemSprite])
                        {
                            [dropJewels addObject:upCell.gemSprite];
                        }
                    }
                }
            }
        }
    }
    
    // 检查下落宝石数量
    if (dropJewels.count==0)
    {
        [self skip];
    }
    
    for (JewelSprite *dropSprite in dropJewels)
    {
        [dropSprite drop];
    }
    
}

-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    if ([self isAllJewelsDropped])
    {
        return YES;
    }
    return NO;
}

-(void) update:(ccTime)delta
{
    if ([self isAllJewelsDropped])
    {
        [self execute];
    }
}

-(void) execute
{
    // 掉落完成
    [jewelController.jewelBoard updateJewelGridInfo];
    
    // 检查可消除性
    CCArray *elimList = [[CCArray alloc] initWithCapacity:20];
    
    // 检查可消除宝石集合
    for (JewelSprite *dropSprite in dropJewels)
    {
        [jewelController.jewelBoard checkHorizontalEliminableJewels:elimList withJewel:dropSprite];
        [jewelController.jewelBoard checkVerticalEliminableJewels:elimList withJewel:dropSprite];
    }
    
    if (elimList.count>0)
    {
        JewelEliminateAction *elimateAction = [[JewelEliminateAction alloc] initWithJewelController:jewelController elimList:elimList];
        [jewelController queueAction:elimateAction top:NO];
        [elimateAction release];
    }
    
    [elimList release];
    
    
    // 宝石面板设置为可操作
    [jewelController.jewelBoard setIsControlEnabled:YES];
    
    
}

-(BOOL) isAllJewelsDropped
{
    BOOL done = YES;
    for (JewelSprite *dropSprite in dropJewels)
    {
        if ([dropSprite isDropping])
        {
            done = NO;
            break;
        }
    }
    
    return done;
}


@end
