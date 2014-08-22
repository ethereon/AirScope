//
//  ASBounds.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/18/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ASBounds : NSObject

+(ASBounds*) bounds;
+(ASBounds*) boundsWithLower:(GLKVector3)lower upper:(GLKVector3)upper;

-(GLKVector3) center;

-(void) includePoint:(GLKVector3)p;
-(void) unionWith:(ASBounds*)b;

-(BOOL) coversBounds:(ASBounds*)b;

-(float) minX;
-(float) minY;
-(float) minZ;
-(float) maxX;
-(float) maxY;
-(float) maxZ;

-(GLKVector3) span;
-(float) spanX;
-(float) spanY;
-(float) spanZ;

-(float) boundingSphereDiameter;
-(void) transform:(GLKMatrix3)xform;

-(ASBounds*) transformed:(GLKMatrix3)xform;

-(void) setLower:(GLKVector3)lower upper:(GLKVector3)upper;

@property (assign) GLKVector3 lower;
@property (assign) GLKVector3 upper;

@end
