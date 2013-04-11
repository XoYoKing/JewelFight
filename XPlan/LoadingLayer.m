//
//  PvPFightLoadingLayer.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "LoadingLayer.h"
#import "PvPScene.h"
#import "PvPController.h"
#import "CCBReader.h"

@interface LoadingLayer()
{

}

@end

@implementation LoadingLayer

-(id) init
{
    if ((self = [super init]))
    {
        // 初始化UI
        [self initUI];
    }
    
    return self;
}

-(void) dealloc
{
    [loadingBar release];
    [super dealloc];
}

-(void) initUI
{
    CCNode *node = [CCBReader nodeGraphFromFile:@"pvp_loading.ccbi" owner:self];
    [self addChild:node];
    
    CGPoint barPos = loadingBgSprite.position;
    
    loadingBar = [[HonsterBar alloc] initBarWithBarSprite:loadingBarSprite insetSprite:loadingBgSprite maskSprite:loadingMaskSprite];
    [self addChild:loadingBar];
    loadingBar.position = barPos;
    loadingBar.progress = 0;
}

-(void) setPercent:(float)value
{
    loadingBar.progress = value;
}

-(void) setText:(NSString *)text
{
    [textLabel setString:text];
}

@end
