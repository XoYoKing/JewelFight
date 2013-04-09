//
//  StoneActionQueue.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@interface StoneActionQueue : NSObject
{
    CCArray *actions;
}

@property (readonly,nonatomic) CCArray *actions;


@end
