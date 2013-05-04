//
//  JewelMessageDispatcher.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelMessageDispatcher.h"

@implementation JewelMessageDispatcher

-(id) init
{
    if ((self = [super init]))
    {
        messageQueue = [[CCArray alloc] initWithCapacity:30];
    }
    
    return self;
}

-(void) dealloc
{
    [messageQueue release];
    [super dealloc];
}

-(void) dispatchMessage:(int)messgeId data:(id)data
{
}

@end
