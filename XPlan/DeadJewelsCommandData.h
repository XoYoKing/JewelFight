//
//  DeadJewelsCommandData.h
//  XPlan
//
//  Created by Hex on 4/21/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelCommandData.h"

@interface DeadJewelsCommandData : JewelCommandData
{
    CCArray *jewelVoList; // 宝石信息集合
}

@property (readwrite,nonatomic,retain) CCArray *jewelVoList;

@end
