//
//  AttackData.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "AttackVo.h"

@implementation AttackVo

@synthesize skillId,isTarget,actorGlobalId,targetGlobalId,targetPos,damages;

-(CCArray*) damages
{
    if (damages == nil)
    {
        damages = [[CCArray alloc] initWithCapacity:5];
    }
    
    return damages;
}

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [damages release];
    [super dealloc];
}

/// 判断是否是物理攻击
-(BOOL) isPhysicalAttack
{
    return self.skillId == 1001;
}

@end
