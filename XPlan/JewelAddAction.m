//
//  JewelAddAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAddAction.h"
#import "JewelController.h"
#import "JewelPanel.h"
#import "JewelVo.h"
#import "JewelSprite.h"
#import "JewelController.h"
#import "JewelEliminateAction.h"


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
    [jewelController.jewelPanel setIsControlEnabled:NO];
    
    // 创建宝石
    for (JewelVo *jv in jewelVoList)
    {
        // 创建宝石
        JewelSprite *jewel = [jewelController.jewelPanel createJewelSpriteWithJewelVo:jv];
        
        [jewelSpriteList addObject:jewel];
        
        // 获取宝石最终坐标
        CGPoint targetPos = [jewelController.jewelPanel cellCoordToPosition:jv.coord];
        CGPoint startPos = ccp(targetPos.x,jewelController.jewelPanel.boundingBox.size.height + targetPos.y);
        
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
    
    [jewelController.jewelPanel updateJewelGridInfo];
    
    
    // 检查可消除性
    CCArray *elimList = [[CCArray alloc] initWithCapacity:20];
    
    // 检查可消除宝石集合
    for (JewelSprite *dropSprite in jewelSpriteList)
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
    
    
    // 允许面板操作?
    [jewelController.jewelPanel setIsControlEnabled:YES];
}

@end
