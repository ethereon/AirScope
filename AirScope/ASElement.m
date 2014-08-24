//
//  ASElement.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/18/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASElement.h"

@implementation ASElement

-(id) init
{
    if(!(self=[super init])) return nil;
    _bounds = [ASBounds bounds];
    if([self isNormalized])
    {
        [_bounds setLower:GLKVector3Make(-0.5, -0.5, -0.5)
                    upper:GLKVector3Make(0.5, 0.5, 0.5)];
    }
    return self;
}

-(BOOL) isNormalized
{
    return NO;
}

-(void) render
{
    NSLog(@"Virtual render method called.");
    assert(false);
}

-(void) setupShader
{
    NSLog(@"Virtual setupShader method called.");
    assert(false);
}

-(Shader*) shader
{
    if(!_shader)
    {
        [self setupShader];
    }
    return _shader;
}

@end
