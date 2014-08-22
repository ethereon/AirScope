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
    return self;
}

-(void) render
{
    NSLog(@"Virtual render method called.");
    assert(false);
}

@end
