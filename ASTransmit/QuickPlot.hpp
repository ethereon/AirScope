//
//  QuickPlot.hpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef AirScope_QuickPlot_hpp
#define AirScope_QuickPlot_hpp

#include "Plot.hpp"

namespace as
{
    template <typename ElementType>
    class QuickPlot
    {
    public:
        
        QuickPlot(const std::string& title="Untitled Plot", const std::string& elemKey="Data")
        : plot_(title)
        {
            elem_ = plot_.insertNewElement<ElementType>(elemKey);
        }
        
        void plot(float x, float y, float z)
        {
            elem_->plot(x, y, z);
        }
        
    private:
        
        Plot plot_;
        ElementType* elem_;
    };
}

#endif
