//
//  SocketTransmitter.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScope__SocketTransmitter__
#define __AirScope__SocketTransmitter__

#include "Transmitter.hpp"
#include <string>

namespace as
{
    class SocketTransmitter: public Transmitter
    {
    public:
        
        SocketTransmitter(const std::string& serverAddress);
        ~SocketTransmitter();
        
        void transmit(const AbstractCommand& cmd);

    private:
        
        void* context_;
        void* transmitter_;
        
        bool connect(const std::string& serverAddress);
        void disconnect();
        void transmitString(const std::string& dataString);
    };
}

#endif /* defined(__AirScope__SocketTransmitter__) */
