//
//  StoneFactory.m
//  XPlan
//
//  Created by Hex on 4/12/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneFactory.h"

@implementation StoneFactory

+(JewelVo*) randomStone
{
    // 获取宝石的配置文件
    NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"stones_config.plist"]];
    NSArray *list = [config objectForKey:@"stones"];
    NSDictionary *stoneConfig = [list randomObject];
    JewelVo *stone = [[[JewelVo alloc] init] autorelease];
    
    stone.jewelId = [[stoneConfig valueForKey:@"jewelId"] intValue];
    stone.jewelType = [stoneConfig valueForKey:@"jewelType"];
    return stone;
}

@end
