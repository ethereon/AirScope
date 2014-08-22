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

@class ASPlot;

@interface ASElement : NSObject

-(void) render;

@property (assign) GLKMatrix4 transform;
@property (strong) ASBounds* bounds;

@end
