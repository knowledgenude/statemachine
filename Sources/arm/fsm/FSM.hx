package arm.fsm;

import iron.Trait;

class FSM {
	static var previousState: State;
	var currentState: State;
	static var nextState: State;
	static var entered = false;
	static var currentTransitions = new Array<Transition>();
	static final transitions = new Array<Transition>();

	public function new(): Void {}

	public function setCurrentState(state: State): Void {
		currentState = state;
	}

	public function addTransition(func: Void -> Bool, fromState: State, toState: State): Void {
		transitions.push(new Transition(func, fromState, toState));
		syncTransitions();
	}

	public inline function getPreviousState(): State {
		return previousState;
	}

	public inline function getCurrentState(): State {
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
	final func: Void -> Bool;
	final fromState: State;
	final toState: State;

	public function new(func: Void -> Bool, fromState: State, toState: State): Void {
		this.func = func;
		this.fromState = fromState;
		this.toState = toState;
	}

	public inline function get(state: State): Bool {
		return state == fromState;
	}

	public inline function getNextState(): State {
		return func() ? toState : null;
	}
}

class State {
	final parent: Trait;

	public function new(parent: Trait): Void {
		this.parent = parent;
	}

	public function onEnter(): Void {}

	public function onUpdate(): Void {}

	public function onExit(): Void {}
}