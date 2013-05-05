//
//  ExplodeEliminateEffect.m
//  XPlan
//
//  Created by Hex on 5/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ExplodeEliminateEffectAction.h"
#import "JewelController.h"
#import "JewelBoard.h"
#import "JewelBoardData.h"
#import "JewelVo.h"
#import "JewelSprite.h"
#import "JewelCell.h"


@implementation ExplodeEliminateEffectAction

-(id) initWithJewelController:(JewelController *)contr eliminateAction:(JewelEliminateAction *)a jewel:(JewelVo *)jv
{
    if ((self = [super initWithJewelController:contr eliminateAction:a]))
    {
        actorGlobalId = jv.globalId;
        eliminateDone = NO;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) start
{
    // 检查是否跳过动作
    if (skipped)
    {
        return;
    }
    
    
    timer = 0;
    
    [self activateExplode];
    
}

-(void) activateExplode
{
    // 爆炸效果,获得2000得分
    [jewelController addScore:2000];
    
    JewelBoard *board = jewelController.board;
    JewelBoardData *boardData = jewelController.boardData;
    
    JewelVo *actorVo = [jewelController.boardData getJewelVoByGlobalId:actorGlobalId];
    JewelSprite *actorSprite = [board getJewelSpriteWithGlobalId:actorGlobalId];
    
    if (!actorVo || !actorSprite)
    {
        [self skip];
        return;
    }

    
    // 移除水平方向的宝石
    for (int xRemove = 0; xRemove < board.boardWidth; xRemove++)
    {
        JewelCell *jc = [board getCellAtCoord:ccp(xRemove,actorSprite.coord.y)];
        if (jc.jewelGlobalId>0 && (jc.jewelVo.special==0 || jc.jewelGlobalId == actorVo.globalId))
        {
            [jc.jewelSprite explodeEliminate];
        }
    }
    
    // 移除垂直方向的宝石
    for (int yRemove = 0; yRemove < board.boardHeight; yRemove++)
    {
        JewelCell *jc = [board getCellAtCoord:ccp(actorSprite.coord.x,yRemove)];
        if (jc.jewelGlobalId>0 && (jc.jewelVo.special==0 || jc.jewelGlobalId == actorVo.globalId))
        {
            [jc.jewelSprite explodeEliminate];
        }
    }
    
    // 添加横向粒子效果
    CCParticleSystem *hp = [CCParticleSystemQuad particleWithFile:@"taken_hrow.plist"];
    hp.position = ccp(board.boardWidth/2*board.cellSize.width + board.cellSize.width/2,actorSprite.coord.y*board.cellSize.height + board.cellSize.height/2);
    [hp setAutoRemoveOnFinish:YES];
    [board addParticle:hp];
    
    // 添加纵向粒子效果
    CCParticleSystem *vp = [CCParticleSystemQuad particleWithFile:@"taken_vrow.plist"];
    vp.position = ccp(actorSprite.coord.x*board.cellSize.width + board.cellSize.width/2,board.boardHeight/2*board.cellSize.height + board.cellSize.height/2);
    [vp setAutoRemoveOnFinish:YES];
    [board addParticle:vp];
    
    // 添加爆炸动画
    CGPoint center = ccp(actorSprite.coord.x * board.cellSize.width + board.cellSize.width/2,actorSprite.coord.y * board.cellSize.height + board.cellSize.height/2);
    
    // 水平爆炸
    EffectSprite *effectH0 = [[EffectSprite alloc] initWithFile:@"bomb_explo.png"];
    [effectH0 setBlendFunc:(ccBlendFunc){GL_SRC_ALPHA,GL_ONE}];
    [effectH0 setPosition:center];
    [effectH0 setScaleX:5];
    [effectH0 runAction:[CCScaleTo actionWithDuration:0.5f scaleX:30 scaleY:1]];
    [effectH0 runAction:[CCSequence actions:
                         [CCFadeOut actionWithDuration:0.5f],
                         [CCCallFunc actionWithTarget:effectH0 selector:@selector(removeFromParent)]
                         , nil]];
    [board addEffectSprite:effectH0];
    [effectH0 release];
    
    // 垂直爆炸
    EffectSprite *effectV0 = [[EffectSprite alloc] initWithFile:@"bomb_explo.png"];
    [effectV0 setBlendFunc:(ccBlendFunc){GL_SRC_ALPHA,GL_ONE}];
    [effectV0 setPosition:center];
    [effectV0 setScaleY:5];
    [effectV0 runAction:[CCScaleTo actionWithDuration:0.5f scaleX:1 scaleY:30]];
    [effectV0 runAction:[CCSequence actions:
                         [CCFadeOut actionWithDuration:0.5f],
                         [CCCallFunc actionWithTarget:effectV0 selector:@selector(removeFromParent)]
                         , nil]];
    [board addEffectSprite:effectV0];
    [effectV0 release];
    
    // 水平爆炸
    EffectSprite *effectH1 = [[EffectSprite alloc] initWithFile:@"bomb_explo_inner.png"];
    [effectH1 setBlendFunc:(ccBlendFunc){GL_SRC_ALPHA,GL_ONE}];
    [effectH1 setPosition:center];
    [effectH1 setScaleX:0.5f];
    [effectH1 runAction:[CCScaleTo actionWithDuration:0.5f scaleX:8 scaleY:1]];
    [effectH1 runAction:[CCSequence actions:
                         [CCFadeOut actionWithDuration:0.5f],
                         [CCCallFunc actionWithTarget:effectH1 selector:@selector(removeFromParent)]
                         , nil]];
    [board addEffectSprite:effectH1];
    [effectH1 release];
    
    // 垂直爆炸
    EffectSprite *effectV1 = [[EffectSprite alloc] initWithFile:@"bomb_explo_inner.png"];
    [effectV1 setRotation:90];
    [effectV1 setBlendFunc:(ccBlendFunc){GL_SRC_ALPHA,GL_ONE}];
    [effectV1 setPosition:center];
    [effectV1 setScaleY:0.5f];
    [effectV1 runAction:[CCScaleTo actionWithDuration:0.5f scaleX:8 scaleY:1]];
    [effectV1 runAction:[CCSequence actions:
                         [CCFadeOut actionWithDuration:0.5f],
                         [CCCallFunc actionWithTarget:effectV1 selector:@selector(removeFromParent)]
                         , nil]];
    [board addEffectSprite:effectV1];
    [effectV1 release];
}


-(void) update:(ccTime)delta
{
    if (!skipped)
    {
        timer+=delta;
        if (timer > 0.5f)
        {
            [self execute];
        }
    }
}

-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    return eliminateDone;
}

-(void) execute
{
    eliminateDone = YES;
}

@end
