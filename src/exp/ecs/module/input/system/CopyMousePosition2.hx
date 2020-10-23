package exp.ecs.module.input.system;

import exp.ecs.module.input.component.*;
import exp.ecs.module.transform.component.*;

private typedef Components = {
	final mouse:Mouse;
	final position:Position2;
}

/**
 * Basic system to copy mouse's screen space position to world space position
 * Mostly for a quick start, normally one would want some translation between the two
 */
@:nullSafety(Off)
class CopyMousePosition2 extends System {
	final list:NodeList<Components>;
	var nodes:Array<Node<Components>>;

	public function new(list) {
		this.list = list;
	}

	override function initialize() {
		return list.bind(v -> nodes = v, tink.state.Scheduler.direct);
	}

	override function update(dt:Float) {
		for (node in nodes) {
			final mouse = node.components.mouse;
			final position = node.components.position;
			position.x = mouse.x;
			position.y = mouse.y;
		}
	}

	public static function getNodes(world:World) {
		// @formatter:off
		return NodeList.generate(world, Mouse && @:field(position) Position2);
		// @formatter:on
	}
}
