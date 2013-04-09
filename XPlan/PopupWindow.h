//
//  DialogWindow.h
//  XPlan
//
//  Created by Hex on 12/1/12.
//
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

#define kPopupStateUndefined 0 // 未定义
#define kPopupStateOpening 1 // 正在打开
#define kPopupStateReady 2 // 打开完成
#define kPopupStateClosing 3 // 正在关闭

@interface PopupWindow : CCLayer
{
    int state; // 对话框状态
    BOOL isModalWindowOpen; // 是否打开了模态对话框
}

/// 状态
@property (readwrite,nonatomic) int state;

/// 是否打开了模态对话框
@property (readonly,nonatomic) BOOL isModalWindowOpen;

/// 初始化
-(id) initWithProperties:(NSDictionary*)properties;

/// 打开窗体
-(void) openWithParent:(CCNode*)p isModal:(BOOL)m;

/// 关闭窗体
-(void) close;

/// 清理
-(void) clean;

/// 判断是否已经关闭
-(BOOL) isClosed;

@end
