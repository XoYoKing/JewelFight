//
//  JewelVo.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelVo.h"

@implementation JewelVo

@synthesize globalId,jewelId,jewelType,coord,time,state,special,yPos;

-(id) init
{
    if ((self = [super init]))
    {
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
