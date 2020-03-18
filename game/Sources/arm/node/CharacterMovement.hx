package arm.node;

@:keep class CharacterMovement extends armory.logicnode.LogicTree {

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
		_TranslateObject.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.30000001192092896, 0.0), 0);
		_TranslateObject.addInput(new armory.logicnode.BooleanNode(this, true), 0);
		_TranslateObject.addOutputs([new armory.logicnode.NullNode(this)]);
		var _RotateObjectAroundAxis = new armory.logicnode.RotateObjectAroundAxisNode(this);
		var _OnKeyboard_002 = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard_002.property0 = "Down";
		_OnKeyboard_002.property1 = "a";
		_OnKeyboard_002.addOutputs([_RotateObjectAroundAxis]);
		_RotateObjectAroundAxis.addInput(_OnKeyboard_002, 0);
		_RotateObjectAroundAxis.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_RotateObjectAroundAxis.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.0, 1.0), 0);
		_RotateObjectAroundAxis.addInput(new armory.logicnode.FloatNode(this, 0.019999999552965164), 0);
		_RotateObjectAroundAxis.addOutputs([new armory.logicnode.NullNode(this)]);
		var _RotateObjectAroundAxis_001 = new armory.logicnode.RotateObjectAroundAxisNode(this);
		var _OnKeyboard_003 = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard_003.property0 = "Down";
		_OnKeyboard_003.property1 = "d";
		_OnKeyboard_003.addOutputs([_RotateObjectAroundAxis_001]);
		_RotateObjectAroundAxis_001.addInput(_OnKeyboard_003, 0);
		_RotateObjectAroundAxis_001.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_RotateObjectAroundAxis_001.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.0, 1.0), 0);
		_RotateObjectAroundAxis_001.addInput(new armory.logicnode.FloatNode(this, -0.019999999552965164), 0);
		_RotateObjectAroundAxis_001.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}