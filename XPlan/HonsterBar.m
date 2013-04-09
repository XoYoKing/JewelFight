//
//  HonsterBar.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "HonsterBar.h"


@implementation HonsterBar
@synthesize bar, inset, type, active, progress;

+(id) barWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m
{
    return [[[self alloc] initBarWithBar:b inset:i mask:m] autorelease];
}
-(id) initBarWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m
{
    if ((self = [super init]))
    {
        bar = [[NSString alloc] initWithString:b];
        inset = [[NSString alloc] initWithString:i];
        mask = [[NSString alloc] initWithString:m];
        spritesheet = NO;
        
        insetSprite = [[CCSprite alloc] initWithFile:inset];
        [self setContentSize:insetSprite.contentSize];
        middle = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.5f);
        
        insetSprite.anchorPoint = ccp(0.5,0.5);
        insetSprite.position = middle;
        [self addChild:insetSprite z:1];
        
        barSprite = [[CCSprite alloc] initWithFile:bar];
        barSprite.anchorPoint = ccp(0.5,0.5);
        barSprite.position = middle;
		
		
        maskSprite = [[CCSprite alloc] initWithFile:mask];
        maskSprite.anchorPoint = ccp(1,0.5);
        maskSprite.position = middle;
        
        renderMasked = [[CCRenderTexture alloc] initWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMasked sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMasked.position = barSprite.position;
        renderMaskNegative = [[CCRenderTexture alloc] initWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMaskNegative sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMaskNegative.position = barSprite.position;
        
        [maskSprite setBlendFunc: (ccBlendFunc) {GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
        [maskSprite retain];
        
        [self clearRender];
        
        [self maskBar];
        
        [self addChild:renderMasked z:2];
    }
    return self;
}

+(id) barWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m {
    return [[[self alloc] initBarWithBarFrame:b insetFrame:i maskFrame:m] autorelease];
}
-(id) initBarWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m {
    if ((self = [super init])) {
        bar = [[NSString alloc] initWithString:b];
        inset = [[NSString alloc] initWithString:i];
        mask = [[NSString alloc] initWithString:m];
        spritesheet = YES;

        insetSprite = [[CCSprite alloc] initWithSpriteFrameName:inset];
        [self setContentSize:insetSprite.contentSize];
        middle = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.5f);
        insetSprite.anchorPoint = ccp(0.5,0.5);
        insetSprite.position = middle;
        [self addChild:insetSprite z:1];
        
        barSprite = [[CCSprite alloc] initWithSpriteFrameName:bar];
        barSprite.anchorPoint = ccp(0.5,0.5);
        barSprite.position = middle;
		
		
        maskSprite = [[CCSprite alloc] initWithSpriteFrameName:mask];
        maskSprite.anchorPoint = ccp(1,0.5);
        maskSprite.position = middle;
        
        renderMasked = [[CCRenderTexture alloc] initWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMasked sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMasked.position = barSprite.position;
        renderMaskNegative = [[CCRenderTexture alloc] initWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMaskNegative sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMaskNegative.position = barSprite.position;
        
        [maskSprite setBlendFunc: (ccBlendFunc) {GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
        [maskSprite retain];
        
        [self clearRender];
        
        [self maskBar];
        
        [self addChild:renderMasked z:2];
    }
    return self;
}

+(id) barWithBarSprite:(CCSprite *)b insetSprite:(CCSprite *)i maskSprite:(CCSprite *)m {
    return [[[self alloc] initBarWithBarSprite:b insetSprite:i maskSprite:m] autorelease];
}
-(id) initBarWithBarSprite:(CCSprite *)b insetSprite:(CCSprite *)i maskSprite:(CCSprite *)m {
    if ((self = [super init])) {
        
        insetSprite = [i retain];
        [i removeFromParentAndCleanup:YES];
        [self setContentSize:insetSprite.contentSize];
        middle = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.5f);
        insetSprite.anchorPoint = ccp(0.5,0.5);
        insetSprite.position = middle;
        [self addChild:insetSprite z:1];
        
        barSprite = [b retain];
        [b removeFromParentAndCleanup:YES];
        barSprite.anchorPoint = ccp(0.5,0.5);
        barSprite.position = middle;
		

		
        maskSprite = [m retain];
        [m removeFromParentAndCleanup:YES];
        maskSprite.anchorPoint = ccp(1,0.5);
        maskSprite.position = middle;
        
        renderMasked = [[CCRenderTexture alloc] initWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMasked sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMasked.position = barSprite.position;
        renderMaskNegative = [[CCRenderTexture alloc] initWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMaskNegative sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMaskNegative.position = barSprite.position;
        
        [maskSprite setBlendFunc: (ccBlendFunc) {GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
        [maskSprite retain];
        
        [self clearRender];
        
        [self maskBar];
        
        [self addChild:renderMasked z:2];
    }
    return self;
}

-(void) clearRender {
    [renderMasked beginWithClear:0.0f g:0.0f b:0.0f a:0.0f];
    
    [barSprite visit];
    
    [renderMasked end];
    
    [renderMaskNegative beginWithClear:0.0f g:0.0f b:0.0f a:0.0f];
    
    [barSprite visit];
    
    [renderMaskNegative end];
}
-(void) maskBar {
    [renderMaskNegative begin];
    
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    [maskSprite visit];
    
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [renderMaskNegative end];
    
    masked = renderMaskNegative.sprite;
    masked.position = middle;
    
    [masked setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [masked retain];
    
    [renderMasked begin];
    
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    [masked visit];
    
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [renderMasked end];
}
-(void) setProgress:(float)lp {
    progress = lp;
    [self drawLoadingBar];
}
-(void) drawLoadingBar {
    maskSprite.position = ccp(((self.contentSize.width - maskSprite.boundingBox.size.width) / 2) + (progress / 100 * maskSprite.boundingBox.size.width), middle.y);
    [self clearRender];
    [self maskBar];
}
-(void) show {
	active = YES;
}
-(void) hide {
	active = NO;
}
-(void) setTransparency:(float)trans {
	if (trans > 0 && trans <= 255) {
		active = YES;
	}
	else if (trans < 0) {
		NSLog(@"Transparency must be greater than or equal 0.");
	}
	else if (trans == 0) {
		
	}
	else if (trans > 255) {
		NSLog(@"Transparency must be less than or equal to 255.");
	}
	barSprite.opacity = trans;
	insetSprite.opacity = trans;
	maskSprite.opacity = trans;
}
-(void)dealloc{
    [masked release];
    [renderMasked release];
    [renderMaskNegative release];
    [maskSprite release];
    [barSprite release];
    [insetSprite release];
    [mask release];
    [bar release];
    [inset release];
    [super dealloc];
}

@end
