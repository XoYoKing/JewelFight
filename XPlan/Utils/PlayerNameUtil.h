//
//  PlayerNameUtil.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 随机用户名
@interface PlayerNameUtil : NSObject
{
    NSArray *surnameList;
    NSArray *man0;
    NSArray *man1;
    NSArray *woman0;
    NSArray *woman1;
}

/// 获取单例
+(PlayerNameUtil*) sharedNameUtil;

/// 获取随机名称
-(NSString*) getRandomName:(BOOL)isMale;

@end
