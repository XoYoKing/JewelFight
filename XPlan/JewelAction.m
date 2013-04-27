//
//  JewelAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAction.h"
#import "JewelController.h"
#import "JewelSprite.h"
#import "JewelVo.h"

@implementation JewelAction

-(id) initWithJewelController:(JewelController *)contr name:(NSString*)n
{
    if ((self = [super init]))
    {
        jewelController = contr;
        name = n;
    }
    
    return self;
}

-(void) dealloc
{
    [name release];
    [super dealloc];
}

-(void) start
{
    if (skipped)
    {
        return;
    }
}

-(void)skip
{
    skipped = YES;
}

-(BOOL) isOver
{
    return YES;
}

@end
