//
//  GameSettings.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//
//

#import "GameSettings.h"
#import "Constants.h"

@implementation KITSettings (XPlan)

-(void) clear:(int)areaNumber
{
    // create fresh dictionary
    [dictionary release];
    dictionary = [[NSMutableDictionary alloc] init];
}

+(void) reset
{
    // reset the save games
    [KITSettings loadSettings:0];
    [[KITSettings get] clear:0];
    [KITSettings saveSettings:0];
}


-(NSMutableDictionary*) idiomsDictionary
{
    NSString *idiom = [KITApp idiom];
    NSMutableDictionary *idiomDict = [dictionary objectForKey:idiom];
    
    if (idiomDict == nil)
    {
        idiomDict = [[NSMutableDictionary alloc] init];
        [dictionary setValue:idiomDict forKey:idiom];
        [idiomDict release];
        
        idiomDict = [dictionary objectForKey:idiom];
    }
    
    return idiomDict;
}

-(NSMutableDictionary*) systemDictionary
{
    NSString *key = @"system";
    NSMutableDictionary *idiomDict = [self idiomsDictionary];
    NSMutableDictionary *dict = [idiomDict objectForKey:key];
    
    if (dict == nil)
    {
        // create initial Battfield dictionary
        dict = [[NSMutableDictionary alloc] init];
        // save it in the Settings dictionary
        [idiomDict setValue:dict forKey:key];
        [dict release];
        
        // re get it from the dictionary
        dict = [idiomDict objectForKey:key];
    }
    
    return dict;
}


-(NSMutableDictionary*) playerDictionary
{
    NSString *key = @"player";
    NSMutableDictionary *idiomDict = [self idiomsDictionary];
    NSMutableDictionary *dict = [idiomDict objectForKey:key];
    
    if (dict == nil)
    {
        // create initial Player dictionary
        dict = [[NSMutableDictionary alloc] init];
        [idiomDict setValue:dict forKey:key];
        [dict release];
        
        // re get it from the dictionary
        dict = [idiomDict objectForKey:key];
    }
    
    return dict;
}

#pragma mark -
#pragma mark System

-(NSString*) serverIPAddress
{
    NSString *address = [[self systemDictionary] valueForKey:@"serverIPAddress"];
    if (!address)
    {
        address = @"192.168.16.65";
    }
    return address;
}

-(void) setServerIPAddress:(NSString *)value
{
    
}



@end
