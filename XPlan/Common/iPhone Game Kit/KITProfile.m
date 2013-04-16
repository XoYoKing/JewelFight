//
//  KitProfile.m
//  NationalInvasion
//
//  Created by Hex on 1/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "KITProfile.h"


// cache and re-use profiles here
// (speeds up loading by about 0.06s per re-used item on a 3gs)
static NSMutableDictionary* profiles = nil;

@interface KITProfile()
{
}

-(void) loadSpritesheets:(NSArray*)spritesheets;
-(NSMutableArray*) loadSpriteFramesForKey:(NSString*)key dict:(NSDictionary*)dict;
-(CCAnimation*) loadAnimationForKey:(NSString*)key dict:(NSDictionary*)dict;
-(void) loadSounds:(NSArray*)ra;
-(NSString*) getSoundForKey:(NSString*)key;

@end

@implementation KITProfile

+(KITProfile*) profileWithName:(NSString *)name
{
    // auto-create the profiles cache
    if( profiles == nil )
        profiles = [[NSMutableDictionary alloc] init];
    
    // see if this item exists already
    KITProfile* profile = [profiles objectForKey:name];
    if( profile == nil )
    {
        @try
        {
            KITLog(@"KITProfile: loading %@", name);
            
            
            // load item dictionary
            NSString* filename = [[NSString alloc] initWithFormat:@"%@.plist",name];
            NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:filename]];
            BOOL isValid = ([config count] > 0);
            
            if( isValid )
            {
                // create the item & save for re-use
                profile = [[KITProfile alloc] initWithProfileName:name config:config];
                if( profile != nil )
                    [profiles setObject:profile forKey:name];
                [profile release]; // ok because setObject retains
            
                // re-get it from cache (avoids using autorelease & potential memory leaks)
                profile = [profiles objectForKey:name];
            }
            [config release];
            [filename release];
        }
        @catch(NSException* exception)
        {
            KITLog(@"resourceWithName exception: %@: %@", [exception name], [exception reason]);
        }
    }
    
    return profile;
}

+(void) purge
{
    [profiles release];
    profiles = nil;
}

#pragma mark -
#pragma mark Attributes

-(NSArray*) allAttributeKeys
{
    return [[configDict objectForKey:@"attributes"] allKeys];
}

-(id) attributeForKey:(NSString*)key
{
    return [[configDict objectForKey:@"attributes"] objectForKey:key];
}

-(NSString*) literalForKey:(NSString*)key
{
    return [[configDict objectForKey:@"literals"] objectForKey:key];
}

#pragma mark -
#pragma mark Sprite frames

-(CCSpriteFrame*) spriteFrameForKey:(NSString*)key
{
    return [self spriteFrameForKey:key index:0];
}

-(CCSpriteFrame*) spriteFrameForKey:(NSString*)key index:(int)index
{
    NSDictionary *spriteFrameDict = [[configDict objectForKey:@"sprites"] objectForKey:key];
    
    // 加载可能需要的spritesheet
    NSArray *spritesheets = [spriteFrameDict objectForKey:@"spritesheets"];
    [self loadSpritesheets:spritesheets];
    
    // 加载sprites
    NSMutableArray *spriteFrames = [self loadSpriteFramesForKey:key dict:spriteFrameDict];
    
    // 获取指定SpriteFrame
    CCSpriteFrame* spriteFrame = [spriteFrames objectAtIndex:index];
    return spriteFrame;
}

#pragma mark -
#pragma mark Animations

-(CCAnimation*) animationForKey:(NSString*)key
{
    // 获取动画指定字典
    NSDictionary *animDict = [[configDict objectForKey:@"animations"] objectForKey:key];
    KITAssert2(animDict != nil, @"Called %@'s animationForKey: when object at key '%@' is not Dictionary. Check item.plist", name, key);
    
    // 加载指定spriteshet
    [self loadSpritesheets:[animDict objectForKey:@"spritesheets"]];
    
    // 加载动画
    return [self loadAnimationForKey:key dict:animDict];
}

-(CCAnimation*) animationForKey:(NSString *)key index:(int)index
{
    // 获取动画指定字典
    NSDictionary *animDict = [[configDict objectForKey:@"animations"] objectForKey:key];
    KITAssert2(animDict != nil, @"Called %@'s animationForKey: when object at key '%@' is not Dictionary. Check item.plist", name, key);
    
    // 加载指定spriteshet
    [self loadSpritesheets:[animDict objectForKey:@"spritesheets"]];
    
    // 加载动画
    return [self loadAnimationForKey:key dict:animDict index:index];
}

-(BOOL) hasAnimation:(NSString*)key
{
    return [[configDict objectForKey:@"animations"] objectForKey:key] != nil;
}

#pragma mark -
#pragma mark Sounds

-(void) playSound:(NSString*)key
{
    [self playSound:key volume:1.0f pan:1.0f pitch:1.0f solo:NO];
}

-(void) playSound:(NSString*)key distanceSQ:(float)distanceSQ
{
    NSString* fname = [self getSoundForKey:key];
    if( fname != nil )
    {
        currentSound = [[KITSound sharedSound] playSound:fname distanceSQ:distanceSQ];
    }
}

-(void) playSound:(NSString*)key volume:(float)volume pan:(float)pan pitch:(float)pitch solo:(BOOL)solo
{
    // get the entry associated with this key
    NSString* fname = [self getSoundForKey:key];
    if( fname != nil )
    {
        // stop old effect
        if( solo && currentSound != CD_MUTE )
            [[KITSound sharedSound] stopSound:currentSound];
        
        // play the effect
        currentSound = [[KITSound sharedSound] playSound:fname volume:volume pan:pan pitch:pitch loop:NO group:kSoundGroupMultiple];
    }
}

-(void) playSoundSolo:(NSString*)key
{
    [self playSound:key volume:1.0f pan:1.0f pitch:1.0f solo:YES];
}

#pragma mark -
#pragma mark Instance methods

-(id) initWithProfileName:(NSString *)n config:(NSDictionary *)_config
{
    if((self = [super init]))
    {
        currentSound = CD_MUTE;
        name = [n retain];
        configDict = [_config retain];
        // load the sound effects
        [self loadSounds:[[configDict objectForKey:@"sounds"] allValues]];
    }
    return self;
}

-(void) dealloc
{
    [name release];
    [configDict release];
    [super dealloc];
}

-(void) loadSpritesheets:(NSArray*)spritesheets
{
    // 检查
    if (spritesheets == nil || spritesheets.count == 0)
    {
        return;
    }
    
    @try
    {
        // load each spritesheet
        CCSpriteFrameCache* cacher = [CCSpriteFrameCache sharedSpriteFrameCache];
        for(NSString* sheet in spritesheets)
        {
            KITAssert1([KITApp resourceExists:sheet], @"The spritesheet '%@' must exist in resources", sheet);
            [cacher addSpriteFramesWithFile:sheet];
        }
    }
    @catch (NSException* exception)
    {
        KITLog(@"loadSpritesheets exception: %@: %@", [exception name], [exception reason]);
    }
}

-(NSMutableArray*) loadSpriteFramesForKey:(NSString*)key dict:(NSDictionary*)dict
{
    NSString *format = [dict valueForKey:@"format"];
    int frameCount = [[dict valueForKey:@"frameCount"] intValue];
    
    // assertions
    KITAssert2(frameCount >= 1, @"The number 'sprites.%@.frameCount' is required in the plist for: %@", key, name);
    KITAssert2([format length] >= 1, @"The string 'sprites.%@.format' is required in the plist for: %@", key, name);
    
    // create sprite frame array
    KITSpriteFrameArray* spriteFrames = [[KITSpriteFrameArray alloc] initWithFormat:format subString:nil frameCount:frameCount];
    NSMutableArray *frames = [[[NSMutableArray alloc] initWithArray:spriteFrames.array] autorelease];
    [spriteFrames release]; // ok because spriteFrames retain
    return frames;
}

-(CCAnimation*) loadAnimationForKey:(NSString*)key dict:(NSDictionary*)dict
{
    // get the details for this animation
    NSString* format = [dict valueForKey:@"format"];
    
    int frameCount = [[dict valueForKey:@"frameCount"] intValue];
    
    float delay = [[dict valueForKey:@"delay"] floatValue];
    delay = (delay == 0.0f ? 0.05f : clampf(delay, 0.01f, 0.33f));
    KITLog(@"Item: loading animation %@, format %@, frameCount %d, delay %.2f", key, format, frameCount, delay);
    
    // assertions
    KITAssert2(frameCount >= 1, @"The number 'animations.%@.frameCount' is required in the plist for: %@", key, name);
    KITAssert2([format length] >= 1, @"The string 'animations.%@.format' is required in the plist for: %@", key, name);
    
    // autorelease CCAnimation
    CCAnimation* animation = [[[CCAnimation alloc]
                               initWithFormat:format subString:nil frameCount:frameCount delay:delay] autorelease];
    return animation;
}

-(CCAnimation*) loadAnimationForKey:(NSString*)key dict:(NSDictionary*)dict index:(int)index
{
    // get the details for this animation
    NSString *format = [dict valueForKey:@"format"];
    NSString *dir = [[dict objectForKey:@"directions"] objectAtIndex:index];
    int frameCount = [[dict valueForKey:@"frameCount"] intValue];
    
    float delay = [[dict valueForKey:@"delay"] floatValue];
    delay = (delay == 0.0f ? 0.05f : clampf(delay, 0.01f, 0.33f));
    KITLog(@"Item: loading animation %@, format %@, frameCount %d, delay %.2f", key, format, frameCount, delay);
    
    // assertions
    KITAssert2(frameCount >= 1, @"The number 'animations.%@.frameCount' is required in the plist for: %@", key, name);
    KITAssert2([format length] >= 1, @"The string 'animations.%@.format' is required in the plist for: %@", key, name);
    
    // autorelease CCAnimation
    CCAnimation* animation = [[[CCAnimation alloc]
                               initWithFormat:format subString:dir frameCount:frameCount delay:delay] autorelease];
    return animation;
}




-(void) loadSounds:(NSArray*)ra
{
    for(id o in ra)
    {
        // load all sounds in array recursively
        if( [o isKindOfClass:[NSArray class]] )
            [self loadSounds:o];
        
        // load this sound
        else if( [o isKindOfClass:[NSString class]] )
            [[KITSound sharedSound] loadSound:o];
        
        // run-time error
        else
            KITAssert1(NO, @"What's this sound '%@'? Expecting a string or array.", o);
    }
}

-(NSString*) getSoundForKey:(NSString*)key
{
    id o = [[configDict objectForKey:@"sounds"] valueForKey:key];
    if( o != nil )
    {
        // if it's a string, then it's a string
        // if it's an array, then select a string at random
        return ([o isKindOfClass:[NSString class]] ? o : [(NSArray*)o randomObject]);
    }
    return nil;
}


@end
