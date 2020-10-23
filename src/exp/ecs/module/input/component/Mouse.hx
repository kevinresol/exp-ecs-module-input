package exp.ecs.module.input.component;

class Mouse implements Component {
	public var x:Int;
	public var y:Int;
	public var leftButton:Button = new Button();
	public var rightButton:Button = new Button();
	public var middleButton:Button = new Button();

	public function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public function clone() {
		return new Mouse(x, y);
	}
}

class Button {
	// up/down status for current frame
	public var isDown:Bool = false;
	public var justDown:Bool = false;
	public var justUp:Bool = false;

	public function new() {}

	public inline function reset() {
		justDown = justUp = false;
	}
}
