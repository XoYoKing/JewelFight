//
//  MockPvPServer.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "MockPvPServer.h"

@implementation MockPvPServer

-(id) init
{
    if ((self = [super init]))
    {
        player1JewelDict = [[NSMutableDictionary alloc] initWithCapacity:35];
        player1JewelList = [[CCArray alloc] initWithCapacity:35];
        player2JewelDict = [[NSMutableDictionary alloc] initWithCapacity:35];
        player2JewelList = [[CCArray alloc] initWithCapacity:35];
        
        
    }
    
    return self;
}

-(CCArray*) fillEmptyJewels
{
    // 填充空白的宝石
    
}

@end
