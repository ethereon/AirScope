//
//  PointCloud.cpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include "PointCloud.hpp"
#include "Plot.hpp"
#include "Protocol.hpp"

using namespace as;

PointCloud::PointCloud(Plot& plot, const std::string& key)
: Element(plot, key)
{
    
}

PointCloud::~PointCloud()
{
    
}

void PointCloud::plot(float x, float y, float z)
{
    transmitPointOp(OpCode::AddPointToCloud, x, y, z);
}

