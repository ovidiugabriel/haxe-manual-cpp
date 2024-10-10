
package cgenerator;

import syntax.FunctionParser;
import syntax.FunctionCallExpression;
import syntax.VariableDeclaration;

/**
    Generates C code
**/
class CGenerator {

    static private var includes : Array<String> = null;

    static public function getIncludes() {
        var out = '';

        if (null != includes) {
            for (include in includes) {
                out += '#include "${include}"\n';
            }
        }
        return out + "\n";
    }

    static public function addInclude(include : String) {
        if (null == includes) {
            includes = new Array<String>();
        }
        includes.push(include);
    }

    static public function getFunction(packageName : String, className : String, functionName : String,
        attributes : Array<String>, functionParser : FunctionParser)
    {
        var args = '';
        var returnType = 'void';
        var functionBody =  functionParser.getFunctionBody();

        functionName = getFunctionFullName(packageName, className, functionName);

        if ('int' == returnType && '' == functionBody) {
            functionBody = 'return 0;';
        }

        return '${returnType} ${functionName}(${args}) {\n' +
               '    ${functionBody}\n' +
               '}\n\n';
    }

    static public function getMainCall(mainFunctionFullName : String) {
        return 'int main() {\n' +
               '    ${mainFunctionFullName}(); \n' +
               '    return 0;\n' +
               '}\n\n';
    }

    static public function getFunctionFullName(packageName : String, className : String, functionName : String) {
        return '${packageName}_${className}_${functionName}';
    }

    static public function getVariableDeclaration(declaration : VariableDeclaration) {
        var expr = cast(declaration.varValue, FunctionCallExpression);

        addInclude('lib/${expr.className}.h');

        return 'auto ${declaration.varName} = ${expr.className}::${expr.methodName}();';
    }
}
