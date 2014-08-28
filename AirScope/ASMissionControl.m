//
//  ASMissionControl.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/22/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASMissionControl.h"
#import "ASPlotController.h"
#import "ASAppDelegate.h"

@interface ASMissionControl ()
@property (strong) NSMutableDictionary* plotControllers;
@end

@implementation ASMissionControl

+(instancetype) central
{
    return [(ASAppDelegate*)[NSApp delegate] missionControl];
}

-(id) init
{
    if(!(self=[super init])) return nil;
    _plotControllers = [NSMutableDictionary dictionary];
    return self;
}

-(ASPlotController*) beginPlotWithKey:(NSString*)plotKey resetExisting:(BOOL)resetExisting
{
    @synchronized(_plotControllers)
    {
        ASPlotController* controller = _plotControllers[plotKey];
        if(controller==nil)
        {
            controller = [[ASPlotController alloc] init];
            [controller setTitle:plotKey];
            _plotControllers[plotKey] = controller;
            [controller showWindow:self];
        }
        else if(resetExisting)
        {
            [controller reset];
        }
        return controller;
    }
}

-(ASPlotController*) plotControllerForKey:(NSString*)plotKey
{
    @synchronized(_plotControllers)
    {
        return _plotControllers[plotKey];
    }
}

-(NSString*) keyForPlotController:(ASPlotController*)plotController
{
    @synchronized(_plotControllers)
    {
        for(NSString* key in _plotControllers)
        {
            if([_plotControllers objectForKey:key]==plotController)
            {
                return key;
            }
        }
        return nil;
    }
}

-(void) removePlotController:(ASPlotController*)plotController
{
    NSString* key = [self keyForPlotController:plotController];
    assert(key!=nil);
    @synchronized(_plotControllers)
    {
        [_plotControllers removeObjectForKey:key];
    }
}

@end
