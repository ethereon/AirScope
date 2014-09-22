//
//  PointCloud.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScope__PointCloud__
#define __AirScope__PointCloud__

#include "Element.hpp"

namespace as
{
    class PointCloud: public Element
    {
    public:
        
        PointCloud(Plot& plot, const std::string& key);
        ~PointCloud();
        
        void plot(float x, float y, float z);
    };
}


#endif /* defined(__AirScope__PointCloud__) */
