//
//  Shader.h
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl3.h>

@interface Shader : NSObject

+(instancetype) shaderNamed:(NSString*)shaderName;

-(id) initWithShaderName:(NSString*)shaderName;

-(GLuint) program;

-(BOOL) load;

-(void) use;

-(NSString*) pathForShaderOfType:(NSString*)shaderType;

-(GLint) locationForAttribute:(const char*)attrib;

-(GLint) locationForUniform:(const char*)uniform;

@property (strong, readonly) NSString* name;

@end
