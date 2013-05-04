//
//  FightGround.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class FightActor;
/// 战斗场地
@interface FightGround : CCLayer
{
    FightActor *actor1; // 战士1
    FightActor *actor2; // 战士2
}

/// 基于标识获取战场演员
-(FightActor*) getActorById:(NSString*)actorId;


@end
