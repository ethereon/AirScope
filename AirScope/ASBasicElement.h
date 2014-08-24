//
//  ASBasicElement.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/24/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASElement.h"

@interface ASBasicElement : ASElement

-(GLint) vbo;

-(void) prepareToRender;

@property (assign) GLKVector4 color;

@end
