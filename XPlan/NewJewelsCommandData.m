//
//  NewJewelsCommandData.m
//  XPlan
//
//  Created by Hex on 4/18/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "NewJewelsCommandData.h"

@implementation NewJewelsCommandData

@synthesize jewelVoList;

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [jewelVoList release];
    [super dealloc];
}

@end
