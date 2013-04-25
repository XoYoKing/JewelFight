//
//  JewelFactory.h
//  XPlan
//
//  Created by Hex on 4/12/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GemVo.h"
#import "cocos2d.h"

/// 宝石工厂
@interface GemFactory : NSObject
{
    
}


/// 生成随机的宝石
+(GemVo*) randomJewel;

@end
