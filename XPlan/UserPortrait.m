//
//  UserPortrait.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "UserPortrait.h"
#import "CCBReader.h"
#import "UserInfo.h"

@interface UserPortrait()

@end

@implementation UserPortrait

@synthesize userVo;

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
    // 加载界面素材
    
}

/// 设置血量
-(void) setHp:(int)value
{
    hp =value;
    [self updateHpGraphic];
}

-(void) setMaxHp:(int)value
{
    maxHp = value;
    [self updateHpGraphic];
}

/// 更新生命值表现
-(void) updateHpGraphic
{
    
}

// TODO:设置头像
-(void) setPortraitByUrl:(NSString*)url
{
    
}


@end
