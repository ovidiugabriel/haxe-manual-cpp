
//
// This tool will convert Haxe code to native C code without having to rely on
// hxcpp or HL.
//
// The most important aspect of this project is that we generate C code without
// the need for a garbage collector. It is very important when you need to call
// Haxe generated code from C/C++.
//

import syntax.Tokenizer;
import cgenerator.CGenerator.*;

class Main {
    static public function main() {
        // Get the command-line arguments (not inluding the command name)
        final args : Array<String> = Sys.args();
        Tokenizer.tokenize(args[0], true);

        emitIncludes();

        Tokenizer.emit();

        Sys.print(getMainCall(Tokenizer.mainFunctionName));
    }
}
