//
//  ASPlotView.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASPlot.h"

@interface ASPlotView : NSOpenGLView

@property (strong) ASPlot* plot;

@end

