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

static int jewelGlobalIdGenerator = 0;

@implementation MockPvPFightUser

@synthesize userInfo,fighters,jewelDict,jewelList,currentFighterIndex;

-(id) init
{
    if ((self = [super init]))
    {
        userInfo = [[UserInfo alloc] init];
        fighters =[[CCArray alloc] initWithCapacity:3];
        currentFighterIndex = 0;
        jewelDict = [[NSMutableDictionary alloc] initWithCapacity:35];
        jewelList = [[CCArray alloc] initWithCapacity:36];
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


-(JewelVo*) getJewelAtCoord:(CGPoint)coord
{
    if (coord.x<0 || coord.y <0 || coord.x >= kJewelBoardWidth || coord.y >= kJewelBoardHeight)
    {
        return nil;
    }
    int index = coord.y * kJewelBoardWidth + coord.x;
    if (index < jewelList.count)
    {
        return [jewelList objectAtIndex:(index)];
    }
    else
    {
        return nil;
    }
}

/// 检查垂直方向
-(int) checkVerticalWithJewel:(JewelVo*)jewel
{
    if (jewel==nil)
    {
        return 0;
    }
    
    int elimateCount = 1;
    
    // 向上检测
    JewelVo *upJewel = [self getJewelAtCoord:ccp(jewel.coord.x,jewel.coord.y - 1)];
    while (upJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (upJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || upJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            upJewel = [self getJewelAtCoord:ccp(upJewel.coord.x,upJewel.coord.y - 1)];
        }
        else
        {
            break;
        }
    }
    
    // 向下检测
    JewelVo *downJewel = [self getJewelAtCoord:ccp(jewel.coord.x,jewel.coord.y + 1)];
    while (downJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (downJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || downJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            
            downJewel = [self getJewelAtCoord:ccp(downJewel.coord.x,downJewel.coord.y + 1)];
        }
        else
        {
            break;
        }
    }
    
    return elimateCount;
}


/// 检查水平方向
-(int) checkHorizontalWithJewel:(JewelVo*)jewel
{
    if (jewel==nil)
    {
        return 0;
    }
    
    int elimateCount = 1;
    
    // 向左检测
    JewelVo *leftJewel = [self getJewelAtCoord:ccp(jewel.coord.x-1,jewel.coord.y)];
    while (leftJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (leftJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || leftJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            
            leftJewel = [self getJewelAtCoord:ccp(leftJewel.coord.x-1,leftJewel.coord.y)];
        }
        else
        {
            break;
        }
    }
    
    // 向右检测
    JewelVo *rightJewel = [self getJewelAtCoord:ccp(jewel.coord.x+1,jewel.coord.y)];
    while (rightJewel!=nil)
    {
        // 宝石类型一致的话,加入到可消除队列
        if (rightJewel.jewelId == jewel.jewelId || jewel.jewelType == kJewelTypeSpecial || rightJewel.jewelType == kJewelTypeSpecial)
        {
            elimateCount+=1;
            
            rightJewel = [self getJewelAtCoord:ccp(rightJewel.coord.x+1,rightJewel.coord.y)];
        }
        else
        {
            break;
        }
    }
    
    return elimateCount;
}

/// 初始化宝石
-(void) initJewels
{
    
    // WARNING: mock测试!死局检测就免了!!!
    int totalJewels = kJewelBoardWidth * kJewelBoardHeight;
    int n = 0;
    while (n< totalJewels)
    {
        JewelVo *sv = [JewelFactory randomJewel];
        sv.coord = ccp(n%kJewelBoardWidth, n / kJewelBoardWidth);
        // 如果会产生可能被消除的,则生成新的宝石
        while ([self checkHorizontalWithJewel:sv] >= kJewelEliminateMinNeed || [self checkVerticalWithJewel:sv] >= kJewelEliminateMinNeed)
        {
            sv = [JewelFactory randomJewel];
            sv.coord = ccp(n%kJewelBoardWidth, n / kJewelBoardWidth);
        }
        
        sv.globalId = ++jewelGlobalIdGenerator;
        [jewelDict setObject:sv forKey:[NSNumber numberWithInt:sv.globalId]];
        [jewelList addObject:sv];
        n++;
    }
    
    
    //
}


-(void) swapJewel1:(int)globalId1 jewel2:(int)globalId2
{
    JewelVo *jv1 = [jewelDict objectForKey:[NSNumber numberWithInt:globalId1]];
    JewelVo *jv2 = [jewelDict objectForKey:[NSNumber numberWithInt:globalId2]];
    
    
    // 切换数据坐标
    CGPoint temp = jv1.coord;
    jv1.coord = jv2.coord;
    jv2.coord = temp;
    
    // 切换集合
    [jewelList replaceObjectAtIndex:jv1.coord.x + jv1.coord.y * kJewelBoardWidth withObject:jv2];
    [jewelList replaceObjectAtIndex:jv2.coord.x + jv2.coord.y * kJewelBoardWidth withObject:jv1];
}

-(void) eliminateJewelsWithGlobalIds:(CCArray*)globalIds
{
    CCArray *dropJewels = [[CCArray alloc] initWithCapacity:20];
    
    // 先清理宝石
    for (NSNumber *globalIdNum in globalIds)
    {
        JewelVo *elimJv = [jewelDict objectForKey:globalIdNum];
        [jewelList replaceObjectAtIndex:elimJv.coord.x + elimJv.coord.y * kJewelBoardWidth withObject:nil];
        [jewelDict removeObjectForKey:globalIdNum];
    }
    
    // 循环遍历全部宝石格子
    for (int i = 0; i< kJewelBoardWidth;i++)
    {
        for (int j=0; j< kJewelBoardHeight; j++)
        {
            JewelVo *jv = [self getJewelAtCoord:ccp(i,j)];
            
            if (jv == nil)
            {
                for (int k=j-1; k>=0; k--)
                {
                    JewelVo *upJewel = [self getJewelAtCoord:ccp(i,k)];
                    if(upJewel!=nil)
                    {
                        [upJewel addYGap];
                        if (![dropJewels containsObject:upJewel])
                        {
                            [dropJewels addObject:upJewel];
                        }
                    }
                }
            }
        }
    }
    
    // 下落
    for (JewelVo *dropJv in dropJewels)
    {
        dropJv.coord = ccp(dropJv.coord.x,dropJv.toY);
        dropJv.yGap = 0;
    }
    
    // 更新宝石格子信息
    [self updateJewelGridInfo];
    
    [dropJewels release];
}

-(void) updateJewelGridInfo
{
    // 清理
    for (int i=0;i<jewelList.count;i++)
    {
        [jewelList replaceObjectAtIndex:i withObject:nil];
    }
    
    // 设置
    for (JewelVo *jv in jewelDict.allValues)
    {
        [jewelList replaceObjectAtIndex:jv.coord.x + jv.coord.y * kJewelBoardWidth withObject:jv];
    }
}

/// 填充宝石
-(void) fillEmptyJewels:(CCArray*)filledList
{
    KITLog(@"%@",jewelList);
    
    // 找出空出来的宝石位置,向上寻找宝石
    for (int i =0;i <kJewelBoardWidth; i++)
    {
        for (int j = 0; j< kJewelBoardHeight; j++)
        {
            int index = i + j * kJewelBoardWidth;
            if ([jewelList objectAtIndex:index]==nil)
            {
                JewelVo *newJv = [JewelFactory randomJewel];
                newJv.globalId = ++jewelGlobalIdGenerator;
                newJv.coord = ccp(i,j);
                
                [jewelList replaceObjectAtIndex:index withObject:newJv];
                [jewelDict setObject:newJv forKey:[NSNumber numberWithInt:newJv.globalId]];
                [filledList addObject:newJv];
            }
        }
    }
    
    [self updateJewelGridInfo];
    
}



@end
