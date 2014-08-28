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
    _zoom = GLKVector3Make(0.0f, 0.0f, 1.0f);
    return self;
}

-(void) addElement:(ASElement*)elem
{
    [_elements addObject:elem];
}

-(void) removeElement:(ASElement*)elem
{
    assert([_elements containsObject:elem]);
    [_elements removeObject:elem];
}

-(void) renderInView:(ASPlotView*)plotView
{
    //Normalize the data to [-0.5, 0.5] along each axis.
    GLKMatrix4 N;
    GLKVector3 dataCenter = [_dataBounds center];
    N = GLKMatrix4MakeTranslation(-dataCenter.x, -dataCenter.y, -dataCenter.z);
    N = GLKMatrix4Multiply(GLKMatrix4MakeScale(1.0f/[_dataBounds spanX],
                                               1.0f/[_dataBounds spanY],
                                               1.0f/[_dataBounds spanZ]), N);
    
    //Base Model-View-Projection.
    GLKMatrix4 T = [self transformForView:plotView];
    GLKMatrix4 TN = GLKMatrix4Multiply(T, N);
    for(ASElement* elem in _elements)
    {
        [elem setTransform:[elem isNormalized]?T:TN];
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
    //Rotate the model.
    GLKMatrix4 MV = GLKMatrix4MakeXRotation(_xRotation);
    MV = GLKMatrix4Multiply(GLKMatrix4MakeYRotation(_yRotation), MV);
    MV = GLKMatrix4Multiply(GLKMatrix4MakeZRotation(_zRotation), MV);
    
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
    
    //Apply the zoom transformation.
    //We apply this to the projection matrix so we don't have to worry about clipping issues.
    GLKMatrix4 zoomT = GLKMatrix4MakeTranslation(-_zoom.x, -_zoom.y, 0.0f);
    zoomT = GLKMatrix4Multiply(GLKMatrix4MakeScale(_zoom.z, _zoom.z, 0.0f), zoomT);
    zoomT = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(_zoom.x, _zoom.y, 0.0f), zoomT);
    P = GLKMatrix4Multiply(zoomT, P);
    
    //-zNear and -zFar are our clipping planes. (See documentation for glOrtho.)
    //Shift the model into the viewing volume.
    MV = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, -(dia*0.5)-zNear), MV);
    
    return GLKMatrix4Multiply(P, MV);
}

@end
