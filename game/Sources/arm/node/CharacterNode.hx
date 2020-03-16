package arm.node;

@:keep class CharacterNode extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _PlayAction = new armory.logicnode.PlayActionNode(this);
		var _OnKeyboard = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard.property0 = "Started";
		_OnKeyboard.property1 = "w";
		_OnKeyboard.addOutputs([_PlayAction]);
		_PlayAction.addInput(_OnKeyboard, 0);
		_PlayAction.addInput(new armory.logicnode.ObjectNode(this, "Armature"), 0);
		_PlayAction.addInput(new armory.logicnode.StringNode(this, "runAway"), 0);
		_PlayAction.addInput(new armory.logicnode.FloatNode(this, 0.6000000238418579), 0);
		_PlayAction.addOutputs([new armory.logicnode.NullNode(this)]);
		_PlayAction.addOutputs([new armory.logicnode.NullNode(this)]);
		var _PlayAction_001 = new armory.logicnode.PlayActionNode(this);
		var _OnKeyboard_001 = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard_001.property0 = "Released";
		_OnKeyboard_001.property1 = "w";
		_OnKeyboard_001.addOutputs([_PlayAction_001]);
		_PlayAction_001.addInput(_OnKeyboard_001, 0);
		_PlayAction_001.addInput(new armory.logicnode.ObjectNode(this, "Armature"), 0);
		_PlayAction_001.addInput(new armory.logicnode.StringNode(this, "idle"), 0);
		_PlayAction_001.addInput(new armory.logicnode.FloatNode(this, 0.6000000238418579), 0);
		_PlayAction_001.addOutputs([new armory.logicnode.NullNode(this)]);
		_PlayAction_001.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}