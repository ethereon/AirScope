//
//  ASCommunicator.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/22/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCommunicator : NSObject

-(BOOL) start;

@property (strong) NSString* serverAddress;

@end
