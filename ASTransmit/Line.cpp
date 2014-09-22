//
//  Line.cpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include "Line.hpp"
#include "Plot.hpp"
#include "Protocol.hpp"

using namespace as;

Line::Line(Plot& plot, const std::string& key)
: Element(plot, key)
{
    
}

Line::~Line()
{
    
}

void Line::plot(float x, float y, float z)
{
    transmitPointOp(OpCode::AddPointToLine, x, y, z);
}
