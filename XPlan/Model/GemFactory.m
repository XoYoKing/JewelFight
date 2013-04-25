//
//  JewelFactory.m
//  XPlan
//
//  Created by Hex on 4/12/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemFactory.h"

@implementation GemFactory

+(GemVo*) randomJewel
{
    // 获取宝石的配置文件
    NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"jewels_config.plist"]];
    NSArray *list = [config objectForKey:@"jewels"];
    NSDictionary *jewelConfig = [list randomObject];
    GemVo *jewel = [[[GemVo alloc] init] autorelease];
    jewel.jewelId = [[jewelConfig valueForKey:@"jewelId"] intValue];
    jewel.jewelType = [jewelConfig valueForKey:@"jewelType"];
    return jewel;
}

@end
