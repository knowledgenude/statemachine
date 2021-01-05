package arm.states;

import arm.fsm.FSM;

class Idle extends State {
	public function new() {
		super();
	}

	public override function onEnter() {
		trace("enter idle");
	}

	public override function onUpdate() {}

	public override function onExit() {
		trace("leave idle");
	}
}

class Walk extends State {
	public function new() {
		super();
	}

	public override function onEnter() {
		trace("enter walk");
	}

	public override function onUpdate() {}

	public override function onExit() {
		trace("leave walk");
	}
}

class Run extends State {
	public function new() {
		super();
	}

	public override function onEnter() {
		trace("enter run");
	}

	public override function onUpdate() {}

	public override function onExit() {
		trace("leave run");
	}
}