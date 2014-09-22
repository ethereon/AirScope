//
//  Transmitter.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScope__Transmitter__
#define __AirScope__Transmitter__

#include <string>

namespace as
{
    class AbstractCommand;
    
    class Transmitter
    {
    public:
        
        Transmitter()           = default;
        virtual ~Transmitter()  = default;
        
        virtual void transmit(const AbstractCommand& cmd) = 0;
    };
}
#endif /* defined(__AirScope__Transmitter__) */
