//
//  FaceItem.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"

@class FacePopup;

/// 表情
@interface FaceNode : CCNode<CCTouchOneByOneDelegate>
{
    NSString *faceId; // 头像标识
    EffectSprite *sprite; //
    FacePopup *facePopup; // 隶属对话框

}

/// 表情标识
@property (readonly,nonatomic) NSString *faceId;

/// 初始化
-(id) initWithPopup:(FacePopup*)popup faceId:(NSString*)fId;

@end
