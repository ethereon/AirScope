//
//  Plotter.hpp
//  AirScopeClient
//
//  Created by Saumitro Dasgupta on 8/22/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScopeClient__Plotter__
#define __AirScopeClient__Plotter__

#include <string>

namespace as
{
    class Plotter
    {
        
    public:
        
        Plotter();
        ~Plotter();
        
        bool connect(const std::string& address="");
        void disconnect();
        void start(const std::string& plotKey, bool resetExisting=true);
        void plot(float x, float y, float z);
        void plotLine(float x, float y, float z, const std::string& lineKey);
        
    private:
        
        void* context_;
        void* transmitter_;
        std::string plotKey_;
        
        template <typename CMD> void transmitCommand(const char* name, const CMD& cmd);
        void transmitString(const std::string& dataString);
    };
}

#endif /* defined(__AirScopeClient__Plotter__) */
