package arm.fsm;

class FSM {
	var state: State;
	var nextState: State;
	var transitions = new Array<Transition>();
	var entered = false;

	public function new() {}

	public function setState(state: State) {
		this.state = state;
	}

	public function addTransition(condition: Void -> Bool, fromState: State, toState: State) {
		transitions.push(new Transition(condition, fromState, toState));
	}

	public function execute() {
		if (!entered) {
			state.onEnter();
			entered = true;
		}

		state.onUpdate();

		for (t in transitions) {
			if (t.getNextState(state) != null) {
				nextState = t.getNextState(state);
				break;
			}
		}

		if (nextState != null) {
			state.onExit();
			state = nextState;
			nextState = null;
			entered = false;
		}
	}
}

class Transition {
	var condition: Void -> Bool;
	var fromState: State;
	var toState: State;

	public function new(condition: Void -> Bool, fromState: State, toState: State) {
		this.condition = condition;
		this.fromState = fromState;
		this.toState = toState;
	}

	public inline function getNextState(state: State) {
		if (fromState == state && condition()) return toState;
		return null;
	}
}

class State {
	public function new() {}

	public function onEnter() {}

	public function onUpdate() {}

	public function onExit() {}
}

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