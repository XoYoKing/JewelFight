//
//  FightUtil.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFightMinStoneCheckNum 3 // 至少需要三个方块,才能被消除

@class JewelVo;

@interface FightUtil : NSObject
{
    int checkNum; // 至少要多少方块,才能被消除
    
}
@end
