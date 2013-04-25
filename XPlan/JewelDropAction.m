//
//  JewelDropAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelDropAction.h"
#import "GemController.h"
#import "GemBoard.h"
#import "GemSprite.h"
#import "GemVo.h"
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

-(id) initWithJewelController:(GemController *)contr
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
    [jewelController.jewelPanel setIsControlEnabled:NO];
    
    GemBoard *panel = jewelController.jewelPanel;
    dropJewels = [[CCArray alloc] initWithCapacity:10];
    
    
    // 循环遍历全部宝石格子
    for (int i = 0; i< panel.gridSize.width;i++)
    {
        for (int j=0; j< panel.gridSize.height; j++)
        {
            GemCell *cell = [panel getCellAtCoord:ccp(i,j)];
            if (cell!=nil && cell.jewelSprite == nil)
            {
                for (int k = j-1; k >= 0;k--)
                {
                    // 宝石下落逻辑
                    GemCell *upCell = [panel getCellAtCoord:ccp(i,k)];
                    if (upCell.jewelSprite!=nil)
                    {
                        // 掉落距离计数
                        [upCell.jewelSprite.jewelVo addYGap];
                        
                        // 检查是否在下落列表中
                        if (![dropJewels containsObject:upCell.jewelSprite])
                        {
                            [dropJewels addObject:upCell.jewelSprite];
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
    
    for (GemSprite *dropSprite in dropJewels)
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
    [jewelController.jewelPanel updateJewelGridInfo];
    
    // 检查可消除性
    CCArray *elimList = [[CCArray alloc] initWithCapacity:20];
    
    // 检查可消除宝石集合
    for (GemSprite *dropSprite in dropJewels)
    {
        [jewelController.jewelPanel checkHorizontalEliminableJewels:elimList withJewel:dropSprite];
        [jewelController.jewelPanel checkVerticalEliminableJewels:elimList withJewel:dropSprite];
    }
    
    if (elimList.count>0)
    {
        JewelEliminateAction *elimateAction = [[JewelEliminateAction alloc] initWithJewelController:jewelController elimList:elimList];
        [jewelController queueAction:elimateAction top:NO];
        [elimateAction release];
    }
    
    [elimList release];
    
    
    // 宝石面板设置为可操作
    [jewelController.jewelPanel setIsControlEnabled:YES];
    
    
}

-(BOOL) isAllJewelsDropped
{
    BOOL done = YES;
    for (GemSprite *dropSprite in dropJewels)
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
