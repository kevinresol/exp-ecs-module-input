package exp.ecs.module.input.component;

class Mouse implements Component {
	public var x:Int = 0;
	public var y:Int = 0;
	public var dx:Int = 0;
	public var dy:Int = 0;
	public var wheel:Int = 0;
	public final isDown:Map<MouseButton, Bool> = new Map();
	public final justDown:Map<MouseButton, Bool> = new Map();
	public final justUp:Map<MouseButton, Bool> = new Map();

	public function clone() {
		return new Mouse(x, y, dx, dy, wheel, isDown.copy(), justDown.copy(), justUp.copy());
	}
}

@:enum abstract MouseButton(Int) {
	var Left;
	var Right;
	var Middle;
}
