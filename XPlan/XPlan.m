//
//  XPlan.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "XPlan.h"
#import "GameController.h"
#import "GameLoadingScene.h"
#import "GameController.h"

@implementation XPlan

-(void) startApp
{
    CCFileUtils *fileUtils = [CCFileUtils sharedFileUtils];
    //[fileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];
    //[fileUtils setiPadSuffix:@""];
    [fileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];
    
    //
    [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
    
    // 初始化GameController
    [[GameController sharedController] initServer];
    
    // 加载场景
    GameLoadingScene *scene = [GameLoadingScene node];
    [[CCDirector sharedDirector] runWithScene:scene];
}

-(void) stopApp
{
    
}

-(void) pauseApp
{
    
}

-(void) resumeApp
{
    
}

-(void) foregroundApp
{
    
}

-(void) backgroundApp
{
    
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [super applicationDidReceiveMemoryWarning:application];
}

@end
