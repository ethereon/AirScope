//
//  ASLine3D.mm
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASLine3D.h"
#include <vector>

@implementation ASLine3D

-(id) init
{
    if(!(self=[super init])) return nil;
    [self setColor:GLKVector4Make(0.96f, 0.6f, 0.0f, 1.0f)];
    return self;
}

-(void) renderPoints
{
    glLineWidth([self effectiveThickness]);
    glDrawArrays(GL_LINE_STRIP, 0, (GLsizei)[self numberOfPoints]);
}

@end
