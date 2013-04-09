//
//  FacePopup.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PopupWindow.h"
#import "CCScrollView.h"

/// 表情弹窗
@interface FacePopup : PopupWindow
{
    CCScrollView *facesView;
}

/// 激活弹窗
-(void) activateWithDoneTarget:(id)t doneCallback:(SEL)s;

@end
