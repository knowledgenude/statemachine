package arm.fsm;

class FSM {
	var previousState: State;
	var currentState: State;
	var nextState: State;
	var entered = false;
	var currentTransitions = new Array<Transition>();
	var transitions = new Array<Transition>();

	public function new() {}

	public function setCurrentState(state: State) {
		this.currentState = state;
	}

	public function addTransition(func: Void -> Bool, fromState: State, toState: State) {
		transitions.push(new Transition(func, fromState, toState));
		syncTransitions();
	}

	public function getPreviousState(): State {
		return previousState;
	}

	public function getCurrentState(): State {
		return currentState;
	}

	public function execute(): Void {
		if (!entered) {
			currentState.onEnter();
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

	function changeState(): Void {
		currentState.onExit();
		previousState = currentState;
		currentState = nextState;
		nextState = null;
		entered = false;
		syncTransitions();
	}

	function syncTransitions(): Void {
		currentTransitions = [];

		for (t in transitions) {
			if (t.get(currentState)) currentTransitions.push(t);
		}
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

	public inline function get(state: State): Bool {
		return state == fromState;
	}

	public inline function getNextState(): State {
		if (func()) return toState;
		return null;
	}
}

class State {
	public function new() {}

	public function onEnter(): Void {}

	public function onUpdate(): Void {}

	public function onExit(): Void {}
}