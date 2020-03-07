package arm.node;

@:keep class Movement extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _TranslateObject = new armory.logicnode.TranslateObjectNode(this);
		var _OnKeyboard = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard.property0 = "Down";
		_OnKeyboard.property1 = "w";
		_OnKeyboard.addOutputs([_TranslateObject]);
		_TranslateObject.addInput(_OnKeyboard, 0);
		_TranslateObject.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		var _Vector = new armory.logicnode.VectorNode(this);
		_Vector.addInput(new armory.logicnode.FloatNode(this, 0.0), 0);
		_Vector.addInput(new armory.logicnode.FloatNode(this, -0.05000000074505806), 0);
		_Vector.addInput(new armory.logicnode.FloatNode(this, 0.0), 0);
		_Vector.addOutputs([_TranslateObject]);
		_TranslateObject.addInput(_Vector, 0);
		_TranslateObject.addInput(new armory.logicnode.BooleanNode(this, false), 0);
		_TranslateObject.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}