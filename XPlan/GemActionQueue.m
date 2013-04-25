//
//  JewelActionQueue.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemActionQueue.h"
#import "GemAction.h"

@implementation GemActionQueue

@synthesize actions;

-(id) init
{
    if ((self = [super init]))
    {
        actions = [[CCArray alloc] initWithCapacity:20];
    }
    
    return self;
}

-(void) dealloc
{
    [actions release];
    [super dealloc];
}


@end
