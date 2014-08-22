//
//  ASLine3D.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASElement.h"

@interface ASLine3D : ASElement

-(void) clearPoints;

-(void) appendPoint:(GLKVector3)p;

@property (assign) GLKVector4 lineColor;

@end
