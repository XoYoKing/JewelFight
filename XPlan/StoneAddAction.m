//
//  StoneAddAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneAddAction.h"
#import "StoneManager.h"
#import "StonePanel.h"

@interface StoneAddAction()

@end

@implementation StoneAddAction


-(id) initWithStonePanel:(StonePanel *)panel continueDispose:(int)cd stoneVoList:(CCArray *)list
{
    if ((self = [super initWithStonePanel:panel]))
    {
        stoneVoList = list;
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
    [stonePanel addNewStones:stoneVoList];
}

@end
