//
//  Line.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScope__Line__
#define __AirScope__Line__

#include "Element.hpp"

namespace as
{
    class Line: public Element
    {
    public:
        
        Line(Plot& plot, const std::string& key);
        ~Line();
        
        void plot(float x, float y, float z);
    };
}

#endif /* defined(__AirScope__Line__) */
