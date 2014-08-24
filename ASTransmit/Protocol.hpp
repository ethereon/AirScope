//
//  Protocol.hpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef AirScope_Protocol_hpp
#define AirScope_Protocol_hpp

#include <string>
#include <vector>

/* Command Constants */

#define AS_CMD_NEW_PLOT             "+"
#define AS_CMD_ADD_LINE_POINT       "A"

/* Protocol Constants */

#define AS_DEFAULT_ADDRESS          "tcp://0.0.0.0:4242"

/* Helper Macros */

#define AS_SERIALIZE(...) \
template <typename Archive> \
void serialize(Archive& archive) \
{ archive(__VA_ARGS__); }

namespace as
{
    namespace cmd
    {
        struct NewPlot
        {
            std::string title;
            bool resetExistingPlot;
            AS_SERIALIZE(title, resetExistingPlot);
        };

        struct AddLinePoint
        {
            std::string lineKey;
            float x;
            float y;
            float z;
            AS_SERIALIZE(lineKey, x, y, z);
        };
    }
}

#endif
