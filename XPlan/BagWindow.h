//
//  BagWindow.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PopupWindow.h"

/// 背包窗体
@interface BagWindow : PopupWindow
{
    
}

/// 激活
-(void) activateWithDoneTarget:(id)t doneCallback:(SEL)cb;

@end
