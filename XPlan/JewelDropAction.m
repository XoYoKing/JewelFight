//
//  JewelDropAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelDropAction.h"
#import "JewelController.h"
#import "JewelPanel.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelCell.h"

@interface JewelDropAction()
{
    CCArray *dropJewels; // 下落宝石列表
}

@end

@implementation JewelDropAction

-(id) initWithJewelController:(JewelController *)contr
{
    if ((self = [super initWithJewelController:contr name:@"JewelDropAction"]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
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
    [jewelController.jewelPanel setIsControlEnabled:NO];
    
    JewelPanel *panel = jewelController.jewelPanel;
    dropJewels = [[CCArray alloc] initWithCapacity:10];
    
    
    // 循环遍历全部宝石格子
    for (int i = 0; i< panel.gridSize.width;i++)
    {
        for (int j=0; j< panel.gridSize.height; j++)
        {
            JewelCell *cell = [panel getCellAtCoord:ccp(i,j)];
            if (cell!=nil && cell.jewelSprite == nil)
            {
                // 宝石下落逻辑
                JewelCell *upCell = [panel getCellAtCoord:ccp(i,j-1)];
                while(upCell!=nil)
                {
                    if (upCell.jewelSprite!=nil)
                    {
                        // 掉落距离计数
                        [upCell.jewelSprite.jewelVo addYGap];
                        
                        // 检查是否在下落列表中
                        if (![dropJewels containsObject:upCell.jewelSprite])
                        {
                            [dropJewels addObject:upCell.jewelSprite];
                        }
                    }

                    upCell = [panel getCellAtCoord:ccp(upCell.coord.x,upCell.coord.y-1)];
                }
            
            }
            
        }
    }
    
    // 检查下落宝石数量
    if (dropJewels.count==0)
    {
        [self skip];
    }
    
    for (JewelSprite *dropSprite in dropJewels)
    {
        [dropSprite drop];
    }
    
}

-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    if ([self isAllJewelsDropped])
    {
        return YES;
    }
    return NO;
}

-(void) update:(ccTime)delta
{
    if ([self isAllJewelsDropped])
    {
        [self execute];
    }
}

-(void) execute
{
    // 掉落完成
    
    // 
    [jewelController.jewelPanel updateJewelGridInfo];
    
    // 宝石面板设置为不可操作
    [jewelController.jewelPanel setIsControlEnabled:YES];
    
    
}

-(BOOL) isAllJewelsDropped
{
    BOOL done = YES;
    for (JewelSprite *dropSprite in dropJewels)
    {
        if ([dropSprite isDropping])
        {
            done = NO;
            break;
        }
    }
    
    return done;
}


@end
