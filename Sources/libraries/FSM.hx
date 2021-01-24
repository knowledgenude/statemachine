package libraries;

class FSM {
	var state: Null<State>;
	var nextState: Null<State>;
	var transitions = new Array<Transition>();
	var tempTransitions = new Array<Transition>();
	var entered = false;

	public function new() {}

	public function setState(state: State) {
		this.state = state;
		syncTransitions();
		return state;
	}

	public function bindTransitions(canEnter: Void -> Bool, to: State, from: Array<State>) {
		for (s in from) {
			transitions.push(new Transition(canEnter, s, to));
		}

		syncTransitions();
	}

	function syncTransitions() {
		tempTransitions = [];

		for (t in transitions) {
			if (t.isConnected(state)) tempTransitions.push(t);
		}
	}

	public function run() {
		if (!entered) {
			state.onEnter();
			entered = true;
		}

		state.onUpdate();

		for (t in tempTransitions) {
			if (t.canEnter()) {
				nextState = t.getNextState();
				state.onExit();
				state = nextState;
				entered = false;
				syncTransitions();
				break;
			}
		}
	}
}

class Transition {
	final func: Void -> Bool;
	final from: State;
	final to: State;

	public function new(func: Void -> Bool, from: State, to: State) {
		this.func = func;
		this.from = from;
		this.to = to;
	}

	public function canEnter() {
		return func();
	}

	public function isConnected(state: State) {
		return from == state;
	}

	public function getNextState() {
		return to;
	}
}

interface State {
	function onEnter(): Void;
	function onUpdate(): Void;
	function onExit(): Void;
}