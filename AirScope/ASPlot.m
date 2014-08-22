//
//  ASPlot.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/18/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASPlot.h"
#import "ASPlotView.h"

@interface ASPlot ()
@property (strong, nonatomic) NSMutableArray* elements;
@property (strong, nonatomic) ASBounds* dataBounds;
@end

@implementation ASPlot

-(id) init
{
    if(!(self=[super init])) return nil;
    _elements = [[NSMutableArray alloc] init];
    return self;
}

-(void) addElement:(ASElement*)elem scaleToFit:(BOOL)rescale
{
    [_elements addObject:elem];
    if(rescale)
    {
        [self scaleToFit];
    }
}

-(void) addElement:(ASElement*)elem
{
    [self addElement:elem scaleToFit:YES];
}

-(void) renderInView:(ASPlotView*)plotView
{
    GLKMatrix4 xform = [self transformForView:plotView];
    for(ASElement* elem in _elements)
    {
        [elem setTransform:xform];
        [elem render];
    }
}

-(void) scaleToFit
{
    ASBounds* newBounds = [[ASBounds alloc] init];
    for(ASElement* elem in _elements)
    {
        [newBounds unionWith:[elem bounds]];
    }
    [self setDataBounds:newBounds];
}

-(GLKMatrix4) transformForView:(ASPlotView*)plotView
{
    GLKMatrix4 MV;

    //Normalize the data to [-0.5, 0.5] along each axis.
    GLKVector3 dataCenter = [_dataBounds center];
    MV = GLKMatrix4MakeTranslation(-dataCenter.x, -dataCenter.y, -dataCenter.z);
    MV = GLKMatrix4Multiply(GLKMatrix4MakeScale(1.0f/[_dataBounds spanX],
                                                1.0f/[_dataBounds spanY],
                                                1.0f/[_dataBounds spanZ]), MV);

    //Rotate the model.
    GLKMatrix4 modelRotation = GLKMatrix4MakeXRotation(_xRotation);
    modelRotation = GLKMatrix4Multiply(GLKMatrix4MakeYRotation(_yRotation), modelRotation);
    modelRotation = GLKMatrix4Multiply(GLKMatrix4MakeZRotation(_zRotation), modelRotation);
    MV = GLKMatrix4Multiply(modelRotation, MV);

    //Setup orthographic projection.
    NSSize viewSize = [plotView bounds].size;
    float dia       = sqrtf(3.0f);
    float radius    = dia*0.5f;
    float left      = -radius;
    float right     = radius;
    float bottom    = -radius;
    float top       = radius;
    float zNear     = 0.01f;
    float zFar      = zNear + dia;
    float aspect    = viewSize.width/viewSize.height;
    if(aspect<1.0f)
    {
        bottom  /= aspect;
        top     /= aspect;
    }
    else
    {
        left    *= aspect;
        right   *= aspect;
    }
    GLKMatrix4 P = GLKMatrix4MakeOrtho(left, right, bottom, top, zNear, zFar);

    //-zNear and -zFar are our clipping planes. (See documentation for glOrtho.)
    //Shift the model into the viewing volume.
    MV = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, -radius-zNear), MV);

    return GLKMatrix4Multiply(P, MV);
}

@end
