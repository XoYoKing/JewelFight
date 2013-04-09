//
//  HudBase.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "HudBase.h"
#import "PopupManager.h"
#import "BagWindow.h"
#import "ShopWindow.h"

@implementation HudBase

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

/// 打开背包对话框
-(void) openBagWindow
{
    BagWindow *dialog = (BagWindow*)[[PopupManager sharedManager] getPopup:[BagWindow class]];
    [dialog openWithParent:self.parent isModal:YES];
    [dialog activateWithDoneTarget:self doneCallback:@selector(closeDialog:)];
}

-(void) openShopWindow
{
    
}

-(void) closeDialog:(Class)popupClass
{
    PopupWindow *popup = [[PopupManager sharedManager] getPopup:popupClass];
    [popup close];
    [[PopupManager sharedManager] releasePopup:popupClass];
}

@end
