//
//  FighterStonePanel.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterStonePanel.h"
#import "CCBReader.h"

@interface FighterStonePanel()

/// 初始化UI
-(void) initUI;

@end

@implementation FighterStonePanel

@synthesize team,stonePanel;

-(id) initWithTeam:(int)t fighterVo:(FighterVo *)fv
{
    if ((self = [super init]))
    {
        team = t;
        fighterVo = fv;
        [self initUI];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) initUI
{
    // 玩家阵营
    if (self.team == 0)
    {
        CCNode *node = [CCBReader nodeGraphFromFile:@"fight_player_fighter_stone_panel.ccbi" owner:self];
        [self addChild:node];
    }
    else
    {
        CCNode *node = [CCBReader nodeGraphFromFile:@"fight_enemy_fighter_stone_panel.ccbi" owner:self];
        [self addChild:node];
    }
    
    // 设置战士名称
    [nameLabel setString:fighterVo.name];
}


@end
