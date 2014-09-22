//
//  Command.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 9/22/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef AirScope_Command_h
#define AirScope_Command_h

#include <cereal/archives/binary.hpp>
#include <cereal/types/string.hpp>
#include <assert.h>
#include <sstream>

namespace as
{
    enum class OpCode: int;

    class AbstractCommand
    {
    public:
        OpCode      opCode;
        std::string plotKey;

        virtual ~AbstractCommand() = default;
        
        virtual const std::string serialize() const = 0;
        
    protected:
        AbstractCommand(OpCode opCode, const std::string& plotKey)
        : opCode(opCode)
        , plotKey(plotKey)
        {
        }
    };
    
    template <typename T>
    class Command : public AbstractCommand
    {
    public:
        
        T command;
        
        Command(OpCode opCode, const std::string& plotKey)
        :AbstractCommand(opCode, plotKey)
        {
        }

        Command(OpCode opCode)
        :Command(opCode, std::string(""))
        {
        }

        virtual ~Command() = default;
        
        const std::string serialize() const
        {
            assert(plotKey.length()>0);
            std::stringstream ss(std::ios::in | std::ios::out | std::ios::binary);
            {
                //Archive flushes content on destruction.
                cereal::BinaryOutputArchive archive(ss);
                archive(opCode);
                archive(plotKey);
                archive(command);
            }
            return ss.str();
        }
        
    private:
        
    };
}

#endif
