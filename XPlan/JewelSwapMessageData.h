//
//  JewelSwapMessageData.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelMessageData.h"

@interface JewelSwapMessageData : JewelMessageData
{
    
    int jewelGlobalId1;
    
    int jewelGlobalId2;
}

@property (readonly,nonatomic) int jewelGlobalId1;

@property (readonly,nonatomic) int jewelGlobalId2;

+(id) dataWithUserId:(long)uId jewelGlobalId1:(int)j1 jewelGlobalId2:(int)j2;

-(id) initWithUserId:(long)uId jewelGlobalId1:(int)j1 jewelGlobalId2:(int)j2;


@end
