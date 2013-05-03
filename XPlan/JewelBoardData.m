//
//  JewelBoardData.m
//  XPlan
//
//  Created by Hex on 5/2/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelBoardData.h"
#import "Constants.h"
#import "JewelCell.h"
#import "JewelVo.h"
#import "JewelController.h"

@implementation JewelBoardData

@synthesize jewelController,cellGrid,numJewelsInColumn,timeSinceAddInColumn,boardChangedSinceEvaluation,boardJewelVoGrid,boardJewelVoDict,fallingJewelVos;

-(id) initWithJewelController:(JewelController *)jc
{
    if ((self = [super init]))
    {
        jewelController = jc;
        
        boardWidth = jewelController.boardWidth;
        boardHeight = jewelController.boardHeight;
        
        // 设置数据对象集合
        boardJewelVoDict = [[NSMutableDictionary alloc] initWithCapacity:50];
        boardJewelVoGrid = [[CCArray alloc] initWithCapacity:100];

        // 初始化宝石格子
        int totalCells = boardWidth * boardHeight;
        cellGrid = [[CCArray alloc] initWithCapacity:totalCells];
        int n = 0;
        while (n < totalCells)
        {
            JewelCell *cell = [[JewelCell alloc] initWithJewelController:jc coord:ccp(n %  boardWidth, n / boardWidth)];
            [cellGrid addObject:cell];
            [cell release];
            n++;
        }
        
        // 列中宝石数量集合
        numJewelsInColumn = malloc(boardWidth * sizeof(int));
        
        // 添加宝石时间集合
        timeSinceAddInColumn = malloc(boardWidth * sizeof(float));
        
        // 设置初始值
        for (int i = 0; i< boardWidth; i++)
        {
            numJewelsInColumn[i] = 0;
            timeSinceAddInColumn[i] = 0;
        }
        
        // 初始化下落宝石集合
        fallingJewelVos = [[CCArray alloc] initWithCapacity:boardWidth];
        for (int i =0; i< boardWidth;i++)
        {
            CCArray *list = [[CCArray alloc] initWithCapacity:5];
            [fallingJewelVos addObject:list];
            [list release];
        }
        
        possibleEliminates = [[CCArray alloc] initWithCapacity:5];
        
        boardChangedSinceEvaluation = YES;
        
    }
    
    return self;
}

-(void) dealloc
{
    [cellGrid release];
    [fallingJewelVos release];
    [possibleEliminates release];
    free(numJewelsInColumn); // 释放c数组
    free(timeSinceAddInColumn); // 释放c数组
    [super dealloc];
}

-(void) addJewelVo:(JewelVo *)vo
{
    // 添加JewelVo
    if (![boardJewelVoDict.allKeys containsObject:[NSNumber numberWithInt:vo.globalId]])
    {
        [boardJewelVoDict setObject:vo forKey:[NSNumber numberWithInt:vo.globalId]];
        [boardJewelVoGrid addObject:vo];
    }
}

-(void) removeJewelVo:(JewelVo *)vo
{
    // 重置宝石地格
    [[self getCellAtCoord:vo.coord] setJewelGlobalId:0];
    
    // 从字典中删除
    [boardJewelVoDict removeObjectForKey:[NSNumber numberWithInt:vo.globalId]];
    
    // 从列表中删除
    [boardJewelVoGrid removeObject:vo];
}

-(void) removeAllJewelVos
{
    [boardJewelVoDict removeAllObjects];
    [boardJewelVoGrid removeAllObjects];
    
    // 清理地格
    for (JewelCell *cell in cellGrid)
    {
        cell.jewelGlobalId = 0;
    }
    
    for (int x=0;x<boardWidth;x++)
    {
        numJewelsInColumn[x] = 0;
        timeSinceAddInColumn[x] = 0;
    }
}

-(JewelVo*) getJewelVoByGlobalId:(int)jewelGlobalId
{
    return [boardJewelVoDict objectForKey:[NSNumber numberWithInt:jewelGlobalId]];
}

/// 获取指定坐标的宝石格子
-(JewelCell*) getCellAtCoord:(CGPoint)coord
{
    if (coord.x < 0 || coord.y < 0 || coord.x >= boardWidth || coord.y >= boardHeight)
    {
        return nil;
    }
    
    return [cellGrid objectAtIndex:coord.x + coord.y * boardWidth];
}

#pragma mark -
#pragma mark 死局检查

/// 检查死局
-(BOOL) checkDead
{
    for (JewelVo *jv in boardJewelVoGrid)
    {
        // 检查纵向是否有可能消除的宝石
        if ([self isVerticalPossibleEliminate:jv])
        {
            return NO;
        }
        
        // 检查横向是否有可能消除的宝石
        if ([self isHorizontalPossibleEliminate:jv])
        {
            return NO;
        }
    }
    
    return YES;
}

/// 检查水平方向是否有可消除的宝石
-(BOOL) isHorizontalPossibleEliminate:(JewelVo*)center
{
    CCArray *leftList = [[CCArray alloc] initWithCapacity:boardHeight];
    CCArray *middleList = [[CCArray alloc] initWithCapacity:boardHeight];
    CCArray *rightList = [[CCArray alloc] initWithCapacity:boardHeight];
    
    BOOL can = [self isHorizontalPossibleEliminateWithJewelVo:center leftList:leftList middleList:middleList rightList:rightList];
    
    [middleList release];
    [leftList release];
    [rightList release];
    
    return can;
}

/// 检查水平方向是否有可消除的宝石并填充相同宝石集合
-(BOOL) isHorizontalPossibleEliminateWithJewelVo:(JewelVo*)center leftList:(CCArray*)leftList middleList:(CCArray*)middleList rightList:(CCArray*)rightList
{
    // 获取可消除的宝石集合
    int skipCount = 0;
    
    // 添加自身
    [middleList addObject:center];
    
    // 向左检测
    JewelVo *check = [self getCellAtCoord:ccp(center.coord.x-1,center.coord.y)].jewelVo;
    while (check!=nil)
    {
        if (check.jewelId != center.jewelId)
        {
            skipCount++;
            
            // 只能跳过一个
            if (skipCount>1)
            {
                break;
            }
            
            // 检测垂直方向是否有相同类型的宝石
            JewelCell *topCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y-1)];
            if (topCell && topCell.jewelVo.jewelId == center.jewelId)
            {
                [leftList addObject:topCell.jewelVo];
            }
            else
            {
                JewelCell *bottomCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y+1)];
                if (bottomCell && bottomCell.jewelVo.jewelId == center.jewelId)
                {
                    [leftList addObject:bottomCell.jewelVo];
                }
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [leftList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x-1,check.coord.y)].jewelVo;
    }
    
    // 向右检测
    //skipCount = 0;
    check = [self getCellAtCoord:ccp(center.coord.x+1,center.coord.y)].jewelVo;
    while (check!=nil)
    {
        if (check.jewelId != center.jewelId)
        {
            skipCount++;
            if (skipCount>1)
            {
                break;
            }
            
            // 检测垂直方向是否有相同类型的宝石
            JewelCell *topCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y-1)];
            if (topCell && topCell.jewelVo.jewelId == center.jewelId)
            {
                [rightList addObject:topCell.jewelVo];
            }
            else
            {
                JewelCell *bottomCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y+1)];
                if (bottomCell && bottomCell.jewelVo.jewelId == center.jewelId)
                {
                    [rightList addObject:bottomCell.jewelVo];
                }
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [rightList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x+1,check.coord.y)].jewelVo;
    }
    
    BOOL life = middleList.count>=kJewelEliminateMinNeed || leftList.count + middleList.count >= kJewelEliminateMinNeed || rightList.count + middleList.count >= kJewelEliminateMinNeed;
    
    return life;
}

/// 检测水平方向死局
-(BOOL) isVerticalPossibleEliminate:(JewelVo*)center
{
    CCArray *topList = [[CCArray alloc] initWithCapacity:boardWidth];
    CCArray *middleList = [[CCArray alloc] initWithCapacity:boardWidth];
    CCArray *bottomList = [[CCArray alloc] initWithCapacity:boardWidth];
    
    BOOL can = [self isVerticalPossibleEliminateWithJewelVo:center topList:topList middleList:middleList bottomList:bottomList];
    
    [middleList release];
    [topList release];
    [bottomList release];
    
    return can;
}

/// 寻找垂直方向的相同类型的宝石集合并填充相同宝石集合
-(BOOL) isVerticalPossibleEliminateWithJewelVo:(JewelVo*)center topList:(CCArray*)topList middleList:(CCArray*)middleList bottomList:(CCArray*)bottomList
{
    int skipCount = 0;
    [middleList addObject:center];
    
    // 向上检测
    JewelVo *check = [self getCellAtCoord:ccp(center.coord.x,center.coord.y-1)].jewelVo;
    while (check!=nil)
    {
        if (check.jewelId != center.jewelId)
        {
            skipCount++;
            if (skipCount>1)
            {
                break;
            }
            
            // 检测水平方向是否有相同类型的宝石
            JewelCell *leftCell = [self getCellAtCoord:ccp(check.coord.x-1,check.coord.y)];
            if (leftCell && leftCell.jewelVo.jewelId == center.jewelId)
            {
                [topList addObject:leftCell.jewelVo];
            }
            else
            {
                JewelCell *rightCell = [self getCellAtCoord:ccp(check.coord.x+1,check.coord.y)];
                if (rightCell && rightCell.jewelVo.jewelId == center.jewelId)
                {
                    [topList addObject:rightCell.jewelVo];
                }
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [topList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x,check.coord.y-1)].jewelVo;
    }
    
    // 向下检测
    //skipCount = 0;
    check = [self getCellAtCoord:ccp(center.coord.x,center.coord.y+1)].jewelVo;
    while (check!=nil)
    {
        if (check.jewelId != center.jewelId)
        {
            skipCount++;
            if (skipCount>1)
            {
                break;
            }
            
            // 检测水平方向是否有相同类型的宝石
            JewelCell *leftCell = [self getCellAtCoord:ccp(check.coord.x-1,check.coord.y)];
            if (leftCell && leftCell.jewelVo.jewelId == center.jewelId)
            {
                [bottomList addObject:leftCell.jewelVo];
            }
            else
            {
                JewelCell *rightCell = [self getCellAtCoord:ccp(check.coord.x+1,check.coord.y)];
                if (rightCell && rightCell.jewelVo.jewelId == center.jewelId)
                {
                    [bottomList addObject:rightCell.jewelVo];
                }
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [bottomList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x,check.coord.y+1)].jewelVo;
    }
    
    BOOL life = middleList.count>=kJewelEliminateMinNeed || topList.count + middleList.count >= kJewelEliminateMinNeed || bottomList.count + middleList.count >= kJewelEliminateMinNeed;
    
    return life;
}


/// 宝石是否满的
-(BOOL) isJewelFull
{
    return boardJewelVoGrid.count == boardWidth * boardHeight;
}

/// 
-(void) removeMarkedJewels
{
    CCArray *checked = [[CCArray alloc] initWithCapacity:20];
    for (int x = 0; x < boardWidth; x++)
    {
        for (int y = 0; y < boardHeight; y++)
        {
            int idx = x + y * boardWidth;
            JewelCell *cell = [cellGrid objectAtIndex:idx];
            if (![checked containsObject:cell] && cell.jewelGlobalId==0)
            {
                KITLog(@"JewelBoardData:numJewelsInColumn %d : amount:%d",x,numJewelsInColumn[x]);
                numJewelsInColumn[x]--;
                [checked addObject:cell];
                boardChangedSinceEvaluation = YES;
                
                // 所有在当前宝石上方的宝石加入下落列表
                for (int yAbove = y + 1; yAbove <boardHeight; yAbove++)
                {
                    int idxAbove = x + yAbove * boardWidth;
                    
                    JewelCell *aboveCell = [cellGrid objectAtIndex:idxAbove];
                    if (aboveCell.jewelGlobalId==0)
                    {
                        KITLog(@"JewelBoardData:numJewelsInColumn %d : amount:%d",x,numJewelsInColumn[x]);
                        numJewelsInColumn[x]--;
                        [checked addObject:aboveCell];
                        continue;
                    }
                    
                    // 加入下落宝石列表
                    JewelVo *aboveJv = aboveCell.jewelVo;
                    aboveJv.ySpeed = 0;
                    aboveJv.yPos = yAbove;
                    [[fallingJewelVos objectAtIndex:x] addObject:aboveJv];
                    [self removeJewelVo:aboveCell.jewelVo];
                    
                    KITLog(@"JewelBoardData:numJewelsInColumn %d : amount:%d",x,numJewelsInColumn[x]);
                    numJewelsInColumn[x]--;
                    [checked addObject:aboveCell];
                }
            }
        }
    }
    
    [checked release];
    [self updateJewelGridInfo];
}

#pragma mark -
#pragma mark Eliminate Jewels

/// 寻找可消除的宝石
-(void) findEliminableJewels:(CCArray*)elimList
{
    for (JewelVo *jv in boardJewelVoGrid)
    {
        [self findHorizontalEliminableJewels:elimList withJewel:jv];
        [self findVerticalEliminableJewels:elimList withJewel:jv];
    }
}

/// 检查水平方向的可消除的宝石
-(void) findHorizontalEliminableJewels:(CCArray*)elimList withJewel:(JewelVo*)source
{
    CCArray *connectedList = [[CCArray alloc] initWithCapacity:10];
    
    // 自身加入进去
    [connectedList addObject:source];
    
    JewelVo *specialJewel; // 特殊宝石
    
    // 检查特殊宝石
    if (source.special >= kJewelSpecialExplode)
    {
        specialJewel = source;
    }
    
    // 向左侧检查
    JewelVo *leftJewel = [self getCellAtCoord:ccp(source.coord.x-1,source.coord.y)].jewelVo;
    while (leftJewel!=nil && leftJewel.jewelId == source.jewelId)
    {
        // 检查特殊宝石
        if (leftJewel.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.special < leftJewel.special)
            {
                specialJewel = leftJewel;
            }
        }
        
        // 添加到相同类型集合中
        [connectedList insertObject:leftJewel atIndex:0];
        leftJewel = [self getCellAtCoord:ccp(leftJewel.coord.x-1,leftJewel.coord.y)].jewelVo;
    }
    
    // 向右侧检查
    JewelVo *rightJewel= [self getCellAtCoord:ccp(source.coord.x+1,source.coord.y)].jewelVo;
    while (rightJewel!=nil && rightJewel.jewelId == source.jewelId)
    {
        if (rightJewel.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.special < rightJewel.special)
            {
                specialJewel = rightJewel;
            }
        }
        
        // 添加到检查列表
        [connectedList addObject:rightJewel];
        rightJewel= [self getCellAtCoord:ccp(rightJewel.coord.x+1,rightJewel.coord.y)].jewelVo;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (connectedList.count >= kJewelEliminateMinNeed)
    {
        BOOL isBoo = NO; // 爆炸标识
        for (JewelVo *connected in connectedList)
        {
            // 标记参与的横向消除
            connected.hEliminate = connectedList.count; // 横向消除数量
            if (connected.lt)
            {
                // 产生一个爆炸
                isBoo = YES;
                [self resetEliminateTop:connected];
            }
        }
        
        if (connectedList.count >= kJewelSpecialExplode && isBoo == NO)
        {
            [[connectedList lastObject] setEliminateRight:YES];
        }
        
        // 加入消除列表
        [elimList addObjectsFromArray:connectedList];
    }
    
    [connectedList release];
}

/// 检查垂直方向的可消除的宝石
-(void) findVerticalEliminableJewels:(CCArray*)elimList withJewel:(JewelVo*)source
{
    // 创建一个检查列表
    CCArray *connectedList = [[CCArray alloc] initWithCapacity:10];
    [connectedList addObject:source];
    
    JewelVo *specialJewel;
    
    // 检查特殊宝石
    if (source.special >= kJewelSpecialExplode)
    {
        specialJewel = source;
    }
    
    // 上方检查
    // 获取上方宝石
    JewelVo *upJewel = [self getCellAtCoord:ccp(source.coord.x,source.coord.y+1)].jewelVo;
    while (upJewel!=nil && upJewel.jewelId == source.jewelId)
    {
        // 检查特殊宝石
        if (upJewel.special >= kJewelSpecialExplode)
        {
            if (upJewel == nil || specialJewel.special < upJewel.special)
            {
                specialJewel = upJewel;
            }
        }
        
        // 符合条件,加入检查列表
        [connectedList insertObject:upJewel atIndex:0];
        upJewel = [self getCellAtCoord:ccp(upJewel.coord.x,upJewel.coord.y+1)].jewelVo;
    }
    
    // 检测下方
    JewelVo *downJewel= [self getCellAtCoord:ccp(source.coord.x,source.coord.y - 1)].jewelVo;
    while (downJewel!=nil && downJewel.jewelId == source.jewelId)
    {
        if (downJewel.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.special < downJewel.special)
            {
                specialJewel = downJewel;
            }
        }
        
        // 符合条件,加入检查列表
        [connectedList addObject:downJewel];
        downJewel= [self getCellAtCoord:ccp(downJewel.coord.x,downJewel.coord.y - 1)].jewelVo;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (connectedList.count >= kJewelEliminateMinNeed)
    {
        BOOL isBoo;
        for (JewelVo *connected in connectedList)
        {
            connected.hEliminate = connectedList.count; // 横向消除数量
            if (connected.lt)
            {
                isBoo = YES;
                [self resetEliminateRight:connected];
            }
        }
        
        if (connectedList.count >= kJewelSpecialExplode && isBoo == NO)
        {
            [[connectedList lastObject] setEliminateTop:YES];
        }
        
        // 加入消除列表
        [elimList addObjectsFromArray:connectedList];
    }
    
    [connectedList release];
}

/// 重置上方消除状态
-(void) resetEliminateTop:(JewelVo*)source
{
    // 向上检查
    JewelVo *upJewel = [self getCellAtCoord:ccp(source.coord.x,source.coord.y -1)].jewelVo;
    while(upJewel!=nil && upJewel.jewelId == source.jewelId)
    {
        upJewel.eliminateTop = NO;
        upJewel = [self getCellAtCoord:ccp(upJewel.coord.x,upJewel.coord.y -1)].jewelVo;
    }
    
    
    // 向下检查
    JewelVo *downJewel = [self getCellAtCoord:ccp(source.coord.x,source.coord.y +  1)].jewelVo;
    while (downJewel!=nil && downJewel.jewelId == source.jewelId)
    {
        downJewel.eliminateTop = YES;
        downJewel = [self getCellAtCoord:ccp(downJewel.coord.x,downJewel.coord.y +  1)].jewelVo;
    }
}

/// 重置右侧消除状态
-(void) resetEliminateRight:(JewelVo*)source
{
    // 左边
    JewelVo *leftJewel = [self getCellAtCoord:ccp(source.coord.x-1,source.coord.y)].jewelVo;
    while(leftJewel!=nil && leftJewel.jewelId == source.jewelId)
    {
        leftJewel.eliminateRight = NO;
        leftJewel = [self getCellAtCoord:ccp(leftJewel.coord.x-1,leftJewel.coord.y)].jewelVo;
    }
    
    // 右侧
    JewelVo *rightJewel = [self getCellAtCoord:ccp(source.coord.x+1,source.coord.y)].jewelVo;
    while (rightJewel!=nil && rightJewel.jewelId == source.jewelId)
    {
        rightJewel.eliminateRight = NO;
        rightJewel = [self getCellAtCoord:ccp(rightJewel.coord.x+1,rightJewel.coord.y)].jewelVo;
    }
}



/// 寻找可消除的宝石
-(CCArray*) findPossibleEliminateJewels
{
    if (!boardChangedSinceEvaluation)
    {
        return possibleEliminates;
    }
    
    // 清理
    [possibleEliminates removeAllObjects];
    
    for (int i = 0; i < boardWidth; i++)
    {
        for (int j = 0; j < boardHeight; j++)
        {
            JewelCell *cell = [self getCellAtCoord:ccp(i,j)];
            // 检查是否有宝石
            if (cell.jewelGlobalId==0)
            {
                continue;
            }
            
            // 检查水平方向是否可消除
            CCArray *leftList = [[CCArray alloc] initWithCapacity:5];
            CCArray *middleList = [[CCArray alloc] initWithCapacity:5];
            CCArray *rightList = [[CCArray alloc] initWithCapacity:5];
            
            // 检查水平方向可消除的宝石
            if ([self isHorizontalPossibleEliminateWithJewelVo:cell.jewelVo leftList:leftList middleList:middleList rightList:rightList])
            {
                [possibleEliminates addObjectsFromArray:leftList];
                [possibleEliminates addObjectsFromArray:middleList];
                [possibleEliminates addObjectsFromArray:rightList];
            }
            
            [leftList release];
            [middleList release];
            [rightList release];
            
            // 检查可移动宝石是否已经找到
            if (possibleEliminates.count>0)
            {
                return possibleEliminates;
            }
            
            // 检查垂直方向是否可消除
            // 检查水平方向是否可消除
            CCArray *topList = [[CCArray alloc] initWithCapacity:5];
            middleList = [[CCArray alloc] initWithCapacity:5];
            CCArray *bottomList = [[CCArray alloc] initWithCapacity:5];
            
            // 检查垂直方向可消除的宝石
            if ([self isVerticalPossibleEliminateWithJewelVo:cell.jewelVo topList:topList middleList:middleList bottomList:rightList])
            {
                [possibleEliminates addObjectsFromArray:topList];
                [possibleEliminates addObjectsFromArray:middleList];
                [possibleEliminates addObjectsFromArray:bottomList];
            }
            
            [topList release];
            [middleList release];
            [bottomList release];
            
            // 检查可移动宝石是否已经找到
            if (possibleEliminates.count > 0)
            {
                return possibleEliminates;
            }
        }
    }
    
    // 未找到
    boardChangedSinceEvaluation = NO;
    [possibleEliminates removeAllObjects];
    return possibleEliminates;
}



-(void) updateJewelGridInfo
{
    // 清理
    for (JewelCell *cell in cellGrid)
    {
        cell.jewelGlobalId = 0;
    }
    
    // 设置
    for (JewelVo *jv in boardJewelVoGrid)
    {
        JewelCell *cell = [self getCellAtCoord:jv.coord];
        cell.jewelGlobalId = jv.globalId;
    }
}


@end
