
package cgenerator;

/**
    Generates C code
**/
class CGenerator {

    static public function emitFunction(packageName : String, className : String, functionName : String,
        attributes : Array<String>)
    {
        var args = 'void'; // default args in C are 'void'
        var returnType = 'int'; // default type in C is 'int'
        var functionBody =  '';

        functionName = '${packageName}_${className}_${functionName}';

        if ('int' == returnType && '' == functionBody) {
            functionBody = 'return 0;';
        }

        Sys.println('${returnType} ${functionName}(${args}) {');
        Sys.println('    ${functionBody}');
        Sys.println('}');
    }

    static public function emitMain() {
        Sys.println('int main(int argc, const char* argv[]) {');
        Sys.println('    return 0;');
        Sys.println('}');
    }
}
