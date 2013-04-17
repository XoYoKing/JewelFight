//
//  PvPFightUser.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "MockPvPFightUser.h"
#import "JewelVo.h"
#import "FighterVo.h"
#import "UserInfo.h"
#import "JewelFactory.h"

@implementation MockPvPFightUser

@synthesize userInfo,fighters,jewelDict,jewelList;

-(id) init
{
    if ((self = [super init]))
    {
        userInfo = [[UserInfo alloc] init];
        fighters =[[CCArray alloc] initWithCapacity:3];
        currentFighterIndex = 0;
        jewelDict = [[NSMutableDictionary alloc] initWithCapacity:35];
        jewelList = [[CCArray alloc] initWithCapacity:35];
    }
    
    return self;
}

-(void) dealloc
{
    [userInfo release];
    [fighters release];
    [jewelDict release];
    [jewelList release];
    [super dealloc];
}

-(void) initJewels
{
    [self initJewels:jewelList];
}

-(JewelVo*) getJewelAtCoord:(CGPoint)coord withJewels:(CCArray*)jewels
{
    if (coord.x<0 || coord.y <0 || coord.x >= kJewelGridWidth || coord.y >= kJewelGridHeight)
    {
        return nil;
    }
    int index = coord.y * kJewelGridWidth + coord.x;
    if (index < jewels.count)
    {
        return [jewels objectAtIndex:(index)];
    }
    else
    {
        return nil;
    }
}

/// 检查垂直方向
-(int) checkVerticalWithJewel:(JewelVo*)jewel withJewels:(CCArray*)list
{
    if (jewel==nil)
    {
        return 0;
    }
    
    int elimateCount = 1;
    
    // 向上检测
    JewelVo *upJewel = [self getJewelAtCoord:ccp(jewel.coord.x,jewel.coord.y - 1) withJewels:list];
    while (upJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (upJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || upJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            upJewel = [self getJewelAtCoord:ccp(upJewel.coord.x,upJewel.coord.y - 1) withJewels:list];
        }
        else
        {
            break;
        }
    }
    
    // 向下检测
    JewelVo *downJewel = [self getJewelAtCoord:ccp(jewel.coord.x,jewel.coord.y + 1) withJewels:list];
    while (downJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (downJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || downJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            
            downJewel = [self getJewelAtCoord:ccp(downJewel.coord.x,downJewel.coord.y + 1) withJewels:list];
        }
        else
        {
            break;
        }
    }
    
    return elimateCount;
}


/// 检查水平方向
-(int) checkHorizontalWithJewel:(JewelVo*)jewel withJewels:(CCArray*)list
{
    if (jewel==nil)
    {
        return 0;
    }
    
    int elimateCount = 1;
    
    // 向左检测
    JewelVo *leftJewel = [self getJewelAtCoord:ccp(jewel.coord.x-1,jewel.coord.y) withJewels:list];
    while (leftJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (leftJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || leftJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            
            leftJewel = [self getJewelAtCoord:ccp(leftJewel.coord.x-1,leftJewel.coord.y) withJewels:list];
        }
        else
        {
            break;
        }
    }
    
    // 向右检测
    JewelVo *rightJewel = [self getJewelAtCoord:ccp(jewel.coord.x+1,jewel.coord.y) withJewels:list];
    while (rightJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (rightJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || rightJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            
            rightJewel = [self getJewelAtCoord:ccp(rightJewel.coord.x+1,rightJewel.coord.y) withJewels:list];
        }
        else
        {
            break;
        }
    }
    
    return elimateCount;
}

/// 初始化宝石
-(void) initJewels:(CCArray*)jewels
{
    
    // WARNING: mock测试!死局检测就免了!!!
    int totalJewels = kJewelGridWidth * kJewelGridHeight;
    int n = 0;
    while (n< totalJewels)
    {
        JewelVo *sv = [JewelFactory randomJewel];
        sv.coord = ccp(n%kJewelGridWidth, n / kJewelGridWidth);
        // 如果会产生可能被消除的,则生成新的宝石
        while ([self checkHorizontalWithJewel:sv withJewels:jewels] >= kJewelEliminateMinNeed || [self checkVerticalWithJewel:sv withJewels:jewels] >= kJewelEliminateMinNeed)
        {
            sv = [JewelFactory randomJewel];
            sv.coord = ccp(n%kJewelGridWidth, n / kJewelGridWidth);
        }
        
        [jewels addObject:sv];
        n++;
    }
    
    
    //
}



@end
