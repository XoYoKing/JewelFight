//
//  GameSettings.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 游戏的一些独立设置,譬如声音,缩放等
@interface  KITSettings (XPlan)

/// Resets all the settings
+(void) reset;

/// 获取玩家配置
-(NSMutableDictionary*) playerDictionary;

/// 获取系统配置
-(NSMutableDictionary*) systemDictionary;

#pragma mark -
#pragma mark System


/// 获取服务器IP地址
-(NSString*) getServerIPAddress;

/// 设置服务器IP地址
-(void) setServerIPAddress:(NSString*)value;

/// 服务器端口
@property (readwrite,nonatomic) uint serverPort;

@end
