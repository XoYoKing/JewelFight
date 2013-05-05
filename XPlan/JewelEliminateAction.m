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
#import "JewelFallAction.h"
#import "JewelBoard.h"
#import "JewelEliminateMessageData.h"
#import "GameMessageDispatcher.h"
#import "JewelBoardData.h"

@interface JewelEliminateAction()
{
    
}

@end

@implementation JewelEliminateAction

-(id) initWithJewelController:(JewelController *)contr connectedList:(CCArray *)list
{
    if ((self = [super initWithJewelController:contr name:@"JewelEliminateAction"]))
    {
        connectedList = [list retain];
    }
    
    return self;
}

-(void) dealloc
{
    [connectedList release];
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
    [jewelController.board setIsControlEnabled:NO];
    
    
    for (JewelVo * elimVo in connectedList)
    {
        JewelSprite *elimSprite = [jewelController.board getJewelSpriteWithGlobalId:elimVo.globalId];
        // 执行消除动画
        [elimSprite eliminate:1];
    }
}

-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    return NO;
}

-(void) update:(ccTime)delta
{
    if ([self isAllJewelEliminated])
    {
        [self skip];
        [self execute];
    }
}

-(void) execute
{
    [jewelController.boardData updateJewelGridInfo];
    
    // 清理已经标记为删除的宝石
    [jewelController.boardData removeMarkedJewels];
    
    
    // 玩家操作的情况下, 处理下落逻辑,否则是等待
    if ([jewelController isPlayerControl])
    {
        // 发送消除消息
        CCArray *elimIds = [[CCArray alloc] initWithCapacity:connectedList.count];
        for (JewelSprite *js in connectedList)
        {
            [elimIds addObject:[NSNumber numberWithInt:js.globalId]];
        }
        
        JewelEliminateMessageData *msg = [JewelEliminateMessageData dataWithUserId:jewelController.userId jewelGlobalIds:elimIds];
        
        [elimIds release];
        elimIds = nil;
        [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:jewelController message:JEWEL_MESSAGE_ELIMINATE_JEWELS object:msg];
            
        // TODO:补充缺失的宝石
        
        // 宝石下落
        JewelFallAction *dropAction = [[JewelFallAction alloc] initWithJewelController:jewelController addList:nil];
        [jewelController queueAction:dropAction top:YES];
        [dropAction release];
         
    }
    
    // 宝石面板设置为可操作
    [jewelController.board setIsControlEnabled:YES];
    
}

/// 检查全部宝石是否消除完毕
-(BOOL) isAllJewelEliminated
{
    BOOL eliminated = YES;
    for (JewelVo * elimVo in connectedList)
    {
        JewelSprite *elimSprite = [jewelController.board getJewelSpriteWithGlobalId:elimVo.globalId];
        if (elimSprite && elimSprite.state!=kJewelStateEliminated)
        {
            eliminated = NO;
            break;
        }
    }
    
    return eliminated;
}


@end
