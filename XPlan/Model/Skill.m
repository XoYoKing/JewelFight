//
//  Skill.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "Skill.h"

@implementation Skill

-(id) initWithConfig:(NSDictionary*)config
{
    if ((self = [super init]))
    {
        skillId = [[config valueForKey:@"skillId"] intValue];
        name = [[config valueForKey:@"name"] retain];
        requiredLevel = [[config valueForKey:@"requiredLevel"] intValue];
        effectTarget = [[config valueForKey:@"effectTarget"] intValue];
        skillArea = [[config valueForKey:@"skillArea"] intValue];
        continueTime = [[config valueForKey:@"continueTime"] intValue];
        happenFrequence = [[config valueForKey:@"happenFrequence"] intValue];
        coldTime = [[config valueForKey:@"coldTime"] intValue];
        coldGroup = [[config valueForKey:@"coldGroup"] intValue];
        cost = [[config valueForKey:@"cost"] intValue];
        iconId = [[config valueForKey:@"iconId"] intValue];
        skillEffect1 = [[config valueForKey:@"skillEffect1"] retain];
        effectPosition1 = [[config valueForKey:@"effectPosition1"] intValue];
        skillEffect2 = [[config valueForKey:@"skillEffect2"] retain];
        effectPosition2 = [[config valueForKey:@"effectPosition2"] intValue];
        skillEffect3 = [[config valueForKey:@"skillEffect3"] retain];
        effectPosition3 = [[config valueForKey:@"effectPosition3"] intValue];
        targetType = [[config valueForKey:@"targetType"] intValue];
        skillWay = [[config valueForKey:@"skillWay"] intValue];
        skillAction = [[config valueForKey:@"skillAction"] retain];
        playerTimes = [[config valueForKey:@"playerTimes"] intValue];
    }
    
    return self;
}

@end
