//
//  JewelElimateAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelEliminateAction.h"
#import "GemController.h"
#import "GemCell.h"
#import "GemSprite.h"
#import "GemVo.h"
#import "Constants.h"
#import "JewelDropAction.h"
#import "GemBoard.h"
#import "JewelEliminateMessageData.h"
#import "GameMessageDispatcher.h"

@interface JewelEliminateAction()

@end

@implementation JewelEliminateAction

-(id) initWithJewelController:(GemController *)contr elimList:(CCArray *)list
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
    [jewelController.gemBoard setIsControlEnabled:NO];
    
    for (GemSprite * elimSprite in elimList)
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
    for (GemSprite *js in elimList)
    {
        [elimIds addObject:[NSNumber numberWithInt:js.globalId]];
    }
    
    JewelEliminateMessageData *msg = [JewelEliminateMessageData dataWithUserId:jewelController.userId jewelGlobalIds:elimIds];
    
    [elimIds release];
    elimIds = nil;
    [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:jewelController message:JEWEL_MESSAGE_ELIMINATE_JEWELS object:msg];

    
    // 宝石更新时会自动删除宝石,所以这块不处理
    // 宝石下落
    JewelDropAction *dropAction = [[JewelDropAction alloc] initWithJewelController:jewelController];
    [jewelController queueAction:dropAction top:YES];
    [dropAction release];
    
    // 宝石面板设置为可操作
    [jewelController.gemBoard setIsControlEnabled:YES];
    
}

/// 检查全部宝石是否消除完毕
-(BOOL) isAllJewelEliminated
{
    BOOL eliminated = YES;
    for (GemSprite * elimSprite in elimList)
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
