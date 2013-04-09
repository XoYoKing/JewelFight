//
//  ServerDataEncoder.h
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 服务器端数据编码工具类
@interface ServerDataEncoder : NSObject
{
    NSMutableData *data;
    short byteOrder; //
}

-(id) initWithData:(NSMutableData*)d;

/// 写入布尔值
-(void) writeBoolean:(BOOL)value;

-(void) writeChar:(char)value;

/// 写入char值
-(void) writeInt8:(int8_t)value;

/// 写入short值
-(void) writeInt16:(int16_t)value;

/// 写入整形值
-(void) writeInt32:(int32_t)value;

/// 写入长整值
-(void) writeInt64:(int64_t)value;

/// 写入浮点值
-(void) writeDouble:(double_t)value;

/// 写入文本
-(void) writeUTF:(NSString*)value;

@end
