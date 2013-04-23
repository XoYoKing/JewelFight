//
//  TextEffect.m
//  XPlan
//
//  Created by Hex on 4/23/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightTextEffect.h"

@interface FightTextEffect()
{
    
    NSString *text;
    NSString *textFieldName;
    int type;
}

@end

@implementation FightTextEffect

-(id) initWithType:(int)ty text:(NSString *)te pos:(CGPoint)_pos
{
    if ((self = [super init]))
    {
        text = [te retain];
        type = ty;
    }
    
    return self;
}

-(void) dealloc
{
    [text release];
    [super dealloc];
}

-(void) start
{
    // 添加文本label
    CCLabelBMFont *textLabel = [[CCLabelBMFont alloc] initWithString:text fntFile:@"Font_silver_size17.fnt"];
    textLabel.anchorPoint = ccp(0.0f,0.5f);
    [self addChild:textLabel z:1];
    [textLabel release];
    
    if (type == kTextEffectTypeBonus)
    {
        self.scale = 2;
    }
    
    self.opacity = 0.0f; // hide
    
    switch (type)
    {
        case kTextEffectTypeLoss:
        {
            [self runAction:[CCSequence actions:
                             [CCSpawn actions:
                              [CCFadeIn actionWithDuration:0.5f],
                              [CCMoveBy actionWithDuration:1.0f position:ccp(0,3.4f)],
                              nil],
                             [CCSpawn actions:
                              [CCFadeOut actionWithDuration:0.5f],
                              [CCMoveBy actionWithDuration:0.5f position:ccp(0,25.0f)],
                              nil],
                             [CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)],
                             nil]];
            
            break;
        }
        case kTextEffectTypeGain:
        case kTextEffectTypeBonus:
        {
            [self runAction:[CCSequence actions:
                             [CCSpawn actions:
                              [CCFadeIn actionWithDuration:0.5f],
                              [CCMoveBy actionWithDuration:1.0f position:ccp(0,3.4f)],
                              nil],
                             [CCSpawn actions:
                              [CCFadeOut actionWithDuration:0.5f],
                              [CCMoveBy actionWithDuration:0.5f position:ccp(0,25.0f)],
                              nil],
                             [CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)],
                             nil]];
            
            break;
        }
    }
}

-(void) scaleIcon:(CCSprite *)_icon
{
    
}

@end
