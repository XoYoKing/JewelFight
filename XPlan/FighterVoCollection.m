//
//  FighterCollection.m
//  XPlan
//
//  Created by Hex on 4/21/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterVoCollection.h"
#import "FighterVo.h"

@implementation FighterVoCollection

-(id) init
{
    if ((self = [super init]))
    {
        fighterVoDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        fighterVoList = [[CCArray alloc] initWithCapacity:5];
    }
    
    return self;
}

-(void) addFighterVo:(FighterVo*)fv
{
    if (![fighterVoDict.allKeys containsObject:[NSNumber numberWithLong:fv.globalId]])
    {
        [fighterVoDict setObject:fv forKey:[NSNumber numberWithLong:fv.globalId]];
        [fighterVoList addObject: fv];
    }
}

-(void) deleteFighterVo:(FighterVo*)fv
{
    [fighterVoList removeObject:fv];
    [fighterVoDict removeObjectForKey:[NSNumber numberWithLong:[NSNumber numberWithLong:fv.globalId]]];
}



-(void) dealloc
{
    [fighterVoDict release];
    [fighterVoList release];
    [super dealloc];
}



@end
