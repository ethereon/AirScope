//
//  ASMissionControl.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/22/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASPlotController;

@interface ASMissionControl : NSObject

+(instancetype) central;

-(ASPlotController*) beginPlotWithKey:(NSString*)plotKey resetExisting:(BOOL)resetExisting;

-(ASPlotController*) plotControllerForKey:(NSString*)plotKey;

-(ASPlotController*) plotControllerForKey:(NSString*)plotKey autoCreate:(BOOL)autoCreate;

-(void) removePlotController:(ASPlotController*)plotController;

@end
