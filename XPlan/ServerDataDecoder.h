//
//  ServerDataDecoder.h
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 服务器端数据解码工具类
@interface ServerDataDecoder : NSObject
{
    NSData *data;
    short byteOrder;
    char *startByte;
    char *currentByte; //
}

@property (readonly,nonatomic) NSData *data;

@property (readwrite,nonatomic) char *startByte;

@property (readwrite,nonatomic) char *currentByte;

-(id) initWithData:(NSData*)d;

-(char) readByte;

// 读取 Double 值, 8 bytes (64-bit IEEE 754 floating point)
- (double)readDouble;

// 读取布尔值
- (BOOL)readBoolean;

- (int16_t)readInt16;

// 读取整形数
- (int32_t)readInt32;

// 读取长整形
- (int64_t)readInt64;

// Read a UTF-8 String
- (NSString*)readUTF;

@end
