package arm.node;

@:keep class Corona extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _Print = new armory.logicnode.PrintNode(this);
		var _SetLocation = new armory.logicnode.SetLocationNode(this);
		var _Print_001 = new armory.logicnode.PrintNode(this);
		var _OnInit = new armory.logicnode.OnInitNode(this);
		_OnInit.addOutputs([_Print_001]);
		_Print_001.addInput(_OnInit, 0);
		var _GetLocation_001 = new armory.logicnode.GetLocationNode(this);
		_GetLocation_001.addInput(new armory.logicnode.ObjectNode(this, "CoronaVirus"), 0);
		_GetLocation_001.addOutputs([_Print_001]);
		_Print_001.addInput(_GetLocation_001, 0);
		_Print_001.addOutputs([_SetLocation]);
		_SetLocation.addInput(_Print_001, 0);
		_SetLocation.addInput(new armory.logicnode.ObjectNode(this, "CoronaVirus"), 0);
		var _Random_Vector_ = new armory.logicnode.RandomVectorNode(this);
		_Random_Vector_.addInput(new armory.logicnode.VectorNode(this, -5.0, -5.0, 0.0), 0);
		_Random_Vector_.addInput(new armory.logicnode.VectorNode(this, 5.0, 5.0, 1.0), 0);
		_Random_Vector_.addOutputs([_SetLocation]);
		_SetLocation.addInput(_Random_Vector_, 0);
		_SetLocation.addOutputs([_Print]);
		_Print.addInput(_SetLocation, 0);
		var _GetName = new armory.logicnode.GetNameNode(this);
		_GetName.addInput(new armory.logicnode.ObjectNode(this, "CoronaVirus"), 0);
		_GetName.addOutputs([_Print]);
		_Print.addInput(_GetName, 0);
		_Print.addOutputs([new armory.logicnode.NullNode(this)]);
		var _GetLocation = new armory.logicnode.GetLocationNode(this);
		_GetLocation.addInput(new armory.logicnode.ObjectNode(this, "CoronaVirus"), 0);
		_GetLocation.addOutputs([new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0)]);
	}
}