//
//  ASLine3D.mm
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASLine3D.h"
#import "Shader.h"
#include <vector>

using namespace std;

#define VERIFY(x)   if((x)==-1) return nil;

@interface ASLine3D ()
@property (strong) Shader* shader;
@end

@implementation ASLine3D
{
    GLint _shTransform;
    GLint _shPoints;
    GLint _shLineColor;
    GLuint _vbo;
    std::vector<GLKVector3> _points;
    BOOL _dataNeedsUpdate;
}

-(id) init
{
    if(!(self=[super init])) return nil;
    _shader = [[Shader alloc] initWithShaderName:@"BasicElement"];
    if(![_shader load]) return nil;
    VERIFY(_shPoints = [_shader locationForAttribute:"point"]);
    VERIFY(_shTransform = [_shader locationForUniform:"transform"]);
    VERIFY(_shLineColor = [_shader locationForUniform:"elem_color"]);
    glGenBuffers(1, &_vbo);
    _lineColor = GLKVector4Make(0.96f, 0.6f, 0.0f, 1.0f);
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
    [_shader use];
    if(_dataNeedsUpdate)
    {
        GLKVector3* pointData = _points.data();
        glBindBuffer(GL_ARRAY_BUFFER, _vbo);
        glBufferData(GL_ARRAY_BUFFER, _points.size()*sizeof(GLKVector3), pointData, GL_STATIC_DRAW);
        _dataNeedsUpdate = NO;
    }
    glUniformMatrix4fv(_shTransform, 1, 0, [self transform].m);
    glUniform4f(_shLineColor, _lineColor.r, _lineColor.g, _lineColor.b, _lineColor.a);

    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glEnableVertexAttribArray(_shPoints);
    glVertexAttribPointer(_shPoints, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glLineWidth(4.0);
    glDrawArrays(GL_LINE_STRIP, 0, (GLsizei)_points.size());
}

@end
