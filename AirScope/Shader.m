//
//  Shader.m
//
//  Created by Saumitro Dasgupta on 8/17/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "Shader.h"

@implementation Shader
{
    GLuint _program;
}

+(instancetype) shaderNamed:(NSString*)shaderName
{
    return [[Shader alloc] initWithShaderName:shaderName];
}

-(id) initWithShaderName:(NSString*)shaderName
{
    if(!(self=[super init])) return nil;
    _name = shaderName;
    return self;
}

-(GLuint) program
{
    return _program;
}

-(void) use
{
    glUseProgram(_program);
}

-(NSString*) pathForShaderOfType:(NSString*)shaderType
{
    return [[NSBundle mainBundle] pathForResource:_name ofType:shaderType];
}

-(BOOL) load
{
    GLuint vertShader, fragShader;

    // Create shader program.
    _program = glCreateProgram();

    // Create and compile vertex shader.
    NSString* vertShaderPath = [self pathForShaderOfType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPath])
    {
        NSLog(@"Failed to compile vertex shader.");
        return NO;
    }

    // Create and compile fragment shader.
    NSString* fragShaderPath = [self pathForShaderOfType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPath])
    {
        NSLog(@"Failed to compile fragment shader,");
        return NO;
    }

    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);

    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);

    // Link program.
    if(![self linkProgram:_program])
    {
        NSLog(@"Failed to link program: %d", _program);

        if(vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if(fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if(_program)
        {
            glDeleteProgram(_program);
            _program = 0;
        }
        return NO;
    }

    // Release vertex and fragment shaders.
    if(vertShader)
    {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if(fragShader)
    {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    return YES;
}

NS_INLINE GLint CheckLocation(GLint loc, const char* s)
{
    if(loc==-1)
    {
        fprintf(stderr, "Shader: could not get location for %s.\n", s);
    }
    return loc;
}

-(GLint) locationForAttribute:(const char*)attrib
{
    return CheckLocation(glGetAttribLocation(_program, attrib), attrib);
}

-(GLint) locationForUniform:(const char*)uniform
{
    return CheckLocation(glGetUniformLocation(_program, uniform), uniform);
}

#pragma mark - Shader Utility

-(BOOL) compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;

    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }

    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);

#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif

    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }

    return YES;
}

-(BOOL) linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);

#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif

    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }

    return YES;
}

-(BOOL) validateProgram:(GLuint)prog
{
    GLint logLength, status;

    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }

    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
