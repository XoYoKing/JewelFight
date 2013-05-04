//
//  JewelAddAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelInitAction.h"
#import "JewelController.h"
#import "JewelPanel.h"
#import "JewelVo.h"
#import "JewelSprite.h"
#import "JewelController.h"

@interface JewelInitAction()
{
    int totalJewelsCount; // 全部宝石的数量
    int doneJewelsCounter; // 完成移动的宝石的计时器
}
@end

@implementation JewelInitAction

@synthesize continueDispose;


-(id) initWithJewelController:(JewelController *)contr jewelVoList:(CCArray *)list
{
    if ((self = [super initWithJewelController:contr name:@"JewelInitAction"]))
    {
        jewelVoList = list;
        totalJewelsCount = jewelVoList.count;
        doneJewelsCounter = 0;
    }
    
    return self;
}

-(void) dealloc
{
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
    
    // 允许面板操作?
    [jewelController.jewelPanel setIsControlEnabled:YES];
}

@end
