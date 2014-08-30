//
//  Plotter.cpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include "Plotter.hpp"
#include "Protocol.hpp"
#include <zmq.h>
#include <iostream>
#include <sstream>
#include <assert.h>
#include <cereal/archives/binary.hpp>
#include <cereal/types/string.hpp>

static const std::string kDefaultLineKey = "DefaultLine";
static const std::string kDefaultCloudKey = "DefaultCloud";

using namespace as;

Plotter::Plotter(const std::string& plotKey,
                 const std::string& plotTitle,
                 bool resetExisting,
                 const std::string& serverAddress)
: context_(nullptr)
, transmitter_(nullptr)
, plotKey_(plotKey)
{
    connect(serverAddress);
    start(plotTitle==AS_AUTO_DETECT?plotKey:plotTitle, resetExisting);
}

Plotter::~Plotter()
{
    this->disconnect();
}

bool Plotter::connect(const std::string& address)
{
    this->disconnect();
    std::string serverAddress = address;
    if(serverAddress==AS_AUTO_DETECT)
    {
        serverAddress = AS_DEFAULT_ADDRESS;
    }
    context_ = zmq_ctx_new();
    transmitter_ = zmq_socket(context_, ZMQ_PUSH);
    if(zmq_connect(transmitter_, serverAddress.c_str())==-1)
    {
        std::cerr << "Failed to connect to plotting server at address: " << serverAddress << std::endl;
        return false;
    }
    return true;
}

void Plotter::disconnect()
{
    if(context_!=nullptr)
    {
        zmq_close(transmitter_);
        zmq_ctx_destroy(context_);
        context_ = nullptr;
        transmitter_ = nullptr;
    }
}

void Plotter::start(const std::string& plotTitle, bool resetExisting)
{
    op::NewPlot cmd;
    cmd.title = plotTitle;
    cmd.resetExistingPlot = resetExisting;
    this->transmitCommand(OpCode::NewPlot, cmd);
}

void Plotter::plotLine(float x, float y, float z, const std::string& lineKey)
{
    const std::string& elemKey = lineKey==AS_AUTO_DETECT?kDefaultLineKey:lineKey;
    this->transmitPointOp(x, y, z, elemKey, OpCode::AddPointToLine);
}

void Plotter::plotPoint(float x, float y, float z, const std::string& cloudKey)
{
    const std::string& elemKey = cloudKey==AS_AUTO_DETECT?kDefaultCloudKey:cloudKey;
    this->transmitPointOp(x, y, z, elemKey, OpCode::AddPointToCloud);
}

void Plotter::plot(float x, float y, float z)
{
    this->plotLine(x, y, z, kDefaultLineKey);
}

void Plotter::deleteElement(const std::string& elemKey)
{
    op::DeleteElement cmd;
    cmd.elementKey = elemKey;
    this->transmitCommand(OpCode::DeleteElement, cmd);
}

template <typename OP> void Plotter::transmitPointOp(float x, float y, float z, const std::string& elemKey, OP opCode)
{
    op::PointOp cmd;
    cmd.elementKey = elemKey;
    cmd.x = x;
    cmd.y = y;
    cmd.z = z;
    this->transmitCommand(opCode, cmd);
}

template <typename OP, typename CMD> void Plotter::transmitCommand(OP opCode, const CMD& cmd)
{
    assert(plotKey_.length()>0);
    std::stringstream ss(std::ios::in | std::ios::out | std::ios::binary);
    {
        //Archive flushes content on destruction.
        cereal::BinaryOutputArchive archive(ss);
        archive(opCode);
        archive(plotKey_);
        archive(cmd);
    }
    transmitString(ss.str());
}

void Plotter::transmitString(const std::string& dataString)
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
