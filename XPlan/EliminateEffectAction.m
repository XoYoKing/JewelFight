//
//  ElinimateEffect.m
//  XPlan
//
//  Created by Hex on 5/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "EliminateEffectAction.h"

@implementation EliminateEffectAction

-(id) initWithJewelController:(JewelController *)contr eliminateAction:(JewelEliminateAction *)a
{
    if ((self = [super init]))
    {
        jewelController = contr;
        ownerAction = a;
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
}

-(void)skip
{
    skipped = YES;
}

-(BOOL) isOver
{
    return YES;
}

@end
