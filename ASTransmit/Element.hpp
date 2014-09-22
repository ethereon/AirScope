//
//  Element.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScope__Element__
#define __AirScope__Element__

#include <string>
#include "Transmitter.hpp"

namespace as
{
    class Plot;
    class AbstractCommand;
    enum class OpCode: int;

    class Element
    {
    public:
        
        virtual ~Element();
        const std::string key;
        
        void removeFromPlot();
        
    protected:

        Plot& plot_;

        Element(Plot& plot, const std::string& key);
        
        void transmit(AbstractCommand& cmd);
        void transmitPointOp(OpCode opCode, float x, float y, float z);
    };
}

#endif /* defined(__AirScope__Element__) */
