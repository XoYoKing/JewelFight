//
//  LoginLayer.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "LoginLayer.h"
#import "CCBReader.h"

@interface LoginLayer()

/// 初始化
-(void) initialize;

@end

@implementation LoginLayer

-(id) init
{
    if ((self = [super init]))
    {
        [self initialize];
    }
    
    return self;
}

-(void) initialize
{
    // 从配置文件中加载界面
    CCNode *node = [CCBReader nodeGraphFromFile:@"login.ccbi" owner:self];
    [self addChild:node];
}


@end
