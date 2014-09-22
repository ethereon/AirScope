//
//  SocketTransmitter.cpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include "SocketTransmitter.hpp"
#include "Protocol.hpp"
#include "Command.hpp"
#include <cassert>
#include <iostream>
#include <zmq.h>

using namespace as;


SocketTransmitter::SocketTransmitter(const std::string& serverAddress)
{
    connect(serverAddress);
}

SocketTransmitter::~SocketTransmitter()
{
    disconnect();
}

bool SocketTransmitter::connect(const std::string& address)
{
    this->disconnect();
    std::string serverAddress = address;
    context_ = zmq_ctx_new();
    transmitter_ = zmq_socket(context_, ZMQ_PUSH);
    if(zmq_connect(transmitter_, serverAddress.c_str())==-1)
    {
        std::cerr << "Failed to connect to plotting server at address: " << serverAddress << std::endl;
        return false;
    }
    return true;
}

void SocketTransmitter::disconnect()
{
    if(context_!=nullptr)
    {
        zmq_close(transmitter_);
        zmq_ctx_destroy(context_);
        context_ = nullptr;
        transmitter_ = nullptr;
    }
}

void SocketTransmitter::transmit(const AbstractCommand& cmd)
{
    this->transmitString(cmd.serialize());
}

void SocketTransmitter::transmitString(const std::string& dataString)
{
    assert(transmitter_!=nullptr);
    size_t dataLen = dataString.size();
    zmq_msg_t req;
    zmq_msg_init_size(&req, dataLen);
    memcpy(zmq_msg_data(&req), dataString.data(), dataLen);
    if(zmq_msg_send(&req, transmitter_, 0)==-1)
    {
        std::cerr << "Failed to transmit message to plotting server: " << zmq_strerror(zmq_errno()) << std::endl;
    }
    zmq_msg_close(&req);
}
