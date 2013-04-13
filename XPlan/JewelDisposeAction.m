//
//  JewelDisposeAction.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelDisposeAction.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelPanel.h"

@implementation JewelDisposeAction

-(id) initWithJewelPanel:(JewelPanel *)panel disposeList:(CCArray *)disList specialList:(CCArray *)speList
{
    if ((self = [super initWithJewelPanel:panel]))
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
    [jewelPanel disposeJewelsWithJewelVoList:disposeList specialType:specialType specialJewelVoList:specialType];
}

@end
