//
//  JewelMessageData.m
//  XPlan
//
//  Created by Hex on 4/21/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelMessageData.h"

@implementation JewelMessageData

@synthesize userId;

-(id) initWithUserId:(long)uid
{
    if ((self = [super init]))
    {
        userId = uid;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
