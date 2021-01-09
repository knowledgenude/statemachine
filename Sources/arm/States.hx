package arm;

import arm.FSM;

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

class JumpStart extends State {
	public function new() {
		super();
	}

	public override function onEnter() {
		trace("enter jump start");
	}

	public override function onUpdate() {}

	public override function onExit() {
		trace("leave jump start");
	}
}

class JumpLoop extends State {
	public function new() {
		super();
	}

	public override function onEnter() {
		trace("enter jump loop");
	}

	public override function onUpdate() {}

	public override function onExit() {
		trace("leave jump loop");
	}
}

class Landing extends State {
	public function new() {
		super();
	}

	public override function onEnter() {
		trace("enter landing");
	}

	public override function onUpdate() {}

	public override function onExit() {
		trace("leave landing");
	}
}