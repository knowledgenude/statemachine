package libs;

class StateMachine {
	var initState: State;
	public var currentState: State;
	public var entered = false;
	var states = new Map<String, State>();

	public function new() {}

	function getRegisteredState(stateName: String): State {
		if (!states.exists(stateName))
			states.set(stateName, new State());

		return states.get(stateName);
	}

	public function setInitState(state: String): State {
		return initState = currentState = getRegisteredState(state);
	}

	public function linkStates(fromState: String, toState: String, canEnter: Void -> Bool) {
		final f = getRegisteredState(fromState);
		final t = getRegisteredState(toState);

		f.linkTo(t, canEnter);
	}

	public function setStateParent(state: String, parent: String) {
		final s = getRegisteredState(state);
		final p = getRegisteredState(parent);

		s.parent = p;
	}

	public function update() {
		currentState.run(this);
	}
}

class Transition {
	public final state: State;
	public final canEnter: Void -> Bool;

	public function new(state: State, canEnter: Void -> Bool) {
		this.state = state;
		this.canEnter = canEnter;
	}
}

class State {
	public var parent: Null<State>;
	var enterListeners: Null<Array<Void -> Void>>;
	var updateListeners: Null<Array<Void -> Void>>;
	var exitListeners: Null<Array<Void -> Void>>;
	var transitions: Null<Array<Transition>>;

	public function new() {}

	public function linkTo(state: State, canEnter: Void -> Bool) {
		if (transitions == null)
			transitions = new Array<Transition>();

		for (t in transitions)
			if (t.state == state)
				break;
		
		transitions.push(new Transition(state, canEnter));
	}

	public function run(stateMachine: StateMachine) {
		if (!stateMachine.entered) {
			onEnter();
			stateMachine.entered = true;
		}

		onUpdate();

		if (transitions != null)
			for (t in transitions)
				if (t.canEnter()) {
					onExit();
					stateMachine.entered = false;
					stateMachine.currentState = t.state;
				}
	}

	public function notifyOnEnter(f: Void -> Void) {
		if (enterListeners == null)
			enterListeners = new Array<Void -> Void>();

		enterListeners.push(f);
	}

	public function notifyOnUpdate(f: Void -> Void) {
		if (updateListeners == null)
			updateListeners = new Array<Void -> Void>();

		updateListeners.push(f);
	}

	public function notifyOnExit(f: Void -> Void) {
		if (exitListeners == null)
			exitListeners = new Array<Void -> Void>();

		exitListeners.push(f);
	}

	function onEnter() {
		if (parent != null)
			parent.onEnter();

		if (enterListeners == null)
			return;

		for (f in enterListeners)
			f();
	}

	function onUpdate() {
		if (parent != null)
			parent.onUpdate();
		
		if (updateListeners == null)
			return;

		for (f in updateListeners)
			f();
	}

	function onExit() {
		if (parent != null)
			parent.onExit();

		if (exitListeners == null)
			return;

		for (f in exitListeners)
			f();
	}
}