//
//  NewJewelsCommandData.h
//  XPlan
//
//  Created by Hex on 4/18/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 新宝石命令数据
@interface NewJewelsCommandData : NSObject
{
    long userId; // 隶属用户标识
    CCArray *jewelVoList; // 宝石信息集合
}

@property (readwrite,nonatomic) long userId;

@property (readwrite,nonatomic,retain) CCArray *jewelVoList;

@end
