//
//  FighterCollection.m
//  XPlan
//
//  Created by Hex on 4/21/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterCollection.h"

@implementation FighterCollection

-(id) init
{
    if ((self = [super init]))
    {
        fighterDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        fighterList = [[CCArray alloc] initWithCapacity:5];
    }
    
    return self;
}

-(void) addFighterVo:

-(void) dealloc
{
    [fighterDict release];
    [fighterList release];
    [super dealloc];
}



@end
