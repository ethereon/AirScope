//
//  Element.cpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/19/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include "Element.hpp"
#include "Plot.hpp"
#include "Protocol.hpp"
#include "Command.hpp"

using namespace as;

Element::Element(Plot& plot, const std::string& key)
: plot_(plot)
, key(key)
{
}

Element::~Element()
{
}

void Element::removeFromPlot()
{
    plot_.removeElement(this);
}

void Element::transmit(AbstractCommand& cmd)
{
    plot_.transmit(cmd);
}

void Element::transmitPointOp(OpCode opCode, float x, float y, float z)
{
    Command<op::PointCommand> cmd(opCode);
    cmd.command.x = x;
    cmd.command.y = y;
    cmd.command.z = z;
    cmd.command.elementKey = this->key;
    transmit(cmd);
}
