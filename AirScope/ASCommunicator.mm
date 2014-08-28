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
    OpCode operation = [msg opCode];
    switch (operation)
    {
        case OpCode::NewPlot:
            [self handleNewPlotMessage:msg];
            break;
        case OpCode::AddPointToCloud:
        case OpCode::AddPointToLine:
            [self handleAddPointMessage:msg forOperation:operation];
            break;
        default:
            NSLog(@"Received unknown operation code: %d", (int)operation);
    }
}

#pragma mark - Command Handlers

-(void) handleNewPlotMessage:(ASMessage*)msg
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       op::NewPlot cmd;
                       [msg archive](cmd);
                       ASPlotController* plotController = [[ASMissionControl central] beginPlotWithKey:[msg plotKey]
                                                                                         resetExisting:cmd.resetExistingPlot];
                       [plotController setTitle:NSStringFromString(cmd.title)];
                   });
}

-(void) handleAddPointMessage:(ASMessage*)msg forOperation:(OpCode)opCode
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       ASPlotController* plotController = [[ASMissionControl central] plotControllerForKey:[msg plotKey] autoCreate:YES];
                       op::PointOp cmd;
                       [msg archive](cmd);
                       GLKVector3 pt = GLKVector3Make(cmd.x, cmd.y, cmd.z);
                       NSString* elemKey = NSStringFromString(cmd.elementKey);
                       switch (opCode)
                       {
                           case OpCode::AddPointToLine:
                               [plotController addPoint:pt toLineWithKey:elemKey];
                               break;
                           case OpCode::AddPointToCloud:
                               [plotController addPoint:pt toCloudWithKey:elemKey];
                               break;
                           default:
                               NSLog(@"Invalid operation code for add point message encountered.");                               
                               break;
                       }
                       [plotController update];
                   });
}



#pragma mark - Utility

static NSString* NSStringFromString(const std::string& s)
{
    return [NSString stringWithUTF8String:s.c_str()];
}

@end
