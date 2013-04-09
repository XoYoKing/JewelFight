//
//  UserPortrait.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class UserInfo;

@interface UserPortrait : CCNode
{
    int hp; // 生命值
    int maxHp; // 最大生命值
    
    UserInfo *userVo; // 对应用户数据对象
}

/// 用户数据对象
@property (readonly,nonatomic) UserInfo *userVo;

/// 初始化
-(id) initWithUserVo:(UserInfo*)uv;



@end
