//
//  ASLine3D.mm
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASLine3D.h"
#include <vector>

using namespace std;

@implementation ASLine3D
{
    std::vector<GLKVector3> _points;
    BOOL _dataNeedsUpdate;
}

-(id) init
{
    if(!(self=[super init])) return nil;

    [self setColor:GLKVector4Make(0.96f, 0.6f, 0.0f, 1.0f)];
    _lineWidth = 2.0*[[NSScreen mainScreen] backingScaleFactor];
    [self clearPoints];
    return self;
}

-(void) clearPoints
{
    _points.clear();
    _dataNeedsUpdate = NO;
}

-(void) appendPoint:(GLKVector3)p
{
    _points.push_back(p);
    [[self bounds] includePoint:p];
    _dataNeedsUpdate = YES;
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
    glLineWidth(_lineWidth);
    glDrawArrays(GL_LINE_STRIP, 0, (GLsizei)_points.size());
}

@end
