//
//  StoneClearAction.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneClearAction.h"
#import "StonePanel.h"

@implementation StoneClearAction

-(id) initWithStonePanel:(StonePanel *)panel
{
    if ((self = [super initWithStonePanel:panel]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) execute
{
    // 清理全部宝石
    [stonePanel clearAllStoneSprites];
}

@end
