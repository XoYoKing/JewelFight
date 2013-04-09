//
//  HonsterBar.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
	kBarRounded,
	kBarRectangle,
} kBarTypes;

/// 进度条Bar
@interface HonsterBar : CCNode
{
    NSString *bar, *inset, *mask;
    CCSprite *barSprite, *maskSprite, *insetSprite, *masked;
    CCRenderTexture *renderMasked, *renderMaskNegative;
    kBarTypes type;
    float progress;
    BOOL active, spritesheet;
    CGPoint middle;
}
@property (nonatomic, retain ,readonly)	NSString *bar, *inset;
@property (nonatomic) float progress;
@property kBarTypes type;
@property BOOL active;

+(id) barWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m;
-(id) initBarWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m;
+(id) barWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m;
-(id) initBarWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m;
+(id) barWithBarSprite:(CCSprite *)b insetSprite:(CCSprite *)i maskSprite:(CCSprite *)m;
-(id) initBarWithBarSprite:(CCSprite *)b insetSprite:(CCSprite *)i maskSprite:(CCSprite *)m;
-(void) hide;
-(void) show;
-(void) setTransparency:(float)trans;
-(void) setProgress:(float)lv;
-(void) clearRender;
-(void) maskBar;
-(void) drawLoadingBar;

@end
