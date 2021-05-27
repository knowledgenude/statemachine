package libraries;

class FSM<T> {
	var transitions = new Array<Transition<T>>();
	var tempTransitions = new Array<Transition<T>>();
	var state: Null<State<T>>;
	var entered = false;

	public function new() {}

	public function bindTransition(canEnter: Void -> Bool, fromState: State<T>, toState: State<T>) {
		var t = new Transition<T>(canEnter, fromState, toState);
		transitions.push(t);
		syncTransitions();
	}

	public function setInitState(state: State<T>) {
		this.state = state;
		syncTransitions();
	}

	public function update() {
		if (!entered) {
			state.onEnter();
			entered = true;
		}

		state.onUpdate();

		for (t in tempTransitions) {
			if (t.canEnter()) {
				state.onExit();
				state = t.toState;
				entered = false;
				syncTransitions();
				break;
			}
		}
	}

	public function syncTransitions() {
		tempTransitions.resize(0);

		for (t in transitions) {
			if (t.fromState == state) tempTransitions.push(t);
		}
	}
}

class Transition<T> {
	public var canEnter: Void -> Bool;
	public var fromState: State<T>;
	public var toState: State<T>;

	public function new(canEnter: Void -> Bool, fromState: State<T>, toState: State<T>) {
		this.canEnter = canEnter;
		this.fromState = fromState;
		this.toState = toState;
	}
}

class State<T> {
	var owner: T;

	public function new(owner: T) {
		this.owner = owner;
	}

	public function onEnter(): Void {}

	public function onUpdate(): Void {}

	public function onExit(): Void {}
}