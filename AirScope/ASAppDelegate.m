//
//  ASAppDelegate.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASMissionControl.h"
#import "ASCommunicator.h"
#import "ASDemos.h"

@interface ASAppDelegate ()
@property (strong) ASCommunicator* comm;
@end

@implementation ASAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _missionControl = [[ASMissionControl alloc] init];
    _comm = [[ASCommunicator alloc] init];
    [_comm start];
}

-(IBAction) launchDemos:(id)sender
{
    [ASDemos launchDemos];
}

@end
