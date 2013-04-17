//
//  JewelSwapMessageData.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageData.h"

@interface JewelSwapMessageData : MessageData
{
    long userId;
    
    int jewelGlobalId1;
    
    int jewelGlobalId2;
}

@property (readonly,nonatomic) long userId;

@property (readonly,nonatomic) int jewelGlobalId1;

@property (readonly,nonatomic) int jewelGlobalId2;

+(id) dataWithUserId:(long)uId jewelGlobalId1:(int)j1 jewelGlobalId2:(int)j2;

-(id) initWithUserId:(long)uId jewelGlobalId1:(int)j1 jewelGlobalId2:(int)j2;


@end
