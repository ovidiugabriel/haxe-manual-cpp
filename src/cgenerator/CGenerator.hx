
package cgenerator;

/**
    Generates C code
**/
class CGenerator {
    /**
        Detect if the function in main function (entry point)
    **/
    static private function isMainFunction(functionName : String) {
        return ('main' == functionName);
    }

    static public function emitFunction(packageName : String, className : String, functionName : String,
        attributes : Array<String>)
    {
        var args = '';
        var returnType = '';
        var functionBody =  '';

        if (isMainFunction(functionName)) {
            args = 'int argc, const char* argv[]';
            returnType = 'int';
            functionBody = 'return 0;';
        }

        Sys.println('${returnType} ${packageName}_${className}_${functionName}(${args}) {');
        Sys.println('    ${functionBody}');
        Sys.println('}');
    }
}
