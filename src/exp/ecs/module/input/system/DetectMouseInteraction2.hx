package exp.ecs.module.input.system;

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

private typedef Lists = {
	final mouses:ObservableNodeList<MouseComponents>;
	final nodes:ObservableNodeList<Components>;
}

@:nullSafety(Off)
class DetectMouseInteraction2 extends System {
	final trackers:Lists;

	var mouses:NodeList<MouseComponents>;
	var nodes:NodeList<Components>;

	public function new(trackers) {
		this.trackers = trackers;
	}

	override function initialize():tink.core.Callback.CallbackLink {
		return [
			trackers.mouses.bind(v -> this.mouses = v, tink.state.Scheduler.direct),
			trackers.nodes.bind(v -> this.nodes = v, tink.state.Scheduler.direct),
		];
	}

	override function update(dt:Float) {
		for (mouse in mouses) {
			final mouse = mouse.components.mouse;
			final mx = mouse.x;
			final my = mouse.y;
			for (node in nodes) {
				final interactive = node.components.interactive;

				// reset
				interactive.clicked = false;

				final transform = node.components.transform;
				final radius = node.components.circle.radius;
				final dx = transform.global.tx - mx;
				final dy = transform.global.ty - my;
				final hovered = dx <= radius && dy <= radius && dx * dx + dy * dy < radius * radius;
				node.components.interactive.hovered = hovered;
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

	public static function getNodes(world:World):Lists {
		// @formatter:off
		return {
			mouses: NodeList.generate(world, Mouse),
			nodes: NodeList.generate(world, @:field(transform) Transform2 && Circle && @:field(interactive) MouseInteractive),
		}
		// @formatter:on
	}
}
