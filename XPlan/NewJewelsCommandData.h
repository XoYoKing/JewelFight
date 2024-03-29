//
//  NewJewelsCommandData.h
//  XPlan
//
//  Created by Hex on 4/18/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelCommandData.h"

/// 新宝石命令数据
@interface NewJewelsCommandData : JewelCommandData
{
    CCArray *jewelVoList; // 宝石信息集合
}


@property (readwrite,nonatomic,retain) CCArray *jewelVoList;

@end
