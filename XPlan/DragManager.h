//
//  DragManager.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 拖放管理器
@interface DragManager : NSObject<CCTouchOneByOneDelegate>
{
    CCNode *dragIntiator; // 拖动目标
    id dataSource; // 拖动目标的数据源
    CCNode *dragProxy; // 代理,跟随鼠标的图标
    
    id dropDoneTarget; // 拖动后的处理函数执行体
    SEL dropDoneCallback; // 拖动后的处理函数
}

/// 单例
+(DragManager*)sharedManager;

/// 开始拖放物体
-(void) doDragWithInitiator:(CCNode*)initiator dataSource:(id)ds proxy:(CCNode*)p;

@end
