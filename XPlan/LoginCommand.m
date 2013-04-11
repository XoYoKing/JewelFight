//
//  LoginCommand.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "LoginCommand.h"
#import "Constants.h"
#import "ServerDataEncoder.h"
#import "ServerDataDecoder.h"
#import "GameController.h"
#import "GameServer.h"

@interface LoginCommand()

@end

@implementation LoginCommand

#pragma mark -
#pragma mark Request

/// 请求注册
-(void) requestCreateWithUserName:(NSString*)userName sex:(int)sex
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:100]; // 服务
    [encoder writeInt16:1001]; // 模块
    [encoder writeInt8:2]; // 函数
    [encoder writeUTF:userName]; // 用户姓名
    [encoder writeInt8:sex];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}



@end
