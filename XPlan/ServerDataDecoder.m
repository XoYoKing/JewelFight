//
//  ServerDataDecoder.m
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ServerDataDecoder.h"

@interface ServerDataDecoder()
{

}
@end

@implementation ServerDataDecoder

@synthesize data,currentByte,startByte;

-(id) initWithData:(NSData *)d
{
    startByte = (char*)[d bytes];
    
    // 空数据,返回错误
    if (!startByte)
    {
        return nil;
    }
    
    if ((self = [super init]))
    {
        data = [d retain];
        currentByte = startByte;
    }
    
    return self;
}

-(void) dealloc
{
    [data release];
    [super dealloc];
}

-(char) readByte
{
    char c;
    memcpy(&c, self.currentByte, sizeof(char));
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + sizeof(char);
    return c;
}

// 读取 Double 值, 8 bytes (64-bit IEEE 754 floating point)
- (double_t)readDouble
{
    double_t double64;
    memcpy(&double64, self.currentByte, sizeof(double_t));
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + sizeof(double_t);
    return double64;
}

// 读取布尔值
- (BOOL)readBoolean
{
    Byte value = *self.currentByte;
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + sizeof(Byte);
    
    if (value == 0x00)
    {
        return YES;
    }
    else if (value == 0x01)
    {
        return NO;
    }
    else
    {
        return NO;
    }
}

- (int8_t)readInt8
{
    int8_t int8;
    memcpy(&int8, self.currentByte, sizeof(int8_t));
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + sizeof(int8_t);
    return int8;
}

- (int16_t)readInt16
{
    int16_t int16;
    memcpy(&int16, self.currentByte, sizeof(int16_t));
    int16 = CFSwapInt16BigToHost(int16);
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + sizeof(int16_t);
    return int16;
}

// 读取整形数
- (int32_t)readInt32
{
    int32_t int32;
    memcpy(&int32, self.currentByte, sizeof(int32_t));
    int32 = CFSwapInt32BigToHost(int32);
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + sizeof(int32_t);
    return int32;
}

// 读取长整形
- (int64_t)readInt64
{
    int64_t int64;
    memcpy(&int64, self.currentByte, sizeof(int64_t));
    int64 = CFSwapInt64BigToHost(int64);
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + sizeof(int64_t);
    return int64;
}

// Read a UTF-8 String
- (NSString*)readUTF
{
    
    // The first 4 bytes (int32) contains the total length of the string (including the 0x00 end char)
    int32_t length = [self readInt32];
    
    // Read the string
    NSString *string = [[[NSString alloc] initWithBytes:self.currentByte
                                                 length:length
                                               encoding:NSUTF8StringEncoding] autorelease];
    
    // Move the current byte pointer forward
    self.currentByte = self.currentByte + length;
    
    return string;
}

@end
