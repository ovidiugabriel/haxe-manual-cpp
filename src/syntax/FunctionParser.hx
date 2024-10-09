
package syntax;

import cgenerator.CGenerator.*;

class FunctionParser {
    private var state : Int = 0;

    static final STATE_DEFAULT = 0;
    static final STATE_VAR_NAME = 1;
    static final STATE_VAR_TYPE = 2;
    static final STATE_VAR_VALUE = 3;

    private var variableDeclaration : VariableDeclaration;

    public function new() {}

    public function receiveToken(token : String) {

        switch (state) {
            case STATE_DEFAULT: {
                if ('var' == token) {
                    state = STATE_VAR_NAME;
                }
            }

            case STATE_VAR_NAME: {
                if (':' == token) {
                    state = STATE_VAR_TYPE;
                    return;
                }

                variableDeclaration = new VariableDeclaration();
                variableDeclaration.varName = token;
            }

            case STATE_VAR_TYPE: {
                if ('=' == token) {
                    state = STATE_VAR_VALUE;
                    return;
                }

                variableDeclaration.varType = token;
            }

            case STATE_VAR_VALUE: {
                variableDeclaration.varValue = parseExpression(token);

                state = STATE_DEFAULT;
            }
        }
    }

    public function parseExpression(str_expr : String) : Expression {
        var ereg = new EReg("([A-Za-z0-9]+).([A-Za-z0-9]+)(.*)", "gm");

        if (ereg.match(str_expr)) {
            var parsed = new FunctionCallExpression();
            parsed.className = ereg.matched(1);
            parsed.methodName = ereg.matched(2);

            return parsed;
        }

        return null;
    }

    public function getFunctionBody() {
        return getVariableDeclaration(variableDeclaration);
    }
}
