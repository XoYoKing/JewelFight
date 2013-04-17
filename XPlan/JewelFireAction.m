//
//  JewelFireAction.m
//  XPlan
//
//  Created by Hex on 4/14/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelFireAction.h"
#import "EffectSprite.h"
#import "JewelSprite.h"
#import "JewelController.h"
#import "JewelPanel.h"
#import "JewelVo.h"

@interface JewelFireAction()
{
    EffectSprite *fireBall; // 火球
    float timer; // 计时
    CCArray *firingJewelGlobalIds; // 正在燃烧的宝石标识集合
}

@end

@implementation JewelFireAction

-(id) initWithJewelController:(JewelController *)contr jewelVoList:(CCArray *)list
{
    if ((self = [super initWithJewelController:contr name:@"JewelFireAction"]))
    {
        jewelVoList = [list retain]; // retain
        firingJewelGlobalIds = [[CCArray alloc] initWithCapacity:jewelVoList.count];
        state = -1;
        newState = -1;
    }
    
    return self;
}

-(void) dealloc
{
    [jewelVoList release];
    [firingJewelGlobalIds release];
    [super dealloc];
}

-(void) start
{
    if (skipped)
    {
        return;
    }
    
    newState = kJewelFireActionStateBeforeFire;
    
}

-(BOOL) isOver
{
    return state = kJewelFireActionStateOver || skipped;
}


-(void) update:(ccTime)delta
{
    if (state == kJewelFireActionStateOver || skipped)
    {
        return;
    }
    
    if (newState!=state)
    {
        [self changeState:newState];
    }
    
    timer += delta;
    switch (state)
    {
        case kJewelFireActionStateFiring:
        {
            float vel = 200;
            
            // 更新坐标
            CGPoint nextPos = ccp(fireBall.position.x, fireBall.position.y + vel);
            fireBall.position = nextPos;
            JewelSprite *js = [jewelController.jewelPanel getJewelSpriteWithGlobalId:[[jewelVoList objectAtIndex:0] globalId]];
            if (fireBall.position.y > js.position.y)
            {
                // 燃烧
                [js animateFire:1];
                
                // 标记正在燃烧的宝石
                [firingJewelGlobalIds addObject:js.globalId];
                
                [jewelVoList removeObjectAtIndex:0];
                
            }
            
            // 移动到最底层
            if (fireBall.position.y <= -fireBall.contentSize.height)
            {
                [self execute];
            }
            break;
        }
    }
    
}

-(void) changeState:(int)s
{
    state = newState = s;
    timer = 0;
    switch (state)
    {
        // 燃烧前状态
        case kJewelFireActionStateBeforeFire:
        {
            // 初始化火龙
            
            // 火龙效果
            KITProfile *profile = [KITProfile profileWithName:@"jewel_fire_action.plist"];
            CCAnimation *fireAnim = [profile animationForKey:@"fire"];
            
            fireBall = [[EffectSprite alloc] initWithSpriteFrame:[fireAnim.frames objectAtIndex:0]];
            
            // 设置动画
            [fireBall animate:fireAnim tag:-1 repeat:YES restore:NO];
            
            // 设置坐标
            CGPoint pos = [jewelController.jewelPanel cellCoordToPosition:[[jewelVoList objectAtIndex:0] coord]];
            fireBall.position = pos;
            
            // 添加火龙效果
            [jewelController.jewelPanel addEffectSprite:fireBall];
            
            
            // 设置新状态
            newState = kJewelFireActionStateFiring;
            break;
        }
        case kJewelFireActionStateFiring:
        {
            
            break;
        }
        case kJewelFireActionStateOver:
        {
            break;
        }
    }
}

-(void) execute
{
    // 清除火球效果
    [fireBall removeFromParentAndCleanup:YES];
    [fireBall release];
    fireBall = nil;
    
    // 清除剩余队列
    for(JewelVo *jv in jewelVoList)
    {
        JewelSprite *js = [jewelController.jewelPanel getJewelSpriteWithGlobalId:jv.globalId];
        js.jewelVo.state = kJewelStateEliminated;
        [firingJewelGlobalIds addObject:[NSNumber numberWithInt:js.globalId]];
    }
    
    // 点燃的宝石燃烧成灰烬
    for (NSNumber *idNumber in firingJewelGlobalIds)
    {
        JewelSprite *js = [jewelController.jewelPanel getJewelSpriteWithGlobalId:[idNumber intValue]];
        
        // 播放火焰消除动画
        [js animateFireEliminate];
        
    }
    
    newState = kJewelFireActionStateOver;
}

@end
