package arm;

class FSM {
	static var previousState: State;
	static var currentState: State;
	static var nextState: State;
	static var entered = false;

	static final transitions = new Array<Transition>();
	static var tempTransitions = new Array<Transition>();

	public function new() {}

	public function setInitState(state: State) {
		currentState = state;
	}

	public inline function addTransition(func, fromState, toState) {
		var t = new Transition(func, fromState, toState);
		transitions.push(t);
		syncTransitions();
		return t;
	}

	function syncTransitions() {
		tempTransitions = [];

		for (t in transitions) {
			if (t.isLinked(currentState)) tempTransitions.push(t);
		}
	}

	public function execute() {
		if (!entered) {
			currentState.onEnter();
			entered = true;
		}

		currentState.onUpdate();

		for (t in tempTransitions) {
			nextState = t.getNextState();
			if (nextState != null) {
				changeState();
				break;
			}
		}
	}

	function changeState() {
		currentState.onExit();
		previousState = currentState;
		currentState = nextState;
		entered = false;
		nextState = null;
		syncTransitions();
	}
}

class Transition {
	var func: Void -> Bool;
	var fromState: State;
	var toState: State;

	public function new(func: Void -> Bool, fromState: State, toState: State) {
		this.func = func;
		this.fromState = fromState;
		this.toState = toState;
	}

	public inline function isLinked(state: State) {
		return fromState == state;
	}

	public inline function getNextState() {
		return func() ? toState : null;
	}
}

class State {
	public function new() {}

	public function onEnter() {}

	public function onUpdate() {}

	public function onExit() {}
}