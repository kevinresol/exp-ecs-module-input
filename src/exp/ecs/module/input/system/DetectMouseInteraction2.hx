package exp.ecs.module.input.system;

import exp.ecs.NodeList;
import exp.ecs.module.input.component.*;
import exp.ecs.module.transform.component.*;
import exp.ecs.module.geometry.component.*;

private typedef MouseComponents = {
	final mouse:Mouse;
}

private typedef Components = {
	final transform:Transform2;
	final circle:Circle;
	final interactive:MouseInteractive;
}

private typedef Specs = {
	final mouses:NodeListSpec<MouseComponents>;
	final nodes:NodeListSpec<Components>;
}

@:nullSafety(Off)
class DetectMouseInteraction2 extends System {
	final specs:Specs;

	var mouses:NodeList<MouseComponents>;
	var nodes:NodeList<Components>;

	public function new(specs) {
		this.specs = specs;
	}

	override function initialize(world:World) {
		return NodeList.make(world, specs.mouses)
			.bind(v -> this.mouses = v, tink.state.Scheduler.direct) & NodeList.make(world, specs.nodes)
			.bind(v -> this.nodes = v, tink.state.Scheduler.direct);
	}

	override function update(dt:Float) {
		for (mouse in mouses) {
			final mouse = mouse.components.mouse;
			final mx = mouse.x;
			final my = mouse.y;
			for (node in nodes) {
				final interactive = node.data.interactive;

				// reset
				interactive.clicked = false;

				final transform = node.data.transform;
				final radius = node.data.circle.radius;
				final dx = transform.global.tx - mx;
				final dy = transform.global.ty - my;
				final hovered = dx <= radius && dy <= radius && dx * dx + dy * dy < radius * radius;
				node.data.interactive.hovered = hovered;
				if (hovered && mouse.leftButton.justDown) {
					interactive.down = true;
				}

				if (interactive.down && mouse.leftButton.justUp) {
					if (hovered)
						interactive.clicked = true;
					interactive.down = false;
				}
			}
		}
	}

	public static function getSpec():Specs {
		// @formatter:off
		return {
			mouses: NodeList.spec(Mouse),
			nodes: NodeList.spec(@:component(transform) Transform2 && Circle && @:component(interactive) MouseInteractive),
		}
		// @formatter:on
	}
}
