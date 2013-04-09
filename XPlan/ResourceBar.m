//
//  MoneyBar.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ResourceBar.h"
#import "CCBReader.h"
#import "UserInfo.h"

@interface ResourceBar()

@end

@implementation ResourceBar

-(id) initWithUserVo:(UserInfo *)uv
{
    if ((self = [super init]))
    {
        userVo = uv;
        [self loadArt];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) loadArt
{
    CCNode *node = [CCBReader nodeGraphFromFile:@"hud_resource_bar.ccbi" owner:self];
    [self addChild:node];
    
    [self setSilver:userVo.silver];
    [self setGold:userVo.gold];
    [self setDiamond:userVo.diamond];
    
}

-(void) setSilver:(int)value
{
    [silverTxt setString:[NSString stringWithFormat:@"%d",value]];
}

-(void) setGold:(int)value
{
    [goldTxt setString:[NSString stringWithFormat:@"%d",value]];
}

-(void) setDiamond:(int)value
{
    [diamondTxt setString:[NSString stringWithFormat:@"%d",value]];
}

@end
