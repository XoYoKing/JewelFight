//
//  ServerDataEncoder.m
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ServerDataEncoder.h"

@implementation ServerDataEncoder

-(id) initWithData:(NSMutableData*)d
{
    if ((self = [super init]))
    {
        data = d;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) writeBoolean:(BOOL)value
{
    [data appendBytes:&value length:sizeof(BOOL)];
}

-(void) writeChar:(char)value
{
    [data appendBytes:&value length:sizeof(char)];
}

-(void) writeInt8:(int8_t)value
{
    [data appendBytes:&value length:sizeof(int8_t)];
}

-(void) writeInt16:(int16_t)value
{
    int16_t new = CFSwapInt16HostToBig(value);
    [data appendBytes:&new length:sizeof(int16_t)];
}

-(void) writeInt32:(int32_t)value
{
    int32_t new = CFSwapInt32HostToBig(value);
    [data appendBytes:&new length:sizeof(int32_t)];
}

-(void) writeInt64:(int64_t)value
{
    int64_t new = CFSwapInt64HostToBig(value);
    [data appendBytes:&new length:sizeof(int64_t)];
}

-(void) writeDouble:(double_t)value
{
    [data appendBytes:&value length:sizeof(double_t)];
}

-(void) writeUTF:(NSString*)value
{
    NSData *utf8Data = [value dataUsingEncoding:NSUTF8StringEncoding];
    uint32_t length = CFSwapInt32HostToBig([utf8Data length] + 1);
    [data appendBytes:&length length:4];
    [data appendData:utf8Data];
    [data appendBytes:"\x00" length:1];
}

@end
