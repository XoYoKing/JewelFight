//
//  ChatUtil.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ChatUtil.h"
#import "Constants.h"

@implementation ChatUtil

+(NSString*) matchSpecial:(NSString*)value
{
    // TODO:
}

/// 获得频道外发光颜色
+(ccColor3B) getFilterColor:(int)type
{
    ccColor3B color =ccBLACK;
    switch (type)
    {
        case kChatChannelRoom:
            color = [self getColorFromString:@"1c1005"];
            break;
        case kChatChannelFamily:
            color = [self getColorFromString:@"014136"];
            break;
        case kChatChannelTeam:
            color = [self getColorFromString:@"1355ed"];
            break;
        case kChatChannelHorn:
            color = [self getColorFromString:@"1e90ff"];
            break;
        case kChatChannelPrivate:
            color = [self getColorFromString:@"680b58"];
            break;
        case kChatChannelWorld:
            color = [self getColorFromString:@"6b310a"];
            break;
        case kChatChannelSystem:
            color = [self getColorFromString:@"6c311c"];
            break;
        case kChatChannelNormal:
            color = [self getColorFromString:@"fcfcfc"];
            break;
    }
    
    return color;
}

/// 转换颜色
+(ccColor3B) getColorFromString:(NSString*)colorStr
{
    NSScanner *scanner2 = [NSScanner scannerWithString:colorStr];
    [scanner2 setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; 
    unsigned int baseColor1;
    [scanner2 scanHexInt:&baseColor1];
    CGFloat red   = ((baseColor1 & 0xFF0000) >> 16) / 255.0f;
    CGFloat green = ((baseColor1 & 0x00FF00) >>  8) / 255.0f;
    CGFloat blue  =  (baseColor1 & 0x0000FF) / 255.0f;
    return ccc3(red, green, blue);
}

/// 获得频道颜色
+(ccColor3B) getChannelColor:(int)type
{
    ccColor3B color = ccBLACK;
    switch (type)
    {
        case kChatChannelRoom:
            color = [self getColorFromString:@"ffffff"];
            break;
        case kChatChannelFamily:
            color = [self getColorFromString:@"6df3d5"];
            break;
        case kChatChannelTeam:
            color = [self getColorFromString:@"1355ed"];
            break;
        case kChatChannelNormal:
            color = [self getColorFromString:@"fcfcfc"];
            break;
        case kChatChannelPrivate:
            color = [self getColorFromString:@"fe89fd"];
            break;
        case kChatChannelHorn:
            color = [self getColorFromString:@"1e90ff"];
            break;
        case kChatChannelWorld:
            color = [self getColorFromString:@"fe9073"];
            break;
        case kChatChannelSystem:
            color = [self getColorFromString:@"ffd075"];
            break;
    }
    
    return color;
}

/// 获取频道名称
+(NSString*) getChannelName:(int)type
{
    NSString *text = @"";
    switch (type)
    {
        case kChatChannelRoom:
            text = NSLocalizedString(@"CHANNEL_NAME_ROOM", nil);
            break;
        case kChatChannelFamily:
            text = NSLocalizedString(@"CHANNEL_NAME_FAMILY", nil);
            break;
        case kChatChannelTeam:
            text = NSLocalizedString(@"CHANNEL_NAME_TEAM", nil);
            break;
        case kChatChannelNormal:
            text = NSLocalizedString(@"CHANNEL_NAME_NORMAL", nil);
            break;
        case kChatChannelPrivate:
            text = NSLocalizedString(@"CHANNEL_NAME_PRIVATE", nil);
            break;
        case kChatChannelHorn:
            text = NSLocalizedString(@"CHANNEL_NAME_HORN", nil);
            break;
        case kChatChannelWorld:
            text = NSLocalizedString(@"CHANNEL_NAME_WORLD", nil);
            break;
        case kChatChannelSystem:
            text = NSLocalizedString(@"CHANNEL_NAME_SYSTEM", nil);
            break;
        default:
            text = NSLocalizedString(@"ACOUSTIC", nil);
            break;
    }
    
    return text;
}

@end
