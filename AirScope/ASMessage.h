//
//  ASMessage.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>
#include <cereal/archives/binary.hpp>
#include <cereal/types/string.hpp>
#import <ASTransmit/Protocol.hpp>

typedef cereal::BinaryInputArchive MsgArchive;

@interface ASMessage : NSObject

+(ASMessage*) messageFromData:(void*)msgData ofLength:(size_t)msgLen;

-(as::OpCode) opCode;

-(MsgArchive&) archive;

@property (strong) NSString* plotKey;

@end
