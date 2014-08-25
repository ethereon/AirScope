//
//  Plotter.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScope__Plotter__
#define __AirScope__Plotter__

#include <string>

#define AS_AUTO_DETECT  ""

namespace as
{
    class Plotter
    {

    public:

        Plotter(const std::string& plotKey,
                const std::string& plotTitle=AS_AUTO_DETECT,
                bool resetExisting=true,
                const std::string& serverAddress=AS_AUTO_DETECT);
        ~Plotter();

        void plot(float x, float y, float z);
        void plotLine(float x, float y, float z, const std::string& lineKey=AS_AUTO_DETECT);
        void plotPoint(float x, float y, float z, const std::string& cloudKey=AS_AUTO_DETECT);

    private:

        void* context_;
        void* transmitter_;
        std::string plotKey_;

        bool connect(const std::string& address);
        void disconnect();
        void start(const std::string& plotTitle, bool resetExisting=true);
        template <typename OP> void transmitPointOp(float x, float y, float z, const std::string& elemKey, OP opCode);
        template <typename OP, typename CMD> void transmitCommand(OP opCode, const CMD& cmd);
        void transmitString(const std::string& dataString);
    };
}

#endif /* defined(__AirScope__Plotter__) */
