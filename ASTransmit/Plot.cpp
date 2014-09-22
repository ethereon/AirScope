//
//  Plot.cpp
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#include "Plot.hpp"
#include "Protocol.hpp"
#include "SocketTransmitter.hpp"
#include "Element.hpp"
#include "Command.hpp"
#include <iostream>
#include <cassert>

static const std::string kDefaultLineKey = "DefaultLine";
static const std::string kDefaultCloudKey = "DefaultCloud";

using namespace as;

Plot::Plot(const std::string& plotKey,
           const std::string& plotTitle,
           bool resetExisting,
           std::string serverAddress)
:plotKey_(plotKey)
{
    if(serverAddress==AS_AUTO_DETECT)
    {
        serverAddress = AS_DEFAULT_ADDRESS;
    }
    transmitter_ = std::unique_ptr<Transmitter>(new SocketTransmitter(serverAddress));
    start(plotTitle==AS_AUTO_DETECT?plotKey:plotTitle, resetExisting);
}

Plot::~Plot()
{
    for(Element* elem: elements_)
    {
        delete elem;
    }
}

const std::vector<Element*>& Plot::getElements() const
{
    return elements_;
}

void Plot::start(const std::string& plotTitle, bool resetExisting)
{
    Command<op::NewPlot> cmd(OpCode::NewPlot);
    cmd.command.title = plotTitle;
    cmd.command.resetExistingPlot = resetExisting;
    transmit(cmd);
}

void Plot::transmit(AbstractCommand& cmd)
{
    cmd.plotKey = plotKey_;
    transmitter_->transmit(cmd);
}

void Plot::insertElement(Element* element)
{
    elements_.push_back(element);
}

void Plot::removeElement(Element* element)
{
    auto it = std::find(elements_.begin(), elements_.end(), element);
    assert(it!=elements_.end() && "Attempt to remove unknown element.");
    elements_.erase(it);
    
    Command<op::ElementCommand> cmd(OpCode::DeleteElement);
    cmd.command.elementKey = element->key;
    transmit(cmd);
    delete element;
}
