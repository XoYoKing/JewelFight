//
//  JewelArea.h
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class GemBoard,GemCell;
@interface JewelArea : NSObject

+(void) getAreaCellsAroundCell:(CCArray*)areaTiles panel:(GemBoard*)panel cell:(GemCell*)cell radius:(int)radius;


@end
