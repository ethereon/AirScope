//
//  ASPlane.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/22/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASPlane.h"
#import "Shader.h"
#import <GLKit/GLKit.h>

@implementation ASPlane
{
    GLuint _ibo;
    int _numIndices;
}

-(BOOL) isNormalized
{
    return YES;
}

-(void) setupShader
{
    [super setupShader];
    [self setColor:GLKVector4Make(0.4, 0.4, 0.4, 1.0)];

    //Generate Vertices.
    const int gridSize = 21;
    const int numVertices = gridSize*gridSize;
    GLKVector3* vertices = malloc(numVertices*sizeof(GLKVector3));
    const int halfGridSize = gridSize/2;
    for(int i = 0; i <gridSize; ++i)
    {
        for(int j = 0; j <gridSize; ++j)
        {
            GLKVector3* v = vertices + (gridSize*i) + j;
            v->x = (j - halfGridSize)/(float)gridSize;
            v->y = -0.5;
            v->z = (i - halfGridSize)/(float)gridSize;
        }
    }
    glBindBuffer(GL_ARRAY_BUFFER, [self vbo]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLKVector3)*numVertices, vertices, GL_STATIC_DRAW);
    free(vertices);

    //Generate Indices.
    _numIndices = 4*(gridSize-1)*gridSize;
    GLushort* indices = malloc(sizeof(GLushort)*_numIndices);
    int i = 0;
    for(int y = 0; y < gridSize; ++y)
    {
        for(int x = 0; x < gridSize-1; ++x)
        {
            indices[i++] = y * gridSize + x;
            indices[i++] = y * gridSize + x + 1;
        }
    }
    for(int x = 0; x < gridSize; ++x)
    {
        for(int y = 0; y < gridSize-1; ++y)
        {
            indices[i++] = y * gridSize + x;
            indices[i++] = (y + 1) * gridSize + x;
        }
    }
    glGenBuffers(1, &_ibo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*_numIndices, indices, GL_STATIC_DRAW);
    free(indices);
}

-(void) render
{
    [[self shader] use];
    [self prepareToRender];
    glLineWidth(1.0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
    glDrawElements(GL_LINES, _numIndices, GL_UNSIGNED_SHORT, 0);
}

@end
