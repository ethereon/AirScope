//
//  ASElement.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/18/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ASBounds.h"
#import "Shader.h"

@class ASPlot;

@interface ASElement : NSObject

-(BOOL) isNormalized;

-(void) render;

-(void) setupShader;

@property (assign, nonatomic) GLKMatrix4 transform;
@property (strong, nonatomic) ASBounds* bounds;
@property (strong, nonatomic) Shader* shader;

@end
