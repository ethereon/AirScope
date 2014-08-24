//
//  ASLine3D.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASBasicElement.h"

@interface ASLine3D : ASBasicElement

-(void) clearPoints;

-(void) appendPoint:(GLKVector3)p;

@property (assign) float lineWidth;

@end
