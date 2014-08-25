//
//  ASPointsElement.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/24/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASPointsElement.h"
#include <vector>

@implementation ASPointsElement
{
    std::vector<GLKVector3> _points;
    BOOL _dataNeedsUpdate;
    CGFloat _backingScale;
}

-(id) init
{
    if(!(self=[super init])) return nil;
    _backingScale = [[NSScreen mainScreen] backingScaleFactor];
    [self setThickness:1.0];
    [self clearPoints];
    return self;
}

-(void) clearPoints
{
    _points.clear();
    _dataNeedsUpdate = NO;
}

-(void) addPoint:(GLKVector3)p
{
    _points.push_back(p);
    [[self bounds] includePoint:p];
    _dataNeedsUpdate = YES;
}

-(size_t) numberOfPoints
{
    return _points.size();
}

-(float) effectiveThickness
{
    return _thickness*_backingScale;
}

-(void) render
{
    if(_points.size()==0) return;
    [[self shader] use];
    if(_dataNeedsUpdate)
    {
        GLKVector3* pointData = _points.data();
        glBindBuffer(GL_ARRAY_BUFFER, [self vbo]);
        glBufferData(GL_ARRAY_BUFFER, _points.size()*sizeof(GLKVector3), pointData, GL_STATIC_DRAW);
        _dataNeedsUpdate = NO;
    }
    [self prepareToRender];
    [self renderPoints];
}

-(void) renderPoints
{
    NSLog(@"renderPoints not overriden!");
    assert(false);
}

@end
