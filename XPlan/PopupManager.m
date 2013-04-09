//
//  PopupManager.m
//  NationalInvasion
//
//  Created by Hex on 12/1/12.
//
//

#import "PopupManager.h"
#import "PopupWindow.h"

static PopupManager *_popupManagerInstance = nil;

@interface PopupManager()
{
    
}

@end

@implementation PopupManager

@synthesize totalOpenCount,modalOpenCount,popups;

#pragma mark -
#pragma mark Class methods

+(PopupManager*) sharedManager
{
    @synchronized([PopupManager class])
    {
        if (!_popupManagerInstance)
        {
            _popupManagerInstance = [[self alloc] init];
        }
    }
    
    return _popupManagerInstance;
}

+(id) alloc
{
    @synchronized([PopupManager class])
    {
        KITAssert(_popupManagerInstance == nil, @"There can only be one PopupManager singleton");
        return [super alloc];
    }
    return nil;
}

#pragma mark -
#pragma mark Instance methods

-(id) init
{
    if ((self = [super init]))
    {
        popups = [[NSMutableDictionary alloc] initWithCapacity:20];
        totalOpenCount = 0;
        modalOpenCount = 0;
    }
    
    return self;
}

-(void) dealloc
{
    [popups release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

-(PopupWindow*) getPopup:(Class)popupClass
{
    return [self getPopup:popupClass withProperties:nil];
}

-(PopupWindow*) getPopup:(Class)popupClass withProperties:(NSDictionary*)properties
{
    NSString *popupKey = NSStringFromClass(popupClass);
    PopupWindow *popup = [popups objectForKey:popupKey];
    if (popup == nil)
    {
        popup = [[popupClass alloc] initWithProperties:properties];
        
        // 4. 保存到popups
        [popups setObject:popup forKey:popupKey];
        [popup release];
        popup = [popups objectForKey:popupKey];
    }
    
    return popup;
}

-(BOOL) isPopupCreated:(Class)popupClass
{
    return [popups objectForKey:NSStringFromClass(popupClass)] != nil;
}

-(void) releasePopup:(Class)popupClass
{
    [popups removeObjectForKey:NSStringFromClass(popupClass)];
}

-(BOOL) isModalPopupActive
{
    return modalOpenCount > 0;
}

-(BOOL) isAnyPopupActive
{
    return totalOpenCount > 0;
}


@end
