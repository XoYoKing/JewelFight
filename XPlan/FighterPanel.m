//
//  FighterPanel.m
//  XPlan
//
//  Created by Hex on 4/2/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterPanel.h"
#import "CCBReader.h"

@interface FighterPanel()

@end

@implementation FighterPanel

-(id) initWithFighterVo:(FighterVo *)fv
{
    if ((self = [super init]))
    {
        [self loadGraphic];
        [self setFighterVo:fv];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) loadGraphic
{
    CCNode *node = [CCBReader nodeGraphFromFile:@"fight_fighter_panel.ccbi" owner:self];
    [self addChild:node];
}

/// 
-(void) setFighterVo:(FighterVo *)fv
{
    fighterVo = fv;
    
    // 设置战士显示
    KITProfile *profile = [KITProfile profileWithName:fv];
    
    [fighterPic setDisplayFrame:[profile spriteFrameForKey:@"img"]];
}

-(void) updateLifeBar
{
    int x = lifepad.width / 2;
    int y = lifepad.height / 2;
    
    lifebar.scaleX = (fighterVo.life / fighterVo.maxLife) * 0.99f;
    
    lifebar.position = ccp(1 + x - (clampf(1.0f - lifebar.scaleX, 0.0f, 1.0f) * x), y);
    
}


@end
