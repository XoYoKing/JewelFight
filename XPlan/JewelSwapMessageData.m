//
//  JewelSwapMessageData.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelSwapMessageData.h"

@implementation JewelSwapMessageData

@synthesize jewelGlobalId1,jewelGlobalId2;

+(id) dataWithUserId:(long)uId jewelGlobalId1:(int)j1 jewelGlobalId2:(int)j2
{
    return [[[self alloc] initWithUserId:uId jewelGlobalId1:j1 jewelGlobalId2:j2] autorelease];
}

-(id) initWithUserId:(long)uId jewelGlobalId1:(int)j1 jewelGlobalId2:(int)j2
{
    if ((self = [super initWithUserId:uId]))
    {
        jewelGlobalId1 = j1;
        jewelGlobalId2 = j2;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
