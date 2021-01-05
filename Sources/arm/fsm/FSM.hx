package arm.fsm;

class FSM {
	//var previousState: State;
	var currentState: State;
	var nextState: State;
	var entered = false;
	var transitions = new Array<Transition>();

	public function new() {}

	public function setCurrentState(state: State) {
		this.currentState = state;
	}

	public function addTransition(func: Void -> Bool, fromState: State, toState: State) {
		transitions.push(new Transition(func, fromState, toState));
	}

	//public function getPreviousState() {
	//	return previousState;
	//}

	public function getCurrentState() {
		return currentState;
	}

	public function execute() {
		if (!entered) {
			currentState.onEnter();
			entered = true;
		}

		currentState.onUpdate();

		for (t in transitions) {
			if (t.getNextState(currentState) != null) {
				nextState = t.getNextState(currentState);
				break;
			}
		}

		if (nextState != null) {
			currentState.onExit();
			//previousState = currentState;
			currentState = nextState;
			nextState = null;
			entered = false;
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

	public inline function getNextState(state: State) {
		if (fromState == state && func()) return toState;
		return null;
	}
}

class State {
	public function new() {}

	public function onEnter() {}

	public function onUpdate() {}

	public function onExit() {}
}