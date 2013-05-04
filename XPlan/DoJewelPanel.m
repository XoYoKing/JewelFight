//
//  DoJewelPanel.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "DoJewelPanel.h"
#import "JewelSprite.h"
#import "HeroVo.h"
#import "JewelVo.h"
#import "JewelSprite.h"
#import "JewelActionQueue.h"
#import "JewelAction.h"
#import "JewelInitAction.h"
#import "JewelCell.h"

@interface DoJewelPanel()
{
    JewelSprite *selectedJewel; // 选中的宝石

}


@end

@implementation DoJewelPanel

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{

    [super dealloc];
}




-(void) onEnter
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:1 swallowsTouches:NO];
    [super onEnter];
}

-(void) onExit
{
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super onExit];
}

/// 逻辑更新
-(void) update:(ccTime)delta
{
    // 遍历全部的宝石动作
    [self updateJewelActions:delta];
    
    /// 更新宝石
    [self updateJewels:delta];
    
}


-(void) updateJewels:(ccTime)delta
{
    CCArray *jewelsToRemove = [[CCArray alloc] initWithCapacity:10];
    
    for (JewelSprite *jewel in allJewelSprites)
    {
        BOOL remove = [jewel update:delta];
        if (remove)
        {
            [jewelsToRemove addObject:jewel];
            continue;
        }
        
        // 更新移动
        [jewel updateMovement:delta];
        
    }
    
    if (jewelsToRemove.count > 0)
    {
        for (JewelSprite *jewel in jewelsToRemove)
        {
            [self removeJewelItem:jewel];
        }
    }
    
    [jewelsToRemove removeAllObjects];
    
}

/// 创建新的宝石队列
-(void) newJewelColumnWithHeroVo:(HeroVo*)hv jewelVoList:(CCArray*)jewelVoList
{
    // 清理
    [self removeAllJewels];
}

-(void) removeAllJewels
{
    for (CCNode *node in self.children)
    {
        if ([node isKindOfClass:[JewelSprite class]])
        {
            [node removeFromParentAndCleanup:YES];
        }
    }
}

#pragma mark -
#pragma mark Touch

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

#pragma mark -
#pragma mark Public Methods


@end
