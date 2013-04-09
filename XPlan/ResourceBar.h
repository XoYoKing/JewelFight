//
//  MoneyBar.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class UserInfo;

/// 资源条
@interface ResourceBar : CCNode
{
    UserInfo *userVo; // 用户数据对象
    CCLabelBMFont *silverTxt; // 银币数量
    CCLabelBMFont *goldTxt; // 金币数量
    CCLabelBMFont *diamondTxt; // 钻石数量
}

/// 初始化
-(id) initWithUserVo:(UserInfo*)uv;

@end
