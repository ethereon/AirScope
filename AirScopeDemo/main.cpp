//
//  main.cpp
//  AirScopeDemo
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include <iostream>
#include <cmath>
#include <ASTransmit/Plotter.hpp>

int main(int argc, const char * argv[])
{
    as::Plotter plt("Helix");
    for(float theta=0; theta<10*M_PI; theta+=0.01)
    {
        plt.plot(theta, sin(theta), cos(theta));
    }
    return 0;
}

