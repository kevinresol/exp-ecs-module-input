package exp.ecs.module.input.component;

class MouseInteractive implements Component {
	public var hovered:Bool = false;
	public var down:Bool = false;
	public var clicked:Bool = false;

	public function new() {}

	public function clone()
		return new MouseInteractive();
}
