//
//  FacePopup.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FacePopup.h"
#import "CCBReader.h"
#import "FaceItem.h"

@interface FacePopup()
{
    id doneTarget; // 完成目标
    SEL doneCallback; //完成回调
}
-(void) loadArt;

@end

@implementation FacePopup

-(id) initWithProperties:(NSDictionary *)properties
{
    if ((self = [super initWithProperties:properties]))
    {
        [self loadArt];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) activateWithDoneTarget:(id)t doneCallback:(SEL)s
{
    doneTarget = t;
    doneCallback = s;
    
    // 显示
}

-(void) loadArt
{
    CCNode *popNode = [CCBReader nodeGraphFromFile:@"popup_face.ccbi" owner:self];
    [self addChild:popNode];
    
    // 添加表情列表
    
    // 添加容器
    CCLayer *container = [[CCLayer alloc] init];
    [facesView setContainer:container];
    
    // 4行7列
    int rows = 4;
    int columns = 7;
    int faceWidth = [KITApp scale:25];
    int padding = [KITApp scale:8];
    for (int i =0; i< rows;i++)
    {
        for (int j=0; j<columns; j++)
        {
            // 生成表情标识
            NSString *faceId = [NSString stringWithFormat:@"%d%d",i,j];
            
            // 创建表情节点
            FaceItem *node = [[FaceItem alloc] initWithFaceId:faceId];
            node.position = ccp(j*faceWidth + padding, i * faceWidth + padding);
            [container addChild:node];
            [node release];
            
        }
    }
    
    
    [container release];
    
    
    
}

@end
