//
//  JewelArea.h
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class JewelBoard,JewelCell;
@interface JewelArea : NSObject

+(void) getAreaCellsAroundCell:(CCArray*)areaTiles panel:(JewelBoard*)panel cell:(JewelCell*)cell radius:(int)radius;


@end
