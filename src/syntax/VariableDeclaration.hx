
package syntax;

class VariableDeclaration {
    public var varName : String;
    public var varType : String;
    public var varValue : Expression;

    public function new() {
        varValue = new Expression();
    }
}
