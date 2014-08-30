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

/* Protocol Constants */

#define AS_DEFAULT_ADDRESS          "tcp://0.0.0.0:4242"

/* Helper Macros */

#define AS_SERIALIZE(...) \
template <typename Archive> \
void serialize(Archive& archive) \
{ archive(__VA_ARGS__); }

namespace as
{
    enum class OpCode : char
    {
        NewPlot,
        AddPointToLine,
        AddPointToCloud,
        DeleteElement
    };

    namespace op
    {
        struct NewPlot
        {
            std::string title;
            bool resetExistingPlot;
            AS_SERIALIZE(title, resetExistingPlot);
        };

        struct PointOp
        {
            std::string elementKey;
            float x;
            float y;
            float z;
            AS_SERIALIZE(elementKey, x, y, z);
        };
        
        struct DeleteElement
        {
            std::string elementKey;
            AS_SERIALIZE(elementKey);
        };
    }
}

#endif
