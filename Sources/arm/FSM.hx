package arm;

class FSM {
	static var previousState: State;
	static var currentState: State;
	static var nextState: State;
	static var entered = false;

	static final transitions = new Array<Transition>();
	static var currentTransitions = new Array<Transition>();

	public function new() {}

	public function setInitState(state: State) {
		currentState = state;
	}

	public inline function addTransition(func, fromState, toState) {
		var t = new Transition(func, fromState, toState);
		transitions.push(t);
		return t;
	}

	public function execute() {
		if (!entered) {
			currentState.onEnter();
			syncTransitions();
			entered = true;
		}

		currentState.onUpdate();

		for (t in currentTransitions) {
			nextState = t.getNextState();
			if (nextState != null) {
				changeState();
				break;
			}
		}
	}

	function syncTransitions() {
		currentTransitions = [];

		for (t in transitions) {
			if (t.isLinked(currentState)) currentTransitions.push(t);
		}
	}

	function changeState() {
		currentState.onExit();
		previousState = currentState;
		currentState = nextState;
		entered = false;
		nextState = null;
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