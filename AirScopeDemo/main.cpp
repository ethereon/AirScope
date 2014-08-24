//
//  main.cpp
//  AirScopeDemo
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include <iostream>
#include <cmath>
#include <unistd.h>
#include <ASTransmit/Plotter.hpp>

void plot_helix()
{
    as::Plotter plt("Helix");
    for(float theta=0; theta<10*M_PI; theta+=0.01)
    {
        plt.plot(theta, sin(theta), cos(theta));
    }
}

void plot_lorenz_attractor(float sigma = 10.0f,
                           float rho = 28.0f,
                           float beta = 8.0f/3.0f,
                           int numIters = 1000,
                           float delay = 2000)
{
    as::Plotter plt("Lorenz Attractor");
    const float dt=0.01f;
    float x=0.1f, y=0.0f, z=0.0f;
    for(int i=0; i<numIters; ++i)
    {
        float nx = x + dt*sigma*(y-x);
        float ny = y + dt*(x*(rho-z) - y);
        float nz = z + dt*(x*y - beta*z);
        x = nx; y = ny; z = nz;
        plt.plot(x, y, z);
        usleep(delay);
    }
}

int main(int argc, const char * argv[])
{
    plot_lorenz_attractor();
    return 0;
}

