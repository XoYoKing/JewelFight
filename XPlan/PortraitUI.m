//
//  PortraitUI.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PortraitUI.h"
#import "CCBReader.h"

@implementation PortraitUI



-(id) initWithFighterVo:(FighterVo *)fv
{
    if ((self = [super init]))
    {
        fighterVo = fv;
        [self initUI];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) setLife:(int)value
{
    life = value;
    [self changeLife];
}

-(void) setMaxLife:(int)value
{
    maxLife = value;
    [self changeMaxHp];
}

/// 减少生命值
-(void) reduceHp:(int)reduce
{
    hp = hp - reduce;
}

-(void) changeHp
{
    
}

-(void) initUI
{
    if (!fighterVo)
        return;
    
    // 加载素材
    
    // 设置头像
    
    // 设置血量
    life = maxLife = fighterVo.maxLife;
}

@end
