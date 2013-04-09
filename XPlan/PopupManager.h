//
//  PopupManager.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class PopupWindow;
@interface PopupManager : NSObject
{
    CCScene *scene; // 对话框隶属场景
    NSMutableDictionary *popups; // 窗体集合
    int totalOpenCount; // 窗体打开数量
    int modalOpenCount; // 模态窗体打开数量
}

/// 窗体打开数量
@property (readonly,nonatomic) int totalOpenCount;

/// 模态窗体打开数量
@property (readonly,nonatomic) int modalOpenCount;

@property (readonly,nonatomic) NSMutableDictionary *popups;

+(PopupManager*) sharedManager;

/// 设置所处场景
-(void) setScene:(CCScene*)s;

/// 获取特定对话框
-(PopupWindow*) getPopup:(Class)popupClass;

-(PopupWindow*) getPopup:(Class)popupClass withProperties:(NSDictionary*)properties;

/// 检查给定的对话框是否创建
-(BOOL) isPopupCreated:(Class)popupClass;

/// 释放对话框
-(void) releasePopup:(Class)popupClass;

/// 是否有模态对话框激活
-(BOOL) isModalPopupActive;

/// 是否有任何对话框激活
-(BOOL) isAnyPopupActive;

@end
