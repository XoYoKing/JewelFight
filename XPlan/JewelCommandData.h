//
//  JewelCommandData.h
//  XPlan
//
//  Created by Hex on 4/21/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "CommandData.h"

@interface JewelCommandData : CommandData
{
    long userId; // 关联用户标识
}

@property (readwrite,nonatomic) long userId;

@end
