//
//  JewelVo.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelVo.h"
#import "JewelController.h"
#import "JewelCell.h"
#import "JewelBoardData.h"

@implementation JewelVo

@synthesize globalId,jewelId,jewelType, special,coord,time,state,yPos,eliminateType,ySpeed;

-(id) init
{
    if ((self = [super init]))
    {
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


-(CCArray*) getActivateEffectJewelGlobalIdsWithJewelController:(JewelController *)controller
{
    CCArray *effectGlobalIds = [CCArray arrayWithCapacity:10];
    
    if (self.special>0)
    {
        switch (self.special)
        {
            case kJewelSpecialExplode:
            {
                //TODO: 获取影响范围不应该放在这块,有代码冗余问题 By Hex 5/5/2013
                
                // 检查水平方向的宝石
                for (int xRemove = 0; xRemove < controller.boardWidth; xRemove++)
                {
                    JewelCell *jc = [controller.boardData getCellAtCoord:ccp(xRemove,self.coord.y)];
                    if (jc.jewelGlobalId>0)
                    {
                        [effectGlobalIds addObject:[NSNumber numberWithInt:jc.jewelGlobalId]];
                    }
                }
                
                // 检查垂直方向的宝石
                for (int yRemove = 0; yRemove < controller.boardHeight; yRemove++)
                {
                    JewelCell *jc = [controller.boardData getCellAtCoord:ccp(self.coord.x,yRemove)];
                    if (jc.jewelGlobalId>0)
                    {
                        [effectGlobalIds addObject:[NSNumber numberWithInt:jc.jewelGlobalId]];
                    }
                }
                
                break;
            }
        }
    }
    else
    {
        [effectGlobalIds addObject:[NSNumber numberWithInt:self.globalId]];
    }
}

@end
