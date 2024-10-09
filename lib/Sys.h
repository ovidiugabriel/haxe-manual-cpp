
#pragma once

#include <memory>

#include <windows.h>

#include "Array.h"
#include "String.h"

namespace {

template<typename T>
void ParseCommandLine(LPWSTR wstr, T out)
{
    int argc = -1;
    LPWSTR *argvw = CommandLineToArgvW(wstr, &argc);
}

} // namespace

class Sys {
public:
    /**
     * Returns all the arguments that were passed in the command line.
     * This does not include the interpreter or the name of the program file.
    */
    static std::shared_ptr< Array<String> >  args()
    {
        auto result = std::make_shared<Array<String> >();

        // for windows
        LPWSTR wstr = GetCommandLineW();
        ParseCommandLine(wstr, result.get());

        return result;
    }
};
