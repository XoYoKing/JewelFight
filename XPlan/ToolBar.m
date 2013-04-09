//
//  ToolBar.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ToolBar.h"
#import "CCBReader.h"
#import "PopupManager.h"
#import "HudBase.h"

@interface ToolBar()

@end

@implementation ToolBar

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) initialize:(HudBase *)theHud
{
    hud = theHud;
}

-(void) loadArt
{
    CCNode *node = [CCBReader nodeGraphFromFile:@"hud_tool_bar.ccbi" owner:self];
    [self addChild:node];
}

/// 点击背包按钮
-(void) clickBagBtn:(id)sender
{
    [hud openBagWindow];
}

/// 点击技能按钮
-(void) clickSkillBtn:(id)sender
{
    [hud openSkillWindow];
}

/// 点击任务按钮
-(void) clickTaskBtn:(id)sender
{
    [hud openTaskWindow];
}

/// 点击公会按钮
-(void) clickGuildBtn:(id)sender
{
    [hud openGuildWindow];
}

/// 点击商店按钮
-(void) clickShopBtn:(id)sender
{
    [hud openSkillWindow];
}

@end
