//
//  ASMessage.mm
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASMessage.h"
#import <sstream>
#import "ASMissionControl.h"

@implementation ASMessage
{
    std::stringstream _ss;
    as::OpCode _opCode;
    MsgArchive* _archive;
}

+(ASMessage*) messageFromData:(void*)msgData ofLength:(size_t)msgLen
{
    ASMessage* msg = [[ASMessage alloc] init];
    msg->_ss.write((const char*)msgData, msgLen);
    msg->_archive = new MsgArchive(msg->_ss);
    [msg archive](msg->_opCode);
    std::string plotKey;
    [msg archive](plotKey);
    [msg setPlotKey:[NSString stringWithUTF8String:plotKey.c_str()]];
    return msg;
}

-(void) dealloc
{
    if(_archive!=nullptr)
    {
        delete _archive;
    }
}

-(as::OpCode) opCode;
{
    return _opCode;
}

-(MsgArchive&) archive
{
    return *_archive;
}

-(ASPlotController*) plotController
{
    return [[ASMissionControl central] plotControllerForKey:[self plotKey] autoCreate:YES];
}

@end
