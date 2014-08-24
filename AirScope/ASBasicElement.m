//
//  ASBasicElement.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/24/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASBasicElement.h"

@implementation ASBasicElement
{
    GLint _shTransform;
    GLint _shPoints;
    GLint _shElemColor;
    GLuint _vbo;
}

-(GLint) vbo
{
    return _vbo;
}

-(void) setupShader
{
    Shader* shader = [Shader shaderNamed:@"BasicElement"];
    [shader load];
    _shPoints = [shader locationForAttribute:"point"];
    _shTransform = [shader locationForUniform:"transform"];
    _shElemColor = [shader locationForUniform:"elem_color"];
    glGenBuffers(1, &_vbo);
    [self setShader:shader];
}

-(void) prepareToRender
{
    glUniformMatrix4fv(_shTransform, 1, 0, [self transform].m);
    glUniform4f(_shElemColor, _color.r, _color.g, _color.b, _color.a);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glEnableVertexAttribArray(_shPoints);
    glVertexAttribPointer(_shPoints, 3, GL_FLOAT, GL_FALSE, 0, 0);
}

@end
