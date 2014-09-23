//
//  Plot.h
//  AirScope
//
//  Created by Saumitro Dasgupta on 8/23/14.
//  Copyright (c) 2014 Saumitro Dasgupta. All rights reserved.
//

#ifndef __AirScope__Plot__
#define __AirScope__Plot__

#include <string>
#include <vector>

#define AS_AUTO_DETECT  ""

namespace as
{
    class Element;
    class AbstractCommand;
    class Transmitter;
    
    class Plot
    {
    public:
        
        Plot(const std::string& plotKey,
             const std::string& plotTitle=AS_AUTO_DETECT,
             bool resetExisting=true,
             std::string serverAddress=AS_AUTO_DETECT);
        
        ~Plot();
        
        const std::vector<Element*>& getElements() const;
        
        template<typename T> T* insertNewElement(const std::string& key)
        {
            T* elem = new T(*this, key);
            insertElement(elem);
            return elem;
        }
        void removeElement(Element* element);
        
        /// Prohibit copying.
        Plot& operator=(const Plot&)    = delete;
		Plot(const Plot&)               = delete;
        
    private:
        
        std::string plotKey_;
        std::unique_ptr<Transmitter> transmitter_;
        std::vector<Element*> elements_;
        
        void start(const std::string& plotTitle, bool resetExisting=true);
        void insertElement(Element* element);
        void transmit(AbstractCommand& cmd);
        
        friend Element;
    };
}

#endif /* defined(__AirScope__Plot__) */
