//
//  JewelController.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemController.h"
#import "GemVo.h"
#import "GemCell.h"
#import "GemSprite.h"
#import "Constants.h"
#import "GemBoard.h"
#import "GemActionQueue.h"
#import "GemAction.h"
#import "GemAddAction.h"
#import "GemFactory.h"
#import "GameMessageDispatcher.h"
#import "JewelMessageData.h"
#import "Constants.h"

static int jewelGlobalIdGenerator = 10000;

@interface GemController()

@end

@implementation GemController

@synthesize gemBoard,userId;

-(id) initWithGemBoard:(GemBoard *)panel operatorUserId:(long)uId
{
    if ((self = [super init]))
    {
        gemBoard = panel;
        gemBoard.jewelController = self;
        userId = uId;
        
        gemVoDict = [[NSMutableDictionary alloc] init];
        gemVoList = [[CCArray alloc] initWithCapacity:60];
        actionQueue = [[GemActionQueue alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [actionQueue release];
    [gemVoDict release];
    [gemVoList release];
    
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    [self updateGemActions:delta];
    [self.gemBoard update:delta];
}

/// 检查连续消除
-(void) checkContinue
{
    
}

#pragma mark -
#pragma mark Jewel Actions

/// 更新宝石动作
-(void) updateGemActions:(ccTime)delta
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
            if(gemVoList.count<kJewelGridWidth*kJewelGridHeight)
            {
                // 补充宝石
                [self fillEmptyGems];
            }
            else
            {
                // 检查死局
                // 当宝石为满时,检查死局
                if ([gemBoard isFull] && [gemBoard checkDead])
                {
                    // 发送死局通知
                    JewelMessageData *msg = [[[JewelMessageData alloc] initWithUserId:userId] autorelease];
                    [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:self message:JEWEL_MESSAGE_DEAD object:msg];
                }
            }
        }
    }
}

-(void) queueAction:(GemAction*)action top:(BOOL)top
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

-(void) newGemVoList:(CCArray *)list
{
    // 清除原来的全部宝石
    [self removeAllJewels];
    
    // Action
    GemAddAction *action = [[GemAddAction alloc] initWithJewelController:self jewelVoList:list];
    [self queueAction:action top:NO];
    [action release];
    
}

-(void) addGemVoList:(CCArray*)list
{
    GemAddAction *action = [[GemAddAction alloc] initWithJewelController:self jewelVoList:list];
    [self queueAction:action top:NO];
    [action release];
}


/// 添加宝石数据
-(void) addGemVo:(GemVo*)jv
{
    // 添加JewelVo
    if (![gemVoDict.allKeys containsObject:[NSNumber numberWithInt:jv.globalId]])
    {
        [gemVoDict setObject:jv forKey:[NSNumber numberWithInt:jv.globalId]];
        [gemVoList addObject:jv];
    }
}

/// 删除宝石数据
-(void) removeGemVo:(GemVo*)jv
{
    [gemVoDict removeObjectForKey:[NSNumber numberWithInt:jv.globalId]];
    [gemVoList removeObject:jv];
}

-(void) removeAllJewels
{
    // 清除Jewel Sprite
    [self.gemBoard removeAllJewels];
    
    // 清除
    [gemVoDict removeAllObjects];
    [gemVoList removeAllObjects];
}


/// 填充空白宝石
-(void) fillEmptyGems
{
    CCArray *fillJewels = [[CCArray alloc] initWithCapacity:10];
    // 找出空出来的宝石位置,向上寻找宝石
    for (int i =0;i <kJewelGridWidth; i++)
    {
        for (int j = 0; j< kJewelGridHeight; j++)
        {
            if ([gemBoard getCellAtCoord:ccp(i,j)].gemSprite==nil)
            {
                GemVo *newJv = [GemFactory randomJewel];
                newJv.globalId = ++jewelGlobalIdGenerator;
                newJv.coord = ccp(i,j);
                [fillJewels addObject:newJv];
            }
        }
    }
    GemAddAction *action = [[GemAddAction alloc] initWithJewelController:self jewelVoList:fillJewels];
    [self queueAction:action top:NO];
    [action release];
    [fillJewels release];
}




@end
