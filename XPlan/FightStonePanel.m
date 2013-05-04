//
//  FighterJewelPanel.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightJewelPanel.h"
#import "CCBReader.h"

@interface FightJewelPanel()

/// 初始化UI
-(void) initUI;

@end

@implementation FightJewelPanel

@synthesize team,jewelPanel;

-(id) initWithTeam:(int)t
{
    if ((self = [super init]))
    {
        team = t;
        [self initUI];
    }
    
    return self;
}


-(void) dealloc
{
    [super dealloc];
}

-(void) initializeWithFighter:(FighterVo *)fv
{
    // 更换战士
    fighterVo = fv;
    
    // 设置战士名称
    [nameLabel setString:fighterVo.name];
    
    // 设置宝石面板
}

-(void) initUI
{
    // 玩家阵营
    if (self.team == 0)
    {
        CCNode *node = [CCBReader nodeGraphFromFile:@"fight_player_jewel_panel.ccbi" owner:self];
        [self addChild:node];
        [self setContentSize:node.contentSize];
    }
    else
    {
        CCNode *node = [CCBReader nodeGraphFromFile:@"fight_opponent_jewel_panel.ccbi" owner:self];
        [self addChild:node];
        [self setContentSize:node.contentSize];
    }
}


@end
