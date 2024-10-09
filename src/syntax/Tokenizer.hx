package syntax;

import sys.io.File;
import cgenerator.CGenerator.*;

class Tokenizer {
    // List of common Haxe keywords
    private static var keywords = [
        "var", "function", "class", "if", "else", "for", "while", "do", "switch",
        "case", "default", "break", "continue", "return", "import", "package",
        "static", "public", "private", "new", "extends", "implements", "typedef",
        "macro", "enum", "using", "try", "catch", "throw"
    ];

    private static var functionParser : FunctionParser;

    private static var state : Int = 0;
    private static var stack : Array<String>;
    private static var functionAttributes : Array<String>;
    private static var isMainFunction : Bool = false;
    public static var mainFunctionName : String = '';

    private static var packageName : String;
    private static var className : String;
    private static var functionName : String;

    private static var outputBuffer : String = '';

    static final STATE_DEFAULT = 0;
    static final STATE_PACKAGE = 1;
    static final STATE_CLASS = 2;
    static final STATE_CLASS_BODY = 3;
    static final STATE_FUNCTION = 4;
    static final STATE_FUNCTION_BODY = 5;

    private static function onStateDefault(token : String) {
        switch (token) {
            case 'package': {
                state = STATE_PACKAGE;
            }

            case 'class': {
                state = STATE_CLASS;
            }
        }
    }

    private static function onStateClass(token : String) {
        if ('{' == token)  {
            state = STATE_CLASS_BODY;
            stack.push('class');

            functionAttributes = new Array<String>();
            return;
        }
        className = token;
    }

    private static function onStateClassBody(token : String) {
        switch (token) {
            case 'function': {
                state = STATE_FUNCTION;
            }

            default: {
                functionAttributes.push(token);
            }
        }
    }

    private static function onStateFunction(token : String) {
        if ('{' == token) {
            state = STATE_FUNCTION_BODY;
            stack.push('function');
            if (isMainFunction) {
                mainFunctionName = getFunctionFullName(packageName, className, functionName);
            }

            return;
        }

        var pos = token.indexOf('(');

        functionName = (pos >= 0)  ? token.substring(0, pos) : token;
    }

    private static function onStatePackage(token : String, ended : Bool) {
        if (ended) {
            packageName = token;
            state = STATE_DEFAULT;
        }
    }

    private static function onStateFunctionBody(token : String) {
        if ('}' == token) {
            var top = stack.pop();

            if ('function' == top) {
                state = STATE_CLASS_BODY;

                outputBuffer += getFunction(packageName, className, functionName, functionAttributes, functionParser);

                return;
            }
        }

        functionParser.receiveToken(token);
    }

    private static function dispatchState(token : String, ended : Bool) {
        switch (state) {
            case STATE_DEFAULT: {
                onStateDefault(token);
            }

            case STATE_PACKAGE: {
                onStatePackage(token, ended);
            }

            case STATE_CLASS: {
                onStateClass(token);
            }

            case STATE_CLASS_BODY: {
                onStateClassBody(token);
            }

            case STATE_FUNCTION: {
                onStateFunction(token);
            }

            case STATE_FUNCTION_BODY: {
                onStateFunctionBody(token);
            }
        }
    }

    public static function tokenize(filePath : String, isMain : Bool) {
        isMainFunction = isMain;

        stack = new Array<String>();
        functionParser = new FunctionParser();

        try {
            final content = File.getContent(filePath);

            var ereg = new EReg("[^a-zA-Z0-9_{}<>;:=.()]+", "gm");
            var tokens = ereg.split(content);

            for (token in tokens) {
                token = StringTools.trim(token);
                final ended = StringTools.endsWith(token, ';');
                if (ended) {
                    token = token.substr(0, -1);
                }

                dispatchState(token, ended);
            }
        }
        catch (e : Dynamic) {
            trace("Error: " + e);
        }
    }

    public static function emit() {
        Sys.println(outputBuffer);
    }
}
