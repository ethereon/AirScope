//
//  ASPointsElement.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/24/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASBasicElement.h"

@interface ASPointsElement : ASBasicElement

-(void) clearPoints;

-(void) addPoint:(GLKVector3)p;

-(size_t) numberOfPoints;

-(float) effectiveThickness;

@property (assign, nonatomic) float thickness;

@end

@interface ASPointsElement (SubclassHooks)

-(void) renderPoints;

@end
