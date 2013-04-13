//
//  JewelClearAction.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelClearAction.h"
#import "JewelPanel.h"

@implementation JewelClearAction

-(id) initWithJewelPanel:(JewelPanel *)panel
{
    if ((self = [super initWithJewelPanel:panel]))
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
    [jewelPanel clearAllJewelSprites];
}

@end
