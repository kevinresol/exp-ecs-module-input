package exp.ecs.module.input.system;

import exp.ecs.module.input.component.*;

private typedef Components = {
	final mouse:Mouse;
}

/**
 * Capture user input
 */
@:nullSafety(Off)
class CaptureMouseInput extends System {
	var nodes:Array<Node<Components>>;

	var leftDown = false;
	var rightDown = false;
	var middleDown = false;
	var leftUp = false;
	var rightUp = false;
	var middleUp = false;
	var x:Int;
	var y:Int;

	public function new(nodes:NodeList<Components>) {
		// TODO: cleanup
		nodes.bind(v -> this.nodes = v, tink.state.Scheduler.direct);
		kha.input.Mouse.get(0).notify(onDown, onUp, onMove, onWheel, onLeave);
	}

	override function update(dt:Float) {
		for (node in nodes) {
			final mouse = node.components.mouse;

			mouse.leftButton.reset();
			mouse.rightButton.reset();
			mouse.middleButton.reset();

			mouse.x = x;
			mouse.y = y;

			if (leftDown) {
				mouse.leftButton.isDown = true;
				mouse.leftButton.justDown = true;
				leftDown = false;
			}
			if (rightDown) {
				mouse.rightButton.isDown = true;
				mouse.rightButton.justDown = true;
				rightDown = false;
			}
			if (middleDown) {
				mouse.middleButton.isDown = true;
				mouse.middleButton.justDown = true;
				middleDown = false;
			}
			if (leftUp) {
				mouse.leftButton.isDown = false;
				mouse.leftButton.justUp = true;
				leftUp = false;
			}
			if (rightUp) {
				mouse.rightButton.isDown = false;
				mouse.rightButton.justUp = true;
				rightUp = false;
			}
			if (middleUp) {
				mouse.middleButton.isDown = false;
				mouse.middleButton.justUp = true;
				middleUp = false;
			}
		}
	}

	function onDown(button, x, y) {
		switch button {
			case 0:
				leftDown = true;
			case 1:
				rightDown = true;
			case 2:
				middleDown = true;
		}
	}

	function onUp(button, x, y) {
		switch button {
			case 0:
				leftUp = true;
			case 1:
				rightUp = true;
			case 2:
				middleUp = true;
		}
	}

	function onMove(x, y, dx, dy) {
		this.x = x;
		this.y = y;
		// trace('moved $x, $y');
	}

	function onWheel(delta) {}

	function onLeave() {}

	public static function getNodes(world:World) {
		// @formatter:off
		return NodeList.generate(world, Mouse);
		// @formatter:on
	}
}
