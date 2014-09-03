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
#import "ASPointCloud.h"
#import "ASMissionControl.h"
#import <Carbon/Carbon.h>

static NSString* const kInternalElementPrefix = @"__as-";
static NSString* const kGroundPlaneKey = @"__as-ground-plane";

@interface ASPlotController () <NSWindowDelegate>
@property (strong) NSMutableDictionary* elements;
@property (strong) NSTimer* rotationTimer;
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

-(void) dealloc
{
    [self stopAutoRotation];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window] setDelegate:self];
    [_plotView setPlot:_plot];
}

-(void) setTitle:(NSString*)title
{
    [[self window] setTitle:title];
}

-(void) reset
{
    NSArray* elemKeys = [_elements allKeys];
    for(id key in elemKeys)
    {
        if(![key hasPrefix:kInternalElementPrefix])
        {
            [self deleteElementWithKey:key];
        }
    }
    [_plotView setNeedsDisplay:YES];
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

-(void) addPoint:(GLKVector3)p toElementOfClass:(Class)ElemClass withKey:(NSString*)elemKey
{
    ASPointsElement* elem = _elements[elemKey];
    if(elem==nil)
    {
        elem = [[ElemClass alloc] init];
        [self addElement:elem withKey:elemKey];
    }
    assert([elem isKindOfClass:ElemClass]);
    [elem addPoint:p];
}

-(void) addPoint:(GLKVector3)p toLineWithKey:(NSString*)lineKey
{
    [self addPoint:p toElementOfClass:[ASLine3D class] withKey:lineKey];
}

-(void) addPoint:(GLKVector3)p toCloudWithKey:(NSString*)cloudKey
{
    [self addPoint:p toElementOfClass:[ASPointCloud class] withKey:cloudKey];
}

-(void) deleteElementWithKey:(NSString*)elemKey
{
    ASElement* elem = _elements[elemKey];
    [_plot removeElement:elem];
    [_elements removeObjectForKey:elemKey];
}

#pragma mark - NSWindowDelegate Methods

-(void) windowWillClose:(NSNotification *)notification
{
    [[ASMissionControl central] removePlotController:self];
}

#pragma mark - Event Handling

-(void) keyDown:(NSEvent *)theEvent
{
    int keyCode = [theEvent keyCode];
    switch (keyCode)
    {
        case kVK_Return:
            [self toggleAutoRotate];
            break;
        case kVK_LeftArrow:
            [self incrementRotationX:0 y:[self manualRotationIncrement]];
            break;
        case kVK_RightArrow:
            [self incrementRotationX:0 y:-[self manualRotationIncrement]];
            break;
        case kVK_UpArrow:
            [self incrementRotationX:[self manualRotationIncrement] y:0];
            break;
        case kVK_DownArrow:
            [self incrementRotationX:-[self manualRotationIncrement] y:0];
            break;
        case kVK_ANSI_R:
            [self resetTransform];
            break;
    }
}

//Returns the point in the range [-1, 1].
-(NSPoint) normalizeWindowLocation:(NSPoint)p
{
    NSSize winSize = [[self window] frame].size;
    //Cocoa window locations start from 1 (rather than of 0).
    //We start from the middle of the pixel instead.
    return NSMakePoint(2*(p.x-0.5f)/winSize.width - 1.0f,
                       2*(p.y-0.5f)/winSize.height - 1.0f);
}

-(void)scrollWheel:(NSEvent *)theEvent
{
    float delta = [theEvent scrollingDeltaY];
    if(delta==0)
    {
        return;
    }
    //Negate as scroll-axis is inverted.
    float zoomIncrement = -0.05f*delta;
    float newZoomFactor = [self zoomFactor]+zoomIncrement;
    if(newZoomFactor>=1.0f)
    {
        [self setZoomFactor:newZoomFactor
                 withOrigin:[self normalizeWindowLocation:[theEvent locationInWindow]]];
    }
    else
    {
        //Snap to perfect 1.0 scale.
        [self setZoomFactor:1.0 withOrigin:NSZeroPoint];
    }
}

#pragma mark - Plot Transformations

-(float) zoomFactor
{
    return [_plot zoom].z;
}

-(void) setZoomFactor:(float)zoomFactor withOrigin:(NSPoint)origin
{
    [_plot setZoom:GLKVector3Make(origin.x, origin.y, zoomFactor)];
    [_plotView setNeedsDisplay:YES];
}

-(void) toggleAutoRotate
{
    if(_rotationTimer!=nil)
    {
        [_rotationTimer invalidate];
        _rotationTimer = nil;
    }
    else
    {
        _rotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                          target:self
                                                        selector:@selector(handleRotationTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

-(float) manualRotationIncrement
{
    return 0.1;
}

-(void) incrementRotationX:(float)deltaX y:(float)deltaY
{
    [_plot setXRotation:[_plot xRotation]+deltaX];
    [_plot setYRotation:[_plot yRotation]+deltaY];
    [_plotView setNeedsDisplay:YES];
}

-(void) handleRotationTimer:(NSTimer*)timer
{
    [self incrementRotationX:0.0 y:0.02];
}

-(void) stopAutoRotation
{
    if(_rotationTimer!=nil)
    {
        [_rotationTimer invalidate];
        _rotationTimer = nil;
    }
}

-(void) resetTransform
{
    [self stopAutoRotation];
    [_plot setXRotation:0];
    [_plot setYRotation:0];
    [_plot setZoom:GLKVector3Make(0.0f, 0.0f, 1.0f)];
    [_plotView setNeedsDisplay:YES];
}

@end
