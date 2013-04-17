//
//  MessageDispatcherListener.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 消息接收器
@protocol GameMessageListener

/// 接收消息响应
-(void) handleMessageWithSender:(id)sender messageId:(int)messageId object:(id)obj;

@end

