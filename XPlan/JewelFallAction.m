//
//  JewelDropAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelFallAction.h"
#import "JewelController.h"
#import "JewelBoard.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelCell.h"
#import "JewelEliminateAction.h"
#import "JewelMessageData.h"
#import "GameMessageDispatcher.h"
#import "JewelBoardData.h"
#import "JewelMessageData.h"

@interface JewelFallAction()
{
}

@end

@implementation JewelFallAction

-(id) initWithJewelController:(JewelController *)contr addList:(CCArray *)list
{
    if ((self = [super initWithJewelController:contr name:@"JewelFallAction"]))
    {
        addList = [list retain];
        isFallingJewels = YES;
    }
    
    return self;
}

-(void) dealloc
{
    [addList release];
    [super dealloc];
}

-(void) start
{
    // 检查是否跳过动作
    if (skipped)
    {
        return;
    }
    
    // 宝石面板设置为不可操作
    [jewelController.board setIsControlEnabled:NO];
    
    // 检查下落宝石数量
    if (jewelController.boardData.fallingJewelVos.count==0)
    {
        [self skip];
    }
}

-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    return isFallingJewels == NO;
}

-(void) update:(ccTime)delta
{
    if (skipped)
    {
        return;
    }
    
    JewelBoardData *boardData = jewelController.boardData;
    JewelBoard *board = jewelController.board;
    
    // 按顺序增加下落宝石
    if (addList)
    {
        for (int x = 0; x < jewelController.boardWidth; x++)
        {
            CCArray *column = [addList objectAtIndex:x];
            if (column.count>0)
            {
                if (boardData.numJewelsInColumn[x] + [[boardData.fallingJewelVos objectAtIndex:x] count] < jewelController.boardHeight && boardData.timeSinceAddInColumn[x] >= jewelController.boardWidth)
                {
                    // 自上向下反序获取
                    JewelVo *jv = [column objectAtIndex:0];
                
                    jv.yPos = jewelController.boardHeight;
                    [[boardData.fallingJewelVos objectAtIndex:x] addObject:jv];
                    [board createJewelSpriteWithJewelVo:jv];
                    [column removeObjectAtIndex:0]; // 移除
                    boardData.timeSinceAddInColumn[x] = 0;
                
                }
            }
            
            boardData.timeSinceAddInColumn[x]++;
        }
    }
    
    
    BOOL jewelLanded = NO; // 
    
    // 移动下落的宝石
    for (int x = 0; x < jewelController.boardWidth; x++)
    {
        CCArray *column = [boardData.fallingJewelVos objectAtIndex:x];
        int numFallingJewels = column.count;
        for (int i = numFallingJewels-1; i >= 0; i--)
        {
            JewelVo *jewel = [column objectAtIndex:i];
            
            jewel.ySpeed += 0.06f;
            jewel.ySpeed *= 0.99f;
            jewel.yPos -= jewel.ySpeed;
            
            // 宝石
            if (jewel.yPos <= boardData.numJewelsInColumn[x])
            {
                KITLog(@"numJewelsInColumn %d : amount:%d",x,boardData.numJewelsInColumn[x]);
                
                // 宝石撞击到地面或宝石
                if (!jewelLanded)
                {
                    NSString *soundName = [NSString stringWithFormat:@"tap-%d.wav", (int)CCRANDOM_0_1() * 4];
                    [[KITSound sharedSound] playSound:soundName];
                    
                    jewelLanded = YES;
                }
                    
                // 插入到board
                int y = boardData.numJewelsInColumn[x];
                jewel.coord = ccp(x,y);
                JewelCell *targetCell = [boardData getCellAtCoord:ccp(x,y)];
                
                if (targetCell.jewelGlobalId!=0)
                {
                    KITLog(@"Warning! Overwriting board coord: %d %d",x,y);
                }
                    
                targetCell.jewelGlobalId = jewel.globalId;
                
                // 加入到面板数组中
                [boardData addJewelVo:jewel];
                
                // 从下拉列表中移除已经完成的
                [column removeObjectAtIndex:i];
                
                // Update fixed position
                [jewelController.board getJewelSpriteWithGlobalId:jewel.globalId].position = ccp(x * board.cellSize.width, y * jewelController.board.cellSize.height);
                boardData.numJewelsInColumn[x]++;             
                boardData.boardChangedSinceEvaluation = YES;
            }
            else
            {
                [jewelController.board getJewelSpriteWithGlobalId:jewel.globalId].position = ccp(x * jewelController.board.cellSize.width, jewel.yPos * jewelController.board.cellSize.height);
            }
        }
    }
    
    isFallingJewels = NO; //
    
    // 检查是否还存在下落的宝石
    for (int x = 0; x < jewelController.boardWidth; x++)
    {
        if ([[addList objectAtIndex:x] count] > 0)
        {
            isFallingJewels = YES;
            break;
        }
        else
        {
            if ([[boardData.fallingJewelVos objectAtIndex:x] count] > 0)
            {
                isFallingJewels = YES;
                break;
            }
        }
    }
    
    if (!isFallingJewels)
    {
        [self execute];
    }
}

-(void) execute
{
    [jewelController.boardData updateJewelGridInfo];
    
    // 检查可消除性
    NSMutableArray *connectedGroup = [[NSMutableArray alloc] initWithCapacity:20];
    
    // 检查可消除宝石集合
    [jewelController.boardData findEliminableJewels:connectedGroup];
    
    if (connectedGroup.count>0)
    {
        JewelEliminateAction *elimateAction = [[JewelEliminateAction alloc] initWithJewelController:jewelController connectedGroup:connectedGroup];
        [jewelController queueAction:elimateAction top:NO];
        [elimateAction release];
    }
    
    [connectedGroup release];
    
    if ([jewelController isPlayerControl])
    {
        JewelBoardData *boardData = jewelController.boardData;
        // 检查死局
        // 当宝石为满时,检查死局
        if ([boardData isJewelFull] && [boardData checkDead])
        {
            // 发送死局通知
            JewelMessageData *msg = [[[JewelMessageData alloc] initWithUserId:jewelController.userId] autorelease];
            [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:self message:JEWEL_MESSAGE_DEAD object:msg];
        }
    }
    
    // 宝石面板设置为可操作
    if ([jewelController.boardData isJewelFull])
    {
        [jewelController.board setIsControlEnabled:YES];
    }
    
}


@end
