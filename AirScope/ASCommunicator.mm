//
//  ASCommunicator.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/22/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASCommunicator.h"
#import "ASMissionControl.h"
#import "ASPlotController.h"
#import "ASMessage.h"
#import <zmq.h>
#import <ASTransmit/Protocol.hpp>

using namespace as;


@interface ASCommunicator ()
@property (assign) BOOL isRunning;
@property (assign) void* context;
@property (assign) void* receiver;
@end

@implementation ASCommunicator

-(id) init
{
    if(!(self=[super init])) return nil;
    _isRunning = NO;
    _serverAddress = [NSString stringWithUTF8String:AS_DEFAULT_ADDRESS];
    return self;
}

-(BOOL) start
{
    assert(_serverAddress!=nil);
    @synchronized(self)
    {
        if(_isRunning)
        {
            NSLog(@"WARNING: Attempt to start already running communicator!");
            return NO;
        }
        _context = zmq_ctx_new();
        _receiver = zmq_socket(_context, ZMQ_PULL);
        assert((_receiver!=NULL) && (_context!=NULL));
        if(zmq_bind(_receiver, [_serverAddress UTF8String])==-1)
        {
            NSLog(@"Failed to bind communicator to %@. Error: %s.", _serverAddress, zmq_strerror(zmq_errno()));
            return NO;
        }
        [self performSelectorInBackground:@selector(processMessages) withObject:nil];
        NSLog(@"Communicator started at %@", _serverAddress);
        _isRunning = YES;
        return YES;
    }
}

-(void) processMessages
{
    int rc;
    for(;;)
    {
        zmq_msg_t msg;
        rc = zmq_msg_init(&msg);
        assert(rc==0);
        rc = zmq_msg_recv(&msg, _receiver, 0);
        assert(rc!=-1);
        ASMessage* message = [ASMessage messageFromData:zmq_msg_data(&msg) ofLength:zmq_msg_size(&msg)];
        [self handleMessage:message];
        zmq_msg_close(&msg);
    }
    zmq_close(_receiver);
    zmq_ctx_destroy(_context);
}

-(void) handleMessage:(ASMessage*)msg
{
    const std::string& cmd = [msg command];
    if(cmd==AS_CMD_NEW_PLOT)
    {
        [self handleNewPlotCommand:msg];
    }
    else if(cmd==AS_CMD_ADD_LINE_POINT)
    {
        [self handleAddLinePointCommand:msg];
    }
    else
    {
        NSLog(@"Received unknown command: %s", cmd.c_str());
    }
}

#pragma mark - Command Handlers

-(void) handleNewPlotCommand:(ASMessage*)msg
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       cmd::NewPlot cmd;
                       [msg archive](cmd);
                       ASPlotController* plotController = [[ASMissionControl central] beginPlotWithKey:[msg plotKey]
                                                                                         resetExisting:cmd.resetExistingPlot];
                       [plotController setTitle:NSStringFromString(cmd.title)];
                   });
}

-(void) handleAddLinePointCommand:(ASMessage*)msg
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       ASPlotController* plotController = [[ASMissionControl central] plotControllerForKey:[msg plotKey]];
                       if(plotController==nil)
                       {
                           NSLog(@"Received plotting command for unknown plot key: %@", [msg plotKey]);
                           return;
                       }
                       cmd::AddLinePoint cmd;
                       [msg archive](cmd);
                       [plotController addPoint:GLKVector3Make(cmd.x, cmd.y, cmd.z)
                                  toLineWithKey:NSStringFromString(cmd.lineKey)];
                       [plotController update];
                   });
}

#pragma mark - Utility

static NSString* NSStringFromString(const std::string& s)
{
    return [NSString stringWithUTF8String:s.c_str()];
}

@end
