//
//  ASPlotController.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASPlotController.h"
#import "ASLine3D.h"

@interface ASPlotController ()
@property (strong) ASPlot* plot;
@end

@implementation ASPlotController

- (id)init
{
    if(!(self = [super initWithWindowNibName:@"ASPlotWindow"])) return nil;
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    _plot = [[ASPlot alloc] init];
    [_plotView setPlot:_plot];

    ASLine3D* line = [[ASLine3D alloc] init];
    for(float theta=0; theta<10*M_PI; theta+=0.01)
    {
        [line appendPoint:GLKVector3Make(theta, sin(theta), cos(theta))];
    }
    [_plot addElement:line];
    [_plotView setNeedsDisplay:YES];
}

@end
