//
//  ASPlotController.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASPlotView.h"

@interface ASPlotController : NSWindowController

-(void) setTitle:(NSString*)title;
-(void) reset;
-(void) update;

-(void) addPoint:(GLKVector3)p toLineWithKey:(NSString*)lineKey;

@property (strong) IBOutlet ASPlotView* plotView;
@property (strong) ASPlot* plot;

@end
