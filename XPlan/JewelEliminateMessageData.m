//
//  JewelEliminateMessageData.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelEliminateMessageData.h"

@implementation JewelEliminateMessageData

@synthesize jewelGlobalIds;

+(id) dataWithUserId:(long)uid jewelGlobalIds:(CCArray *)globalIds
{
    return [[[self alloc] initWithUserId:uid jewelGlobalIds:globalIds] autorelease];
}

-(id) initWithUserId:(long)uid jewelGlobalIds:(CCArray *)globalIds
{
    if ((self = [super init]))
    {
        userId = uid;
        jewelGlobalIds = [globalIds retain];
    }
    
    return self;
}

-(void) dealloc
{
    [jewelGlobalIds release];
    [super dealloc];
}

@end
