//
//  MockPvPServer.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 仿冒PvP服务器
@interface MockPvPServer : NSObject
{
    NSMutableDictionary *player1JewelDict;
    CCArray *player1JewelList;
    CCArray *player1Fighters;
    
    NSMutableDictionary *player2JewelDict;
    CCArray *player2JewelList;
    CCArray *player2Fighters;
    
}


@end
