//
//  KITServerResourceManager.m
//  NationalInvasion
//
//  从服务器端下载文件保存到本地设备
//
//  Created by Hex on 2/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "KITResourceDownloader.h"

@implementation AsyncFileDownloadData
@synthesize url, localFile, spriteTag;
-(void) dealloc
{
	[url release];
	[localFile release];
	[super dealloc];
}
@end


@interface KITResourceDownloader()
{
    CCArray *unloadFiles; // 准备下载的文件
    CCArray *loadedFiles; // 已经下载的文件
    int fileCountToDownload; // 准备下载的文件数量
    int totalFileCountToDownload; // 准备下载的文件
}

@end

@implementation KITResourceDownloader

-(id) init
{
    if ((self = [super init]))
    {
        unloadFiles = [[CCArray alloc] initWithCapacity:10];
        loadedFiles = [[CCArray alloc] initWithCapacity:10];
    }
    return self;
}

-(void) dealloc
{
    [unloadFiles release];
    [loadedFiles release];
    [super dealloc];
}

-(NSString*) documentsDirectory
{
	NSString* documentsDirectory = nil;
	NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([pathArray count] > 0)
	{
		documentsDirectory = [pathArray objectAtIndex:0];
	}
	return documentsDirectory;
}

/// 记录错误信息
-(void) logError:(NSError*)error
{
	if (error)
	{
        // 目前只记录到日志记录,考虑记录到设备,并向服务器发送
		KITLog(@"%@: %@", error, [error localizedDescription]);
	}
}

/// 检查是否服务器端有新文件
-(BOOL) isNewerFileOnServer:(NSString*)server filename:(NSString*)filename
{
	BOOL isNewer = YES;
    
    // 本地文件路径
	NSString* localFile = [[self documentsDirectory] stringByAppendingPathComponent:filename];
	NSFileManager* fileManager = [NSFileManager defaultManager];
    
    // 检查本地文件是否存在
	if ([fileManager fileExistsAtPath:localFile])
	{
		// 创建http请求,获取文件信息
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", server, filename]];
		NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
		[request setHTTPMethod:@"HEAD"];
        
		NSHTTPURLResponse* response;
		NSError* error = nil;
        
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // 记录错误
		[self logError:error];
        
		// 
		NSString* httpLastModified = nil;
		if ([response respondsToSelector:@selector(allHeaderFields)])
		{
			httpLastModified = [[response allHeaderFields] objectForKey:@"Last-Modified"];
		}
        
		// setup a date formatter to query the server file's modified date
		NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
		df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
		df.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
		df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        
		// get the file attributes to retrieve the local file's modified date
		NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:localFile error:&error];
		[self logError:error];
        
		// test if the server file's date is later than the local file's date
		NSDate* serverFileDate = [df dateFromString:httpLastModified];
		NSDate* localFileDate = [fileAttributes fileModificationDate];
		isNewer = ([localFileDate laterDate:serverFileDate] == serverFileDate);
	}
    
	return isNewer;
}

/// 从服务器端下载指定文件
-(void) downloadFileFromServerInBackground:(AsyncFileDownloadData*)afd
{
	NSError* error = nil;
	NSData* data = [NSData dataWithContentsOfURL:afd.url options:NSDataReadingMappedIfSafe error:&error];
	[self logError:error];
    
	[data writeToFile:afd.localFile options:NSDataWritingAtomic error:&error];
	[self logError:error];
    
    // 标记下载完成
	[self performSelectorOnMainThread:@selector(completeDownload:) withObject:afd waitUntilDone:NO];
}

-(NSString*) downloadFileFromServer:(NSString*)server filename:(NSString*)filename
{
	NSString* localFile = [[self documentsDirectory] stringByAppendingPathComponent:filename];
    
	// only download the file from web server if it is newer
	if ([self isNewerFileOnServer:server filename:filename])
	{
        // 增加文件下载计数
        fileCountToDownload += 1;
        
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", server, filename]];
        
		KITLog(@"Trying to download newer file from URL: %@", url);
        
        AsyncFileDownloadData* afd = [[[AsyncFileDownloadData alloc] init] autorelease];
        afd.url = url;
        afd.localFile = localFile;
        
        // note: performSelectorInBackground retains afd until task is complete
        [self performSelectorInBackground:@selector(downloadFileFromServerInBackground:) withObject:afd];
		
	}
    
	return localFile;
}


/// 完成下载
-(void) completeDownload:(AsyncFileDownloadData*)afd
{
    // 标记完成下载
    [loadedFiles addObject:afd.url];
    
    // 减少文件加载计数
    fileCountToDownload -= 1;
}


@end
