//
//  JewelAddAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAddAction.h"
#import "JewelController.h"
#import "JewelBoard.h"
#import "JewelVo.h"
#import "JewelSprite.h"
#import "JewelController.h"
#import "JewelEliminateAction.h"
#import "JewelMessageData.h"
#import "GameMessageDispatcher.h"


@interface JewelAddAction()
{
    int totalJewelsCount; // 全部宝石的数量
    int doneJewelsCounter; // 完成移动的宝石的计时器
    CCArray *jewelSpriteList;
}
@end

@implementation JewelAddAction

@synthesize continueDispose;


-(id) initWithJewelController:(JewelController *)contr jewelVoList:(CCArray *)list
{
    if ((self = [super initWithJewelController:contr name:@"JewelAddAction"]))
    {
        jewelVoList = [list retain];
        jewelSpriteList = [[CCArray alloc] initWithCapacity:jewelVoList.count];
        totalJewelsCount = jewelVoList.count;
        doneJewelsCounter = 0;
    }
    
    return self;
}

-(void) dealloc
{
    [jewelVoList release];
    [jewelSpriteList release];
    [super dealloc];
}

-(void) start
{
    if (skipped)
    {
        return;
    }
    
    // 宝石面板设置为不可操作
    [jewelController.jewelBoard setIsControlEnabled:NO];
    
    jewelController.jewelBoard.lastMoveTime = [[NSDate date] timeIntervalSince1970];
    
    // 创建宝石
    for (JewelVo *jv in jewelVoList)
    {
        // 创建宝石
        JewelSprite *jewel = [jewelController.jewelBoard createJewelSpriteWithJewelVo:jv];
        
        [jewelSpriteList addObject:jewel];
        
        // 获取宝石最终坐标
        CGPoint targetPos = [jewelController.jewelBoard cellCoordToPosition:jv.coord];
        CGPoint startPos = ccp(targetPos.x,jewelController.jewelBoard.boundingBox.size.height + targetPos.y);
        
        jewel.position = startPos;
        
        // 执行移动动作
        CCAction *action = [CCSequence actions:
                             [CCMoveTo actionWithDuration:0.6f position:targetPos],
                             [CCCallFunc actionWithTarget:self selector:@selector(jewelDropDown)],
                             nil];
        
        // 执行动作
        [jewel runAction:action];
    }
}

-(void) jewelDropDown
{
    doneJewelsCounter++;
}

-(void) update:(ccTime)delta
{
    // 检查创建宝石动作的状态
    if (doneJewelsCounter == totalJewelsCount && !skipped)
    {
        [self execute];
        return;
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
    
    if (doneJewelsCounter == totalJewelsCount)
    {
        return YES;
    }
    return NO;
}

-(void) execute
{
    // 宝石添加完成,更新JewelController的JewelVo列表
    for (JewelVo *jv in jewelVoList)
    {
        [jewelController addJewelVo:jv];
    }
    
    [jewelController.jewelBoard updateJewelGridInfo];
    
    
    // 检查可消除性
    CCArray *elimList = [[CCArray alloc] initWithCapacity:20];
    
    // 检查可消除宝石集合
    for (JewelSprite *dropSprite in jewelSpriteList)
    {
        [jewelController.jewelBoard findHorizontalEliminableJewels:elimList withJewel:dropSprite];
        [jewelController.jewelBoard findVerticalEliminableJewels:elimList withJewel:dropSprite];
    }
    
    if (elimList.count>0)
    {
        JewelEliminateAction *elimateAction = [[JewelEliminateAction alloc] initWithJewelController:jewelController elimList:elimList];
        [jewelController queueAction:elimateAction top:NO];
        [elimateAction release];
    }
    else
    {
        // 检查死局
        // 当宝石为满时,检查死局
        if ([jewelController.jewelBoard isFull] && [jewelController.jewelBoard checkDead])
        {
            // 发送死局通知
            JewelMessageData *msg = [[[JewelMessageData alloc] initWithUserId:jewelController.userId] autorelease];
            [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:self message:JEWEL_MESSAGE_DEAD object:msg];
        }
    }
    
    [elimList release];
    
    
    // 允许面板操作?
    [jewelController.jewelBoard setIsControlEnabled:YES];
}

@end
