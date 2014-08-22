//
//  ASPlot.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/18/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASElement.h"

@class ASPlotView;

@interface ASPlot : NSObject

-(void) addElement:(ASElement*)elem;
-(void) addElement:(ASElement*)elem scaleToFit:(BOOL)rescale;
-(void) renderInView:(ASPlotView*)plotView;
-(void) scaleToFit;

@property (assign) float xRotation;
@property (assign) float yRotation;
@property (assign) float zRotation;

@end
