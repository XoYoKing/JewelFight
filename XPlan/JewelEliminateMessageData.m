//
//  JewelEliminateMessageData.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelEliminateMessageData.h"

@implementation JewelEliminateMessageData

@synthesize eliminateGroup;

+(id) dataWithUserId:(long)uid eliminateGroups:(NSMutableArray *)group
{
    return [[[self alloc] initWithUserId:uid eliminateGroups:group] autorelease];
}

-(id) initWithUserId:(long)uid eliminateGroups:(NSMutableArray *)group
{
    if ((self = [super initWithUserId:uid]))
    {
        eliminateGroup = [group retain];
    }
    
    return self;
}

-(void) dealloc
{
    [eliminateGroup release];
    [super dealloc];
}

@end
