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

-(ASPlotController*) plotControllerForKey:(NSString*)plotKey
{
    return _plotControllers[plotKey];
}

@end
