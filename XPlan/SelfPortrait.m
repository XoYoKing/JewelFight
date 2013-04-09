//
//  SelfPortrait.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "SelfPortrait.h"
#import "CCBReader.h"
#import "GameController.h"
#import "GameServer.h"
#import "Constants.h"

@implementation SelfPortrait

-(id) initWithFighterVo:(FighterVo *)fv
{
    if ((self = [super initWithFighterVo:fv]))
    {
        [self connectCommand];
    }
    
    return self;
}

-(void) dealloc
{
    [self disconnectCommand];
    [super dealloc];
}

/// 侦听服务器端命令
-(void) connectCommand
{
    [[GameController sharedController].server.gameCommand addListenerWithActionId:SERVER_ACTION_ID_UPDATE_HERO listener:self];
}

/// 取消侦听
-(void) disconnectCommand
{
    [[GameController sharedController].server.gameCommand removeListenerWithActionId:SERVER_ACTION_ID_UPDATE_HERO listener:self];
}

-(void) responseWithActionId:(int)actionId object:(id)obj
{
    
}

-(void) initUI
{
    CCNode *ccbNode = [CCBReader nodeGraphFromFile:@"fight_portrait_self.ccbi" owner:self];
    [self addChild:ccbNode];
    
}

-(void) update:(ccTime)delta
{
    
}


-(void) changeEnergy
{
    
}

-(void) changeExp
{
    
}

@end
