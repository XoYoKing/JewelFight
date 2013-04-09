//
//  FightTopPanel.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightTopUI.h"
#import "CCBReader.h"
#import "LeaderPortrait.h"
#import "GameController.h"
#import "FighterVo.h"
#import "PlayerInfo.h"

@implementation FightTopUI

-(id) init
{
    if ((self = [super init]))
    {
        [self initUI];
    }
    
    return self;
}

-(void) dealloc
{
    [leftPortrait release];
    [rightPortrait release];
    [super dealloc];
}

-(void) initUI
{
    CCNode *ccbNode = [CCBReader nodeGraphFromFile:@"fight_ui_top.ccbi" owner:self];
    [self addChild:ccbNode];
}

-(void) initPortraitWithLeftFighters:(CCArray*)leftFighters rightFighters:(CCArray*)rightFighters
{
    leftPortrait = [[LeaderPortrait alloc] initWithFighterVo:[leftFighters objectAtIndex:0]];
    [leftPortraitHolder addChild:leftPortrait];
    
    rightPortrait = [[LeaderPortrait alloc] initWithFighterVo:[rightFighters objectAtIndex:0]];
    [rightPortraitHolder addChild:rightPortrait];
}

/// 减少生命值
-(void) reduceHpWithHeroId:(long)heroId reduce:(int)reduce
{
    if (leftPortrait.fighterVo.heroId == heroId)
    {
        [leftPortrait reduceHp:reduce];
    }
    else if (rightPortrait.fighterVo.heroId == heroId)
    {
        [rightPortrait reduceHp:reduce];
    }
}



@end
