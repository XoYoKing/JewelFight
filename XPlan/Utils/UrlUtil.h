//
//  UrlUtil.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Url工具类
@interface UrlUtil : NSObject
{
    NSString *basePath; // 基本路径
    int version; // 当前版本
}

/// 单例
+(UrlUtil*) sharedUtil;

@end
