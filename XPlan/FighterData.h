//
//  FighterData.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 战士数据
@interface FighterData : NSObject
{
    NSDictionary *attributes; // 属性
}


/// 加载数据
-(void) load:(NSDictionary*)data;

/// 保存数据
-(void) save:(NSMutableDictionary*)data;

@end
