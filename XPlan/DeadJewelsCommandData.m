//
//  DeadJewelsCommandData.m
//  XPlan
//
//  Created by Hex on 4/21/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "DeadJewelsCommandData.h"

@implementation DeadJewelsCommandData

@synthesize jewelVoList;

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(CCArray*) jewelVoList
{
    if (jewelVoList == nil)
    {
        jewelVoList = [[CCArray alloc] initWithCapacity:35];
    }
    
    return jewelVoList;
}

-(void) dealloc
{
    [jewelVoList release];
    [super dealloc];
}

@end
