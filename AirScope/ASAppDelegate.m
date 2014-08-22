//
//  ASAppDelegate.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASPlotController.h"

@interface ASAppDelegate ()
@property (strong) ASPlotController* plotController;
@end

@implementation ASAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _plotController = [[ASPlotController alloc] init];
    [_plotController showWindow:self];
}

@end
