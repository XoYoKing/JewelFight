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
#import "JewelDropAction.h"
#import "JewelBoard.h"
#import "JewelEliminateMessageData.h"
#import "GameMessageDispatcher.h"

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
    
    // 宝石面板设置为不可操作
    [jewelController.jewelBoard setIsControlEnabled:NO];
    
    jewelController.jewelBoard.lastMoveTime = [[NSDate date] timeIntervalSince1970];
    
    for (JewelSprite * elimSprite in elimList)
    {
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
    // 发送消除消息
    
    CCArray *elimIds = [[CCArray alloc] initWithCapacity:elimList.count];
    for (JewelSprite *js in elimList)
    {
        [elimIds addObject:[NSNumber numberWithInt:js.globalId]];
    }
    
    JewelEliminateMessageData *msg = [JewelEliminateMessageData dataWithUserId:jewelController.userId jewelGlobalIds:elimIds];
    
    [elimIds release];
    elimIds = nil;
    [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:jewelController message:JEWEL_MESSAGE_ELIMINATE_JEWELS object:msg];

    // 宝石下落
    JewelDropAction *dropAction = [[JewelDropAction alloc] initWithJewelController:jewelController];
    [jewelController queueAction:dropAction top:YES];
    [dropAction release];
    
    // 宝石面板设置为可操作
    [jewelController.jewelBoard setIsControlEnabled:YES];
    
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
