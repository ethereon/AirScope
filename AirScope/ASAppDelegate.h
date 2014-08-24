//
//  ASAppDelegate.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ASMissionControl;

@interface ASAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, readonly) ASMissionControl* missionControl;

@end
