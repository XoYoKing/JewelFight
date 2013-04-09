//
//  CommandListener.h
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommandListener

/// 接收服务器响应
-(void) responseWithActionId:(int)actionId object:(id)obj;

@end
