//
//  ASBounds.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/18/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASBounds.h"

@implementation ASBounds

+(ASBounds*) bounds
{
    return [[ASBounds alloc] init];
}

+(ASBounds*) boundsWithLower:(GLKVector3)lower upper:(GLKVector3)upper
{
    ASBounds* b = [self bounds];
    [b setLower:lower upper:upper];
    return b;
}

-(id) init
{
    if(!(self=[super init])) return nil;
    _lower = GLKVector3Make(FLT_MAX, FLT_MAX, FLT_MAX);
    _upper = GLKVector3Make(FLT_MIN, FLT_MIN, FLT_MIN);
    return self;
}

-(void) setLower:(GLKVector3)lower upper:(GLKVector3)upper
{
    _lower = lower;
    _upper = upper;
}

-(id) copyWithZone:(NSZone*)zone
{
    return [ASBounds boundsWithLower:_lower upper:_upper];
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"Min: %@ , Max: %@",
            NSStringFromGLKVector3(_lower),
            NSStringFromGLKVector3(_upper)];
}

-(GLKVector3) center
{
    return GLKVector3MultiplyScalar(GLKVector3Add(_lower, _upper), 0.5f);
}

-(void) unionWith:(ASBounds*)b
{
    [self includePoint:[b lower]];
    [self includePoint:[b upper]];
}

-(void) includePoint:(GLKVector3)p
{
    if(p.x<_lower.x) _lower.x = p.x;
    if(p.y<_lower.y) _lower.y = p.y;
    if(p.z<_lower.z) _lower.z = p.z;
    if(p.x>_upper.x) _upper.x = p.x;
    if(p.y>_upper.y) _upper.y = p.y;
    if(p.z>_upper.z) _upper.z = p.z;
}

-(GLKVector3) span
{
    return GLKVector3Make((_upper.x - _lower.x),
                          (_upper.y - _lower.y),
                          (_upper.z - _lower.z));
}

-(float) spanX
{
    return (_upper.x - _lower.x);
}

-(float) spanY
{
    return (_upper.y - _lower.y);
}

-(float) spanZ
{
    return (_upper.z - _lower.z);
}

-(float) minX
{
    return _lower.x;
}

-(float) minY
{
    return _lower.y;
}

-(float) minZ
{
    return _lower.z;
}

-(float) maxX
{
    return _upper.x;
}

-(float) maxY
{
    return _upper.y;
}

-(float) maxZ
{
    return _upper.z;
}

-(float) boundingSphereDiameter
{
    float x = [self spanX];
    float y = [self spanY];
    float z = [self spanZ];
    return sqrt(x*x + y*y + z*z);
}

-(void) transform:(GLKMatrix3)xform
{
    GLKVector3 c = [self center];
    GLKVector3 l = GLKVector3Subtract(_lower, c);
    GLKVector3 u = GLKVector3Subtract(_upper, c);
    GLKVector3 v[8];
    v[0] = GLKVector3Make(l.x, l.y, l.z);
    v[1] = GLKVector3Make(u.x, l.y, l.z);
    v[2] = GLKVector3Make(u.x, u.y, l.z);
    v[3] = GLKVector3Make(l.x, u.y, l.z);
    v[4] = GLKVector3Make(l.x, l.y, u.z);
    v[5] = GLKVector3Make(u.x, l.y, u.z);
    v[6] = GLKVector3Make(u.x, u.y, u.z);
    v[7] = GLKVector3Make(l.x, u.y, u.z);
    _lower = GLKVector3Make(FLT_MAX, FLT_MAX, FLT_MAX);
    _upper = GLKVector3Make(FLT_MIN, FLT_MIN, FLT_MIN);
    for(int i=0; i<8; ++i)
    {
        GLKVector3 p = GLKMatrix3MultiplyVector3(xform, v[i]);
        p = GLKVector3Add(p, c);
        [self includePoint:p];
    }
}

-(ASBounds*) transformed:(GLKMatrix3)xform
{
    ASBounds* b = [self copy];
    [b transform:xform];
    return b;
}

-(BOOL) coversBounds:(ASBounds*)b
{
    GLKVector3 l = [b lower];
    GLKVector3 u = [b upper];
    return ((_lower.x<=l.x) &&
            (_lower.y<=l.y) &&
            (_lower.z<=l.z) &&
            (_upper.x>=u.x) &&
            (_upper.y>=u.y) &&
            (_upper.z>=u.z));
}

-(BOOL) isEqual:(id)object
{
    if(object==self)
        return YES;
    if(![object isKindOfClass:[self class]])
        return NO;
    return (GLKVector3AllEqualToVector3(_lower, [object lower]) &&
            GLKVector3AllEqualToVector3(_upper, [object upper]));
}

@end
