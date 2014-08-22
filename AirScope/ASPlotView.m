//
//  ASPlotView.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASPlotView.h"
#import <GLKit/GLKit.h>

static const float kRadiansPerPoint = 0.01;

@interface ASPlotView ()
@property (assign) BOOL isDragging;
@property (assign) NSPoint dragReference;
@end

@implementation ASPlotView

-(void) drawRect: (NSRect) bounds
{
    const float grayLevel = 0.2f;
    glClearColor(grayLevel, grayLevel, grayLevel, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [_plot renderInView:self];
    [[self openGLContext] flushBuffer];
}

#pragma mark - NSOpenGLView Overrides

-(void) prepareOpenGL
{
    [super prepareOpenGL];
}

#pragma mark - Event Handling

-(void)mouseDown:(NSEvent *)event
{
    _isDragging = YES;
    _dragReference = [self convertPoint:[event locationInWindow] fromView:nil];
}

-(void)mouseDragged:(NSEvent *)event
{
    if(!_isDragging) return;
    NSPoint curLoc = [self convertPoint:[event locationInWindow] fromView:nil];
    float dx = kRadiansPerPoint*(_dragReference.x-curLoc.x);
    float dy = kRadiansPerPoint*(_dragReference.y-curLoc.y);
    [_plot setXRotation:[_plot xRotation]+dy];
    [_plot setYRotation:[_plot yRotation]+dx];
    _dragReference = curLoc;
    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent *)event
{
    _isDragging = NO;
}


@end
