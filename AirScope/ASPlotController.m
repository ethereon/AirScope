//
//  ASPlotController.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASPlotController.h"
#import "ASLine3D.h"
#import "ASPlane.h"

static NSString* const kGroundPlaneKey = @"__as-ground-plane";

@interface ASPlotController ()
@property (strong) NSMutableDictionary* elements;
@end

@implementation ASPlotController

- (id)init
{
    if(!(self = [super initWithWindowNibName:@"ASPlotWindow"])) return nil;
    _elements = [NSMutableDictionary dictionary];
    _plot = [[ASPlot alloc] init];
    [self addElement:[[ASPlane alloc] init] withKey:kGroundPlaneKey];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [_plotView setPlot:_plot];
}

-(void) setTitle:(NSString*)title
{
    [[self window] setTitle:title];
}

-(void) reset
{
}

-(void) update
{
    [_plot scaleToFit];
    [_plotView setNeedsDisplay:YES];
}

-(void) addElement:(ASElement*)elem withKey:(NSString*)elemKey
{
    _elements[elemKey] = elem;
    [_plot addElement:elem];
}

-(void) addPoint:(GLKVector3)p toLineWithKey:(NSString*)lineKey
{
    ASLine3D* line = _elements[lineKey];
    if(line==nil)
    {
        line = [[ASLine3D alloc] init];
        [self addElement:line withKey:lineKey];
    }
    assert([line isKindOfClass:[ASLine3D class]]);
    [line appendPoint:p];
}

@end
