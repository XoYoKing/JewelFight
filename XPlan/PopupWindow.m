//
//  PopupWindow.m
//  XPlan
//
//  Created by Hex on 12/1/12.
//
//

#import "PopupWindow.h"

@interface PopupWindow()
{
    
}

-(void) setModal;

@end

@implementation PopupWindow

@synthesize state,isModalWindowOpen;

-(id) initWithProperties:(NSDictionary *)properties
{
    if ((self = [super init]))
    {
    }
    
    return self;
}

-(void) openWithParent:(CCNode *)p isModal:(BOOL)m
{
    if (m)
    {
        [self setModal];
    }
    
    // 从原来窗体移除
    if (self.parent)
    {
        [self removeFromParentAndCleanup:YES];
    }
    
    [p addChild:self z:3];
}

-(void) close
{
    self.state = kPopupStateClosing;
    [self clean];
}

-(void) clean
{
    self.state = kPopupStateUndefined;
    if (self.parent)
    {
        [self.parent removeChild:self];
        self.parent = nil;
    }
}

-(void) setModal
{
    isModalWindowOpen = YES;
    
    // 底层的处理
    
    
}

-(BOOL) isClosed
{
    return self.state == kPopupStateUndefined;
}

@end
