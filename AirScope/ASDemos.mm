//
//  ASDemos.m
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/28/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#import "ASDemos.h"
#include <iostream>
#include <cmath>
#include <unistd.h>
#include <ASTransmit/Plotter.hpp>

@implementation ASDemos

static void plot_helix()
{
    as::Plotter plt("Helix");
    for(float theta=0; theta<10*M_PI; theta+=0.01)
    {
        plt.plot(theta, sin(theta), cos(theta));
    }
}

static void plot_lorenz_attractor(float sigma = 10.0f,
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

static void plot_sphere(float rho=1.0f, float inc=0.1)
{
    as::Plotter plt("Sphere");
    for(float theta=0.0f; theta<2*M_PI; theta+=inc)
    {
        for(float phi=0.0f; phi<2*M_PI; phi+=inc)
        {
            plt.plotPoint(rho*cos(theta)*sin(phi), rho*sin(theta)*sin(phi), rho*cos(phi));
        }
    }
}

static void launch_demos()
{
    static NSString* const kDemoMutex = @"DemoSyncLock";
    @synchronized(kDemoMutex)
    {
        plot_helix();
        plot_sphere();
        plot_lorenz_attractor();
    }
}

+(void) launchDemos
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       launch_demos();
                   });
}

@end
