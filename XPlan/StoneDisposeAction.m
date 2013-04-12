//
//  StoneDisposeAction.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneDisposeAction.h"
#import "StoneSprite.h"
#import "JewelVo.h"
#import "StonePanel.h"

@implementation StoneDisposeAction

-(id) initWithStonePanel:(StonePanel *)panel disposeList:(CCArray *)disList specialList:(CCArray *)speList
{
    if ((self = [super initWithStonePanel:panel]))
    {
        disposeList = disList; // 待消除的宝石列表
        specialList = speList; // 特殊宝石列表
        if (specialList.count > 0)
        {
            specialType = [[specialList objectAtIndex:0] special];
        }
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) execute
{
    [stonePanel disposeStonesWithStoneVoList:disposeList specialType:specialType specialStoneVoList:specialType];
}

@end
