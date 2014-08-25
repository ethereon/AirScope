//
//  ASPointCloud.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/24/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASPointCloud.h"

@implementation ASPointCloud

-(id) init
{
    if(!(self=[super init])) return nil;
    [self setColor:GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f)];
    [self setThickness:2.0];
    return self;
}

-(void) renderPoints
{
    glPointSize([self effectiveThickness]);
    glDrawArrays(GL_POINTS, 0, (GLsizei)[self numberOfPoints]);
}

@end
