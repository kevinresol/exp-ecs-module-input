package exp.ecs.module.input.system;

import exp.ecs.module.input.component.*;

private typedef Components = {
	final keyboard:Keyboard;
}

/**
 * Capture user input
 */
@:nullSafety(Off)
class CaptureKeyboardInput extends exp.ecs.system.SingleListSystem<Components> {
	var events:Array<KeyEvent> = [];
	var lastEvents:Array<KeyEvent> = [];

	override function initialize(world) {
		final keyboard = kha.input.Keyboard.get(0);
		keyboard.notify(onDown, onUp, onPress);
		return super.initialize(world) & keyboard.remove.bind(onDown, onUp, onPress);
	}

	override function update(dt:Float) {
		for (node in nodes) {
			final keyboard = node.components.keyboard;

			// reset justDown/Up
			for (last in lastEvents) {
				final keyCode = last.keyCode;
				switch last.type {
					case Down:
						keyboard.justDown[keyCode] = false;
					case Up:
						keyboard.justUp[keyCode] = false;
				}
			}

			// set for current frame
			for (event in events) {
				final keyCode = event.keyCode;
				switch event.type {
					case Down:
						keyboard.isDown[keyCode] = keyboard.justDown[keyCode] = true;
					case Up:
						keyboard.isDown[keyCode] = !(keyboard.justUp[keyCode] = true);
				}
			}
		}

		// rotate array
		final tmp = lastEvents;
		lastEvents = events;
		events = tmp;
		events.resize(0);
	}

	function onDown(keyCode:kha.input.KeyCode) {
		events.push({keyCode: keyCode, type: Down});
	}

	function onUp(keyCode:kha.input.KeyCode) {
		events.push({keyCode: keyCode, type: Up});
	}

	function onPress(s:String) {}

	public static function getSpec() {
		return NodeList.spec(Keyboard);
	}
}

@:structInit
private class KeyEvent {
	public final keyCode:kha.input.KeyCode;
	public final type:KeyEventType;
}

private enum abstract KeyEventType(Bool) {
	var Down = true;
	var Up = false;
}
