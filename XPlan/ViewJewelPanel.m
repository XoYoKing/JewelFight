//
//  ViewJewelPanel.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ViewJewelPanel.h"
#import "CCBReader.h"

@interface ViewJewelPanel()

-(void) initUI;

@end

@implementation ViewJewelPanel

-(id) init
{
    if ((self = [super init]))
    {
        
        [self initUI];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) initUI
{
    CCNode *node = [CCBReader nodeGraphFromFile:@"fight_jewel_view_panel.ccbi" owner:self];
    [self addChild:node];
}

@end
