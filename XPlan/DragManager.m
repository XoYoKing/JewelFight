//
//  DragManager.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "DragManager.h"

static DragManager *_dragManagerInstance = nil;

@interface DragManager()
{
    CGPoint _touchPoint; // 触摸点
    float _touchLength; // 触摸长度
    CCArray *_touches; // 触摸点集合
    BOOL _touchMoved;
    BOOL _isDragging; // 是否正在拖放
}

@end

@implementation DragManager

#pragma mark -
#pragma mark Class methods

+(DragManager*) sharedManager
{
    @synchronized([DragManager class])
    {
        if (!_dragManagerInstance)
        {
            _dragManagerInstance = [[self alloc] init];
        }
    }
    
    return _dragManagerInstance;
}

+(id) alloc
{
    @synchronized([DragManager class])
    {
        KITAssert(popupInstance == nil, @"There can only be one DragManager singleton");
        return [super alloc];
    }
    return nil;
}

-(void) doDragWithInitiator:(CCNode *)initiator dataSource:(id)ds proxy:(CCNode *)p
{
    // 检查是否正在拖放
    if (_isDragging)
    {
        return;
    }
    
    _isDragging = YES; // 正在拖放
    dataSource = ds; // 对应数据类
    dragIntiator = initiator; // 拖放目标
    dragProxy = p; // 拖放代理
    
    // 
    dragProxy.visible = NO;
}

#pragma mark -
#pragma mark Touch

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:100 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if ([_touches containsObject:touch])
    {
        if ([_touches count] == 1 && _isDragging)
        {
            // mark touch is moving
            _touchMoved = YES;
            
            CGPoint moveDistance, newPoint;
            
            // 获取新坐标点
            newPoint = [[_touches objectAtIndex:0] locationInGL];
            
            // 计算移动距离
            moveDistance = ccpSub(_touchPoint,newPoint);
            
            // 记录新坐标点
            _touchPoint = newPoint;
            
            // 移动一定距离
            HomeLayer *bl = (HomeLayer*)[self getWorldLayer];
            CGPoint moveTo = ccpAdd(ccpAdd([bl getCameraPosition],[bl cameraMin]), moveDistance);
            [bl moveCamera:moveTo];
            
        }
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([_touches containsObject:touch])
    {
        [_touches removeObject:touch];
    }
    
    if ([_touches count] == 0)
    {
        _isDragging = NO;
        _touchMoved = NO;
    }
    
    // Try get the battle object under coord
    HomeLayer *bl = [self getHomeLayer];
    [bl.field touchClicked:[bl touchToGamePoint:touch]];
    
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_touches removeObject:touch];
    if ([_touches count] == 0)
    {
        _isDragging = NO;
        _touchMoved = NO;
    }
}

/// 检测是否触摸了指定节点
-(BOOL) touch:(UITouch*)touch hitsNode:(CCNode*)node
{
    CGRect r= CGRectMake(0,0, node.contentSize.width,node.contentSize.height);
    CGPoint local = [node convertTouchToNodeSpace:touch];
    return CGRectContainsPoint(r,local);
}


@end
