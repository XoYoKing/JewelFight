//
//  JewelController.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelController.h"
#import "JewelVo.h"
#import "JewelCell.h"
#import "JewelSprite.h"
#import "Constants.h"
#import "JewelBoard.h"
#import "JewelActionQueue.h"
#import "JewelAction.h"
#import "JewelAddAction.h"
#import "JewelFactory.h"
#import "GameMessageDispatcher.h"
#import "JewelMessageData.h"
#import "Constants.h"

static int jewelGlobalIdGenerator = 10000;

@interface JewelController()

@end

@implementation JewelController

@synthesize jewelBoard,userId;

-(id) initWithJewelBoard:(JewelBoard *)jb operatorUserId:(long)uId
{
    if ((self = [super init]))
    {
        jewelBoard = jb;
        jewelBoard.jewelController = self;
        userId = uId;
        
        jewelVoDict = [[NSMutableDictionary alloc] init];
        jewelVoList = [[CCArray alloc] initWithCapacity:60];
        actionQueue = [[JewelActionQueue alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [actionQueue release];
    [jewelVoDict release];
    [jewelVoList release];
    
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    [self updateJewelActions:delta];
    [self.jewelBoard update:delta];
}

/// 检查连续消除
-(void) checkContinue
{
    
}

#pragma mark -
#pragma mark Jewel Actions

/// 更新宝石动作
-(void) updateJewelActions:(ccTime)delta
{
    if (currentAction!=nil)
    {
        [currentAction update:delta];
        
        // 检查宝石动作是否完成
        if ([currentAction isOver])
        {
            currentAction = nil;
        }
    }
    
    if (currentAction == nil)
    {
        if (actionQueue.actions.count > 0)
        {
            currentAction = [[actionQueue.actions objectAtIndex:0] retain];
            [actionQueue.actions removeObjectAtIndex:0];
            [currentAction start];
        }
        else
        {
            if(jewelVoList.count<kJewelBoardWidth*kJewelBoardHeight)
            {
                // 补充宝石
                [self fillEmptyJewels];
            }
            else
            {
                // 检查死局
                // 当宝石为满时,检查死局
                if ([jewelBoard isFull] && [jewelBoard checkDead])
                {
                    // 发送死局通知
                    JewelMessageData *msg = [[[JewelMessageData alloc] initWithUserId:userId] autorelease];
                    [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:self message:JEWEL_MESSAGE_DEAD object:msg];
                }
            }
        }
    }
}

-(void) queueAction:(JewelAction*)action top:(BOOL)top
{
    if (top)
    {
        [actionQueue.actions insertObject:action atIndex:0];
    }
    else
    {
        [actionQueue.actions addObject:action];
    }
}

-(void) resetActions
{
    [actionQueue.actions removeAllObjects];
    currentAction = nil;
}

-(void) newJewelVoList:(CCArray *)list
{
    // 清除原来的全部宝石
    [self removeAllJewels];
    
    // Action
    JewelAddAction *action = [[JewelAddAction alloc] initWithJewelController:self jewelVoList:list];
    [self queueAction:action top:NO];
    [action release];
    
}

-(void) addJewelVoList:(CCArray*)list
{
    JewelAddAction *action = [[JewelAddAction alloc] initWithJewelController:self jewelVoList:list];
    [self queueAction:action top:NO];
    [action release];
}


/// 添加宝石数据
-(void) addJewelVo:(JewelVo*)jv
{
    // 添加JewelVo
    if (![jewelVoDict.allKeys containsObject:[NSNumber numberWithInt:jv.globalId]])
    {
        [jewelVoDict setObject:jv forKey:[NSNumber numberWithInt:jv.globalId]];
        [jewelVoList addObject:jv];
    }
}

/// 删除宝石数据
-(void) removeJewelVo:(JewelVo*)jv
{
    [jewelVoDict removeObjectForKey:[NSNumber numberWithInt:jv.globalId]];
    [jewelVoList removeObject:jv];
}

-(void) removeAllJewels
{
    // 清除Jewel Sprite
    [self.jewelBoard removeAllJewels];
    
    // 清除
    [jewelVoDict removeAllObjects];
    [jewelVoList removeAllObjects];
}


/// 填充空白宝石
-(void) fillEmptyJewels
{
    CCArray *fillJewels = [[CCArray alloc] initWithCapacity:10];
    // 找出空出来的宝石位置,向上寻找宝石
    for (int i =0;i <kJewelBoardWidth; i++)
    {
        for (int j = 0; j< kJewelBoardHeight; j++)
        {
            if ([jewelBoard getCellAtCoord:ccp(i,j)].jewelSprite==nil)
            {
                JewelVo *newJv = [JewelFactory randomJewel];
                newJv.globalId = ++jewelGlobalIdGenerator;
                newJv.coord = ccp(i,j);
                [fillJewels addObject:newJv];
            }
        }
    }
    JewelAddAction *action = [[JewelAddAction alloc] initWithJewelController:self jewelVoList:fillJewels];
    [self queueAction:action top:NO];
    [action release];
    [fillJewels release];
}




@end
