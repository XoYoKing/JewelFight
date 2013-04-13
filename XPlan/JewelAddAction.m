//
//  JewelAddAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAddAction.h"
#import "JewelManager.h"
#import "JewelPanel.h"

@interface JewelAddAction()

@end

@implementation JewelAddAction


-(id) initWithJewelPanel:(JewelPanel *)panel continueDispose:(int)cd jewelVoList:(CCArray *)list
{
    if ((self = [super initWithJewelPanel:panel]))
    {
        jewelVoList = list;
        continueDispose = cd;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) start
{
    
}

-(void) update:(ccTime)delta
{
    
}

-(void) execute
{
    [jewelPanel addNewJewels:jewelVoList];
}

@end
