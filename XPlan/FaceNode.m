//
//  FaceItem.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FaceNode.h"
#import "FacePopup.h"

@interface FaceNode()
{
 
}

/// 更新素材
-(void) addSprite;

@end

@implementation FaceNode

@synthesize faceId;

-(id) initWithPopup:(FacePopup *)popup faceId:(NSString *)fId
{
    if ((self = [super init]))
    {
        faceId = [fId retain];
        
        [self addSprite];
    }
    
    return self;
}

-(void) dealloc
{
    [sprite release];
    [faceId release];
    [super dealloc];
}

-(void) onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
    [super onEnter];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}


-(void) addSprite
{
    if (sprite == nil)
    {
        // 加载表情配置文件
        KITProfile *profile = [KITProfile profileWithName:@"face"];
        
        sprite = [[EffectSprite alloc] init];
        
        // 设置表情动画循环播放
        [sprite animate:[profile animationForKey:faceId] tag:-1 repeat:YES restore:NO];
    }
}


#pragma mark -
#pragma mark Touch

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self touchHitsSelf:touch])
    {
        touchInProgress = YES;
        isPressDown = YES;
        [self onPressDown];
        return YES;
    }
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) onPressed
{
    // subclass implementd
}

-(BOOL) touchHitsSelf:(UITouch *)touch
{
    return [self touch:touch hitsNode:self];
}

-(BOOL) touch:(UITouch *)touch hitsNode:(CCNode *)node
{
    CGRect r = CGRectMake(0, 0, node.contentSize.width, node.contentSize.height);
    CGPoint local = [node convertTouchToNodeSpace:touch];
    return CGRectContainsPoint(r, local);
}

@end
