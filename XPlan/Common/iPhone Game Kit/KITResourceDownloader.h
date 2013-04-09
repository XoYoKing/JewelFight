//
//  KITServerResourceManager.h
//  NationalInvasion
//
//  Created by Hex on 2/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 服务器端数据下载器
@interface KITResourceDownloader : NSObject
{
    
}

/// 下载服务器端文件
-(void) downloadServerFile:(NSString*)filename;

/// 获取需要下载的服务器端文件数量
-(int) getFileCountToDownload;

/// 获取下载百分比
-(int) getDownloadingPercent;

/// 检查指定文件名是否已经加载
-(BOOL) isLoaded:(NSString*)filename;



@end

// helper class to carry info over to the background thread
@interface AsyncFileDownloadData : NSObject
{
	NSURL* url;
	NSString* localFile;
	int spriteTag;
}
@property (copy) NSURL* url;
@property (copy) NSString* localFile;
@property int spriteTag;
@end
