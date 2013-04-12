//
//  StoneFactory.h
//  XPlan
//
//  Created by Hex on 4/12/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JewelVo.h"
#import "cocos2d.h"

/// 宝石工厂
@interface JewelFactory : NSObject
{
    
}


/// 生成随机的宝石
+(JewelVo*) randomStone;

@end
