package exp.ecs.module.input.system;

import exp.ecs.module.input.component.Mouse;

private typedef Components = {
	final mouse:Mouse;
}

/**
 * Capture user input
 */
@:nullSafety(Off)
class CaptureMouseInput extends exp.ecs.system.SingleListSystem<Components> {
	var x:Int = 0;
	var y:Int = 0;
	var dx:Int = 0;
	var dy:Int = 0;
	var wheel:Int = 0;
	var events:Array<MouseEvent> = [];
	var lastEvents:Array<MouseEvent> = [];

	public function new() {
		super(NodeList.spec(Mouse));
	}

	override function initialize(world) {
		final mouse = kha.input.Mouse.get(0);
		mouse.notify(onDown, onUp, onMove, onWheel, onLeave);
		return super.initialize(world) & mouse.remove.bind(onDown, onUp, onMove, onWheel, onLeave);
	}

	override function update(dt:Float) {
		for (node in nodes) {
			final mouse = node.data.mouse;
			mouse.x = x;
			mouse.y = y;
			mouse.dx = dx;
			mouse.dy = dy;
			mouse.wheel = wheel;

			// reset justDown/Up
			for (last in lastEvents) {
				final button = last.button;
				switch last.type {
					case Down:
						mouse.justDown[button] = false;
					case Up:
						mouse.justUp[button] = false;
				}
			}

			// set for current frame
			for (event in events) {
				final button = event.button;
				switch event.type {
					case Down:
						mouse.isDown[button] = mouse.justDown[button] = true;
					case Up:
						mouse.isDown[button] = !(mouse.justUp[button] = true);
				}
			}
		}

		// reset deltas
		dx = dy = wheel = 0;

		// rotate array
		final tmp = lastEvents;
		lastEvents = events;
		events = tmp;
		events.resize(0);
	}

	function onDown(button:Int, x, y) {
		events.push({button: cast button, type: Down});
	}

	function onUp(button:Int, x, y) {
		events.push({button: cast button, type: Up});
	}

	function onMove(x, y, dx, dy) {
		this.x = x;
		this.y = y;
		this.dx += dx;
		this.dy += dy;
	}

	function onWheel(delta) {
		this.wheel += delta;
	}

	function onLeave() {}
}

@:structInit
private class MouseEvent {
	public final button:MouseButton;
	public final type:MouseEventType;
}

private enum abstract MouseEventType(Bool) {
	var Down = true;
	var Up = false;
}
